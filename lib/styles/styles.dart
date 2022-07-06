import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ButtonStyle roundedStyle = ButtonStyle(
  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
    RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: const BorderSide(color: Colors.black),
    ),
  ),
  backgroundColor: MaterialStateProperty.all(Colors.black),
);

TextStyle titleTextStyle = GoogleFonts.roboto(fontSize: 30);
TextStyle boldTextStyle =
    GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold);
TextStyle smallBoldTextStyle =
    GoogleFonts.roboto(fontSize: 18, fontWeight: FontWeight.bold);
TextStyle textStyle = GoogleFonts.roboto(fontSize: 20);
TextStyle minTextStyle = GoogleFonts.roboto(fontSize: 18);
TextStyle linkTextStyle = GoogleFonts.roboto(fontSize: 20, color: Colors.blue);
TextStyle buttonTextStyle = GoogleFonts.roboto(fontSize: 20);

const double iconSize = 25;

int getNbEltExpandedByWidth(double width) => width < 300
    ? 1
    : width < 500
        ? 2
        : width < 800
            ? 3
            : 4;

int getNbEltByWidth(double width) => width < 600
    ? 1
    : width < 900
        ? 2
        : 3;
