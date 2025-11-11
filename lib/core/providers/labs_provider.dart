import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/lab_flag.dart';
import '../models/lab_highlight.dart';
import '../services/mock/mock_data.dart';
import '../services/storage_service.dart';

@immutable
class LabsState {
  const LabsState({
    required this.flags,
    required this.highlights,
    required this.autoEnroll,
    required this.lastUpdated,
  });

  final List<LabFlag> flags;
  final List<LabHighlight> highlights;
  final bool autoEnroll;
  final DateTime lastUpdated;

  LabsState copyWith({
    List<LabFlag>? flags,
    List<LabHighlight>? highlights,
    bool? autoEnroll,
    DateTime? lastUpdated,
  }) {
    return LabsState(
      flags: flags ?? this.flags,
      highlights: highlights ?? this.highlights,
      autoEnroll: autoEnroll ?? this.autoEnroll,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}

final labsProvider = StateNotifierProvider<LabsNotifier, LabsState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final enabledIds = storage.readStringList(StorageService.labsEnabledFlagsKey).toSet();
  final autoEnroll = storage.readBool(StorageService.labsAutoEnrollKey, defaultValue: true);
  final flags = MockData.labFlags()
      .map((flag) => flag.copyWith(enabled: enabledIds.isEmpty ? flag.enabled : enabledIds.contains(flag.id)))
      .toList();

  return LabsNotifier(
    storage,
    LabsState(
      flags: flags,
      highlights: MockData.labHighlights(),
      autoEnroll: autoEnroll,
      lastUpdated: MockData.labsLastUpdated(),
    ),
  );
});

class LabsNotifier extends StateNotifier<LabsState> {
  LabsNotifier(this._storage, super.state);

  final StorageService _storage;

  Future<void> toggleFlag(String id, bool value) async {
    final updatedFlags = state.flags
        .map((flag) => flag.id == id ? flag.copyWith(enabled: value) : flag)
        .toList();
    state = state.copyWith(flags: updatedFlags);
    await _storage.writeStringList(
      StorageService.labsEnabledFlagsKey,
      updatedFlags.where((flag) => flag.enabled).map((flag) => flag.id).toList(),
    );
  }

  Future<void> toggleAutoEnroll(bool value) async {
    state = state.copyWith(autoEnroll: value);
    await _storage.writeBool(StorageService.labsAutoEnrollKey, value);
  }
}
