import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';

void snackBar(BuildContext context, String message, Color color) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message, style: textStyle),
        action: SnackBarAction(
          label: 'Ok',
          onPressed: () {},
        ),
      ),
    );
