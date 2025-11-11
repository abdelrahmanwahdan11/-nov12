import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/voice.dart';
import '../../../../core/providers/voices_provider.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class VoiceDetailView extends ConsumerStatefulWidget {
  const VoiceDetailView({required this.voiceId, super.key});

  final String voiceId;

  @override
  ConsumerState<VoiceDetailView> createState() => _VoiceDetailViewState();
}

class _VoiceDetailViewState extends ConsumerState<VoiceDetailView> {
  late final AudioPlayer _player;
  StreamSubscription<PlayerState>? _playerSubscription;
  String? _activeSampleKey;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _playerSubscription = _player.playerStateStream.listen((state) {
      final playing = state.playing;
      final completed = state.processingState == ProcessingState.completed;
      if (!mounted) {
        return;
      }
      setState(() {
        _isPlaying = playing && !completed;
        if (completed) {
          _activeSampleKey = null;
        }
      });
    });
  }

  @override
  void dispose() {
    unawaited(_playerSubscription?.cancel());
    unawaited(_player.dispose());
    super.dispose();
  }

  Future<void> _playSample(Voice voice, VoiceSample sample) async {
    final isCurrent = _activeSampleKey == sample.titleKey;
    if (isCurrent && _isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
      return;
    }
    await _player.setUrl(sample.url);
    await _player.play();
    setState(() {
      _activeSampleKey = sample.titleKey;
      _isPlaying = true;
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final isRtl = localization.isRtl;
    final theme = Theme.of(context);
    final voice = ref.watch(voiceByIdProvider(widget.voiceId));
    final favorites = ref.watch(favoriteVoicesProvider);

    if (voice == null) {
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          appBar: AppBar(title: Text(localization.translate('voice_detail_not_found'))),
          body: Center(
            child: Text(localization.translate('voice_detail_missing_description')),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(voice.name),
          actions: [
            IconButton(
              onPressed: () async {
                await ref.read(favoriteVoicesProvider.notifier).toggle(voice.id);
              },
              icon: Icon(
                favorites.contains(voice.id) ? IconlyBold.heart : IconlyLight.heart,
                color: favorites.contains(voice.id)
                    ? theme.colorScheme.tertiary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 12),
          ],
          flexibleSpace: Opacity(
            opacity: 0.85,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'voice_${voice.id}',
                      child: CachedNetworkImage(
                        imageUrl: voice.heroImageUrl ?? voice.avatarUrl,
                        height: 240,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            voice.description,
                            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          GlassContainer(
                            borderRadius: AppRadiusTokens.lg,
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localization.translate('voice_detail_overview'),
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 12),
                                Wrap(
                                  spacing: 12,
                                  runSpacing: 12,
                                  children: [
                                    _DetailChip(
                                      icon: IconlyLight.chart,
                                      label: localization.translate(voice.rangeKey),
                                    ),
                                    _DetailChip(
                                      icon: IconlyLight.shield_done,
                                      label: localization.translate(voice.licenseKey),
                                    ),
                                    ...voice.tags.map(
                                      (tag) => _DetailChip(
                                        icon: IconlyLight.category,
                                        label: '#$tag',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (voice.sampleClips.isEmpty)
                            GlassContainer(
                              borderRadius: AppRadiusTokens.lg,
                              padding: const EdgeInsets.all(24),
                              child: Row(
                                children: [
                                  const Icon(IconlyLight.info_square),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      localization.translate('voice_detail_no_samples'),
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  localization.translate('voice_detail_samples'),
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 16),
                                ...voice.sampleClips.map((sample) {
                                  final isActive = _activeSampleKey == sample.titleKey && _isPlaying;
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 14),
                                    child: GlassContainer(
                                      borderRadius: AppRadiusTokens.lg,
                                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                                      child: Row(
                                        children: [
                                          GlassContainer(
                                            borderRadius: AppRadiusTokens.md,
                                            padding: const EdgeInsets.all(12),
                                            child: Icon(
                                              isActive ? IconlyBold.play : IconlyLight.play,
                                              color: theme.colorScheme.primary,
                                            ),
                                          ),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  localization.translate(sample.titleKey),
                                                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  _formatDuration(sample.duration),
                                                  style: theme.textTheme.labelMedium?.copyWith(
                                                    color: theme.colorScheme.onSurfaceVariant,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          IconButton(
                                            onPressed: () => _playSample(voice, sample),
                                            icon: Icon(
                                              isActive && _isPlaying ? IconlyBold.pause : IconlyLight.play,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          const SizedBox(height: 32),
                          AppCtaButton(
                            label: localization.translate('voice_detail_use_voice'),
                            onPressed: () async {
                              final storage = ref.read(storageServiceProvider);
                              await storage.writeString(StorageService.lastVoiceIdKey, voice.id);
                              if (!mounted) {
                                return;
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(localization.translate('voice_detail_selected_toast')),
                                ),
                              );
                              context.pop(voice.id);
                            },
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
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

class _DetailChip extends StatelessWidget {
  const _DetailChip({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: AppRadiusTokens.sm,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
