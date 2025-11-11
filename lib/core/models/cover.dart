import 'package:flutter/foundation.dart';

@immutable
class Cover {
  const Cover({
    required this.id,
    required this.title,
    required this.originalArtist,
    required this.voiceId,
    required this.duration,
    required this.artworkUrl,
    required this.createdAt,
    required this.isFavorite,
  });

  final String id;
  final String title;
  final String originalArtist;
  final String voiceId;
  final Duration duration;
  final String artworkUrl;
  final DateTime createdAt;
  final bool isFavorite;
}
