import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/voice.dart';
import '../services/mock/mock_data.dart';
import '../services/storage_service.dart';

final voicesProvider = Provider<List<Voice>>((ref) {
  return MockData.voices();
});

final favoriteVoicesProvider = StateNotifierProvider<FavoriteVoicesNotifier, Set<String>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final stored = storage.readString(StorageService.lastVoiceIdKey);
  final initialFavorites = <String>{if (stored != null) stored};
  return FavoriteVoicesNotifier(storage, initialFavorites);
});

class FavoriteVoicesNotifier extends StateNotifier<Set<String>> {
  FavoriteVoicesNotifier(this._storage, Set<String> state)
      : super(<String>{...state});

  final StorageService _storage;

  Future<void> toggle(String voiceId) async {
    final favorites = <String>{...state};
    if (favorites.contains(voiceId)) {
      favorites.remove(voiceId);
    } else {
      favorites.add(voiceId);
    }
    state = favorites;
    if (favorites.isNotEmpty) {
      await _storage.writeString(StorageService.lastVoiceIdKey, favorites.last);
    }
  }
}
