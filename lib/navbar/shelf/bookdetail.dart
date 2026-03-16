import 'package:flutter/material.dart';
import 'package:gongdong/model/book_model.dart';
import 'package:gongdong/model/db.dart';
import 'package:gongdong/style/app_style.dart';
import 'package:gongdong/widgets/loginbutton.dart';
import 'package:gongdong/wishlist/wishlist.dart';

final dbHelper = DBHelper();

class Bookdetail extends StatelessWidget {
  final BookModel itemCount;

  const Bookdetail({super.key, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.jetblackColor,
      appBar: AppBar(
        backgroundColor: Appcolors.jetblackColor,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          children: [
            Image.network(itemCount.thumbnail, height: 300, fit: BoxFit.cover),
            SizedBox(height: 20),
            Text(
              itemCount.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                fontFamily: 'supermarket',
              ),
            ),
            Text(
              'ผู้เขียน: ${itemCount.authors}',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontFamily: 'supermarket',
              ),
            ),
            Text(
              'จำนวนหน้า:${itemCount.pageCount} หน้า',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 18,
                fontFamily: 'supermarket',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'คำอธิบาย:',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'supermarket',
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              itemCount.description,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 18,
                fontFamily: 'supermarket',
              ),
            ),
            SizedBox(height: 30),
            LoginButton(
              text: 'เพิ่มหนังสือลงชั้นหนังสือ',
              height: 45,
              width: 305,
              color: Appcolors.copperColor,
              textcolor: Appcolors.creamywhiteColor,
              onPressed: () async {
                await dbHelper.addToShelf(itemCount);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    duration: Duration(seconds: 1),
                    content: Text(
                      'เพิ่ม "${itemCount.title}" ลงชั้นหนังสือแล้ว!',
                    ),
                  ),
                );
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
            SizedBox(height: 15),
            LoginButton(
              text: 'Wishlist',
              height: 45,
              width: 305,
              color: Appcolors.copperColor,
              textcolor: Appcolors.creamywhiteColor,
              onPressed: () async {
                await dbHelper.addToWishlist(itemCount);
                if (!context.mounted) return;
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'เพิ่ม "${itemCount.title}" ใน wishlist แล้ว!',
                    ),
                  ),
                );
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Wishlist()),
                  (route) => route.isFirst,
                );
              },
            ),
            SizedBox(height: 15),
          ],
        ),
      ),
    );
  }
}
