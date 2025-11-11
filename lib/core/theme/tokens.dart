import 'package:flutter/material.dart';

class AppPalette {
  const AppPalette({
    required this.bgBase,
    required this.bgSurface,
    required this.glassSurface,
    required this.primaryStart,
    required this.primaryEnd,
    required this.ctaStart,
    required this.ctaEnd,
    required this.textPrimary,
    required this.textSecondary,
    required this.textMuted,
    required this.success,
    required this.warning,
    required this.danger,
    required this.border,
  });

  final Color bgBase;
  final Color bgSurface;
  final Color glassSurface;
  final Color primaryStart;
  final Color primaryEnd;
  final Color ctaStart;
  final Color ctaEnd;
  final Color textPrimary;
  final Color textSecondary;
  final Color textMuted;
  final Color success;
  final Color warning;
  final Color danger;
  final Color border;
}

class AppColorTokens {
  const AppColorTokens._();

  static const AppPalette dark = AppPalette(
    bgBase: Color(0xFF0B0F14),
    bgSurface: Color(0xFF151A25),
    glassSurface: Color.fromRGBO(28, 34, 51, 0.7),
    primaryStart: Color(0xFF00D1FF),
    primaryEnd: Color(0xFF6A3CFF),
    ctaStart: Color(0xFFF6FF7A),
    ctaEnd: Color(0xFF8EDBFF),
    textPrimary: Color(0xFFFFFFFF),
    textSecondary: Color(0xFFAEB7C5),
    textMuted: Color(0xFF6B7384),
    success: Color(0xFF18DC72),
    warning: Color(0xFFFBD34D),
    danger: Color(0xFFFF5D5D),
    border: Color(0xFF2A3142),
  );

  static const AppPalette light = AppPalette(
    bgBase: Color(0xFFF7F9FC),
    bgSurface: Color(0xFFFFFFFF),
    glassSurface: Color.fromRGBO(255, 255, 255, 0.7),
    primaryStart: Color(0xFF4CCBFF),
    primaryEnd: Color(0xFF7E5BFF),
    ctaStart: Color(0xFFFFE87A),
    ctaEnd: Color(0xFF9EE6FF),
    textPrimary: Color(0xFF0B0F14),
    textSecondary: Color(0xFF3A4150),
    textMuted: Color(0xFF7A8396),
    success: Color(0xFF18DC72),
    warning: Color(0xFFFBD34D),
    danger: Color(0xFFFF5D5D),
    border: Color(0xFFE3E8F0),
  );
}

class AppRadiusTokens {
  const AppRadiusTokens._();

  static BorderRadius xs = BorderRadius.circular(8);
  static BorderRadius sm = BorderRadius.circular(12);
  static BorderRadius md = BorderRadius.circular(16);
  static BorderRadius lg = BorderRadius.circular(20);
  static BorderRadius xl = BorderRadius.circular(28);
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
