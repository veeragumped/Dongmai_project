import 'package:flutter/material.dart';

class ShelfBg extends StatelessWidget {
  const ShelfBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 810,
      width: double.infinity,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/shelfbg.png'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
