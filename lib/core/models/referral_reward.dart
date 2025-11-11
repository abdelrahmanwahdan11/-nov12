import 'package:flutter/foundation.dart';

@immutable
class ReferralReward {
  const ReferralReward({
    required this.id,
    required this.titleKey,
    required this.descriptionKey,
    required this.pointsRequired,
    required this.imageUrl,
    this.isClaimed = false,
    this.badgeKey,
  });

  final String id;
  final String titleKey;
  final String descriptionKey;
  final int pointsRequired;
  final String imageUrl;
  final bool isClaimed;
  final String? badgeKey;

  ReferralReward copyWith({bool? isClaimed}) {
    return ReferralReward(
      id: id,
      titleKey: titleKey,
      descriptionKey: descriptionKey,
      pointsRequired: pointsRequired,
      imageUrl: imageUrl,
      isClaimed: isClaimed ?? this.isClaimed,
      badgeKey: badgeKey,
    );
  }
}
