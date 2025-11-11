import 'package:flutter/material.dart';

import 'tokens.dart';

class AppGradients {
  const AppGradients._();

  static const LinearGradient aurora = LinearGradient(
    colors: [AppColorTokens.dark.primaryStart, AppColorTokens.dark.primaryEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cta = LinearGradient(
    colors: [AppColorTokens.dark.ctaStart, AppColorTokens.dark.ctaEnd],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static LinearGradient background(Brightness brightness) {
    final palette = brightness == Brightness.dark ? AppColorTokens.dark : AppColorTokens.light;
    return LinearGradient(
      colors: [palette.bgBase, palette.bgSurface],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );
  }
}
