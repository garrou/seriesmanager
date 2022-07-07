import 'package:flutter/material.dart';

void snackBar(BuildContext context, String? message, [Color? color]) =>
    ScaffoldMessenger.of(context)
      ..removeCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Theme.of(context).snackBarTheme.backgroundColor,
          content: Text(message ?? 'Erreur',
              style: Theme.of(context).snackBarTheme.contentTextStyle),
          action: SnackBarAction(
            textColor: Theme.of(context).snackBarTheme.actionTextColor,
            label: 'Ok',
            onPressed: () {},
          ),
        ),
      );
