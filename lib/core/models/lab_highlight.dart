import 'package:flutter/foundation.dart';

@immutable
class LabHighlight {
  const LabHighlight({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.tagKey,
    required this.imageUrl,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final String tagKey;
  final String imageUrl;
}
