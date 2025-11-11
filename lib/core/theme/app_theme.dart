import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'animations.dart';
import 'tokens.dart';

ColorScheme _buildColorScheme(AppPalette palette, Brightness brightness) {
  return ColorScheme(
    brightness: brightness,
    primary: palette.primaryEnd,
    onPrimary: palette.textPrimary,
    primaryContainer: palette.primaryStart.withOpacity(0.24),
    onPrimaryContainer: palette.textPrimary,
    secondary: palette.primaryStart,
    onSecondary: palette.textPrimary,
    secondaryContainer: palette.primaryEnd.withOpacity(0.18),
    onSecondaryContainer: palette.textPrimary,
    tertiary: palette.ctaEnd,
    onTertiary: brightness == Brightness.dark ? palette.textPrimary : AppColorTokens.dark.bgBase,
    tertiaryContainer: palette.ctaStart.withOpacity(0.2),
    onTertiaryContainer: palette.textPrimary,
    error: palette.danger,
    onError: palette.textPrimary,
    errorContainer: palette.danger.withOpacity(0.12),
    onErrorContainer: palette.textPrimary,
    background: palette.bgBase,
    onBackground: palette.textPrimary,
    surface: palette.bgSurface,
    onSurface: palette.textSecondary,
    surfaceVariant: palette.glassSurface,
    onSurfaceVariant: palette.textMuted,
    outline: palette.border,
    outlineVariant: palette.border.withOpacity(0.5),
    shadow: Colors.black,
    scrim: Colors.black54,
    inverseSurface: brightness == Brightness.dark ? AppColorTokens.light.bgSurface : AppColorTokens.dark.bgSurface,
    onInverseSurface: brightness == Brightness.dark ? AppColorTokens.light.textPrimary : AppColorTokens.dark.textPrimary,
    inversePrimary: palette.primaryStart,
    surfaceTint: palette.primaryEnd,
  );
}

TextTheme _textTheme(TextTheme base, AppPalette palette) {
  final themed = GoogleFonts.urbanistTextTheme(base).copyWith(
    displayLarge: GoogleFonts.urbanist(textStyle: base.displayLarge)?.copyWith(fontWeight: FontWeight.w800),
    displayMedium: GoogleFonts.urbanist(textStyle: base.displayMedium)?.copyWith(fontWeight: FontWeight.w700),
    headlineLarge: GoogleFonts.urbanist(textStyle: base.headlineLarge)?.copyWith(fontWeight: FontWeight.w700),
    headlineMedium: GoogleFonts.urbanist(textStyle: base.headlineMedium)?.copyWith(fontWeight: FontWeight.w600),
    titleLarge: GoogleFonts.urbanist(textStyle: base.titleLarge)?.copyWith(fontWeight: FontWeight.w600),
  );

  return themed.apply(
    bodyColor: palette.textPrimary,
    displayColor: palette.textPrimary,
  );
}

class _FadeSlidePageTransitionsBuilder extends PageTransitionsBuilder {
  const _FadeSlidePageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: AppAnimations.defaultCurve,
      reverseCurve: AppAnimations.defaultCurve.flipped,
    );
    final offsetTween = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero).chain(
      CurveTween(curve: AppAnimations.defaultCurve),
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: curved.drive(offsetTween),
        child: child,
      ),
    );
  }
}

ThemeData buildLightTheme() {
  const palette = AppColorTokens.light;
  final base = ThemeData.light(useMaterial3: true);
  final colorScheme = _buildColorScheme(palette, Brightness.light);

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: palette.bgBase,
    canvasColor: palette.bgBase,
    textTheme: _textTheme(base.textTheme, palette),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: palette.textPrimary,
      surfaceTintColor: Colors.transparent,
    ),
    iconTheme: IconThemeData(color: palette.textPrimary),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.glassSurface,
      border: OutlineInputBorder(
        borderRadius: AppRadiusTokens.lg,
        borderSide: BorderSide(color: palette.border.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadiusTokens.lg,
        borderSide: BorderSide(color: palette.primaryEnd.withOpacity(0.7)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: palette.glassSurface,
      selectedColor: palette.primaryEnd.withOpacity(0.35),
      labelStyle: TextStyle(color: palette.textPrimary, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.sm, side: BorderSide(color: palette.border.withOpacity(0.3))),
      secondaryLabelStyle: TextStyle(color: palette.textPrimary),
      secondarySelectedColor: palette.primaryStart.withOpacity(0.45),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: palette.glassSurface,
      indicatorColor: palette.primaryEnd.withOpacity(0.35),
      elevation: 0,
      height: 72,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(color: isSelected ? palette.textPrimary : palette.textSecondary);
      }),
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(fontWeight: FontWeight.w600, color: palette.textPrimary),
      ),
    ),
    cardColor: palette.glassSurface,
    dividerColor: palette.border.withOpacity(0.2),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _FadeSlidePageTransitionsBuilder(),
        TargetPlatform.iOS: _FadeSlidePageTransitionsBuilder(),
        TargetPlatform.macOS: _FadeSlidePageTransitionsBuilder(),
        TargetPlatform.linux: _FadeSlidePageTransitionsBuilder(),
        TargetPlatform.windows: _FadeSlidePageTransitionsBuilder(),
      },
    ),
  );
}

ThemeData buildDarkTheme() {
  const palette = AppColorTokens.dark;
  final base = ThemeData.dark(useMaterial3: true);
  final colorScheme = _buildColorScheme(palette, Brightness.dark);

  return base.copyWith(
    colorScheme: colorScheme,
    scaffoldBackgroundColor: palette.bgBase,
    canvasColor: palette.bgBase,
    textTheme: _textTheme(base.textTheme, palette),
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: palette.textPrimary,
      surfaceTintColor: Colors.transparent,
    ),
    iconTheme: IconThemeData(color: palette.textPrimary),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: palette.glassSurface,
      border: OutlineInputBorder(
        borderRadius: AppRadiusTokens.lg,
        borderSide: BorderSide(color: palette.border.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: AppRadiusTokens.lg,
        borderSide: BorderSide(color: palette.primaryStart.withOpacity(0.7)),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: palette.glassSurface,
      selectedColor: palette.primaryEnd.withOpacity(0.45),
      labelStyle: TextStyle(color: palette.textPrimary, fontWeight: FontWeight.w600),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: AppRadiusTokens.sm, side: BorderSide(color: palette.border.withOpacity(0.3))),
      secondaryLabelStyle: TextStyle(color: palette.textPrimary),
      secondarySelectedColor: palette.primaryStart.withOpacity(0.45),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: palette.glassSurface,
      indicatorColor: palette.primaryEnd.withOpacity(0.35),
      elevation: 0,
      height: 72,
      iconTheme: WidgetStateProperty.resolveWith((states) {
        final isSelected = states.contains(WidgetState.selected);
        return IconThemeData(color: isSelected ? palette.textPrimary : palette.textSecondary);
      }),
      labelTextStyle: WidgetStateProperty.all(
        TextStyle(fontWeight: FontWeight.w600, color: palette.textPrimary),
      ),
    ),
    cardColor: palette.glassSurface,
    dividerColor: palette.border.withOpacity(0.2),
    pageTransitionsTheme: const PageTransitionsTheme(
      builders: {
        TargetPlatform.android: _FadeSlidePageTransitionsBuilder(),
        TargetPlatform.iOS: _FadeSlidePageTransitionsBuilder(),
        TargetPlatform.macOS: _FadeSlidePageTransitionsBuilder(),
        TargetPlatform.linux: _FadeSlidePageTransitionsBuilder(),
        TargetPlatform.windows: _FadeSlidePageTransitionsBuilder(),
      },
    ),
  );
}
