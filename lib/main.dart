import 'package:flutter/material.dart';
import 'package:object_detection/camera_preview_scanner.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Object Detection Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const CameraPreviewScanner(),
    );
  }
}
