import 'package:flutter/material.dart';
import 'package:gongdong/navbar/shelf/addbook.dart';
import 'package:gongdong/navbar/shelf/bookinfoonshelf.dart';
import 'package:gongdong/navbar/shelf/booksearchonshelf.dart';
import 'package:gongdong/navbar/shelf/deco.dart';
import 'package:gongdong/style/app_style.dart';
import 'package:gongdong/widgets/shelf_bg.dart';
import 'package:gongdong/model/db.dart';
import 'package:gongdong/model/book_model.dart';
import 'package:gongdong/wishlist/wishlist.dart';
import 'package:flutter_reorderable_grid_view/widgets/widgets.dart';

class Shelf extends StatefulWidget {
  const Shelf({super.key});

  @override
  State<Shelf> createState() => _ShelfState();
}

class _ShelfState extends State<Shelf> {
  int shelfCount = 1;

  void addShelf() {
    setState(() {
      shelfCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 51, 50, 55),
      body: ListView(
        children: [
          SizedBox(height: 10),
          Stack(
            alignment: Alignment.center,
            children: [
              Text(
                'ชั้นหนังสือ',
                style: TextStyle(
                  fontFamily: 'supermarket',
                  color: Appcolors.creamywhiteColor,
                  fontSize: 40,
                ),
              ),
              Positioned(
                right: 20,
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Deco();
                            },
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: Appcolors.creamywhiteColor),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return AddBook();
                            },
                          ),
                        ).then((_) => setState(() {}));
                      },
                      icon: Icon(Icons.add, color: Appcolors.creamywhiteColor),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(color: Color.fromARGB(255, 230, 230, 222), thickness: 2),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return Wishlist();
                        },
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Icon(
                          Icons.star,
                          color: Appcolors.creamywhiteColor,
                          size: 26,
                        ),
                      ),
                      Text(
                        'Wishlist',
                        style: TextStyle(
                          color: Color.fromARGB(255, 230, 230, 222),
                          fontSize: 30,
                          fontFamily: 'supermarket',
                        ),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Booksearchonshelf(),
                      ),
                    );
                  },
                  icon: Icon(
                    Icons.search_rounded,
                    size: 28,
                    color: Appcolors.creamywhiteColor,
                  ),
                ),
              ],
            ),
          ),
          Stack(
            children: [
              Column(
                children: [for (int i = 0; i < shelfCount; i++) ShelfBg()],
              ),
              FutureBuilder<List<BookModel>>(
                future: DBHelper().getBooks(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Appcolors.copperColor,
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(); // ไม่มีหนังสือก็ไม่ต้องโชว์อะไร
                  }
                  final books = snapshot.data!;
                  final bookWidgets = List.generate(books.length, (index) {
                    final book = books[index];
                    return GestureDetector(
                      key: ValueKey(book.id),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Bookinfoonshelf(itemCount: book),
                          ),
                        ).then((_) => setState(() {}));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 4,
                              offset: Offset(2, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.network(
                            book.thumbnail,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Container(
                                  color: Colors.grey,
                                  child: Icon(Icons.broken_image),
                                ),
                          ),
                        ),
                      ),
                    );
                  });
                  return ReorderableBuilder<BookModel>(
                    onReorder: (reorderedListFunction) {
                      final reorderedList = reorderedListFunction(books);
                      DBHelper().updateBooksOrder(reorderedList).then((_) {
                        setState(() {
                          books.clear();
                          books.addAll(reorderedList);
                        });
                      });
                    },
                    builder: (reorderableChildren) {
                      return GridView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 40,
                        ),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          childAspectRatio: 0.65,
                          crossAxisSpacing: 30,
                          mainAxisSpacing: 50,
                        ),
                        children: reorderableChildren,
                      );
                    },
                    children: bookWidgets,
                  );
                },
              ),
            ],
          ),
          SizedBox(height: 20),
          SizedBox(
            child: TextButton(
              onPressed: () {
                addShelf();
              },
              style: TextButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 163, 134, 85),
                foregroundColor: Color.fromARGB(255, 230, 230, 222),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: Text(
                'เพิ่มชั้นหนังสือ',
                style: TextStyle(fontFamily: 'supermarket', fontSize: 25),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}
