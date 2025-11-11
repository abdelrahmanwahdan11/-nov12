import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/lab_flag.dart';
import '../../../../core/models/lab_highlight.dart';
import '../../../../core/providers/labs_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class ChangelogLabsView extends ConsumerWidget {
  const ChangelogLabsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(labsProvider);
    final isRtl = localization.isRtl;
    final dateFormat = DateFormat.yMMMd(localization.locale.languageCode);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('labs_title')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
            children: [
              GlassContainer(
                borderRadius: AppRadiusTokens.xl,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localization.translate('labs_subtitle'),
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localization.translate('labs_last_updated')
                                .replaceFirst('{date}', dateFormat.format(state.lastUpdated)),
                            style: theme.textTheme.bodySmall,
                          ),
                          const SizedBox(height: 12),
                          SwitchListTile.adaptive(
                            contentPadding: EdgeInsets.zero,
                            value: state.autoEnroll,
                            onChanged: (value) => ref.read(labsProvider.notifier).toggleAutoEnroll(value),
                            title: Text(localization.translate('labs_auto_enroll')),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    const Icon(IconlyBold.discovery, size: 42),
                  ],
                ),
              ).animate().fadeIn(duration: AppAnimations.medium),
              const SizedBox(height: 24),
              Text(
                localization.translate('labs_flags_heading'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...state.flags.map((flag) => _FlagTile(flag: flag)),
              const SizedBox(height: 24),
              Text(
                localization.translate('labs_release_notes_heading'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              ...state.highlights.map((highlight) => _HighlightCard(highlight: highlight)),
            ],
          ),
        ),
      ),
    );
  }
}

class _FlagTile extends ConsumerWidget {
  const _FlagTile({required this.flag});

  final LabFlag flag;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isEnabled = flag.enabled;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: AppRadiusTokens.lg,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    localization.translate(flag.titleKey),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
                Chip(
                  label: Text(localization.translate(flag.badgeKey)),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              localization.translate(flag.descriptionKey),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            SwitchListTile.adaptive(
              value: isEnabled,
              onChanged: (value) => ref.read(labsProvider.notifier).toggleFlag(flag.id, value),
              title: Text(isEnabled
                  ? localization.translate('labs_flag_enabled')
                  : localization.translate('labs_flag_disabled')),
            ),
          ],
        ),
      ),
    );
  }
}

class _HighlightCard extends StatelessWidget {
  const _HighlightCard({required this.highlight});

  final LabHighlight highlight;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: AppRadiusTokens.lg,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppRadiusTokens.md,
              child: CachedNetworkImage(
                imageUrl: highlight.imageUrl,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Chip(
                  label: Text(localization.translate(highlight.tagKey)),
                  backgroundColor: theme.colorScheme.secondary.withOpacity(0.14),
                ),
                const Spacer(),
                const Icon(IconlyLight.time_circle, size: 18),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              localization.translate(highlight.titleKey),
              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              localization.translate(highlight.descriptionKey),
              style: theme.textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
