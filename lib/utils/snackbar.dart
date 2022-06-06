import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/text.dart';

void snackBar(BuildContext context, String? message, [Color? color]) =>
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.black,
        content: Text(message ?? 'Erreur', style: textStyle),
        action: SnackBarAction(
          textColor: Colors.white,
          label: 'Ok',
          onPressed: () {},
        ),
      ),
    );
