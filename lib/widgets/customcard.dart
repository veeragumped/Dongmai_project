import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String image;
  final String title;
  final String description;

  const CustomCard({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 180,
      height: 275,
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 230, 230, 222),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            child: Image.network(
              image,
              height: 145.14,
              width: 180,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'sarabunbold',
                    fontSize: 10,
                    color: Color.fromARGB(255, 51, 50, 55),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'supermarket',
                    fontSize: 11,
                    color: Color.fromARGB(255, 51, 50, 55),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
