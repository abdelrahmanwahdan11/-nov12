import 'package:flutter/foundation.dart';

@immutable
class Voice {
  const Voice({
    required this.id,
    required this.name,
    required this.categoryKey,
    required this.avatarUrl,
    required this.description,
    required this.tags,
  });

  final String id;
  final String name;
  final String categoryKey;
  final String avatarUrl;
  final String description;
  final List<String> tags;
}
