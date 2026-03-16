import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:gongdong/navbar/shelf/bookdetail.dart';
import 'package:gongdong/model/book_model.dart';
import 'package:gongdong/model/book_service.dart';
import 'package:gongdong/style/app_style.dart';
import 'package:gongdong/widgets/dropdown.dart';
import 'package:gongdong/widgets/loginbutton.dart';
import 'package:gongdong/widgets/scrollablebook.dart';
import 'package:scroll_loop_auto_scroll/scroll_loop_auto_scroll.dart';

class Random extends StatefulWidget {
  const Random({super.key});

  @override
  State<Random> createState() => _RandomState();
}

class _RandomState extends State<Random> {
  bool isSpinning = false;
  bool isLoading = true;
  String? selectedDropdown;

  BookService bookService = BookService();
  BookModel? winnerBook;
  List<BookModel> showbooks = [];
  List<BookModel> bookshelf = [];
  List<BookModel> author = [];
  List<BookModel> booksgenre = [];
  List<BookModel> publisher = [];
  List<BookModel> currentDisplayList = [];

  @override
  void initState() {
    super.initState();
    loadBooks();
  }

  void loadBooks() async {
    setState(() => isLoading = true);

    try {
      final localData = await bookService.getBooksFromShelf();

      if (!mounted) return;
      setState(() {
        currentDisplayList = localData;
        isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
    try {
      showbooks = await bookService.fetchBooks('นิยาย');
      author = await bookService.fetchBooks('inauthor:');
      booksgenre = await bookService.fetchBooks('subject:');
      publisher = await bookService.fetchBooks('inpublisher:');
    } catch (e) {
      debugPrint('API ERROR: $e');
    }
  }

  void pickWinner() {
    setState(() {
      if (currentDisplayList.isNotEmpty) {
        var randomList = List<BookModel>.from(currentDisplayList);
        randomList.shuffle();
        winnerBook = randomList.first;
        isSpinning = false;
      }
    });
  }

  Widget _buildRandoming() {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
              child: Container(color: Colors.black.withValues(alpha: 0.7)),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Center(
                  child: Text(
                    'สุ่มหนังสือing',
                    style: TextStyle(
                      fontFamily: 'supermarket',
                      fontSize: 42,
                      color: Appcolors.creamywhiteColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              (isLoading)
                  ? Center(child: CircularProgressIndicator())
                  : (currentDisplayList.isEmpty)
                  ? Center(child: Text('ไม่มีหนังสือในชั้นหนังสือ'))
                  : SizedBox(
                      height: 250,
                      child: ScrollLoopAutoScroll(
                        key: ValueKey(
                          '${selectedDropdown}_${currentDisplayList.length}',
                        ),
                        scrollDirection: Axis.horizontal,
                        delay: Duration(seconds: 1),
                        duration: Duration(seconds: 15),
                        gap: 1,
                        enableScrollInput: false,
                        child: Row(
                          children: [
                            Scrollablebook.noscroll(
                              text: '',
                              itemCount: currentDisplayList,
                              width: 115,
                              separatorwidth: 5,
                            ),
                          ],
                        ),
                      ),
                    ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  LoginButton(
                    text: 'หยุด!',
                    height: 50,
                    width: 100,
                    color: Appcolors.lightgrey,
                    textcolor: Appcolors.jetblackColor,
                    onPressed: () {
                      pickWinner();
                      if (winnerBook != null) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) {
                              return Bookdetail(itemCount: winnerBook!);
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<String?> _showAlert(BuildContext context, String title) async {
    TextEditingController controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'ค้นหาตาม$title',
          style: TextStyle(fontFamily: 'supermarket'),
        ),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: 'พิมพ์ชื่อ $title ที่ต้องการ'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('ยกเลิก'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, controller.text);
            },
            child: Text('ตกลง'),
          ),
        ],
      ),
    );
  }

  Future<void> updatedDropdown(String? category) async {
    if (category == 'ชั้นหนังสือ') {
      setState(() {
        isLoading = true;
      });
      try {
        var localBooks = await bookService.getBooksFromShelf();
        if (!mounted) return;
        setState(() {
          debugPrint('${localBooks.length}');
          bookshelf = localBooks;
          currentDisplayList = bookshelf;
          selectedDropdown = category;
          isLoading = false;
        });
      } catch (e) {
        debugPrint('$e');
        setState(() {
          isLoading = false;
        });
      }
    } else if (category == 'ผู้เขียน' ||
        category == 'ประเภทหนังสือ' ||
        category == 'สำนักพิมพ์') {
      String? userInput = await _showAlert(context, category!);
      if (userInput != null && userInput.isNotEmpty) {
        setState(() {
          isLoading = true;
        });
        String query = '';
        if (category == 'ผู้เขียน') {
          query = 'inauthor:$userInput';
        } else if (category == 'ประเภทหนังสือ') {
          query = 'categories:$userInput';
        } else if (category == 'สำนักพิมพ์') {
          query = 'inpublisher:$userInput';
        }
        var searchResults = await bookService.fetchBooks(query);
        if (!mounted) return;
        if (searchResults.isEmpty) {
          setState(() {
            isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'ไม่พบหนังสือในหมวด "$userInput" กรุณากรอกคำอื่น',
                style: TextStyle(
                  fontFamily: 'supermarket',
                  backgroundColor: Colors.redAccent,
                ),
              ),
            ),
          );
          return;
        }
        setState(() {
          selectedDropdown = category;
          currentDisplayList = searchResults;
          isLoading = false;
        });
      }
    }
  }

  String? dropdownvalue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.jetblackColor,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 110),
            child: Center(
              child: Text(
                'สุ่มหนังสือเล่มต่อไปกัน!',
                style: TextStyle(
                  fontFamily: 'supermarket',
                  fontSize: 42,
                  color: Appcolors.creamywhiteColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Dropdown(
            items: ['ชั้นหนังสือ', 'ผู้เขียน', 'ประเภทหนังสือ', 'สำนักพิมพ์'],
            label: 'เลือกประเภทของหนังสือ',
            onchanged: updatedDropdown,
          ),
          SizedBox(height: 50),
          currentDisplayList.isEmpty
              ? SizedBox()
              : ScrollLoopAutoScroll(
                  key: ValueKey(
                    '${selectedDropdown}_${currentDisplayList.length}',
                  ),
                  scrollDirection: Axis.horizontal,
                  delay: Duration(seconds: 1),
                  duration: Duration(seconds: 80),
                  gap: 1,
                  enableScrollInput: false,
                  child: Scrollablebook.noscroll(
                    text: '',
                    itemCount: currentDisplayList,
                    width: 115,
                    separatorwidth: 5,
                  ),
                ),
          SizedBox(height: 50),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              LoginButton(
                text: 'เริ่ม',
                height: 50,
                width: 100,
                color: Appcolors.lightgrey,
                textcolor: Appcolors.jetblackColor,
                onPressed: currentDisplayList.isEmpty
                    ? () {}
                    : () {
                        showGeneralDialog(
                          barrierColor: Colors.black.withValues(alpha: 0.5),
                          barrierDismissible: true,
                          barrierLabel: 'เริ่ม',
                          context: context,
                          transitionDuration: Duration(milliseconds: 300),
                          pageBuilder: (context, anim1, anim2) {
                            return _buildRandoming();
                          },
                        );
                      },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
