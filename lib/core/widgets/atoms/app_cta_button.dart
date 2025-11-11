import 'package:flutter/material.dart';

import '../../theme/gradients.dart';
import '../../theme/tokens.dart';

class AppCtaButton extends StatelessWidget {
  const AppCtaButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.leading,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56, minWidth: double.infinity),
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: AppGradients.cta,
          borderRadius: AppRadiusTokens.xl,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              offset: const Offset(0, 12),
              blurRadius: 24,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: AppRadiusTokens.xl,
            onTap: onPressed,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (leading != null) ...[
                    leading!,
                    const SizedBox(width: 12),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: textTheme.titleMedium?.copyWith(
                        color: AppColorTokens.dark.bgBase,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
