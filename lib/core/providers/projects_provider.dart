import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/project.dart';
import '../services/mock/mock_data.dart';

enum ProjectSortOption { recent, alphabetical, covers }

class ProjectsState {
  const ProjectsState({
    required this.projects,
    required this.query,
    required this.statusFilter,
    required this.sort,
    required this.showPinnedOnly,
  });

  final List<Project> projects;
  final String query;
  final ProjectStatus? statusFilter;
  final ProjectSortOption sort;
  final bool showPinnedOnly;

  ProjectsState copyWith({
    List<Project>? projects,
    String? query,
    ProjectStatus? statusFilter,
    bool clearStatusFilter = false,
    ProjectSortOption? sort,
    bool? showPinnedOnly,
  }) {
    return ProjectsState(
      projects: projects ?? this.projects,
      query: query ?? this.query,
      statusFilter: clearStatusFilter ? null : statusFilter ?? this.statusFilter,
      sort: sort ?? this.sort,
      showPinnedOnly: showPinnedOnly ?? this.showPinnedOnly,
    );
  }

  List<Project> get pinned => projects.where((project) => project.isPinned).toList(growable: false);

  List<Project> get filtered {
    final lowerQuery = query.trim().toLowerCase();
    final filtered = projects.where((project) {
      final matchesQuery = lowerQuery.isEmpty ||
          project.name.toLowerCase().contains(lowerQuery) ||
          project.description.toLowerCase().contains(lowerQuery) ||
          project.tags.any((tag) => tag.toLowerCase().contains(lowerQuery));
      final matchesStatus = statusFilter == null || project.status == statusFilter;
      final matchesPinned = !showPinnedOnly || project.isPinned;
      return matchesQuery && matchesStatus && matchesPinned;
    }).toList(growable: false);

    filtered.sort((a, b) {
      switch (sort) {
        case ProjectSortOption.recent:
          return b.updatedAt.compareTo(a.updatedAt);
        case ProjectSortOption.alphabetical:
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        case ProjectSortOption.covers:
          return b.totalCovers.compareTo(a.totalCovers);
      }
    });
    return filtered;
  }

  int get totalCovers => projects.fold(0, (count, project) => count + project.totalCovers);

  Duration get totalDuration => projects.fold(
        Duration.zero,
        (duration, project) => duration + project.totalDuration,
      );
}

final projectsProvider =
    StateNotifierProvider<ProjectsNotifier, ProjectsState>((ref) {
  final initial = MockData.projects();
  return ProjectsNotifier(initial);
});

class ProjectsNotifier extends StateNotifier<ProjectsState> {
  ProjectsNotifier(List<Project> initial)
      : super(
          ProjectsState(
            projects: List<Project>.unmodifiable(initial),
            query: '',
            statusFilter: null,
            sort: ProjectSortOption.recent,
            showPinnedOnly: false,
          ),
        );

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void clearFilters() {
    state = state.copyWith(query: '', clearStatusFilter: true, showPinnedOnly: false);
  }

  void togglePinnedOnly() {
    state = state.copyWith(showPinnedOnly: !state.showPinnedOnly);
  }

  void updateStatusFilter(ProjectStatus? status) {
    state = state.copyWith(statusFilter: status, clearStatusFilter: status == null);
  }

  void updateSort(ProjectSortOption option) {
    state = state.copyWith(sort: option);
  }

  void togglePinned(String projectId) {
    _updateProject(projectId, (project) {
      return project.copyWith(
        isPinned: !project.isPinned,
        updatedAt: DateTime.now(),
      );
    });
  }

  void updateNotes(String projectId, String notes) {
    _updateProject(projectId, (project) {
      return project.copyWith(
        notes: notes,
        updatedAt: DateTime.now(),
      );
    });
  }

  void updateStatus(String projectId, ProjectStatus status) {
    _updateProject(projectId, (project) {
      return project.copyWith(
        status: status,
        updatedAt: DateTime.now(),
      );
    });
  }

  void toggleEntryCompletion(String projectId, String entryId) {
    _updateProject(projectId, (project) {
      final updatedEntries = project.entries.map((entry) {
        if (entry.id != entryId) {
          return entry;
        }
        return entry.copyWith(
          isCompleted: !entry.isCompleted,
          updatedAt: DateTime.now(),
        );
      }).toList(growable: false);
      return project.copyWith(
        entries: updatedEntries,
        updatedAt: DateTime.now(),
      );
    });
  }

  void _updateProject(
    String projectId,
    Project Function(Project project) transformer,
  ) {
    final updatedProjects = state.projects.map((project) {
      if (project.id != projectId) {
        return project;
      }
      final transformed = transformer(project);
      return transformed;
    }).toList(growable: false);
    state = state.copyWith(
      projects: List<Project>.unmodifiable(updatedProjects),
    );
  }
}
