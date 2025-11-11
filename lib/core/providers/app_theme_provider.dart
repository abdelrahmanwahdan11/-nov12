import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage_service.dart';

final appThemeModeProvider = StateNotifierProvider<AppThemeModeNotifier, ThemeMode>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final storedValue = storage.readString(StorageService.themeModeKey);
  final initialMode = ThemeMode.values.firstWhere(
    (mode) => mode.name == storedValue,
    orElse: () => ThemeMode.system,
  );
  return AppThemeModeNotifier(storage, initialMode);
});

class AppThemeModeNotifier extends StateNotifier<ThemeMode> {
  AppThemeModeNotifier(this._storage, ThemeMode state) : super(state);

  final StorageService _storage;

  Future<void> update(ThemeMode newMode) async {
    state = newMode;
    await _storage.writeString(StorageService.themeModeKey, newMode.name);
  }
}
