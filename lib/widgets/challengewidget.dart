import 'package:flutter/material.dart';

class Challengewidget extends StatelessWidget {

  final String title;

  const Challengewidget({super.key, 
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Container(
                height: 80,
                width: 368,
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 163, 134, 85),
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 30,
          bottom: 25,
          child: Stack(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontFamily: 'print',
                  fontWeight: FontWeight.bold,
                  color: Colors.white
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
