import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/button.dart';

class AppButton extends StatelessWidget {
  final String content;
  final VoidCallback onPressed;
  const AppButton({Key? key, required this.content, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(content, style: buttonTextStyle),
          style: roundedButtonStyle,
        ),
        padding: const EdgeInsets.all(5),
      );
}
