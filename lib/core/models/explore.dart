import 'dart:ui';

class ExploreItem {
  const ExploreItem({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.imageUrl,
    required this.highlightKeys,
    this.voiceId,
    this.accentColor,
  });

  final String id;
  final String titleKey;
  final String subtitleKey;
  final String imageUrl;
  final List<String> highlightKeys;
  final String? voiceId;
  final Color? accentColor;
}

class ExploreSection {
  const ExploreSection({
    required this.id,
    required this.titleKey,
    required this.subtitleKey,
    required this.items,
  });

  final String id;
  final String titleKey;
  final String subtitleKey;
  final List<ExploreItem> items;
}
