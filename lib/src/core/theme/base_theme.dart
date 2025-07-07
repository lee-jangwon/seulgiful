import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final kBaseTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.blue,
    secondary: Colors.pink,
    brightness: Brightness.light,
  ),
  textTheme: GoogleFonts.nanumGothicTextTheme(),
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.white,
    foregroundColor: Colors.black,
    elevation: 2,
    centerTitle: true,
    titleTextStyle: GoogleFonts.nanumGothic(
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),
  scaffoldBackgroundColor: Colors.white,
);
