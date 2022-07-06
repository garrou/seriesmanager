import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seriesmanager/providers/theme_provider.dart';
import 'package:seriesmanager/views/home/home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
        create: (_) => ThemeModel(),
        child: Consumer<ThemeModel>(
            builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            title: 'Series Manager',
            home: const HomePage(),
            scrollBehavior: CustomScrollBehavior(),
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.isDark
                ? ThemeData(
                    brightness: Brightness.dark,
                    primaryColor: Colors.white,
                    textSelectionTheme: const TextSelectionThemeData(
                      selectionHandleColor:
                          Colors.white, // Change bubble to red
                      cursorColor: Colors.white,
                    ),
                    snackBarTheme: const SnackBarThemeData(
                      backgroundColor: Colors.black,
                      actionTextColor: Colors.white,
                      contentTextStyle: TextStyle(color: Colors.white),
                    ),
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                      backgroundColor: Colors.black,
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                  )
                : ThemeData(
                    brightness: Brightness.light,
                    backgroundColor: Colors.white,
                    primaryColor: Colors.black,
                    textSelectionTheme: const TextSelectionThemeData(
                      selectionHandleColor:
                          Colors.black, // Change bubble to red
                      cursorColor: Colors.black,
                    ),
                    snackBarTheme: const SnackBarThemeData(
                      backgroundColor: Colors.black,
                      actionTextColor: Colors.white,
                      contentTextStyle: TextStyle(color: Colors.white),
                    ),
                    floatingActionButtonTheme:
                        const FloatingActionButtonThemeData(
                      backgroundColor: Colors.black,
                    ),
                    iconTheme: const IconThemeData(color: Colors.white),
                  ),
          );
        }),
      );
}

class CustomScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}
