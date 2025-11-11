import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  const AppTextStyles._();

  static TextStyle heading1(Color color) => GoogleFonts.urbanist(
        fontSize: 24,
        fontWeight: FontWeight.w800,
        letterSpacing: 0.2,
        color: color,
      );

  static TextStyle heading2(Color color) => GoogleFonts.urbanist(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: color,
      );

  static TextStyle body(Color color) => GoogleFonts.urbanist(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: color,
      );

  static TextStyle caption(Color color) => GoogleFonts.urbanist(
        fontSize: 13,
        fontWeight: FontWeight.w400,
        color: color,
      );
}
