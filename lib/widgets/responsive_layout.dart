import 'package:flutter/material.dart';

const int mobileDimension = 600;

class AppResponsiveLayout extends StatelessWidget {
  final Widget mobileLayout;
  final Widget desktopLayout;
  const AppResponsiveLayout(
      {Key? key, required this.mobileLayout, required this.desktopLayout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth < mobileDimension) {
        return mobileLayout;
      } else {
        return desktopLayout;
      }
    });
  }
}
