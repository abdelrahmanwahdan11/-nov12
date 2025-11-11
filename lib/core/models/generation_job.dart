import 'package:flutter/foundation.dart';

enum GenerationStatus { queued, processing, completed, failed }

@immutable
class GenerationJob {
  const GenerationJob({
    required this.id,
    required this.voiceId,
    required this.source,
    required this.requestedAt,
    required this.status,
    required this.progress,
    required this.eta,
    this.errorMessage,
  });

  final String id;
  final String voiceId;
  final String source;
  final DateTime requestedAt;
  final GenerationStatus status;
  final double progress;
  final Duration eta;
  final String? errorMessage;

  GenerationJob copyWith({
    GenerationStatus? status,
    double? progress,
    Duration? eta,
    String? errorMessage,
  }) {
    return GenerationJob(
      id: id,
      voiceId: voiceId,
      source: source,
      requestedAt: requestedAt,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      eta: eta ?? this.eta,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
