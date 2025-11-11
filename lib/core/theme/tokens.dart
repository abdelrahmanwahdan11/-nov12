import 'package:flutter/material.dart';

class AppColorTokens {
  const AppColorTokens._();

  static const Color darkBackground = Color(0xFF0B0F14);
  static const Color darkSurface = Color(0xFF151A25);
  static const Color glassSurface = Color.fromRGBO(28, 34, 51, 0.7);
  static const Color primaryStart = Color(0xFF00D1FF);
  static const Color primaryEnd = Color(0xFF6A3CFF);
  static const Color ctaStart = Color(0xFFF6FF7A);
  static const Color ctaEnd = Color(0xFF8EDBFF);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Color(0xFFAEB7C5);
  static const Color textMuted = Color(0xFF6B7384);
  static const Color success = Color(0xFF18DC72);
  static const Color warning = Color(0xFFFBD34D);
  static const Color danger = Color(0xFFFF5D5D);
  static const Color border = Color(0xFF2A3142);

  static const Color lightBackground = Color(0xFFF7F9FC);
  static const Color lightSurface = Colors.white;
  static const Color lightText = Color(0xFF0B0F14);
}

class AppRadiusTokens {
  const AppRadiusTokens._();

  static const BorderRadius xs = BorderRadius.all(Radius.circular(8));
  static const BorderRadius sm = BorderRadius.all(Radius.circular(12));
  static const BorderRadius md = BorderRadius.all(Radius.circular(16));
  static const BorderRadius lg = BorderRadius.all(Radius.circular(20));
  static const BorderRadius xl = BorderRadius.all(Radius.circular(28));
}

class AppSpacingTokens {
  const AppSpacingTokens._();

  static const double base = 8;
}

class AppElevationTokens {
  const AppElevationTokens._();

  static const List<double> values = <double>[0, 2, 6, 12, 24];
}

class AppBlurTokens {
  const AppBlurTokens._();

  static const double glass = 24;
}
