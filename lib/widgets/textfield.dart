import 'package:flutter/material.dart';
import 'package:seriesmanager/styles/textfield.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textfieldController;
  final String? Function(String?)? validator;
  final String label;
  final bool obscureText;
  final IconData icon;
  final int maxLines;
  final bool enabled;
  final TextInputType keyboardType;
  const AppTextField(
      {Key? key,
      required this.textfieldController,
      required this.validator,
      required this.label,
      required this.icon,
      required this.keyboardType,
      this.obscureText = false,
      this.maxLines = 1,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: TextFormField(
          enabled: enabled,
          keyboardType: keyboardType,
          maxLines: maxLines,
          controller: textfieldController,
          obscureText: obscureText,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.black),
            focusedBorder: textFieldBorder,
            border: textFieldBorder,
            labelText: label,
            labelStyle: const TextStyle(color: Colors.black),
          ),
          cursorColor: Colors.black,
          validator: validator,
        ),
      );
}
