import 'package:flutter/material.dart';
import 'package:gongdong/style/app_style.dart';
import 'package:gongdong/widgets/decobutton.dart';
import 'package:gongdong/widgets/itemindeco.dart';

class Deco extends StatefulWidget {
  const Deco({super.key});

  @override
  State<Deco> createState() => _DecoState();
}

class _DecoState extends State<Deco> {
  String selectedTab = 'ชั้นหนังสือ';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.jetblackColor,
      appBar: AppBar(
        backgroundColor: Appcolors.jetblackColor,
        foregroundColor: Appcolors.creamywhiteColor,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Icon(Icons.diamond_sharp, size: 30),
            ),
            Text(
              '20',
              style: TextStyle(fontFamily: 'supermarket', fontSize: 30),
            ),
          ],
        ),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                Divider(color: Appcolors.creamywhiteColor, thickness: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    tabButton('ชั้นหนังสือ', 15, 15),
                    tabButton('ของตกแต่ง', 15, 15),
                    tabButton('ต้นไม้', 35, 35),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: tabItems(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget tabButton(String text, double left, double right) {
    bool isSelected = selectedTab == text;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTab = text;
        });
      },
      child: Decobutton(
        text: text,
        left: left,
        right: right,
        top: 10,
        bottom: 10,
        boxcolor: isSelected ? Appcolors.jetblackColor : Appcolors.lightgrey,
        textcolor: isSelected ? Appcolors.lightgrey : Appcolors.jetblackColor,
      ),
    );
  }

  Widget tabItems() {
    if (selectedTab == 'ชั้นหนังสือ') {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Itemindeco(
                imageurl: 'assets/images/shelfbg_brown.png',
                left: 1,
                right: 20,
                scale: 1.6,
              ),
              Itemindeco(
                imageurl: 'assets/images/shelfbg_white.png',
                left: 20,
                right: 20,
                scale: 1.6,
              ),
              Itemindeco(
                imageurl: 'assets/images/shelfbg_red.png',
                left: 20,
                right: 0,
                scale: 1.6,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Itemindeco(
                imageurl: 'assets/images/shelfbg_purple.png',
                left: 1,
                right: 20,
                scale: 1.6,
              ),
              Itemindeco(
                imageurl: 'assets/images/shelfbg_green.png',
                left: 20,
                right: 20,
                scale: 1.6,
              ),
              Itemindeco(
                imageurl: 'assets/images/shelfbg_blue.png',
                left: 20,
                right: 0,
                scale: 1.6,
              ),
            ],
          ),
        ],
      );
    } else if (selectedTab == 'ของตกแต่ง') {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Itemindeco(
                left: 1,
                right: 20,
                imageurl: 'assets/images/item1.png',
                scale: 2,
              ),
              Itemindeco(
                left: 20,
                right: 20,
                imageurl: 'assets/images/item2.png',
                scale: 2,
              ),
              Itemindeco(
                left: 20,
                right: 00,
                imageurl: 'assets/images/item3.png',
                scale: 2,
              ),
            ],
          ),
        ],
      );
    } else {
      return Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Itemindeco(
                left: 1,
                right: 20,
                imageurl: 'assets/images/tree_item1.png',
                scale: 2,
              ),
              Itemindeco(
                left: 20,
                right: 20,
                imageurl: 'assets/images/tree_item1.png',
                scale: 2,
              ),
              Itemindeco(
                left: 20,
                right: 0,
                imageurl: 'assets/images/tree_item1.png',
                scale: 2,
              ),
            ],
          ),
        ],
      );
    }
  }
}
