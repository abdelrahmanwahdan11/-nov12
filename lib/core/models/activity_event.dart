import 'package:flutter/foundation.dart';

enum ActivityEventType {
  generation,
  download,
  share,
  referral,
  diagnostics,
  project,
  library,
  player,
}

@immutable
class ActivityEvent {
  const ActivityEvent({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.timestamp,
    this.relatedId,
    this.previewImageUrl,
    Map<String, String>? metadata,
  }) : metadata = metadata ?? const <String, String>{};

  final String id;
  final ActivityEventType type;
  final String title;
  final String message;
  final DateTime timestamp;
  final String? relatedId;
  final String? previewImageUrl;
  final Map<String, String> metadata;

  ActivityEvent copyWith({
    String? id,
    ActivityEventType? type,
    String? title,
    String? message,
    DateTime? timestamp,
    String? relatedId,
    String? previewImageUrl,
    Map<String, String>? metadata,
  }) {
    return ActivityEvent(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      relatedId: relatedId ?? this.relatedId,
      previewImageUrl: previewImageUrl ?? this.previewImageUrl,
      metadata: metadata ?? this.metadata,
    );
  }
}
