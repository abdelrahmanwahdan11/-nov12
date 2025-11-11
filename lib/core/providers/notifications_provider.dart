import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/download_task.dart';
import '../models/notification_message.dart';
import '../services/mock/mock_data.dart';

final notificationsProvider =
    StateNotifierProvider<NotificationsNotifier, List<NotificationMessage>>(
  (ref) => NotificationsNotifier(MockData.notifications()),
);

class NotificationsNotifier extends StateNotifier<List<NotificationMessage>> {
  NotificationsNotifier(List<NotificationMessage> initial)
      : super(List<NotificationMessage>.unmodifiable(initial));

  void markAllRead() {
    state = state.map((message) => message.copyWith(isRead: true)).toList(growable: false);
  }

  void markRead(String id) {
    state = state
        .map((message) => message.id == id ? message.copyWith(isRead: true) : message)
        .toList(growable: false);
  }

  void clearAll() {
    state = const <NotificationMessage>[];
  }

  void publishDownloadCompleted(DownloadTask task) {
    final message = NotificationMessage(
      id: 'notif_${DateTime.now().millisecondsSinceEpoch}',
      titleKey: 'notification_download_complete_title',
      bodyKey: 'notification_download_complete_body',
      createdAt: DateTime.now(),
      category: NotificationCategory.download,
      data: <String, String>{
        'title': task.title,
        'format': task.format,
      },
    );
    state = <NotificationMessage>[message, ...state];
  }

  void push(NotificationMessage message) {
    state = <NotificationMessage>[message, ...state];
  }
}
