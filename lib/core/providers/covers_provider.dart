import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/cover.dart';
import '../services/mock/mock_data.dart';

enum CoverSortOption { newest, longest, alphabetical }

class CoversState {
  const CoversState({
    required this.items,
    required this.query,
    required this.sort,
  });

  final List<Cover> items;
  final String query;
  final CoverSortOption sort;

  CoversState copyWith({
    List<Cover>? items,
    String? query,
    CoverSortOption? sort,
  }) {
    return CoversState(
      items: items ?? this.items,
      query: query ?? this.query,
      sort: sort ?? this.sort,
    );
  }

  List<Cover> get filtered {
    final lowerQuery = query.toLowerCase();
    final filtered = items.where((cover) {
      if (query.isEmpty) {
        return true;
      }
      return cover.title.toLowerCase().contains(lowerQuery) ||
          cover.originalArtist.toLowerCase().contains(lowerQuery);
    }).toList();

    filtered.sort((a, b) {
      switch (sort) {
        case CoverSortOption.newest:
          return b.createdAt.compareTo(a.createdAt);
        case CoverSortOption.longest:
          return b.duration.compareTo(a.duration);
        case CoverSortOption.alphabetical:
          return a.title.toLowerCase().compareTo(b.title.toLowerCase());
      }
    });
    return filtered;
  }
}

final coversProvider = StateNotifierProvider<CoversNotifier, CoversState>((ref) {
  final items = MockData.covers();
  return CoversNotifier(
    CoversState(items: List<Cover>.unmodifiable(items), query: '', sort: CoverSortOption.newest),
  );
});

class CoversNotifier extends StateNotifier<CoversState> {
  CoversNotifier(super.state);

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updateSort(CoverSortOption option) {
    state = state.copyWith(sort: option);
  }
}
