import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/vault_item.dart';
import '../../../../core/providers/vault_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class OfflineVaultView extends ConsumerStatefulWidget {
  const OfflineVaultView({super.key});

  @override
  ConsumerState<OfflineVaultView> createState() => _OfflineVaultViewState();
}

class _OfflineVaultViewState extends ConsumerState<OfflineVaultView> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(vaultProvider);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;

    final items = state.filtered;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('offline_vault_title')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 8),
                child: GlassContainer(
                  borderRadius: AppRadiusTokens.lg,
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.translate('offline_vault_total_items'),
                              style: theme.textTheme.bodySmall,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              items.length.toString(),
                              style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(localization.translate('offline_vault_total_storage'),
                                style: theme.textTheme.bodySmall),
                            const SizedBox(height: 4),
                            Text(
                              '${state.totalSizeMb.toStringAsFixed(1)} MB',
                              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: GlassContainer(
                  borderRadius: AppRadiusTokens.md,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  child: TextField(
                    controller: _controller,
                    onChanged: (value) => ref.read(vaultProvider.notifier).updateQuery(value),
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: localization.translate('offline_vault_search_hint'),
                      icon: const Icon(Icons.search_rounded),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Wrap(
                      spacing: 8,
                      children: [
                        FilterChip(
                          label: Text(localization.translate('offline_vault_filter_all')),
                          selected: state.formatFilter == null,
                          onSelected: (_) => ref.read(vaultProvider.notifier).updateFormatFilter(null),
                        ),
                        FilterChip(
                          label: const Text('MP3'),
                          selected: state.formatFilter == 'MP3',
                          onSelected: (_) => ref.read(vaultProvider.notifier).updateFormatFilter('MP3'),
                        ),
                        FilterChip(
                          label: const Text('WAV'),
                          selected: state.formatFilter == 'WAV',
                          onSelected: (_) => ref.read(vaultProvider.notifier).updateFormatFilter('WAV'),
                        ),
                      ],
                    ),
                    const Spacer(),
                    PopupMenuButton<VaultSortOption>(
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: VaultSortOption.recent,
                          child: Text(localization.translate('offline_vault_sort_recent')),
                        ),
                        PopupMenuItem(
                          value: VaultSortOption.alphabetical,
                          child: Text(localization.translate('offline_vault_sort_alpha')),
                        ),
                        PopupMenuItem(
                          value: VaultSortOption.duration,
                          child: Text(localization.translate('offline_vault_sort_duration')),
                        ),
                        PopupMenuItem(
                          value: VaultSortOption.size,
                          child: Text(localization.translate('offline_vault_sort_size')),
                        ),
                      ],
                      onSelected: (option) => ref.read(vaultProvider.notifier).updateSort(option),
                      child: GlassContainer(
                        borderRadius: AppRadiusTokens.sm,
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.tune_rounded, size: 18),
                            const SizedBox(width: 6),
                            Text(localization.translate('offline_vault_sort_label')),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: items.isEmpty
                    ? _EmptyVault(message: localization.translate('offline_vault_empty'))
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 14),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return Dismissible(
                            key: ValueKey(item.id),
                            background: Container(
                              decoration: BoxDecoration(
                                color: theme.colorScheme.error.withOpacity(0.2),
                                borderRadius: AppRadiusTokens.lg,
                              ),
                              alignment: AlignmentDirectional.centerEnd,
                              padding: const EdgeInsets.symmetric(horizontal: 24),
                              child: Icon(Icons.delete_outline_rounded, color: theme.colorScheme.error),
                            ),
                            direction: DismissDirection.endToStart,
                            onDismissed: (_) => ref.read(vaultProvider.notifier).remove(item.id),
                            child: _VaultTile(item: item).animate().fadeIn(duration: AppAnimations.medium),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VaultTile extends ConsumerWidget {
  const _VaultTile({required this.item});

  final VaultItem item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: CachedNetworkImage(
              imageUrl: item.artworkUrl,
              width: 72,
              height: 72,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text('${item.artist} • ${item.voiceName}', style: theme.textTheme.bodySmall),
                const SizedBox(height: 6),
                Text(
                  '${localization.translate('offline_vault_format')} ${item.format} · ${item.duration.inMinutes}:${(item.duration.inSeconds % 60).toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                ),
                const SizedBox(height: 6),
                Text(
                  localization
                      .translate('offline_vault_downloaded_at')
                      .replaceAll('{time}', _formatTime(context, item.downloadedAt)),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${item.sizeMb.toStringAsFixed(1)} MB', style: theme.textTheme.bodyMedium),
              const SizedBox(height: 8),
              TextButton(
                onPressed: () => context.push('/player/${item.coverId}'),
                child: Text(localization.translate('offline_vault_action_play')),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatTime(BuildContext context, DateTime time) {
    final localization = AppLocalizations.of(context);
    final now = DateTime.now();
    final difference = now.difference(time);
    if (difference.inMinutes < 1) {
      return localization.translate('notifications_relative_now');
    }
    if (difference.inMinutes < 60) {
      return localization
          .translate('notifications_relative_minutes')
          .replaceAll('{value}', difference.inMinutes.toString());
    }
    if (difference.inHours < 24) {
      return localization
          .translate('notifications_relative_hours')
          .replaceAll('{value}', difference.inHours.toString());
    }
    return localization
        .translate('notifications_relative_days')
        .replaceAll('{value}', difference.inDays.toString());
  }
}

class _EmptyVault extends StatelessWidget {
  const _EmptyVault({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.download_done_outlined, size: 64, color: theme.colorScheme.primary),
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
