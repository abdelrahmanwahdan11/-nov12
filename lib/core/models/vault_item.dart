import 'package:flutter/foundation.dart';

@immutable
class VaultItem {
  const VaultItem({
    required this.id,
    required this.coverId,
    required this.title,
    required this.artist,
    required this.voiceName,
    required this.artworkUrl,
    required this.format,
    required this.sizeMb,
    required this.duration,
    required this.downloadedAt,
  });

  final String id;
  final String coverId;
  final String title;
  final String artist;
  final String voiceName;
  final String artworkUrl;
  final String format;
  final double sizeMb;
  final Duration duration;
  final DateTime downloadedAt;
}
