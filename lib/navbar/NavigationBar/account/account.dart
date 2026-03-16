import 'package:gongdong/model/book_model.dart';
import 'package:gongdong/model/db.dart';
import 'package:gongdong/navbar/NavigationBar/account/challengetype.dart';
import 'package:gongdong/style/app_style.dart';
//import 'package:gongdong/navbar/shelf/bookdetail.dart';
import 'package:gongdong/widgets/challengewidget.dart';
import 'package:gongdong/widgets/header.dart';
import 'package:gongdong/widgets/line.dart';
import 'package:flutter/material.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  final DBHelper dbHelper = DBHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.jetblackColor,
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                children: [
                  Container(height: 120, color: Appcolors.copperColor),
                  Container(height: 23, color: Appcolors.creamywhiteColor),
                ],
              ),
              Positioned(
                left: 30,
                bottom: -13,
                child: Stack(
                  children: [
                    Text(
                      'Froggy',
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'inter',
                        foreground: Paint()
                          ..style = PaintingStyle.stroke
                          ..strokeWidth = 3
                          ..color = Color.fromARGB(255, 100, 80, 50),
                      ),
                    ),
                    Text(
                      'Froggy',
                      style: TextStyle(
                        fontSize: 50,
                        fontFamily: 'inter',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 40,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/profile.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 20),
            child: Text(
              'หนังสือโปรด',
              style: TextStyle(
                color: Appcolors.creamywhiteColor,
                fontSize: 40,
                fontFamily: 'print',
                height: 1,
              ),
            ),
          ),
          Row(children: [Line(top: 0, left: 20, width: 365)]),
          SizedBox(
            height: 140,
            child: Stack(
              alignment: Alignment.bottomCenter,
              children: [
                Image.asset('assets/images/fav_shelf.png', width: 365),
                Positioned(
                  bottom: 15,
                  child: SizedBox(
                    height: 100,
                    width: 365,
                    child: FutureBuilder<List<BookModel>>(
                      future: dbHelper.getFavoriteBooks(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData || snapshot.data!.isEmpty) {
                          return Center(child: Text(''));
                        }
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Image.network(
                                snapshot.data![index].thumbnail,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 20),
            child: Text(
              'Challenge',
              style: TextStyle(
                color: Appcolors.creamywhiteColor,
                fontSize: 40,
                fontFamily: 'print',
                height: 1,
              ),
            ),
          ),
          Row(children: [Line(top: 0, left: 20, width: 365)]),
          FutureBuilder<List<Map<String, dynamic>>>(
            future: dbHelper.getChallenge(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(child: CircularProgressIndicator());
              if (!snapshot.hasData || snapshot.data!.isEmpty)
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, bottom: 30),
                    child: Text(
                      'ยังไม่มีภารกิจ',
                      style: TextStyle(
                        color: Appcolors.lightgrey,
                        fontSize: 30,
                        fontFamily: 'supermarket',
                      ),
                    ),
                  ),
                );

              return Column(
                children: snapshot.data!.map((item) {
                  return Challengewidget(title: item['title']);
                }).toList(),
              );
            },
          ),
          SizedBox(height: 20),
          Column(
            children: [
              TextButton(
                onPressed: () async {
                  //await dbHelper.insertChallenge();
                  //setState(() {});
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return Challengetype();
                      },
                    ),
                  );
                },
                style: TextButton.styleFrom(
                  backgroundColor: Appcolors.copperColor,
                  foregroundColor: Appcolors.creamywhiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: Text(
                  'เพิ่ม Challenge',
                  style: TextStyle(fontFamily: 'supermarket', fontSize: 25),
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 50, left: 20),
            child: Text(
              'สถิติ',
              style: TextStyle(
                color: Appcolors.creamywhiteColor,
                fontSize: 40,
                fontFamily: 'print',
                height: 1,
              ),
            ),
          ),
          Row(children: [Line(top: 0, left: 20, width: 365)]),
          Container(),

          Padding(
            padding: EdgeInsets.only(top: 50, left: 20),
            child: Text(
              'ตั้งค่า',
              style: TextStyle(
                color: Appcolors.creamywhiteColor,
                fontSize: 40,
                fontFamily: 'print',
                height: 1,
              ),
            ),
          ),
          Row(children: [Line(top: 0, left: 20, width: 365)]),
          Header(title: 'บัญชี', padding: 40, fontsize: 30),
          Line(top: 0, left: 40, width: 350),
          Header(
            title: 'ขนาดตัวอักษรและเปลี่ยนภาษา',
            padding: 40,
            fontsize: 30,
          ),
          Line(top: 0, left: 40, width: 350),
          Header(title: 'ออกระบบ', padding: 40, fontsize: 30),
          Line(top: 0, left: 40, width: 350),
          SizedBox(height: 100),
        ],
      ),
    );
  }
}
