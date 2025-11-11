import 'package:flutter/foundation.dart';

@immutable
class VoiceSample {
  const VoiceSample({
    required this.titleKey,
    required this.url,
    required this.duration,
  });

  final String titleKey;
  final String url;
  final Duration duration;
}

@immutable
class Voice {
  const Voice({
    required this.id,
    required this.name,
    required this.categoryKey,
    required this.avatarUrl,
    required this.description,
    required this.tags,
    this.rangeKey = 'voice_range_unknown',
    this.licenseKey = 'voice_license_personal',
    this.heroImageUrl,
    this.sampleClips = const <VoiceSample>[],
  });

  final String id;
  final String name;
  final String categoryKey;
  final String avatarUrl;
  final String description;
  final List<String> tags;
  final String rangeKey;
  final String licenseKey;
  final String? heroImageUrl;
  final List<VoiceSample> sampleClips;
}
