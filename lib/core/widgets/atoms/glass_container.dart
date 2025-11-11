import 'dart:ui';

import 'package:flutter/material.dart';

import '../../theme/tokens.dart';

class GlassContainer extends StatelessWidget {
  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius,
    this.borderOpacity = 0.35,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;
  final double borderOpacity;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final palette = isDark ? AppColorTokens.dark : AppColorTokens.light;
    final radius = borderRadius ?? AppRadiusTokens.md;

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: AppBlurTokens.glass, sigmaY: AppBlurTokens.glass),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: palette.glassSurface,
            borderRadius: radius,
            border: Border.all(color: palette.border.withOpacity(borderOpacity)),
          ),
          child: child,
        ),
      ),
    );
  }
}
