import 'package:flutter/material.dart';
import 'package:gongdong/style/app_style.dart';

class Challengetype extends StatelessWidget {
  const Challengetype({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.jetblackColor,
        foregroundColor: Appcolors.creamywhiteColor,
      ),
      backgroundColor: Appcolors.jetblackColor,
      body: Column(
        children: [
          Center(
            child: Text(
              'เลือก Challenge ที่ต้องการ',
              style: TextStyle(
                color: Appcolors.creamywhiteColor,
                fontSize: 40,
                fontFamily: 'print',
              ),
            ),
          ),
          Text(
            'Challenge',
            style: TextStyle(
              color: Appcolors.creamywhiteColor,
              fontSize: 20,
              fontFamily: 'print',
            ),
          ),
        ],
      ),
    );
  }
}
