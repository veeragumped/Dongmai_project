import 'package:flutter/material.dart';
import 'package:gongdong/style/app_style.dart';
import 'package:gongdong/widgets/challengetypewidget.dart';
import 'package:gongdong/wishlist/wishlistinfo.dart';

class Challengetype extends StatefulWidget {
  const Challengetype({super.key});

  @override
  State<Challengetype> createState() => _ChallengetypeState();
}

class _ChallengetypeState extends State<Challengetype> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Appcolors.jetblackColor,
        foregroundColor: Appcolors.creamywhiteColor,
      ),
      backgroundColor: Appcolors.jetblackColor,
      body: ListView(
        children: [
          Column(
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
              Challengetypewidget(
                title: 'Challenge',
                text: 'ปี',
                onPressed: () {
                  showAlertyandm(context, 'ในปีนี้');
                },
              ),
              Challengetypewidget(
                title: 'Challenge',
                text: 'เดือน',
                onPressed: () {
                  showAlertyandm(context, 'ในเดือนนี้');
                },
              ),
              CreateChallengeWidget(
                onPressed: () {
                  showAlert(context, 'สร้าง');
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void showAlertyandm(BuildContext context, String title) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Appcolors.notelight,
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ตั้งเป้าหมายว่าจะอ่านหนังสือกี่เล่ม ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'print',
                    fontWeight: FontWeight.bold,
                    color: Appcolors.jetblackColor,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 1, left: 5),
                    hintText: 'จำนวนหนังสือ',
                    hintStyle: TextStyle(
                      fontFamily: 'print',
                      fontSize: 24,
                      color: Color.fromRGBO(95, 95, 95, 255),
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(142, 142, 142, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    alertButton(context, 'ยกเลิก', Appcolors.copperColor, () {
                      Navigator.pop(context);
                    }),
                    alertButton(
                      context,
                      'ตกลง',
                      Appcolors.copperColor,
                      () async {
                        String goalText = controller.text;
                        int goal = int.tryParse(goalText) ?? 0;

                        if (goal > 0) {
                          await dbHelper.insertChallenge({
                            'title': 'อ่านหนังสือให้ได้ $goal เล่ม$title',
                            'description': 'เป้าหมาย',
                            'goal_count': goal,
                            'current_count': 0,
                            'reward_points': 50,
                            'is_completed': 0,
                          });
                        }
                        if (context.mounted) {
                          Navigator.of(
                            context,
                          ).popUntil((route) => route.isFirst);
                        }
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showAlert(BuildContext context, String title) {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          backgroundColor: Appcolors.notelight,
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'ตั้งเป้าหมายว่าจะอ่านหนังสือกี่เล่ม ?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    fontFamily: 'print',
                    fontWeight: FontWeight.bold,
                    color: Appcolors.jetblackColor,
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 1, left: 5),
                    hintText: 'ชื่อ Challenge',
                    hintStyle: TextStyle(
                      fontFamily: 'print',
                      fontSize: 24,
                      color: Color.fromRGBO(95, 95, 95, 255),
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(142, 142, 142, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 19),
                TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(top: 1, left: 5),
                    hintText: 'จำนวนหนังสือ',
                    hintStyle: TextStyle(
                      fontFamily: 'print',
                      fontSize: 24,
                      color: Color.fromRGBO(95, 95, 95, 255),
                    ),
                    filled: true,
                    fillColor: Color.fromRGBO(142, 142, 142, 255),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    alertButton(context, 'ยกเลิก', Appcolors.copperColor, () {
                      Navigator.pop(context);
                    }),
                    alertButton(context, 'ตกลง', Appcolors.copperColor, () {
                      String goal = controller.text;
                      debugPrint('ตั้งเป้าหมาย $title ไว้ที่ $goal เล่ม');
                      Navigator.pop(context);
                    }),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget alertButton(
    BuildContext context,
    String title,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Appcolors.creamywhiteColor,
          fontSize: 26,
          fontFamily: 'print',
        ),
      ),
    );
  }
}
