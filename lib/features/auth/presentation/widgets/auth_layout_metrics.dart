import 'package:flutter/material.dart';

import '../../../../core/theme/tokens.dart';

class AuthLayoutMetrics {
  const AuthLayoutMetrics({
    required this.showHero,
    required this.heroFlex,
    required this.formFlex,
    required this.formMaxWidth,
    required this.heroMaxWidth,
    required this.formPadding,
    required this.heroPadding,
    required this.heroAspectRatio,
  });

  final bool showHero;
  final int heroFlex;
  final int formFlex;
  final double formMaxWidth;
  final double heroMaxWidth;
  final EdgeInsetsDirectional formPadding;
  final EdgeInsetsDirectional heroPadding;
  final double heroAspectRatio;

  static AuthLayoutMetrics resolve(MediaQueryData media, BoxConstraints constraints) {
    final double width = constraints.maxWidth;
    final bool showHero = width >= 960;
    final bool extraWide = width >= 1440;

    final double horizontalPadding = showHero
        ? (extraWide ? AppSpacingTokens.base * 8 : AppSpacingTokens.base * 5)
        : AppSpacingTokens.base * 3;
    final double trailingPadding = showHero ? AppSpacingTokens.base * 4 : AppSpacingTokens.base * 3;

    final double bottomPadding =
        (showHero ? AppSpacingTokens.base * 6 : AppSpacingTokens.base * 4) + media.padding.bottom;
    final double topPadding = media.padding.top + kToolbarHeight +
        (showHero ? AppSpacingTokens.base * 5 : AppSpacingTokens.base * 4);

    final EdgeInsetsDirectional formPadding = EdgeInsetsDirectional.only(
      start: horizontalPadding,
      end: horizontalPadding,
      top: topPadding,
      bottom: bottomPadding,
    );

    final EdgeInsetsDirectional heroPadding = EdgeInsetsDirectional.only(
      start: horizontalPadding,
      end: trailingPadding,
      top: media.padding.top + kToolbarHeight + AppSpacingTokens.base * 3,
      bottom: bottomPadding,
    );

    final int heroFlex = showHero ? (extraWide ? 7 : 6) : 0;
    final int formFlex = showHero ? 11 - heroFlex : 1;

    final double heroMaxWidth = extraWide ? 640 : 560;
    final double formMaxWidth = showHero ? 560 : 540;

    final double heroAspectRatio = extraWide ? 4 / 5 : 0.78;

    return AuthLayoutMetrics(
      showHero: showHero,
      heroFlex: heroFlex,
      formFlex: formFlex,
      formMaxWidth: formMaxWidth,
      heroMaxWidth: heroMaxWidth,
      formPadding: formPadding,
      heroPadding: heroPadding,
      heroAspectRatio: heroAspectRatio,
    );
  }
}
