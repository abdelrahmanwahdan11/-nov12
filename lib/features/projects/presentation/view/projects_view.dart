import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/project.dart';
import '../../../../core/providers/projects_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class ProjectsView extends ConsumerStatefulWidget {
  const ProjectsView({super.key});

  @override
  ConsumerState<ProjectsView> createState() => _ProjectsViewState();
}

class _ProjectsViewState extends ConsumerState<ProjectsView> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
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
    final state = ref.watch(projectsProvider);
    final notifier = ref.read(projectsProvider.notifier);
    final isRtl = localization.isRtl;

    final filtered = state.filtered;
    final pinned = state.pinned;

    final totalMinutes = state.totalDuration.inMinutes;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('projects_title')),
          actions: [
            IconButton(
              tooltip: localization.translate('projects_toggle_pinned_only'),
              onPressed: notifier.togglePinnedOnly,
              icon: Icon(
                state.showPinnedOnly ? Icons.push_pin : Icons.push_pin_outlined,
              ),
            ),
            PopupMenuButton<ProjectSortOption>(
              tooltip: localization.translate('projects_sort_label'),
              icon: const Icon(Icons.sort_rounded),
              onSelected: notifier.updateSort,
              initialValue: state.sort,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: ProjectSortOption.recent,
                  child: Text(localization.translate('projects_sort_recent')),
                ),
                PopupMenuItem(
                  value: ProjectSortOption.alphabetical,
                  child: Text(localization.translate('projects_sort_alpha')),
                ),
                PopupMenuItem(
                  value: ProjectSortOption.covers,
                  child: Text(localization.translate('projects_sort_tracks')),
                ),
              ],
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
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 40),
            children: [
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    _StatTile(
                      label: localization.translate('projects_stats_projects'),
                      value: state.projects.length.toString(),
                    ),
                    _StatTile(
                      label: localization.translate('projects_stats_tracks'),
                      value: state.totalCovers.toString(),
                    ),
                    _StatTile(
                      label: localization.translate('projects_stats_minutes'),
                      value: totalMinutes.toString(),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: AppAnimations.medium),
              const SizedBox(height: 24),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: EdgeInsets.zero,
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) {
                    notifier.updateQuery(value);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: localization.translate('projects_search_hint'),
                    prefixIcon: const Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              notifier.updateQuery('');
                              setState(() {});
                            },
                            icon: const Icon(Icons.close_rounded),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  ChoiceChip(
                    label: Text(localization.translate('projects_filter_all')),
                    selected: state.statusFilter == null,
                    onSelected: (_) => notifier.updateStatusFilter(null),
                  ),
                  ChoiceChip(
                    label: Text(localization.translate('projects_status_ideation')),
                    selected: state.statusFilter == ProjectStatus.ideation,
                    onSelected: (_) => notifier.updateStatusFilter(ProjectStatus.ideation),
                  ),
                  ChoiceChip(
                    label: Text(localization.translate('projects_status_active')),
                    selected: state.statusFilter == ProjectStatus.active,
                    onSelected: (_) => notifier.updateStatusFilter(ProjectStatus.active),
                  ),
                  ChoiceChip(
                    label: Text(localization.translate('projects_status_completed')),
                    selected: state.statusFilter == ProjectStatus.completed,
                    onSelected: (_) => notifier.updateStatusFilter(ProjectStatus.completed),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _QuickActionsRow(localization: localization),
              if (pinned.isNotEmpty) ...[
                const SizedBox(height: 28),
                Text(
                  localization.translate('projects_pinned_section'),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 160,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: pinned.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 16),
                    itemBuilder: (context, index) {
                      final project = pinned[index];
                      return _PinnedProjectCard(project: project).animate().fadeIn(duration: AppAnimations.medium);
                    },
                  ),
                ),
              ],
              const SizedBox(height: 28),
              if (filtered.isEmpty)
                _EmptyProjects(localization: localization)
              else
                ...filtered.map((project) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _ProjectCard(
                      project: project,
                      localization: localization,
                      onTogglePinned: () => notifier.togglePinned(project.id),
                      onUpdateNotes: () => _showNotesSheet(project, localization, notifier),
                      onUpdateStatus: (status) => notifier.updateStatus(project.id, status),
                      onToggleEntry: (entryId) => notifier.toggleEntryCompletion(project.id, entryId),
                    ).animate().fadeIn(duration: AppAnimations.medium),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showNotesSheet(
    Project project,
    AppLocalizations localization,
    ProjectsNotifier notifier,
  ) async {
    final controller = TextEditingController(text: project.notes);
    final result = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final theme = Theme.of(context);
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: GlassContainer(
            borderRadius: AppRadiusTokens.xl,
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localization.translate('projects_notes_label'),
                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: controller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: localization.translate('projects_notes_placeholder'),
                    border: OutlineInputBorder(borderRadius: AppRadiusTokens.md),
                  ),
                ),
                const SizedBox(height: 16),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(controller.text.trim()),
                    child: Text(localization.translate('projects_notes_update')),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      notifier.updateNotes(project.id, result);
    }
  }
}

class _QuickActionsRow extends StatelessWidget {
  const _QuickActionsRow({required this.localization});

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.translate('projects_quick_actions'),
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => context.push('/batch'),
                child: GlassContainer(
                  borderRadius: AppRadiusTokens.lg,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.queue_music_rounded, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.translate('projects_quick_batch'),
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localization.translate('projects_quick_batch_subtitle'),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () => context.push('/studio'),
                child: GlassContainer(
                  borderRadius: AppRadiusTokens.lg,
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.graphic_eq_rounded, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              localization.translate('projects_quick_studio'),
                              style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              localization.translate('projects_quick_studio_subtitle'),
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PinnedProjectCard extends StatelessWidget {
  const _PinnedProjectCard({required this.project});

  final Project project;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SizedBox(
      width: 280,
      child: GlassContainer(
        borderRadius: AppRadiusTokens.lg,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppRadiusTokens.md,
              child: CachedNetworkImage(
                imageUrl: project.heroImageUrl,
                height: 90,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Text(
                    project.name,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    gradient: AppGradients.aurora,
                    borderRadius: AppRadiusTokens.sm,
                  ),
                  child: const Icon(Icons.push_pin, size: 14, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              project.description,
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _ProjectCard extends StatelessWidget {
  const _ProjectCard({
    required this.project,
    required this.localization,
    required this.onTogglePinned,
    required this.onUpdateNotes,
    required this.onUpdateStatus,
    required this.onToggleEntry,
  });

  final Project project;
  final AppLocalizations localization;
  final VoidCallback onTogglePinned;
  final VoidCallback onUpdateNotes;
  final ValueChanged<ProjectStatus> onUpdateStatus;
  final ValueChanged<String> onToggleEntry;

  String _statusLabel(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.ideation:
        return localization.translate('projects_status_ideation');
      case ProjectStatus.active:
        return localization.translate('projects_status_active');
      case ProjectStatus.completed:
        return localization.translate('projects_status_completed');
    }
  }

  ProjectStatus _nextStatus(ProjectStatus status) {
    switch (status) {
      case ProjectStatus.ideation:
        return ProjectStatus.active;
      case ProjectStatus.active:
        return ProjectStatus.completed;
      case ProjectStatus.completed:
        return ProjectStatus.ideation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completedRatio = project.totalCovers == 0
        ? 0.0
        : project.completedCount / project.totalCovers;

    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: AppRadiusTokens.md,
                child: CachedNetworkImage(
                  imageUrl: project.heroImageUrl,
                  width: 96,
                  height: 96,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            project.name,
                            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          onPressed: onTogglePinned,
                          icon: Icon(project.isPinned ? Icons.push_pin : Icons.push_pin_outlined),
                          tooltip: localization.translate(
                            project.isPinned ? 'projects_toggle_unpin' : 'projects_toggle_pin',
                          ),
                        ),
                      ],
                    ),
                    Text(
                      project.description,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      children: [
                        InputChip(
                          label: Text(_statusLabel(project.status)),
                          onPressed: () => onUpdateStatus(_nextStatus(project.status)),
                          avatar: const Icon(Icons.radio_button_checked, size: 16),
                        ),
                        ...project.tags.map((tag) => Chip(label: Text('#$tag'))),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: completedRatio,
            backgroundColor: theme.colorScheme.surfaceVariant.withOpacity(0.3),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _MetricChip(
                label: localization.translate('projects_metric_tracks'),
                value: project.totalCovers.toString(),
              ),
              const SizedBox(width: 12),
              _MetricChip(
                label: localization.translate('projects_metric_completed'),
                value: project.completedCount.toString(),
              ),
              const SizedBox(width: 12),
              _MetricChip(
                label: localization.translate('projects_metric_voices'),
                value: project.uniqueVoices.toString(),
              ),
              const Spacer(),
              PopupMenuButton<ProjectStatus>(
                tooltip: localization.translate('projects_status_menu'),
                onSelected: onUpdateStatus,
                icon: const Icon(Icons.tune_rounded),
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: ProjectStatus.ideation,
                    child: Text(localization.translate('projects_status_ideation')),
                  ),
                  PopupMenuItem(
                    value: ProjectStatus.active,
                    child: Text(localization.translate('projects_status_active')),
                  ),
                  PopupMenuItem(
                    value: ProjectStatus.completed,
                    child: Text(localization.translate('projects_status_completed')),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (project.notes.isNotEmpty)
            Text(
              project.notes,
              style: theme.textTheme.bodyMedium,
            ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton.icon(
              onPressed: onUpdateNotes,
              icon: const Icon(Icons.edit_outlined),
              label: Text(localization.translate('projects_notes_update')),
            ),
          ),
          const Divider(height: 32),
          Column(
            children: project.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _ProjectEntryTile(
                  entry: entry,
                  localization: localization,
                  onToggle: () => onToggleEntry(entry.id),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _ProjectEntryTile extends StatelessWidget {
  const _ProjectEntryTile({
    required this.entry,
    required this.localization,
    required this.onToggle,
  });

  final ProjectEntry entry;
  final AppLocalizations localization;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: AppRadiusTokens.md,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: AppRadiusTokens.sm,
            child: CachedNetworkImage(
              imageUrl: entry.artworkUrl,
              width: 56,
              height: 56,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.title,
                  style: theme.textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  localization.translate('projects_entry_voice_format').replaceFirst('{voice}', entry.voiceName),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  localization
                      .translate('projects_entry_duration_format')
                      .replaceFirst('{duration}', _formatDuration(entry.duration)),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: entry.isCompleted,
            onChanged: (_) => onToggle(),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodySmall),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: AppRadiusTokens.sm,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _EmptyProjects extends StatelessWidget {
  const _EmptyProjects({required this.localization});

  final AppLocalizations localization;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(height: 40),
        Icon(Icons.dashboard_customize_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant),
        const SizedBox(height: 20),
        Text(
          localization.translate('projects_empty_title'),
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          localization.translate('projects_empty_subtitle'),
          style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
