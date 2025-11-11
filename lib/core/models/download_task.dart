import 'package:flutter/foundation.dart';

enum DownloadStatus { queued, downloading, paused, completed, failed }

@immutable
class DownloadTask {
  const DownloadTask({
    required this.id,
    required this.coverId,
    required this.title,
    required this.artist,
    required this.voiceName,
    required this.artworkUrl,
    required this.format,
    required this.sizeMb,
    required this.duration,
    required this.progress,
    required this.status,
    required this.requestedAt,
    this.eta,
    this.completedAt,
    this.failureReasonKey,
  });

  final String id;
  final String coverId;
  final String title;
  final String artist;
  final String voiceName;
  final String artworkUrl;
  final String format;
  final double sizeMb;
  final Duration duration;
  final double progress;
  final DownloadStatus status;
  final DateTime requestedAt;
  final Duration? eta;
  final DateTime? completedAt;
  final String? failureReasonKey;

  DownloadTask copyWith({
    double? progress,
    DownloadStatus? status,
    Duration? eta,
    DateTime? completedAt,
    String? failureReasonKey,
    bool clearFailureReason = false,
    bool clearCompletedAt = false,
  }) {
    return DownloadTask(
      id: id,
      coverId: coverId,
      title: title,
      artist: artist,
      voiceName: voiceName,
      artworkUrl: artworkUrl,
      format: format,
      sizeMb: sizeMb,
      duration: duration,
      progress: progress ?? this.progress,
      status: status ?? this.status,
      requestedAt: requestedAt,
      eta: eta ?? this.eta,
      completedAt: clearCompletedAt ? null : (completedAt ?? this.completedAt),
      failureReasonKey:
          clearFailureReason ? null : (failureReasonKey ?? this.failureReasonKey),
    );
  }
}
