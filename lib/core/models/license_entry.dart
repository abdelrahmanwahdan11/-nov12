import 'package:flutter/foundation.dart';

@immutable
class LicenseEntry {
  const LicenseEntry({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.highlightKeys,
    required this.illustrationUrl,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final List<String> highlightKeys;
  final String illustrationUrl;
}
