import 'package:flutter/material.dart';

class Header extends StatelessWidget {

  final String title;
  final double padding;
  final double fontsize;


  const Header({super.key, 
    required this.title,
    required this.padding,
    required this.fontsize
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
            padding: EdgeInsets.only(top: 50, left: padding),
            child: Text(
              title,
              style: TextStyle(
                color: Color.fromARGB(255, 230, 230, 222),
                fontSize: fontsize,
                fontFamily: 'print',
                height: 1,
              ),
            ),
          );

  }
}