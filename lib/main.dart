import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:seriesmanager/views/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Series Manager',
      color: Colors.black,
      home: const HomePage(),
      scrollBehavior: CustomScrollBehavior(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        textSelectionTheme: const TextSelectionThemeData(
          selectionHandleColor: Colors.black, // Change bubble to red
          cursorColor: Colors.black,
        ),
      ),
    );
  }
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
