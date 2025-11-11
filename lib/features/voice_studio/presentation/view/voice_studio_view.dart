import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';
import '../../../../core/widgets/organisms/feature_placeholder.dart';

class VoiceStudioView extends ConsumerWidget {
  const VoiceStudioView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('studio_title')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            children: [
              Text(
                localization.translate('studio_subtitle'),
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.translate('studio_tools_title'),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _StudioToolChip(label: localization.translate('studio_tool_trim'), icon: Icons.content_cut),
                        _StudioToolChip(label: localization.translate('studio_tool_speed'), icon: Icons.speed),
                        _StudioToolChip(label: localization.translate('studio_tool_pitch'), icon: Icons.multitrack_audio),
                        _StudioToolChip(label: localization.translate('studio_tool_eq'), icon: Icons.equalizer),
                        _StudioToolChip(label: localization.translate('studio_tool_compare'), icon: Icons.compare_arrows),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.translate('studio_monitor_title'),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      localization.translate('studio_monitor_subtitle'),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 16),
                    FeaturePlaceholder(
                      title: localization.translate('studio_placeholder_title'),
                      subtitle: localization.translate('studio_placeholder_subtitle'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StudioToolChip extends StatelessWidget {
  const _StudioToolChip({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: AppRadiusTokens.sm,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20),
          const SizedBox(width: 8),
          Text(label, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }
}
