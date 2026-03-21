import 'package:flutter/material.dart';
import 'package:gongdong/style/app_style.dart';

class EditChallege extends StatelessWidget {
  final int id;
  final String currentTitle;
  final int goalCount;
  final int currentCount;

  const EditChallege({
    super.key,
    required this.id,
    required this.currentTitle,
    required this.goalCount,
    required this.currentCount,
  });

  @override
  Widget build(BuildContext context) {
    double progress = goalCount > 0 ? currentCount / goalCount : 0.0;
    int percentage = (progress * 100).toInt();
    return Scaffold(
      backgroundColor: Appcolors.jetblackColor,
      body: Center(
        child: Container(
          height: 600,
          width: 370,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Appcolors.copperColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          currentTitle,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'print',
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          Icons.mode_edit_outline_outlined,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    Text(
                      '$currentCount/$goalCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontFamily: 'print',
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    SizedBox(height: 10),
                    Expanded(
                      child: ClipRRect(
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 5,
                          backgroundColor: Colors.white.withValues(alpha: 0.2),
                          valueColor: AlwaysStoppedAnimation(
                            Color.from(
                              alpha: 1,
                              red: 0.898,
                              green: 0.408,
                              blue: 0.337,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      '$percentage%',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontFamily: 'print',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 35),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'หนังสือที่อ่านจบแล้ว',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'print',
                        fontSize: 22,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    Container(
                      width: 85,
                      height: 125,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: AssetImage('assets/images/shelfbg_white.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: 85,
                      height: 125,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.add,
                        color: Appcolors.copperColor,
                        size: 35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
