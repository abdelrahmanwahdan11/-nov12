import 'package:flutter/foundation.dart';

@immutable
class LabFlag {
  const LabFlag({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.badgeKey,
    required this.enabled,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final String badgeKey;
  final bool enabled;

  LabFlag copyWith({bool? enabled}) {
    return LabFlag(
      id: id,
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      badgeKey: badgeKey,
      enabled: enabled ?? this.enabled,
    );
  }
}
