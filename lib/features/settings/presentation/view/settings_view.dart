import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/app_theme_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(localeProvider);
    final settings = ref.watch(settingsProvider);
    final isRtl = localization.isRtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('settings')),
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
              _SectionTitle(title: localization.translate('appearance')),
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(localization.translate('theme_mode'), style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: ThemeMode.values.map((mode) {
                        final isSelected = mode == themeMode;
                        final label = localization.translate('theme_${mode.name}');
                        return ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (_) {
                            unawaited(ref.read(appThemeModeProvider.notifier).update(mode));
                          },
                          avatar: Icon(
                            mode == ThemeMode.dark
                                ? IconlyBold.moon
                                : mode == ThemeMode.light
                                    ? IconlyBold.sun
                                    : IconlyBold.activity,
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(localization.translate('language'), style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: AppLocalizations.supportedLocales.map((localeOption) {
                        final isSelected = locale?.languageCode == localeOption.languageCode;
                        final label = localeOption.languageCode == 'ar' ? 'العربية' : 'English';
                        return ChoiceChip(
                          label: Text(label),
                          selected: isSelected,
                          onSelected: (_) {
                            unawaited(ref.read(localeProvider.notifier).update(localeOption));
                          },
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Text(localization.translate('accent_color'), style: theme.textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 12,
                      children: AccentPalette.values.map((palette) {
                        final gradient = palette.gradient(theme);
                        final isSelected = palette == settings.accent;
                        return GestureDetector(
                          onTap: () => unawaited(ref.read(settingsProvider.notifier).updateAccent(palette)),
                          child: AnimatedContainer(
                            duration: AppAnimations.medium,
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              gradient: gradient,
                              borderRadius: AppRadiusTokens.md,
                              border: Border.all(
                                color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
                                width: isSelected ? 3 : 1,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(IconlyBold.tick_square, color: Colors.white)
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: AppAnimations.medium),
              const SizedBox(height: 24),
              _SectionTitle(title: localization.translate('audio_quality')),
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  children: AudioQuality.values.map((quality) {
                    return RadioListTile<AudioQuality>(
                      value: quality,
                      groupValue: settings.audioQuality,
                      onChanged: (value) {
                        if (value != null) {
                          unawaited(ref.read(settingsProvider.notifier).updateAudioQuality(value));
                        }
                      },
                      title: Text(quality.label),
                      secondary: const Icon(IconlyLight.voice),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: localization.translate('export_format')),
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                child: Column(
                  children: ExportFormat.values.map((format) {
                    return SwitchListTile.adaptive(
                      value: settings.exportFormat == format,
                      onChanged: (_) {
                        unawaited(ref.read(settingsProvider.notifier).updateExportFormat(format));
                      },
                      title: Text(format.label),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 24),
              _SectionTitle(title: localization.translate('processing_preferences')),
              const SizedBox(height: 12),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                child: Column(
                  children: [
                    SwitchListTile.adaptive(
                      value: settings.normalizeAudio,
                      onChanged: (value) => unawaited(ref.read(settingsProvider.notifier).toggleNormalize(value)),
                      title: Text(localization.translate('toggle_normalize')),
                    ),
                    SwitchListTile.adaptive(
                      value: settings.fadeEdges,
                      onChanged: (value) => unawaited(ref.read(settingsProvider.notifier).toggleFade(value)),
                      title: Text(localization.translate('toggle_fade_edges')),
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

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
    );
  }
}
