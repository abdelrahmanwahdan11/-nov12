import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/referral_reward.dart';
import '../services/mock/mock_data.dart';
import '../services/storage_service.dart';

@immutable
class ReferralsState {
  const ReferralsState({
    required this.link,
    required this.totalPoints,
    required this.friendsJoined,
    required this.monthlyOpens,
    required this.boostActive,
    required this.rewards,
  });

  final String link;
  final int totalPoints;
  final int friendsJoined;
  final int monthlyOpens;
  final bool boostActive;
  final List<ReferralReward> rewards;

  ReferralsState copyWith({
    String? link,
    int? totalPoints,
    int? friendsJoined,
    int? monthlyOpens,
    bool? boostActive,
    List<ReferralReward>? rewards,
  }) {
    return ReferralsState(
      link: link ?? this.link,
      totalPoints: totalPoints ?? this.totalPoints,
      friendsJoined: friendsJoined ?? this.friendsJoined,
      monthlyOpens: monthlyOpens ?? this.monthlyOpens,
      boostActive: boostActive ?? this.boostActive,
      rewards: rewards ?? this.rewards,
    );
  }
}

final referralsProvider = StateNotifierProvider<ReferralsNotifier, ReferralsState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final claimedIds = storage.readStringList(StorageService.referralClaimedRewardsKey).toSet();
  final rewards = MockData.referralRewards()
      .map((reward) => reward.copyWith(isClaimed: claimedIds.contains(reward.id)))
      .toList();
  final points = storage.readInt(StorageService.referralPointsKey, defaultValue: MockData.referralBasePoints());
  final friends = storage.readInt(StorageService.referralFriendsKey, defaultValue: MockData.referralBaseFriends());
  final boost = storage.readBool(StorageService.referralBoostKey, defaultValue: MockData.referralBoostActive());
  final monthly = ((friends * 3).clamp(8, 60)).toInt();

  return ReferralsNotifier(
    storage,
    ReferralsState(
      link: MockData.referralLink(),
      totalPoints: points,
      friendsJoined: friends,
      monthlyOpens: monthly,
      boostActive: boost,
      rewards: rewards,
    ),
  );
});

class ReferralsNotifier extends StateNotifier<ReferralsState> {
  ReferralsNotifier(this._storage, super.state);

  final StorageService _storage;

  Future<void> simulateInvite() async {
    final updatedPoints = state.totalPoints + 40;
    final updatedFriends = state.friendsJoined + 1;
    final updatedMonthly = ((state.monthlyOpens + 4).clamp(8, 120)).toInt();
    state = state.copyWith(
      totalPoints: updatedPoints,
      friendsJoined: updatedFriends,
      monthlyOpens: updatedMonthly,
    );
    await _storage.writeInt(StorageService.referralPointsKey, updatedPoints);
    await _storage.writeInt(StorageService.referralFriendsKey, updatedFriends);
  }

  Future<bool> claimReward(String id) async {
    final index = state.rewards.indexWhere((reward) => reward.id == id);
    if (index == -1) {
      return false;
    }
    final reward = state.rewards[index];
    if (reward.isClaimed || state.totalPoints < reward.pointsRequired) {
      return false;
    }
    final updatedRewards = List<ReferralReward>.from(state.rewards);
    updatedRewards[index] = reward.copyWith(isClaimed: true);
    final updatedPoints = state.totalPoints - reward.pointsRequired;
    state = state.copyWith(totalPoints: updatedPoints, rewards: updatedRewards);
    await _storage.writeInt(StorageService.referralPointsKey, updatedPoints);
    await _storage.writeStringList(
      StorageService.referralClaimedRewardsKey,
      updatedRewards.where((reward) => reward.isClaimed).map((reward) => reward.id).toList(),
    );
    return true;
  }

  Future<void> toggleBoost(bool value) async {
    state = state.copyWith(boostActive: value);
    await _storage.writeBool(StorageService.referralBoostKey, value);
  }
}
