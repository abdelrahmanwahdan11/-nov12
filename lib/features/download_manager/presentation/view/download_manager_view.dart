import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/download_task.dart';
import '../../../../core/providers/covers_provider.dart';
import '../../../../core/providers/downloads_provider.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/providers/vault_provider.dart';
import '../../../../core/providers/voices_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class DownloadManagerView extends ConsumerWidget {
  const DownloadManagerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final downloads = ref.watch(downloadsProvider);
    final vault = ref.watch(vaultProvider);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;

    final active = downloads.where((task) => task.status == DownloadStatus.downloading).length;
    final queued = downloads.where((task) => task.status == DownloadStatus.queued).length;
    final completed = downloads.where((task) => task.status == DownloadStatus.completed).length;
    final failed = downloads.where((task) => task.status == DownloadStatus.failed).length;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('download_manager_title')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.add_rounded),
              tooltip: localization.translate('download_add_task'),
              onPressed: () => _showAddSheet(context, ref),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: GlassContainer(
                  borderRadius: AppRadiusTokens.lg,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
                  child: Row(
                    children: [
                      Expanded(
                        child: _SummaryMetric(
                          label: localization.translate('download_summary_active'),
                          value: active.toString(),
                          icon: Icons.downloading_rounded,
                        ),
                      ),
                      Expanded(
                        child: _SummaryMetric(
                          label: localization.translate('download_summary_queued'),
                          value: queued.toString(),
                          icon: Icons.schedule_rounded,
                        ),
                      ),
                      Expanded(
                        child: _SummaryMetric(
                          label: localization.translate('download_summary_completed'),
                          value: completed.toString(),
                          icon: Icons.check_circle_rounded,
                        ),
                      ),
                      Expanded(
                        child: _SummaryMetric(
                          label: localization.translate('download_summary_failed'),
                          value: failed.toString(),
                          icon: Icons.error_outline_rounded,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    localization.translate('download_storage_hint')
                        .replaceAll('{size}', vault.totalSizeMb.toStringAsFixed(1)),
                    style: theme.textTheme.bodySmall,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: downloads.isEmpty
                    ? _EmptyDownloadState(message: localization.translate('download_empty_state'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 120),
                        itemBuilder: (context, index) {
                          final task = downloads[index];
                          return _DownloadTile(task: task).animate().fadeIn(duration: AppAnimations.medium);
                        },
                        separatorBuilder: (_, __) => const SizedBox(height: 16),
                        itemCount: downloads.length,
                      ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: AppCTAButton(
            label: localization.translate('download_add_task'),
            onPressed: () => _showAddSheet(context, ref),
          ),
        ),
      ),
    );
  }

  Future<void> _showAddSheet(BuildContext context, WidgetRef ref) async {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final coversState = ref.read(coversProvider);
    final settings = ref.read(settingsProvider);
    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black54,
      builder: (context) {
        return Directionality(
          textDirection: localization.isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GlassContainer(
              borderRadius: AppRadiusTokens.xl,
              padding: const EdgeInsets.all(16),
              child: SafeArea(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      localization.translate('download_sheet_title'),
                      style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 320,
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final cover = coversState.items[index];
                          final voice = ref.read(voiceByIdProvider(cover.voiceId));
                          final subtitle = localization
                              .translate('download_sheet_subtitle')
                              .replaceAll('{voice}', voice?.name ?? cover.voiceId);
                          return ListTile(
                            onTap: () {
                              ref.read(downloadsProvider.notifier).queueFromCover(
                                    cover,
                                    voiceName: voice?.name ?? cover.voiceId,
                                    format: settings.exportFormat.name,
                                  );
                              Navigator.of(context).pop();
                            },
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CachedNetworkImage(
                                imageUrl: cover.artworkUrl,
                                width: 52,
                                height: 52,
                                fit: BoxFit.cover,
                              ),
                            ),
                            title: Text(cover.title),
                            subtitle: Text(subtitle),
                            trailing: const Icon(Icons.download_rounded),
                          );
                        },
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemCount: coversState.items.length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({required this.label, required this.value, required this.icon});

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 6),
        Text(
          value,
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }
}

class _DownloadTile extends ConsumerWidget {
  const _DownloadTile({required this.task});

  final DownloadTask task;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final notifier = ref.read(downloadsProvider.notifier);

    final statusKey = switch (task.status) {
      DownloadStatus.queued => 'download_status_queued',
      DownloadStatus.downloading => 'download_status_active',
      DownloadStatus.paused => 'download_status_paused',
      DownloadStatus.completed => 'download_status_completed',
      DownloadStatus.failed => 'download_status_failed',
    };
    var statusText = localization.translate(statusKey);
    if (task.status == DownloadStatus.failed && task.failureReasonKey != null) {
      final reason = localization.translate(task.failureReasonKey!);
      statusText = '$statusText • $reason';
    } else if (task.status == DownloadStatus.downloading && task.eta != null) {
      final minutes = task.eta!.inMinutes;
      final seconds = task.eta!.inSeconds.remainder(60).toString().padLeft(2, '0');
      statusText = '${localization.translate('download_eta')} $minutes:$seconds';
    }

    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: CachedNetworkImage(
              imageUrl: task.artworkUrl,
              width: 84,
              height: 84,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  '${task.artist} • ${task.voiceName}',
                  style: theme.textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: task.progress.clamp(0, 1),
                  minHeight: 6,
                  backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.4),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(task.sizeMb * task.progress).clamp(0, task.sizeMb).toStringAsFixed(1)}MB / ${task.sizeMb.toStringAsFixed(1)}MB · ${task.format}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(statusText, style: theme.textTheme.bodySmall),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 12,
                  children: _buildActions(localization, notifier),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildActions(AppLocalizations localization, DownloadsNotifier notifier) {
    switch (task.status) {
      case DownloadStatus.downloading:
        return [
          TextButton(
            onPressed: () => notifier.pause(task.id),
            child: Text(localization.translate('download_action_pause')),
          ),
          TextButton(
            onPressed: () => notifier.cancel(task.id),
            child: Text(localization.translate('download_action_cancel')),
          ),
        ];
      case DownloadStatus.queued:
        return [
          TextButton(
            onPressed: () => notifier.cancel(task.id),
            child: Text(localization.translate('download_action_cancel')),
          ),
        ];
      case DownloadStatus.paused:
        return [
          TextButton(
            onPressed: () => notifier.resume(task.id),
            child: Text(localization.translate('download_action_resume')),
          ),
          TextButton(
            onPressed: () => notifier.cancel(task.id),
            child: Text(localization.translate('download_action_cancel')),
          ),
        ];
      case DownloadStatus.failed:
        return [
          TextButton(
            onPressed: () => notifier.retry(task.id),
            child: Text(localization.translate('download_action_retry')),
          ),
        ];
      case DownloadStatus.completed:
        return [
          TextButton(
            onPressed: () => context.push('/player/${task.coverId}'),
            child: Text(localization.translate('download_action_open')),
          ),
        ];
    }
  }
}

class _EmptyDownloadState extends StatelessWidget {
  const _EmptyDownloadState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.cloud_download_outlined, size: 64, color: theme.colorScheme.primary.withOpacity(0.7)),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}
