import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/covers_provider.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class HistoryView extends ConsumerWidget {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final coversState = ref.watch(coversProvider);
    final items = List.of(coversState.items)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(localization.translate('history_title')),
        flexibleSpace: Opacity(
          opacity: 0.9,
          child: Container(
            decoration: const BoxDecoration(gradient: AppGradients.aurora),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
          child: items.isEmpty
              ? _EmptyHistory(localization: localization)
              : ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final cover = items[index];
                    final timestamp = DateFormat.yMMMd().add_Hm().format(cover.createdAt);
                    return GlassContainer(
                      borderRadius: AppRadiusTokens.lg,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(IconlyLight.time_circle, color: theme.colorScheme.primary),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cover.title,
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  localization.translate('history_played_at').replaceFirst('{timestamp}', timestamp),
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                ),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: 1,
                                  minHeight: 6,
                                  backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                                  valueColor: AlwaysStoppedAnimation<Color>(theme.colorScheme.primary),
                                  borderRadius: BorderRadius.circular(AppRadiusTokens.sm),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  const _EmptyHistory({required this.localization});

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(IconlyLight.time_circle, size: 56, color: theme.colorScheme.primary),
          const SizedBox(height: 16),
          Text(localization.translate('history_empty_title'), style: theme.textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(
            localization.translate('history_empty_subtitle'),
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
