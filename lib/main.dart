import 'package:flutter/material.dart';
import 'package:seriesmanager/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Series Manager',
      color: Colors.black,
      home: HomePage(),
    );
  }
}
