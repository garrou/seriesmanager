import 'package:flutter/material.dart';

void push(BuildContext context, Widget destination) => Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => destination),
    );

void pushAndRemove(BuildContext context, Widget destination) =>
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (BuildContext context) => destination),
        (route) => false);

void doublePush(BuildContext context, Widget first, Widget second) {
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => first),
      (route) => false);
  Navigator.push(
    context,
    MaterialPageRoute(builder: (BuildContext context) => second),
  );
}
