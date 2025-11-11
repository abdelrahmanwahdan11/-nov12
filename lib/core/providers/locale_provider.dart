import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../services/storage_service.dart';

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale?>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final storedValue = storage.readString(StorageService.localeKey);
  if (storedValue == null) {
    return LocaleNotifier(storage, null);
  }
  final locale = AppLocalizations.supportedLocales
      .firstWhere((element) => element.languageCode == storedValue, orElse: () => const Locale('en'));
  return LocaleNotifier(storage, locale);
});

class LocaleNotifier extends StateNotifier<Locale?> {
  LocaleNotifier(this._storage, Locale? state) : super(state);

  final StorageService _storage;

  Future<void> update(Locale locale) async {
    state = locale;
    await _storage.writeString(StorageService.localeKey, locale.languageCode);
  }
}
