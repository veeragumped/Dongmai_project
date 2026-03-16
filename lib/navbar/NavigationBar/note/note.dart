import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:typed_data';
import 'package:share_plus/share_plus.dart';
import 'package:flutter/material.dart';
import 'package:gongdong/model/book_model.dart';
import 'package:gongdong/model/db.dart';
import 'package:gongdong/navbar/NavigationBar/note/notereal.dart';
import 'package:gongdong/style/app_style.dart';
import 'package:gongdong/wishlist/wishlistinfo.dart';

class Note extends StatefulWidget {
  const Note({super.key});

  @override
  State<Note> createState() => _NoteState();
}

class _NoteState extends State<Note> {
  List<GlobalKey> _boundaryKeys = [];

  Future<void> shareNote(int index) async {
    try {
      RenderRepaintBoundary? boundary =
          _boundaryKeys[index].currentContext!.findRenderObject()
              as RenderRepaintBoundary?;
      if (boundary == null) return;
      if (boundary.debugNeedsPaint) {
        await Future.delayed(Duration(milliseconds: 50));
      }
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      Uint8List pngBytes = byteData!.buffer.asUint8List();
      final directory = await getTemporaryDirectory();
      final imagePath = await File(
        '${directory.path}/note_$index.png',
      ).create();
      await imagePath.writeAsBytes(pngBytes);
      await SharePlus.instance.share(
        ShareParams(files: [XFile(imagePath.path)]),
      );
    } catch (e) {
      debugPrint('เกิดปัญหา $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 51, 50, 55),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25, right: 25, top: 40, bottom: 10),
            child: Text(
              'โน้ต',
              style: TextStyle(
                fontFamily: 'supermarket',
                fontSize: 38,
                color: Appcolors.creamywhiteColor,
              ),
            ),
          ),
          Divider(color: Color.fromARGB(255, 230, 230, 222), thickness: 2),
          SizedBox(height: 20),
          Expanded(
            child: FutureBuilder<List<Map<String, dynamic>>>(
              future: dbHelper.getAllNotes(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(child: CircularProgressIndicator());
                }
                final notes = snapshot.data!;
                final keys = snapshot.data!;
                _boundaryKeys = List.generate(
                  keys.length,
                  (index) => GlobalKey(),
                );
                return ListView.builder(
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    return RepaintBoundary(
                      key: _boundaryKeys[index],
                      child: Stack(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                              left: 20,
                              top: 20,
                              right: 20,
                              bottom: 10,
                            ),
                            padding: EdgeInsets.fromLTRB(20, 15, 85, 30),
                            decoration: BoxDecoration(
                              color: Appcolors.notelight,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 100),
                                    Expanded(
                                      child: SizedBox(
                                        height: 75,
                                        child: Text(
                                          notes[index]['title'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontFamily: 'supermarket',
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                if (notes[index]['image_path'] != null &&
                                    notes[index]['image_path'].isNotEmpty)
                                  Padding(
                                    padding: EdgeInsets.only(top: 10),
                                    child: Wrap(
                                      spacing: 5,
                                      runSpacing: 5,
                                      children:
                                          (notes[index]['image_path'] as String)
                                              .split(',')
                                              .map((path) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: Image.file(
                                                    File(path.trim()),
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              })
                                              .toList(),
                                    ),
                                  ),
                                SizedBox(height: 10),
                                Text(
                                  notes[index]['content'],
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 36,
                            top: 0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: Image.network(
                                notes[index]['thumbnail'],
                                width: 90,
                                height: 122,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 20,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.edit_outlined,
                                  color: Appcolors.jetblackColor,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Notereal(
                                        itemCount: BookModel(
                                          id: notes[index]['book_id']
                                              .toString(),
                                          thumbnail:
                                              notes[index]['thumbnail'] ?? '',
                                          title: notes[index]['title'] ?? '',
                                          authors:
                                              notes[index]['authors'] != null
                                              ? (notes[index]['authors']
                                                        as String)
                                                    .split(',')
                                              : ['ไม่ระบุผู้เขียน'],
                                          pageCount:
                                              notes[index]['pageCount']
                                                  as int? ??
                                              0,
                                          description:
                                              notes[index]['description'] ?? '',
                                        ),
                                      ),
                                    ),
                                  ).then((value) {
                                    setState(() {
                                      setState(() {});
                                    });
                                  });
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 50,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  shareNote(index);
                                },
                                icon: Icon(
                                  Icons.share,
                                  color: Appcolors.jetblackColor,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 20,
                            right: 20,
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('ลบโน้ต?'),
                                      content: Text('คุณแน่ใจที่จะลบโน้ตนี้?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text('ยกเลิก'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            await DBHelper().deleteNote(
                                              notes[index]['book_id']
                                                  .toString(),
                                            );
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                            setState(() {});
                                          },
                                          child: Text('ลบเลย!'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: Appcolors.jetblackColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
