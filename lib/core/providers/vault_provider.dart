import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/download_task.dart';
import '../models/vault_item.dart';
import '../services/mock/mock_data.dart';

enum VaultSortOption { recent, alphabetical, duration, size }

class VaultState {
  const VaultState({
    required this.items,
    required this.sort,
    required this.query,
    required this.formatFilter,
  });

  final List<VaultItem> items;
  final VaultSortOption sort;
  final String query;
  final String? formatFilter;

  double get totalSizeMb => items.fold(0, (previous, item) => previous + item.sizeMb);

  Duration get totalDuration => items.fold(Duration.zero,
      (previous, element) => previous + element.duration);

  VaultState copyWith({
    List<VaultItem>? items,
    VaultSortOption? sort,
    String? query,
    String? formatFilter,
  }) {
    return VaultState(
      items: items ?? this.items,
      sort: sort ?? this.sort,
      query: query ?? this.query,
      formatFilter: formatFilter ?? this.formatFilter,
    );
  }

  List<VaultItem> get filtered {
    final lowerQuery = query.toLowerCase();
    final filtered = items.where((item) {
      final matchesQuery = lowerQuery.isEmpty ||
          item.title.toLowerCase().contains(lowerQuery) ||
          item.artist.toLowerCase().contains(lowerQuery) ||
          item.voiceName.toLowerCase().contains(lowerQuery);
      final matchesFormat = formatFilter == null ||
          item.format.toUpperCase() == formatFilter?.toUpperCase();
      return matchesQuery && matchesFormat;
    }).toList(growable: false);

    filtered.sort((a, b) {
      switch (sort) {
        case VaultSortOption.recent:
          return b.downloadedAt.compareTo(a.downloadedAt);
        case VaultSortOption.alphabetical:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
        case VaultSortOption.duration:
          return b.duration.compareTo(a.duration);
        case VaultSortOption.size:
          return b.sizeMb.compareTo(a.sizeMb);
      }
    });
    return filtered;
  }
}

final vaultProvider = StateNotifierProvider<VaultNotifier, VaultState>((ref) {
  final initial = MockData.vaultItems();
  return VaultNotifier(initial);
});

class VaultNotifier extends StateNotifier<VaultState> {
  VaultNotifier(List<VaultItem> initial)
      : super(
          VaultState(
            items: List<VaultItem>.unmodifiable(initial),
            sort: VaultSortOption.recent,
            query: '',
            formatFilter: null,
          ),
        );

  void updateSort(VaultSortOption sort) {
    state = state.copyWith(sort: sort);
  }

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updateFormatFilter(String? format) {
    state = state.copyWith(formatFilter: format);
  }

  void remove(String id) {
    state = state.copyWith(
      items: state.items.where((item) => item.id != id).toList(growable: false),
    );
  }

  void addFromDownload(DownloadTask task) {
    final item = VaultItem(
      id: 'vault_${task.id}',
      coverId: task.coverId,
      title: task.title,
      artist: task.artist,
      voiceName: task.voiceName,
      artworkUrl: task.artworkUrl,
      format: task.format.toUpperCase(),
      sizeMb: task.sizeMb,
      duration: task.duration,
      downloadedAt: DateTime.now(),
    );
    final updated = <VaultItem>[...state.items.where((existing) => existing.coverId != task.coverId), item];
    state = state.copyWith(items: List<VaultItem>.unmodifiable(updated));
  }
}
