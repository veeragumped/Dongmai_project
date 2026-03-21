import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/book_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database> get db async {
    //get db ถ้า _db เป็น Null ส่ง initDB แต่ถ้าไม่เป็นก็ส่งค่าเดิมกัลับไป
    if (_db != null) return _db!;
    _db = await initDB();
    return _db!;
  }

  Future<Database> initDB() async {
    Directory appSupportDir =
        await getApplicationSupportDirectory(); //get ตำแหน่งที่อยู่ของโฟลเดอร์ที่ซัพพอร์ต
    String path = join(
      appSupportDir.path,
      'bookshelf.db',
    ); // path เก็บค่าที่อยู่(appSupportDir) ให้มาต่อกับฐานข้อมูลที่ชื่อ bookshelf.db

    if (!await appSupportDir.exists()) {
      await appSupportDir.create(recursive: true);
    } // ถ้าโฟลเดอร์ appSupportDir ไม่มีอยู่ ก็ให้สร้างใหม่ขึ้นมา
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE shelf (
            id TEXT PRIMARY KEY,
            title TEXT,
            thumbnail TEXT,
            authors TEXT,
            pageCount INTEGER,
            description TEXT,
            status TEXT,
            isFavorite INTEGER DEFAULT 0,
            position INTEGER
          )
        ''');
        await db.execute('''
            CREATE TABLE wishlistshelf(
            id TEXT PRIMARY KEY,
            title TEXT,
            thumbnail TEXT,
            authors TEXT,
            pageCount INTEGER,
            description TEXT)''');

        await db.execute('''
            CREATE TABLE notes(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            book_id TEXT UNIQUE, --
            content TEXT,
            image_path TEXT, 
            FOREIGN KEY (book_id) REFERENCES shelf (id) ON DELETE CASCADE)''');

        await db.execute('''
            CREATE TABLE challenge(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            goal_count INTEGER,
            current_count INTEGER,
            reward_points INTEGER,
            is_completed INTEGER DEFAULT 0)''');
      },
    ); //สร้างตาราง
  }

  Future<void> addToShelf(BookModel book) async {
    final dbClient = await db;
    await dbClient.insert('shelf', {
      'id': book.id,
      'title': book.title,
      'thumbnail': book.thumbnail,
      'authors': book.authors.join(', '),
      'pageCount': book.pageCount,
      'description': book.description,
      'status': book.status,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> addToWishlist(BookModel book) async {
    final dbClient = await db;
    await dbClient.insert('wishlistshelf', {
      'id': book.id,
      'title': book.title,
      'thumbnail': book.thumbnail,
      'authors': book.authors.join(', '),
      'pageCount': book.pageCount,
      'description': book.description,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> deleteBook(String id) async {
    final dbClient = await db;
    await dbClient.delete('shelf', where: 'id=?', whereArgs: [id]);
  }

  Future<void> deleteWishlistBook(String id) async {
    final dbClient = await db;
    await dbClient.delete('wishlistshelf', where: 'id=?', whereArgs: [id]);
  }

  Future<void> deleteNote(String bookID) async {
    final dbClient = await db;
    await dbClient.delete('notes', where: 'book_id = ?', whereArgs: [bookID]);
  }

  Future<void> updateBookStatus(String id, String newStatus) async {
    final dbClient = await db;
    int count = await dbClient.update(
      'shelf',
      {'status': newStatus},
      where: 'id = ?',
      whereArgs: [id],
    );
    debugPrint('อัปเดตสำเร็จ $count แถว');
  }

  Future<void> updateBooksOrder(List<BookModel> books) async {
    final dbClient = await db;
    Batch batch = dbClient.batch();

    for (int i = 0; i < books.length; i++) {
      batch.update(
        'shelf',
        {'position': i},
        where: 'id = ?',
        whereArgs: [books[i].id],
      );
    }
    await batch.commit(noResult: true);
  }

  Future<void> saveNotes(
    String bookID,
    String content,
    String imagePaths,
  ) async {
    final dbClient = await db;
    await dbClient.insert('notes', {
      'book_id': bookID,
      'content': content,
      'image_path': imagePaths,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getNotes(String bookID) async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'notes',
      where: 'book_id = ?',
      whereArgs: [bookID],
    );
    if (maps.isNotEmpty) {
      return maps.first;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>> getAllNotes() async {
    final dbClient = await db;
    return await dbClient.rawQuery('''
    SELECT 
    n.content, 
    n.book_id, 
    n.image_path, 
    s.title, 
    s.thumbnail,
    s.position
    FROM notes n
    JOIN shelf s ON n.book_id = s.id
    ORDER BY s.position ASC
  ''');
  }

  Future<List<BookModel>> getBooks() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'shelf',
      orderBy: 'position ASC',
    );

    return List.generate(maps.length, (i) {
      return BookModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        thumbnail: maps[i]['thumbnail'],
        authors: maps[i]['authors'] != null
            ? maps[i]['authors'].split(', ')
            : [],
        description: maps[i]['description'],
        pageCount: maps[i]['pageCount'],
        status: maps[i]['status'] ?? 'กำลังอ่าน',
        isFavorite: maps[i]['isFavorite'] ?? 0,
      );
    });
  }

  Future<void> favorite(String id, int currentStatus) async {
    final dbClient = await db;
    int newStatus = (currentStatus == 1) ? 0 : 1;
    await dbClient.update(
      'shelf',
      {'isFavorite': newStatus},
      where: 'id=?',
      whereArgs: [id],
    );
  }

  Future<List<BookModel>> getFavoriteBooks() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'shelf',
      where: 'isFavorite=?',
      whereArgs: [1],
    );
    return List.generate(maps.length, (i) {
      return BookModel(
        id: maps[i]['id'],
        thumbnail: maps[i]['thumbnail'],
        title: maps[i]['title'],
        authors: maps[i]['authors']?.split(',') ?? [],
        pageCount: maps[i]['pageCount'],
        description: maps[i]['description'],
        isFavorite: maps[i]['isFavorite'],
      );
    });
  }

  Future<List<BookModel>> getWishlistBooks() async {
    final dbClient = await db;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'wishlistshelf',
    );

    return List.generate(maps.length, (i) {
      return BookModel(
        id: maps[i]['id'],
        title: maps[i]['title'],
        thumbnail: maps[i]['thumbnail'],
        authors: maps[i]['authors'] != null
            ? maps[i]['authors'].split(', ')
            : [],
        description: maps[i]['description'],
        pageCount: maps[i]['pageCount'],
        status: maps[i]['status'] ?? 'กำลังอ่าน',
      );
    });
  }

  Future<void> moveToShelf(BookModel book) async {
    final dbClient = await db;
    await dbClient.insert('shelf', {
      'id': book.id,
      'title': book.title,
      'thumbnail': book.thumbnail,
      'authors': book.authors.join(', '),
      'pageCount': book.pageCount,
      'description': book.description,
      'status': 'กำลังอ่าน',
    }, conflictAlgorithm: ConflictAlgorithm.replace);
    await dbClient.delete('wishlistshelf', where: 'id=?', whereArgs: [book.id]);
  }

  Future<List<BookModel>> searchBooksInShelf(String query) async {
    final dbCilent = await db;
    final List<Map<String, dynamic>> maps = await dbCilent.query(
      'shelf',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) {
      return BookModel(
        id: maps[i]['id'],
        thumbnail: maps[i]['thumbnail'],
        title: maps[i]['title'],
        authors: maps[i]['authors'].toString().split(','),
        pageCount: maps[i]['pageCount'],
        description: maps[i]['description'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getChallenge() async {
    final dbClient = await db;
    return await dbClient.query('challenge');
  }

  Future<void> insertChallenge(Map<String, dynamic> data) async {
    final dbClient = await db;
    await dbClient.insert('challenge', data);
  }
}
