import 'package:flutter/material.dart';
import 'package:gongdong/style/app_style.dart';

class Itemindeco extends StatelessWidget {
  final double left;
  final double right;
  final String imageurl;
  final double scale;

  const Itemindeco({
    super.key,
    required this.left,
    required this.right,
    required this.imageurl,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.only(left: left, right: right, bottom: 40),
          child: Column(
            children: [
              Image.asset(imageurl, scale: scale),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.diamond, color: Appcolors.lightgrey, size: 30),
                  Text(
                    '50',
                    style: TextStyle(
                      color: Appcolors.lightgrey,
                      fontFamily: 'print',
                      fontSize: 30,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
