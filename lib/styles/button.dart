import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ButtonStyle roundedButtonStyle = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Colors.black),
    ),
  ),
  backgroundColor: MaterialStateProperty.all(Colors.black),
);

TextStyle buttonTextStyle = GoogleFonts.roboto(fontSize: 20);
