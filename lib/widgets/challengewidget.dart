import 'package:flutter/material.dart';

class Challengewidget extends StatelessWidget {
  final String title;
  final int currentCount;
  final int goalCount;

  const Challengewidget({
    super.key,
    required this.title,
    required this.currentCount,
    required this.goalCount,
  });

  @override
  Widget build(BuildContext context) {
    double progress = goalCount > 0 ? currentCount / goalCount : 0.0;
    int percentage = (progress * 100).toInt();

    return Padding(
      padding: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Container(
        width: 368,
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 163, 134, 85),
          borderRadius: BorderRadius.circular(5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'print',
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  '$currentCount/$goalCount',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () {},
                    child: Icon(
                      Icons.mode_edit_outline_outlined,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '$percentage%',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            ClipRRect(
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: Colors.white.withValues(alpha: 0.2),
                valueColor: AlwaysStoppedAnimation(
                  Color.fromRGBO(229, 104, 86, 1.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
