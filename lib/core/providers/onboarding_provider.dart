import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/storage_service.dart';

final onboardingProvider = StateNotifierProvider<OnboardingNotifier, bool>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final completed = storage.readBool(StorageService.onboardingCompleteKey, defaultValue: false);
  return OnboardingNotifier(storage, completed);
});

class OnboardingNotifier extends StateNotifier<bool> {
  OnboardingNotifier(this._storage, bool state) : super(state);

  final StorageService _storage;

  Future<void> completeOnboarding() async {
    state = true;
    await _storage.writeBool(StorageService.onboardingCompleteKey, true);
  }
}
