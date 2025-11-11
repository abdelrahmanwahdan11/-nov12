import 'dart:async';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/diagnostic_snapshot.dart';
import '../models/download_task.dart';
import 'downloads_provider.dart';
import 'settings_provider.dart';
import 'vault_provider.dart';

final diagnosticsProvider =
    StateNotifierProvider<DiagnosticsNotifier, DiagnosticsState>((ref) {
  return DiagnosticsNotifier(ref);
});

class DiagnosticsState {
  const DiagnosticsState({required this.snapshot, required this.isChecking});

  final DiagnosticSnapshot snapshot;
  final bool isChecking;

  DiagnosticsState copyWith({DiagnosticSnapshot? snapshot, bool? isChecking}) {
    return DiagnosticsState(
      snapshot: snapshot ?? this.snapshot,
      isChecking: isChecking ?? this.isChecking,
    );
  }
}

class DiagnosticsNotifier extends StateNotifier<DiagnosticsState> {
  DiagnosticsNotifier(this._ref)
      : _random = Random(),
        super(
          DiagnosticsState(
            snapshot: DiagnosticSnapshot(
              connectivity: ConnectivityStatus.online,
              latencyMs: 42,
              storageUsedGb: 5.2,
              storageTotalGb: 12.0,
              cacheSizeMb: 742,
              notificationsEnabled: true,
              backgroundAudioEnabled: true,
              downloadsPaused: false,
              offlineModeEnabled: true,
              lastChecked: DateTime.now(),
            ),
            isChecking: false,
          ),
        );

  final Ref _ref;
  final Random _random;
  Future<void> refresh() async {
    if (state.isChecking) {
      return;
    }
    state = state.copyWith(isChecking: true);
    await Future<void>.delayed(const Duration(milliseconds: 900));

    final downloads = _ref.read(downloadsProvider);
    final vault = _ref.read(vaultProvider);
    final settings = _ref.read(settingsProvider);

    final connectivity = _randomConnectivity();
    final latency = _latencyFor(connectivity);
    final downloadsPaused = downloads.where((task) => task.status == DownloadStatus.downloading).isEmpty;
    final cacheSize = max(320, (vault.totalSizeMb * 1.25).round());

    final snapshot = state.snapshot.copyWith(
      connectivity: connectivity,
      latencyMs: latency,
      storageUsedGb: _randomDouble(4.6, 6.1),
      cacheSizeMb: cacheSize.toDouble(),
      notificationsEnabled: settings.notificationsEnabled,
      downloadsPaused: downloadsPaused,
      offlineModeEnabled: vault.items.isNotEmpty,
      lastChecked: DateTime.now(),
    );

    state = DiagnosticsState(snapshot: snapshot, isChecking: false);
  }

  ConnectivityStatus _randomConnectivity() {
    final roll = _random.nextInt(100);
    if (roll < 70) {
      return ConnectivityStatus.online;
    }
    if (roll < 90) {
      return ConnectivityStatus.limited;
    }
    return ConnectivityStatus.offline;
  }

  double _latencyFor(ConnectivityStatus status) {
    switch (status) {
      case ConnectivityStatus.online:
        return _randomDouble(38, 78);
      case ConnectivityStatus.limited:
        return _randomDouble(120, 320);
      case ConnectivityStatus.offline:
        return double.infinity;
    }
  }

  double _randomDouble(double min, double max) {
    return min + _random.nextDouble() * (max - min);
  }
}
