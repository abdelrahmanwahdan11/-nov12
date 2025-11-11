import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';
import 'package:intl/intl.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/activity_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class ActivityCenterView extends ConsumerStatefulWidget {
  const ActivityCenterView({super.key});

  @override
  ConsumerState<ActivityCenterView> createState() => _ActivityCenterViewState();
}

class _ActivityCenterViewState extends ConsumerState<ActivityCenterView> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    final initialQuery = ref.read(activityCenterProvider).query;
    _searchController = TextEditingController(text: initialQuery);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(activityCenterProvider);
    final notifier = ref.read(activityCenterProvider.notifier);
    final isRtl = localization.isRtl;
    final localeTag = localization.locale.toLanguageTag();
    final filteredEvents = state.filtered;
    final dateFormatter = DateFormat.yMMMd(localeTag).add_Hm();
    final totalEvents = state.events.length;
    final lastEventTime =
        filteredEvents.isNotEmpty ? dateFormatter.format(filteredEvents.first.timestamp) : null;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('activity_center_title')),
          actions: [
            IconButton(
              icon: const Icon(IconlyLight.refresh),
              tooltip: localization.translate('activity_refresh'),
              onPressed: notifier.refresh,
            ),
          ],
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
              Text(
                localization.translate('activity_center_description'),
                style: theme.textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${localization.translate('activity_summary_total_prefix')}: $totalEvents',
                                style: theme.textTheme.titleMedium,
                              ),
                              if (lastEventTime != null) ...[
                                const SizedBox(height: 6),
                                Text(
                                  '${localization.translate('activity_summary_recent_prefix')}: $lastEventTime',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        TextButton.icon(
                          onPressed: state.query.isEmpty && state.filter == null && !state.showPinnedOnly
                              ? null
                              : notifier.clearFilters,
                          icon: const Icon(IconlyLight.close_square),
                          label: Text(localization.translate('action_clear_filters')),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _searchController,
                      onChanged: notifier.updateQuery,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(IconlyLight.search),
                        hintText: localization.translate('activity_search_hint'),
                        filled: true,
                        fillColor: theme.colorScheme.surface.withOpacity(0.12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        _buildFilterChip(
                          context: context,
                          localization: localization,
                          theme: theme,
                          labelKey: 'activity_filter_all',
                          count: totalEvents,
                          selected: state.filter == null,
                          onTap: () => notifier.updateFilter(null),
                          type: null,
                        ),
                        for (final type in ActivityEventType.values)
                          _buildFilterChip(
                            context: context,
                            localization: localization,
                            theme: theme,
                            labelKey: _labelKeyForType(type),
                            count: state.totalsByType[type] ?? 0,
                            selected: state.filter == type,
                            onTap: () => notifier.updateFilter(type),
                            type: type,
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SwitchListTile.adaptive(
                      value: state.showPinnedOnly,
                      onChanged: (_) => notifier.togglePinnedOnly(),
                      title: Text(localization.translate('activity_show_pinned_only')),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: AppAnimations.medium),
              const SizedBox(height: 24),
              if (filteredEvents.isEmpty)
                GlassContainer(
                  borderRadius: AppRadiusTokens.lg,
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Icon(IconlyLight.info_circle, size: 52, color: theme.colorScheme.primary),
                      const SizedBox(height: 16),
                      Text(
                        localization.translate('activity_empty_title'),
                        style: theme.textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        localization.translate('activity_empty_subtitle'),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: AppAnimations.medium),
              if (filteredEvents.isNotEmpty)
                ...filteredEvents.map((event) {
                  final isPinned = state.pinnedIds.contains(event.id);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: GlassContainer(
                      borderRadius: AppRadiusTokens.lg,
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _EventPreview(
                                imageUrl: event.previewImageUrl,
                                tint: _accentForType(event.type, theme),
                                icon: _iconForType(event.type, isPinned: false),
                              ),
                              const SizedBox(width: 18),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            event.title,
                                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                        if (isPinned)
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: theme.colorScheme.tertiary.withOpacity(0.18),
                                              borderRadius: BorderRadius.circular(999),
                                            ),
                                            child: Text(
                                              localization.translate('activity_pinned_badge'),
                                              style: theme.textTheme.labelSmall?.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: theme.colorScheme.tertiary,
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      event.message,
                                      style: theme.textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      dateFormatter.format(event.timestamp),
                                      style: theme.textTheme.bodySmall?.copyWith(
                                        color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              IconButton(
                                onPressed: () => notifier.togglePinned(event.id),
                                tooltip: localization
                                    .translate(isPinned ? 'activity_unpin' : 'activity_pin'),
                                icon: Icon(
                                  isPinned ? IconlyBold.bookmark : IconlyLight.bookmark,
                                  color: isPinned ? theme.colorScheme.tertiary : null,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              Chip(
                                avatar: Icon(
                                  _iconForType(event.type, isPinned: isPinned),
                                  size: 18,
                                  color: _accentForType(event.type, theme),
                                ),
                                label: Text(localization.translate(_labelKeyForType(event.type))),
                              ),
                              ...event.metadata.entries.map(
                                (entry) => Chip(
                                  label: Text('${entry.key.toUpperCase()}: ${entry.value}'),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: AppAnimations.medium),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  ChoiceChip _buildFilterChip({
    required BuildContext context,
    required AppLocalizations localization,
    required ThemeData theme,
    required String labelKey,
    required int count,
    required bool selected,
    required VoidCallback onTap,
    ActivityEventType? type,
  }) {
    final label = localization.translate(labelKey);
    final accent = type == null ? theme.colorScheme.primary : _accentForType(type, theme);
    return ChoiceChip(
      label: Text('$label ($count)'),
      selected: selected,
      onSelected: (_) => onTap(),
      avatar: type == null
          ? Icon(IconlyBold.activity, color: accent)
          : Icon(_iconForType(type, isPinned: false), color: accent),
    );
  }

  static String _labelKeyForType(ActivityEventType type) {
    switch (type) {
      case ActivityEventType.generation:
        return 'activity_filter_generation';
      case ActivityEventType.download:
        return 'activity_filter_download';
      case ActivityEventType.share:
        return 'activity_filter_share';
      case ActivityEventType.referral:
        return 'activity_filter_referral';
      case ActivityEventType.diagnostics:
        return 'activity_filter_diagnostics';
      case ActivityEventType.project:
        return 'activity_filter_project';
      case ActivityEventType.library:
        return 'activity_filter_library';
      case ActivityEventType.player:
        return 'activity_filter_player';
    }
  }

  static IconData _iconForType(ActivityEventType type, {required bool isPinned}) {
    switch (type) {
      case ActivityEventType.generation:
        return IconlyBold.edit;
      case ActivityEventType.download:
        return IconlyBold.arrow_down_circle;
      case ActivityEventType.share:
        return IconlyBold.send;
      case ActivityEventType.referral:
        return IconlyBold.user_3;
      case ActivityEventType.diagnostics:
        return IconlyBold.document;
      case ActivityEventType.project:
        return IconlyBold.folder;
      case ActivityEventType.library:
        return IconlyBold.paper;
      case ActivityEventType.player:
        return IconlyBold.play;
    }
  }

  static Color _accentForType(ActivityEventType type, ThemeData theme) {
    switch (type) {
      case ActivityEventType.generation:
        return theme.colorScheme.primary;
      case ActivityEventType.download:
        return theme.colorScheme.secondary;
      case ActivityEventType.share:
        return theme.colorScheme.tertiary;
      case ActivityEventType.referral:
        return const Color(0xFFF6FF7A);
      case ActivityEventType.diagnostics:
        return const Color(0xFF8EDBFF);
      case ActivityEventType.project:
        return theme.colorScheme.primaryContainer;
      case ActivityEventType.library:
        return theme.colorScheme.secondaryContainer;
      case ActivityEventType.player:
        return const Color(0xFF6A3CFF);
    }
  }
}

class _EventPreview extends StatelessWidget {
  const _EventPreview({
    required this.imageUrl,
    required this.tint,
    required this.icon,
  });

  final String? imageUrl;
  final Color tint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: Container(
        width: 72,
        height: 72,
        color: tint.withOpacity(0.16),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (imageUrl != null)
              CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(color: theme.colorScheme.surfaceVariant.withOpacity(0.2)),
                errorWidget: (context, url, error) => Container(
                  color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                ),
              ),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [tint.withOpacity(0.6), tint.withOpacity(0.2)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Icon(icon, color: Colors.white, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}
