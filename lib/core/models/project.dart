import 'package:flutter/foundation.dart';

@immutable
class ProjectEntry {
  const ProjectEntry({
    required this.id,
    required this.coverId,
    required this.title,
    required this.voiceName,
    required this.artworkUrl,
    required this.duration,
    required this.updatedAt,
    required this.isCompleted,
  });

  final String id;
  final String coverId;
  final String title;
  final String voiceName;
  final String artworkUrl;
  final Duration duration;
  final DateTime updatedAt;
  final bool isCompleted;

  ProjectEntry copyWith({
    bool? isCompleted,
    DateTime? updatedAt,
  }) {
    return ProjectEntry(
      id: id,
      coverId: coverId,
      title: title,
      voiceName: voiceName,
      artworkUrl: artworkUrl,
      duration: duration,
      updatedAt: updatedAt ?? this.updatedAt,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}

enum ProjectStatus { ideation, active, completed }

@immutable
class Project {
  const Project({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.heroImageUrl,
    required this.updatedAt,
    required this.entries,
    required this.isPinned,
    required this.notes,
    required this.tags,
  });

  final String id;
  final String name;
  final String description;
  final ProjectStatus status;
  final String heroImageUrl;
  final DateTime updatedAt;
  final List<ProjectEntry> entries;
  final bool isPinned;
  final String notes;
  final List<String> tags;

  int get completedCount => entries.where((entry) => entry.isCompleted).length;

  Duration get totalDuration => entries.fold(
        Duration.zero,
        (previousValue, element) => previousValue + element.duration,
      );

  int get totalCovers => entries.length;

  int get uniqueVoices => entries.map((entry) => entry.voiceName).toSet().length;

  Project copyWith({
    ProjectStatus? status,
    List<ProjectEntry>? entries,
    bool? isPinned,
    String? notes,
    DateTime? updatedAt,
    List<String>? tags,
    String? description,
    String? name,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      status: status ?? this.status,
      heroImageUrl: heroImageUrl,
      updatedAt: updatedAt ?? this.updatedAt,
      entries: List<ProjectEntry>.unmodifiable(entries ?? this.entries),
      isPinned: isPinned ?? this.isPinned,
      notes: notes ?? this.notes,
      tags: List<String>.unmodifiable(tags ?? this.tags),
    );
  }
}
