import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/styles.dart';

class AppButton extends StatelessWidget {
  final String content;
  final VoidCallback onPressed;
  const AppButton({Key? key, required this.content, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        child: SizedBox(
          height: 40,
          width: 150,
          child: ElevatedButton(
            onPressed: onPressed,
            child: Text(content, style: buttonTextStyle),
            style: roundedStyle,
          ),
        ),
        padding: const EdgeInsets.all(5),
      );
}
