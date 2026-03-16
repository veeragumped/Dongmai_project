import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gongdong/model/book_model.dart';
import 'package:gongdong/model/db.dart';
import 'package:gongdong/style/app_style.dart';
import 'package:image_picker/image_picker.dart';

class Notereal extends StatefulWidget {
  final BookModel itemCount;

  const Notereal({super.key, required this.itemCount});

  @override
  State<Notereal> createState() => _NoterealState();
}

class _NoterealState extends State<Notereal> {
  final TextEditingController _controller = TextEditingController();
  final DBHelper dbHelper = DBHelper();
  List<File> _selectedImages = [];

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        _selectedImages.addAll(
          images.map((image) => File(image.path)).toList(),
        );
      });
      _saveCerrentData();
    }
  }

  void _saveCerrentData() {
    String allPaths = _selectedImages.map((file) => file.path).join(',');
    dbHelper.saveNotes(widget.itemCount.id, _controller.text, allPaths);
  }

  @override
  void initState() {
    super.initState();
    _loadNote();
  }

  Future<void> _loadNote() async {
    Map<String, dynamic>? noteData = await dbHelper.getNotes(
      widget.itemCount.id,
    );
    if (noteData != null) {
      setState(() {
        _controller.text = noteData['content'] ?? '';
        String? savedPaths = noteData['image_path'];
        if (savedPaths != null && savedPaths.isNotEmpty) {
          _selectedImages = savedPaths
              .split(',')
              .map((path) => File(path))
              .toList();
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Appcolors.notelight,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(right: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: pickImage,
                icon: Icon(Icons.add_photo_alternate),
              ),
            ],
          ),
        ),
        backgroundColor: Appcolors.noteheavy,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Row(
                children: [
                  Image.network(widget.itemCount.thumbnail, width: 100),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      widget.itemCount.title,
                      style: TextStyle(
                        fontFamily: 'supermarket',
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            if (_selectedImages.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(left: 1),
                child: Wrap(
                  alignment: WrapAlignment.start,
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedImages.map((file) {
                    return Stack(
                      children: [
                        Image.file(
                          file,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedImages.remove(file);
                              });
                              _saveCerrentData();
                            },
                            child: Icon(Icons.cancel),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            SizedBox(height: 20),
            Expanded(
              child: TextField(
                style: TextStyle(fontFamily: 'thonburi', fontSize: 18),
                controller: _controller,
                maxLines: null,
                decoration: InputDecoration(
                  hintStyle: TextStyle(fontFamily: 'supermarket', fontSize: 18),
                  hintText: 'เขียนโน้ตที่นี่...',
                  border: InputBorder.none,
                ),
                onChanged: (value) {
                  _saveCerrentData();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
