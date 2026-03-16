import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Isbnscan extends StatefulWidget {
  const Isbnscan({super.key});

  @override
  State<Isbnscan> createState() => _IsbnscanState();
}

class _IsbnscanState extends State<Isbnscan> {
  bool isProcessed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'สแกน ISBN',
          style: TextStyle(fontFamily: 'supermarket', fontSize: 20),
        ),
      ),
      body: MobileScanner(
        onDetect: (capture) {
          if (isProcessed) return;
          final barcodes = capture.barcodes.first;
          if (barcodes.rawValue != null) {
            isProcessed = true;
            Navigator.pop(context, barcodes.rawValue);
          }
        },
      ),
    );
  }
}
