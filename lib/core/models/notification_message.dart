import 'package:flutter/foundation.dart';

enum NotificationCategory { queue, download, announcement, system }

@immutable
class NotificationMessage {
  const NotificationMessage({
    required this.id,
    required this.titleKey,
    required this.bodyKey,
    required this.createdAt,
    required this.category,
    this.isRead = false,
    this.data = const <String, String>{},
  });

  final String id;
  final String titleKey;
  final String bodyKey;
  final DateTime createdAt;
  final NotificationCategory category;
  final bool isRead;
  final Map<String, String> data;

  NotificationMessage copyWith({bool? isRead}) {
    return NotificationMessage(
      id: id,
      titleKey: titleKey,
      bodyKey: bodyKey,
      createdAt: createdAt,
      category: category,
      isRead: isRead ?? this.isRead,
      data: data,
    );
  }
}
