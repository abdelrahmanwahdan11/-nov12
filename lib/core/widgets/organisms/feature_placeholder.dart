import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FeaturePlaceholder extends StatelessWidget {
  const FeaturePlaceholder({required this.title, required this.subtitle, super.key});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 360),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface.withOpacity(0.7),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: theme.colorScheme.outline.withOpacity(0.4)),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.08),
              blurRadius: 24,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 12),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ).animate().fade(duration: 350.ms).scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutCubic),
    );
  }
}
