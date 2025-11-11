import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/cover.dart';
import '../../../../core/providers/covers_provider.dart';
import '../../../../core/providers/player_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class PlayerView extends ConsumerStatefulWidget {
  const PlayerView({required this.coverId, super.key});

  final String coverId;

  @override
  ConsumerState<PlayerView> createState() => _PlayerViewState();
}

class _PlayerViewState extends ConsumerState<PlayerView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadCover());
  }

  @override
  void didUpdateWidget(covariant PlayerView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.coverId != widget.coverId) {
      _loadCover();
    }
  }

  Future<void> _loadCover() async {
    final cover = _resolveCover();
    await ref.read(playerControllerProvider.notifier).playCover(cover);
  }

  Cover _resolveCover() {
    final coversState = ref.read(coversProvider);
    final fallback = coversState.items.first;
    return coversState.items.firstWhere(
      (cover) => cover.id == widget.coverId,
      orElse: () => fallback,
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final playerState = ref.watch(playerControllerProvider);
    final cover = playerState.activeCover ?? _resolveCover();
    final position = playerState.position;
    final duration = playerState.duration.inMilliseconds == 0 ? cover.duration : playerState.duration;
    final progress = duration.inMilliseconds == 0 ? 0.0 : position.inMilliseconds / duration.inMilliseconds;

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(IconlyLight.arrow_left_circle),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(IconlyLight.download),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(localization.translate('player_download_mock'))),
              );
            },
          ),
          IconButton(
            icon: const Icon(IconlyLight.share),
            onPressed: () {
              Share.share('${cover.title} • ${cover.originalArtist}');
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          CachedNetworkImage(
            imageUrl: cover.artworkUrl,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.6),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  Hero(
                    tag: 'cover_${cover.id}',
                    child: GlassContainer(
                      borderRadius: AppRadiusTokens.xl,
                      padding: EdgeInsets.zero,
                      child: ClipRRect(
                        borderRadius: AppRadiusTokens.xl,
                        child: CachedNetworkImage(
                          imageUrl: cover.artworkUrl,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width * 0.9,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ).animate().fadeIn(duration: AppAnimations.medium),
                  ),
                  const SizedBox(height: 32),
                  Text(
                    cover.title,
                    style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    cover.originalArtist,
                    style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                  ),
                  const SizedBox(height: 32),
                  Column(
                    children: [
                      SliderTheme(
                        data: SliderTheme.of(context).copyWith(
                          activeTrackColor: theme.colorScheme.primary,
                          inactiveTrackColor: theme.colorScheme.onSurface.withOpacity(0.3),
                          thumbColor: theme.colorScheme.primary,
                        ),
                        child: Slider(
                          value: progress.clamp(0, 1),
                          onChanged: (value) {
                            final newPosition = Duration(milliseconds: (duration.inMilliseconds * value).round());
                            ref.read(playerControllerProvider.notifier).seek(newPosition);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_formatDuration(position), style: theme.textTheme.labelMedium),
                            Text(_formatDuration(duration), style: theme.textTheme.labelMedium),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: 28,
                        icon: Icon(
                          playerState.isRepeatEnabled ? IconlyBold.repeat : IconlyLight.repeat,
                        ),
                        onPressed: () {
                          ref.read(playerControllerProvider.notifier).toggleRepeat();
                        },
                      ),
                      const SizedBox(width: 12),
                      GlassContainer(
                        borderRadius: AppRadiusTokens.xl,
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                        child: IconButton(
                          iconSize: 32,
                          icon: Icon(playerState.isPlaying ? IconlyBold.pause : IconlyBold.play),
                          onPressed: () {
                            ref.read(playerControllerProvider.notifier).togglePlayPause();
                          },
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        iconSize: 28,
                        icon: const Icon(IconlyLight.volume_up),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localization.translate('player_volume_mock'))),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  if (playerState.isBuffering)
                    Text(
                      localization.translate('player_buffering'),
                      style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                    ),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
