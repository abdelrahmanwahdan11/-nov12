import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class ExportQualityView extends ConsumerStatefulWidget {
  const ExportQualityView({super.key});

  @override
  ConsumerState<ExportQualityView> createState() => _ExportQualityViewState();
}

class _ExportQualityViewState extends ConsumerState<ExportQualityView> {
  late double _loudnessTarget;

  @override
  void initState() {
    super.initState();
    _loudnessTarget = ref.read(settingsProvider).loudnessTarget;
    ref.listen(settingsProvider, (previous, next) {
      if (_loudnessTarget != next.loudnessTarget) {
        setState(() {
          _loudnessTarget = next.loudnessTarget;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final settings = ref.watch(settingsProvider);
    final isRtl = localization.isRtl;

    const sampleRates = <int>[44100, 48000, 96000];

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('export_quality_title')),
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
                            localization.translate('export_quality_subtitle'),
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            localization.translate('export_quality_preview_heading'),
                            style: theme.textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              _InfoChip(
                                icon: IconlyLight.voice,
                                label: settings.exportFormat.label(localization),
                              ),
                              _InfoChip(
                                icon: IconlyLight.graph,
                                label: '${settings.audioQuality.label(localization)}',
                              ),
                              _InfoChip(
                                icon: IconlyLight.volume_up,
                                label: '${_loudnessTarget.toStringAsFixed(1)} LUFS',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    ClipRRect(
                      borderRadius: AppRadiusTokens.lg,
                      child: CachedNetworkImage(
                        imageUrl: 'https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4',
                        width: 140,
                        height: 140,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: AppAnimations.medium),
              const SizedBox(height: 24),
              Text(
                localization.translate('export_quality_format_heading'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: ExportFormat.values.map((format) {
                    final isSelected = settings.exportFormat == format;
                    return ChoiceChip(
                      label: Text(format.label(localization)),
                      selected: isSelected,
                      avatar: Icon(
                        format == ExportFormat.wav ? IconlyBold.voice : IconlyBold.play,
                        size: 18,
                      ),
                      onSelected: (_) {
                        ref.read(settingsProvider.notifier).updateExportFormat(format);
                      },
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                localization.translate('export_quality_sample_rate'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 12,
                  children: sampleRates.map((rate) {
                    final isSelected = rate == settings.sampleRate;
                    return ChoiceChip(
                      label: Text('${(rate / 1000).toStringAsFixed(rate >= 96000 ? 0 : 1)} kHz'),
                      selected: isSelected,
                      onSelected: (_) => ref.read(settingsProvider.notifier).updateSampleRate(rate),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                localization.translate('export_quality_loudness'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Slider(
                      value: _loudnessTarget,
                      onChanged: (value) {
                        setState(() {
                          _loudnessTarget = value;
                        });
                      },
                      onChangeEnd: (value) {
                        ref.read(settingsProvider.notifier).updateLoudnessTarget(value);
                      },
                      min: -24,
                      max: -6,
                      divisions: 18,
                      label: '${_loudnessTarget.toStringAsFixed(1)} LUFS',
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localization.translate('export_quality_loudness_hint'),
                      style: theme.textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(
                localization.translate('export_quality_processing_title'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      value: settings.normalizeAudio,
                      onChanged: (value) => ref.read(settingsProvider.notifier).toggleNormalize(value),
                      title: Text(localization.translate('toggle_normalize')),
                      secondary: const Icon(IconlyLight.chart),
                    ),
                    const Divider(height: 1),
                    SwitchListTile.adaptive(
                      value: settings.fadeEdges,
                      onChanged: (value) => ref.read(settingsProvider.notifier).toggleFade(value),
                      title: Text(localization.translate('toggle_fade_edges')),
                      secondary: const Icon(IconlyLight.play),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              AppCtaButton(
                label: localization.translate('export_quality_apply'),
                leading: const Icon(IconlyBold.shield_done, color: Colors.black),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(localization.translate('export_quality_applied_toast')),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: AppRadiusTokens.sm,
        color: theme.colorScheme.onSurface.withOpacity(0.05),
        border: Border.all(color: theme.colorScheme.outlineVariant.withOpacity(0.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16),
          const SizedBox(width: 6),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
