import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cover.dart';
import '../models/download_task.dart';
import '../services/mock/mock_data.dart';
import 'notifications_provider.dart';
import 'vault_provider.dart';

final downloadsProvider =
    StateNotifierProvider<DownloadsNotifier, List<DownloadTask>>((ref) {
  final notifier = DownloadsNotifier(ref, MockData.downloads());
  notifier.initialize();
  return notifier;
});

class DownloadsNotifier extends StateNotifier<List<DownloadTask>> {
  DownloadsNotifier(this._ref, List<DownloadTask> initial)
      : _random = Random(),
        super(List<DownloadTask>.unmodifiable(initial));

  static const int _maxConcurrent = 2;
  static const int _baseSeconds = 120;

  final Ref _ref;
  final Random _random;
  final Map<String, Timer> _timers = <String, Timer>{};

  void initialize() {
    var active = 0;
    for (final task in state) {
      if (task.status == DownloadStatus.downloading) {
        active++;
        _start(task);
      }
    }
    if (active < _maxConcurrent) {
      _promoteQueued();
    }
  }

  @override
  void dispose() {
    for (final timer in _timers.values) {
      timer.cancel();
    }
    super.dispose();
  }

  void queueFromCover(Cover cover, {required String voiceName, String format = 'mp3'}) {
    final id = 'download_\${DateTime.now().millisecondsSinceEpoch}';
    final newTask = DownloadTask(
      id: id,
      coverId: cover.id,
      title: cover.title,
      artist: cover.originalArtist,
      voiceName: voiceName,
      artworkUrl: cover.artworkUrl,
      format: format.toUpperCase(),
      sizeMb: _random.nextDouble() * 18 + 6,
      duration: cover.duration,
      progress: 0,
      status: DownloadStatus.queued,
      requestedAt: DateTime.now(),
      eta: const Duration(minutes: 3),
    );
    state = <DownloadTask>[...state, newTask];
    _promoteQueued();
  }

  void pause(String taskId) {
    final task = _find(taskId);
    if (task == null || task.status != DownloadStatus.downloading) {
      return;
    }
    _timers.remove(taskId)?.cancel();
    _updateTask(
      taskId,
      task.copyWith(
        status: DownloadStatus.paused,
        eta: task.eta,
        clearFailureReason: true,
      ),
    );
    _promoteQueued();
  }

  void resume(String taskId) {
    final task = _find(taskId);
    if (task == null || (task.status != DownloadStatus.paused && task.status != DownloadStatus.queued)) {
      return;
    }
    _updateTask(
      taskId,
      task.copyWith(
        status: DownloadStatus.queued,
        eta: task.eta ?? const Duration(minutes: 3),
        clearFailureReason: true,
      ),
    );
    _promoteQueued();
  }

  void cancel(String taskId) {
    _timers.remove(taskId)?.cancel();
    state = state.where((task) => task.id != taskId).toList(growable: false);
    _promoteQueued();
  }

  void retry(String taskId) {
    final task = _find(taskId);
    if (task == null) {
      return;
    }
    _updateTask(
      taskId,
      task.copyWith(
        progress: 0,
        status: DownloadStatus.queued,
        eta: const Duration(minutes: 3),
        clearFailureReason: true,
        clearCompletedAt: true,
      ),
    );
    _promoteQueued();
  }

  DownloadTask? _find(String taskId) {
    for (final task in state) {
      if (task.id == taskId) {
        return task;
      }
    }
    return null;
  }

  void _promoteQueued() {
    final active = state.where((task) => task.status == DownloadStatus.downloading).length;
    if (active >= _maxConcurrent) {
      return;
    }
    final queued = _firstWhereOrNull((task) => task.status == DownloadStatus.queued);
    if (queued != null) {
      _start(queued);
    }
  }

  void _start(DownloadTask task) {
    final current = task.copyWith(
      status: DownloadStatus.downloading,
      eta: _remainingDuration(task.progress),
      clearFailureReason: true,
    );
    _updateTask(task.id, current);
    _timers[task.id]?.cancel();
    final totalSeconds = max(20, (_baseSeconds * (1 - current.progress)).round());
    var ticks = 0;
    _timers[task.id] = Timer.periodic(const Duration(seconds: 1), (timer) {
      final latest = _find(task.id);
      if (latest == null || latest.status != DownloadStatus.downloading) {
        timer.cancel();
        return;
      }
      ticks++;
      final progressDelta = 1 / totalSeconds;
      final nextProgress = (latest.progress + progressDelta).clamp(0, 1);
      final remaining = max(totalSeconds - ticks, 0);
      _updateTask(
        task.id,
        latest.copyWith(
          progress: nextProgress,
          eta: Duration(seconds: remaining),
        ),
      );
      if (nextProgress >= 1 || remaining <= 0) {
        timer.cancel();
        final succeeded = _random.nextInt(18) != 0;
        _finish(task.id, success: succeeded);
      }
    });
  }

  Duration _remainingDuration(double progress) {
    final seconds = max((_baseSeconds * (1 - progress)).round(), 20);
    return Duration(seconds: seconds);
  }

  void _finish(String taskId, {required bool success}) {
    final task = _find(taskId);
    if (task == null) {
      return;
    }
    if (success) {
      final completed = task.copyWith(
        progress: 1,
        status: DownloadStatus.completed,
        eta: Duration.zero,
        completedAt: DateTime.now(),
        clearFailureReason: true,
      );
      _updateTask(taskId, completed);
      _ref.read(vaultProvider.notifier).addFromDownload(completed);
      _ref.read(notificationsProvider.notifier).publishDownloadCompleted(completed);
    } else {
      final failed = task.copyWith(
        status: DownloadStatus.failed,
        eta: const Duration(minutes: 3),
        failureReasonKey: 'download_error_network',
      );
      _updateTask(taskId, failed);
    }
    _timers.remove(taskId)?.cancel();
    _promoteQueued();
  }

  void _updateTask(String taskId, DownloadTask updated) {
    state = state
        .map((task) => task.id == taskId ? updated : task)
        .toList(growable: false);
  }

  DownloadTask? _firstWhereOrNull(bool Function(DownloadTask task) test) {
    for (final task in state) {
      if (test(task)) {
        return task;
      }
    }
    return null;
  }
}
