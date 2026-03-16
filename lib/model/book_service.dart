import 'dart:convert';
import 'package:gongdong/model/book_model.dart';
import 'package:gongdong/model/db.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class BookService {
  final List<String> noSearchWords = ['นิตยสาร', 'มติชน', 'ข่าว'];

  Future<List<BookModel>> fetchBooks(String query) async {
    final apiKey = dotenv.env['API_KEY'];
    final url = Uri.parse(
      'https://www.googleapis.com/books/v1/volumes?q=$query&printType=books&langRestrict=th&orderBy=newest&key=$apiKey',
    );
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List items = data['items'] ?? [];

      //JSONtoList
      return items.map((item) => BookModel.fromJson(item)).toList();
    } else {
      throw Exception('Error Code: ${response.statusCode}');
    }
  }

  Future<List<BookModel>> getBooksFromShelf() async {
    final db = await DBHelper().db;
    final List<Map<String, dynamic>> maps = await db.query('shelf');

    return List.generate(maps.length, (i) {
      return BookModel.fromMap(maps[i]);
    });
  }
}
