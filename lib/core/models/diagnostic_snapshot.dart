import 'package:flutter/foundation.dart';

enum ConnectivityStatus { online, limited, offline }

@immutable
class DiagnosticSnapshot {
  const DiagnosticSnapshot({
    required this.connectivity,
    required this.latencyMs,
    required this.storageUsedGb,
    required this.storageTotalGb,
    required this.cacheSizeMb,
    required this.notificationsEnabled,
    required this.backgroundAudioEnabled,
    required this.downloadsPaused,
    required this.offlineModeEnabled,
    required this.lastChecked,
  });

  final ConnectivityStatus connectivity;
  final double latencyMs;
  final double storageUsedGb;
  final double storageTotalGb;
  final double cacheSizeMb;
  final bool notificationsEnabled;
  final bool backgroundAudioEnabled;
  final bool downloadsPaused;
  final bool offlineModeEnabled;
  final DateTime lastChecked;

  DiagnosticSnapshot copyWith({
    ConnectivityStatus? connectivity,
    double? latencyMs,
    double? storageUsedGb,
    double? storageTotalGb,
    double? cacheSizeMb,
    bool? notificationsEnabled,
    bool? backgroundAudioEnabled,
    bool? downloadsPaused,
    bool? offlineModeEnabled,
    DateTime? lastChecked,
  }) {
    return DiagnosticSnapshot(
      connectivity: connectivity ?? this.connectivity,
      latencyMs: latencyMs ?? this.latencyMs,
      storageUsedGb: storageUsedGb ?? this.storageUsedGb,
      storageTotalGb: storageTotalGb ?? this.storageTotalGb,
      cacheSizeMb: cacheSizeMb ?? this.cacheSizeMb,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      backgroundAudioEnabled: backgroundAudioEnabled ?? this.backgroundAudioEnabled,
      downloadsPaused: downloadsPaused ?? this.downloadsPaused,
      offlineModeEnabled: offlineModeEnabled ?? this.offlineModeEnabled,
      lastChecked: lastChecked ?? this.lastChecked,
    );
  }
}
