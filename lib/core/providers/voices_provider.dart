import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/voice.dart';
import '../services/mock/mock_data.dart';
import '../services/storage_service.dart';

final voicesProvider = Provider<List<Voice>>((ref) {
  return MockData.voices();
});

final voiceByIdProvider = Provider.family<Voice?, String>((ref, id) {
  final voices = ref.watch(voicesProvider);
  for (final voice in voices) {
    if (voice.id == id) {
      return voice;
    }
  }
  return null;
});

final favoriteVoicesProvider = StateNotifierProvider<FavoriteVoicesNotifier, Set<String>>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final storedFavorites = storage.readStringList(StorageService.favoriteVoicesKey);
  final storedLastVoice = storage.readString(StorageService.lastVoiceIdKey);
  final initialFavorites = <String>{...storedFavorites};
  if (storedLastVoice != null && storedLastVoice.isNotEmpty) {
    initialFavorites.add(storedLastVoice);
  }
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
    await _storage.writeStringList(StorageService.favoriteVoicesKey, favorites.toList());
    if (favorites.isNotEmpty) {
      await _storage.writeString(StorageService.lastVoiceIdKey, favorites.last);
    } else {
      await _storage.remove(StorageService.lastVoiceIdKey);
    }
  }
}
