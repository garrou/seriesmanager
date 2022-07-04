import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';

Future<void> helpDialog(BuildContext context, String text) => showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Aide', style: textStyle),
          content: Text(text, style: minTextStyle),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Compris', style: textStyle),
            )
          ],
        );
      },
    );
