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

void doublePop(BuildContext context, String action) {
  Navigator.pop(context);
  Navigator.pop(context, action);
}
