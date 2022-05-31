import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/button.dart';

class AppButton extends StatelessWidget {
  final String content;
  final VoidCallback onPressed;
  const AppButton({Key? key, required this.content, required this.onPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      child: SizedBox(
        child: ElevatedButton(
          onPressed: onPressed,
          child: Text(content, style: buttonTextStyle),
          style: roundedButtonStyle,
        ),
        height: 40,
        width: 150,
      ),
      padding: const EdgeInsets.all(10),
    );
  }
}
