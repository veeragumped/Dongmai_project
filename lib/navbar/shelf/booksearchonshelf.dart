import 'package:flutter/material.dart';
import 'package:gongdong/model/book_model.dart';
import 'package:gongdong/model/db.dart';
import 'package:gongdong/navbar/shelf/bookinfoonshelf.dart';
import 'package:gongdong/style/app_style.dart';

class Booksearchonshelf extends StatefulWidget {
  const Booksearchonshelf({super.key});

  @override
  State<Booksearchonshelf> createState() => _BooksearchonshelfState();
}

class _BooksearchonshelfState extends State<Booksearchonshelf> {
  final TextEditingController _searchController = TextEditingController();
  List<BookModel> _displayBooks = [];
  final dbHelper = DBHelper();

  void _onSearch(String query) async {
    if (query.isEmpty) {
      setState(() => _displayBooks = []);
      return;
    }
    final filtered = await dbHelper.searchBooksInShelf(query);
    debugPrint('คำค้นหา: $query, เจอทั้งหมด: ${filtered.length} เล่ม');
    setState(() {
      _displayBooks = filtered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.jetblackColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Appcolors.creamywhiteColor,
                      size: 30,
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: 45,
                      decoration: BoxDecoration(
                        color: Appcolors.creamywhiteColor,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextField(
                        style: TextStyle(
                          fontFamily: 'supermarket',
                          fontSize: 20,
                        ),
                        controller: _searchController,
                        autofocus: true,
                        onChanged: _onSearch,
                        decoration: InputDecoration(
                          hintText: 'ค้นหาหนังสือ...',
                          prefixIcon: Icon(
                            Icons.search,
                            color: Appcolors.lightgrey,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _displayBooks.isEmpty
                  ? Center(
                      child: Text(
                        'พิมพ์เพื่อค้นหา',
                        style: TextStyle(
                          color: Appcolors.lightgrey,
                          fontFamily: 'supermarket',
                          fontSize: 30,
                        ),
                      ),
                    )
                  : GridView.builder(
                      padding: EdgeInsets.all(20),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 0.65,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 30,
                      ),
                      itemCount: _displayBooks.length,
                      itemBuilder: (context, index) {
                        final book = _displayBooks[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    Bookinfoonshelf(itemCount: book),
                              ),
                            );
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: Image.network(
                              book.thumbnail,
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
