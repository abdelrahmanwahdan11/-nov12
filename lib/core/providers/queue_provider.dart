import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/generation_job.dart';

final queueProvider = StateNotifierProvider<QueueNotifier, List<GenerationJob>>((ref) {
  return QueueNotifier();
});

class QueueNotifier extends StateNotifier<List<GenerationJob>> {
  QueueNotifier() : super(const <GenerationJob>[]);

  static const int _totalSeconds = 90;
  final Map<String, Timer> _timers = <String, Timer>{};
  final Random _random = Random();

  @override
  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void enqueue({required String voiceId, required String source}) {
    final id = 'job_\${DateTime.now().millisecondsSinceEpoch}';
    final job = GenerationJob(
      id: id,
      voiceId: voiceId,
      source: source,
      requestedAt: DateTime.now(),
      status: GenerationStatus.queued,
      progress: 0,
      eta: const Duration(seconds: _totalSeconds),
    );
    state = <GenerationJob>[...state, job];
    _start(job);
  }

  void _start(GenerationJob job) {
    var elapsed = 0;
    _updateJob(job.id, job.copyWith(status: GenerationStatus.processing));
    _timers[job.id]?.cancel();
    _timers[job.id] = Timer.periodic(const Duration(seconds: 1), (timer) {
      elapsed++;
      final progress = (elapsed / _totalSeconds).clamp(0, 1);
      final remaining = max(_totalSeconds - elapsed, 0);
      _updateJob(
        job.id,
        job.copyWith(
          status: GenerationStatus.processing,
          progress: progress,
          eta: Duration(seconds: remaining),
        ),
      );
      if (elapsed >= _totalSeconds) {
        timer.cancel();
        final isFailure = _random.nextInt(10) == 0; // 10% chance failure
        if (isFailure) {
          _updateJob(
            job.id,
            job.copyWith(
              status: GenerationStatus.failed,
              progress: 1,
              eta: Duration.zero,
              errorMessage: 'network_glitch',
            ),
          );
        } else {
          _updateJob(
            job.id,
            job.copyWith(
              status: GenerationStatus.completed,
              progress: 1,
              eta: Duration.zero,
            ),
          );
        }
      }
    });
  }

  void cancelJob(String jobId) {
    _timers.remove(jobId)?.cancel();
    state = state.where((job) => job.id != jobId).toList(growable: false);
  }

  void retryJob(String jobId) {
    final job = state.firstWhere((element) => element.id == jobId);
    final restarted = job.copyWith(
      status: GenerationStatus.queued,
      progress: 0,
      eta: const Duration(seconds: _totalSeconds),
      errorMessage: null,
    );
    _updateJob(jobId, restarted);
    _start(restarted);
  }

  void _updateJob(String jobId, GenerationJob updated) {
    state = state
        .map((job) => job.id == jobId ? updated : job)
        .toList(growable: false);
  }
}
