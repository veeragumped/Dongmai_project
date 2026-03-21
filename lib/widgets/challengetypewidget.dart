import 'package:flutter/material.dart';
import 'package:gongdong/style/app_style.dart';
import 'package:gongdong/widgets/loginbutton.dart';

class Challengetypewidget extends StatelessWidget {
  final String title;
  final String text;
  final VoidCallback onPressed;

  const Challengetypewidget({
    super.key,
    required this.text,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 34, top: 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/challange_logo.png', scale: 1.9),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: Appcolors.creamywhiteColor,
                      fontFamily: 'print',
                      fontSize: 35,
                      height: 1,
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      style: TextStyle(
                        color: Appcolors.creamywhiteColor,
                        fontSize: 20,
                        fontFamily: 'print',
                      ),
                      children: [
                        TextSpan(text: 'ใน '),
                        TextSpan(
                          text: text,
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(text: ' นี้ คุณจะอ่านหนังสือกี่เล่ม ?'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        LoginButton(
          text: 'เลือก Challange นี้',
          height: 42,
          width: 342,
          color: Appcolors.copperColor,
          textcolor: Appcolors.creamywhiteColor,
          onPressed: onPressed,
        ),
      ],
    );
  }
}

class CreateChallengeWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const CreateChallengeWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 34, top: 48),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/images/challange_logo.png', scale: 1.9),
              SizedBox(width: 15),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Challenge',
                    style: TextStyle(
                      color: Appcolors.creamywhiteColor,
                      fontFamily: 'print',
                      fontSize: 35,
                      height: 1,
                    ),
                  ),
                  Text(
                    'สร้างสรรค์ Challenge ของตัวเอง !',
                    style: TextStyle(
                      fontFamily: 'print',
                      fontSize: 20,
                      color: Appcolors.creamywhiteColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 15),
        LoginButton(
          text: 'เลือก Challange นี้',
          height: 42,
          width: 342,
          color: Appcolors.copperColor,
          textcolor: Appcolors.creamywhiteColor,
          onPressed: onPressed,
        ),
      ],
    );
  }
}
