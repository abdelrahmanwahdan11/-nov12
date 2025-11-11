import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity_event.dart';
import '../services/mock/mock_data.dart';
import '../services/storage_service.dart';

class ActivityCenterState {
  const ActivityCenterState({
    required this.events,
    required this.query,
    required this.filter,
    required this.pinnedIds,
    required this.showPinnedOnly,
  });

  final List<ActivityEvent> events;
  final String query;
  final ActivityEventType? filter;
  final Set<String> pinnedIds;
  final bool showPinnedOnly;

  ActivityCenterState copyWith({
    List<ActivityEvent>? events,
    String? query,
    ActivityEventType? filter,
    bool clearFilter = false,
    Set<String>? pinnedIds,
    bool? showPinnedOnly,
  }) {
    return ActivityCenterState(
      events: events ?? this.events,
      query: query ?? this.query,
      filter: clearFilter ? null : filter ?? this.filter,
      pinnedIds: pinnedIds ?? this.pinnedIds,
      showPinnedOnly: showPinnedOnly ?? this.showPinnedOnly,
    );
  }

  List<ActivityEvent> get filtered {
    final lowerQuery = query.trim().toLowerCase();
    final filteredEvents = events.where((event) {
      final matchesFilter = filter == null || event.type == filter;
      final matchesPinned = !showPinnedOnly || pinnedIds.contains(event.id);
      if (!matchesFilter || !matchesPinned) {
        return false;
      }
      if (lowerQuery.isEmpty) {
        return true;
      }
      final metadataValues = event.metadata.values.join(' ').toLowerCase();
      return event.title.toLowerCase().contains(lowerQuery) ||
          event.message.toLowerCase().contains(lowerQuery) ||
          metadataValues.contains(lowerQuery);
    }).toList(growable: false);

    filteredEvents.sort((a, b) {
      final aPinned = pinnedIds.contains(a.id);
      final bPinned = pinnedIds.contains(b.id);
      if (aPinned != bPinned) {
        return aPinned ? -1 : 1;
      }
      return b.timestamp.compareTo(a.timestamp);
    });
    return filteredEvents;
  }

  Map<ActivityEventType, int> get totalsByType {
    final totals = <ActivityEventType, int>{};
    for (final event in events) {
      totals.update(event.type, (value) => value + 1, ifAbsent: () => 1);
    }
    return totals;
  }
}

final activityEventsProvider = Provider<List<ActivityEvent>>((ref) {
  return MockData.activityEvents();
});

final activityCenterProvider =
    StateNotifierProvider<ActivityCenterNotifier, ActivityCenterState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final events = ref.watch(activityEventsProvider);
  final pinnedIds =
      storage.readStringList(StorageService.activityPinnedEventsKey).toSet();
  return ActivityCenterNotifier(storage, events, pinnedIds);
});

class ActivityCenterNotifier extends StateNotifier<ActivityCenterState> {
  ActivityCenterNotifier(this._storage, List<ActivityEvent> initialEvents,
      Set<String> pinnedIds)
      : super(
          ActivityCenterState(
            events: List<ActivityEvent>.unmodifiable(initialEvents),
            query: '',
            filter: null,
            pinnedIds: pinnedIds,
            showPinnedOnly: false,
          ),
        );

  final StorageService _storage;

  void updateQuery(String query) {
    state = state.copyWith(query: query);
  }

  void updateFilter(ActivityEventType? type) {
    state = state.copyWith(filter: type, clearFilter: type == null);
  }

  void togglePinnedOnly() {
    state = state.copyWith(showPinnedOnly: !state.showPinnedOnly);
  }

  void togglePinned(String id) {
    final pinned = <String>{...state.pinnedIds};
    if (pinned.contains(id)) {
      pinned.remove(id);
    } else {
      pinned.add(id);
    }
    state = state.copyWith(pinnedIds: pinned);
    unawaited(_storage.writeStringList(StorageService.activityPinnedEventsKey, pinned.toList()));
  }

  void refresh() {
    final refreshedEvents = MockData.activityEvents();
    final previousPinned = state.pinnedIds;
    final stillPinned =
        previousPinned.where((id) => refreshedEvents.any((event) => event.id == id)).toSet();
    state = state.copyWith(
      events: List<ActivityEvent>.unmodifiable(refreshedEvents),
      pinnedIds: stillPinned,
    );
    if (stillPinned.length != previousPinned.length) {
      unawaited(_storage.writeStringList(
        StorageService.activityPinnedEventsKey,
        stillPinned.toList(),
      ));
    }
  }

  void clearFilters() {
    state = state.copyWith(query: '', clearFilter: true, showPinnedOnly: false);
  }
}
