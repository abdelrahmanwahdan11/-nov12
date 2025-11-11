import 'package:flutter/material.dart';

import 'tokens.dart';

ColorScheme buildDarkColorScheme() {
  return const ColorScheme(
    brightness: Brightness.dark,
    primary: AppColorTokens.primaryEnd,
    onPrimary: AppColorTokens.textPrimary,
    primaryContainer: AppColorTokens.glassSurface,
    onPrimaryContainer: AppColorTokens.textPrimary,
    secondary: AppColorTokens.primaryStart,
    onSecondary: AppColorTokens.textPrimary,
    secondaryContainer: AppColorTokens.glassSurface,
    onSecondaryContainer: AppColorTokens.textPrimary,
    tertiary: AppColorTokens.ctaEnd,
    onTertiary: AppColorTokens.lightText,
    error: AppColorTokens.danger,
    onError: AppColorTokens.textPrimary,
    background: AppColorTokens.darkBackground,
    onBackground: AppColorTokens.textPrimary,
    surface: AppColorTokens.darkSurface,
    onSurface: AppColorTokens.textSecondary,
    surfaceVariant: AppColorTokens.glassSurface,
    onSurfaceVariant: AppColorTokens.textMuted,
    outline: AppColorTokens.border,
    shadow: Colors.black,
    inverseSurface: AppColorTokens.lightSurface,
    onInverseSurface: AppColorTokens.lightText,
    inversePrimary: AppColorTokens.primaryStart,
    surfaceTint: AppColorTokens.primaryEnd,
  );
}

ColorScheme buildLightColorScheme() {
  return const ColorScheme(
    brightness: Brightness.light,
    primary: AppColorTokens.primaryEnd,
    onPrimary: AppColorTokens.lightText,
    primaryContainer: AppColorTokens.ctaEnd,
    onPrimaryContainer: AppColorTokens.lightText,
    secondary: AppColorTokens.primaryStart,
    onSecondary: AppColorTokens.lightText,
    secondaryContainer: AppColorTokens.ctaStart,
    onSecondaryContainer: AppColorTokens.lightText,
    tertiary: AppColorTokens.ctaStart,
    onTertiary: AppColorTokens.lightText,
    error: AppColorTokens.danger,
    onError: AppColorTokens.textPrimary,
    background: AppColorTokens.lightBackground,
    onBackground: AppColorTokens.lightText,
    surface: AppColorTokens.lightSurface,
    onSurface: AppColorTokens.lightText,
    surfaceVariant: AppColorTokens.lightSurface,
    onSurfaceVariant: AppColorTokens.lightText,
    outline: AppColorTokens.border,
    shadow: Colors.black38,
    inverseSurface: AppColorTokens.darkSurface,
    onInverseSurface: AppColorTokens.textPrimary,
    inversePrimary: AppColorTokens.primaryEnd,
    surfaceTint: AppColorTokens.primaryEnd,
  );
}
