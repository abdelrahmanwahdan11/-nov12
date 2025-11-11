import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/generation_job.dart';
import '../../../../core/models/voice.dart';
import '../../../../core/providers/covers_provider.dart';
import '../../../../core/providers/queue_provider.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/providers/voices_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class GenerationQueueView extends ConsumerWidget {
  const GenerationQueueView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobs = ref.watch(queueProvider);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;
    final settings = ref.watch(settingsProvider);
    final voices = ref.watch(voicesProvider);

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          titleSpacing: 24,
          title: Text(localization.translate('queue_title')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GlassContainer(
                  borderRadius: AppRadiusTokens.lg,
                  padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 20),
                  child: Row(
                    children: [
                      Icon(
                        settings.notificationsEnabled ? IconlyBold.notification : IconlyLight.notification,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          localization.translate('queue_notifications_hint'),
                          style: theme.textTheme.bodyMedium,
                        ),
                      ),
                      Switch(
                        value: settings.notificationsEnabled,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).toggleNotifications(value);
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: jobs.isEmpty
                      ? _EmptyState(localization: localization)
                      : ListView.separated(
                          itemCount: jobs.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 18),
                          itemBuilder: (context, index) {
                            final job = jobs[index];
                            final voice = voices.firstWhere(
                              (element) => element.id == job.voiceId,
                              orElse: () => voices.first,
                            );
                            return _QueueTile(job: job, voice: voice).animate().fadeIn(duration: AppAnimations.medium);
                          },
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QueueTile extends ConsumerWidget {
  const _QueueTile({required this.job, required this.voice});

  final GenerationJob job;
  final Voice voice;

  Color _statusColor(ThemeData theme) {
    switch (job.status) {
      case GenerationStatus.queued:
        return theme.colorScheme.outlineVariant;
      case GenerationStatus.processing:
        return theme.colorScheme.primary;
      case GenerationStatus.completed:
        return theme.colorScheme.tertiary;
      case GenerationStatus.failed:
        return theme.colorScheme.error;
    }
  }

  String _statusLabel(AppLocalizations localization) {
    switch (job.status) {
      case GenerationStatus.queued:
        return localization.translate('queue_status_queued');
      case GenerationStatus.processing:
        return localization.translate('queue_status_processing');
      case GenerationStatus.completed:
        return localization.translate('queue_status_completed');
      case GenerationStatus.failed:
        return localization.translate('queue_status_failed');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(AppRadiusTokens.md),
                child: CachedNetworkImage(
                  imageUrl: voice.avatarUrl,
                  width: 64,
                  height: 64,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      voice.name,
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 4),
                    Text(job.source, style: theme.textTheme.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Text(
                _statusLabel(localization),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: _statusColor(theme),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          LinearProgressIndicator(
            value: job.status == GenerationStatus.failed ? 1 : job.progress,
            minHeight: 8,
            backgroundColor: theme.colorScheme.surface.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(_statusColor(theme)),
            borderRadius: BorderRadius.circular(AppRadiusTokens.sm),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(IconlyLight.time_circle, size: 18, color: theme.colorScheme.onSurfaceVariant),
              const SizedBox(width: 6),
              Text(
                job.status == GenerationStatus.completed
                    ? localization.translate('queue_ready_label')
                    : localization.translate('queue_eta').replaceFirst('{seconds}', job.eta.inSeconds.toString()),
                style: theme.textTheme.bodySmall,
              ),
              const Spacer(),
              if (job.status == GenerationStatus.failed)
                SizedBox(
                  width: 160,
                  child: AppCtaButton(
                    label: localization.translate('action_retry'),
                    onPressed: () {
                      ref.read(queueProvider.notifier).retryJob(job.id);
                    },
                  ),
                )
              else if (job.status == GenerationStatus.completed)
                SizedBox(
                  width: 180,
                  child: AppCtaButton(
                    label: localization.translate('action_open_player'),
                    onPressed: () {
                      final coversState = ref.read(coversProvider);
                      final fallback = coversState.items.first;
                      final target = coversState.items.firstWhere(
                        (cover) => cover.voiceId == job.voiceId,
                        orElse: () => fallback,
                      );
                      context.push('/player/${target.id}');
                    },
                  ),
                )
              else
                IconButton(
                  icon: const Icon(IconlyLight.close_square),
                  onPressed: () {
                    ref.read(queueProvider.notifier).cancelJob(job.id);
                  },
                ),
            ],
          ),
          if (job.errorMessage != null && job.status == GenerationStatus.failed)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Text(
                localization.translate('queue_error_generic'),
                style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.error),
              ),
            ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.localization});

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(IconlyLight.voice, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(
            localization.translate('queue_empty_title'),
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            localization.translate('queue_empty_subtitle'),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ).animate().fadeIn(duration: AppAnimations.medium),
    );
  }
}
