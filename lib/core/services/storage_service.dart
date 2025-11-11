import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  static const String themeModeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String lastVoiceIdKey = 'last_voice_id';
  static const String favoriteVoicesKey = 'favorite_voices';
  static const String tipsDismissedKey = 'tips_dismissed';
  static const String onboardingCompleteKey = 'onboarding_complete';
  static const String audioQualityKey = 'audio_quality';
  static const String exportFormatKey = 'export_format';
  static const String normalizeKey = 'normalize_audio';
  static const String fadeEdgesKey = 'fade_edges';
  static const String accentColorKey = 'accent_color';
  static const String notificationsEnabledKey = 'notifications_enabled';
  static const String authTypeKey = 'auth_type';
  static const String authDisplayNameKey = 'auth_display_name';
  static const String authEmailKey = 'auth_email';
  static const String authAvatarKey = 'auth_avatar';
  static const String referralPointsKey = 'referral_points';
  static const String referralFriendsKey = 'referral_friends';
  static const String referralClaimedRewardsKey = 'referral_claimed_rewards';
  static const String referralBoostKey = 'referral_boost';
  static const String licensingConsentKey = 'licensing_consent';
  static const String licensingReportsKey = 'licensing_reports';
  static const String labsEnabledFlagsKey = 'labs_enabled_flags';
  static const String labsAutoEnrollKey = 'labs_auto_enroll';
  static const String loudnessTargetKey = 'loudness_target';
  static const String sampleRateKey = 'sample_rate';

  Future<void> writeString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  String? readString(String key) => _sharedPreferences.getString(key);

  Future<void> writeInt(String key, int value) async {
    await _sharedPreferences.setInt(key, value);
  }

  int readInt(String key, {int defaultValue = 0}) {
    return _sharedPreferences.getInt(key) ?? defaultValue;
  }

  Future<void> writeDouble(String key, double value) async {
    await _sharedPreferences.setDouble(key, value);
  }

  double readDouble(String key, {double defaultValue = 0}) {
    return _sharedPreferences.getDouble(key) ?? defaultValue;
  }

  Future<void> writeStringList(String key, List<String> values) async {
    await _sharedPreferences.setStringList(key, values);
  }

  List<String> readStringList(String key) {
    return _sharedPreferences.getStringList(key) ?? <String>[];
  }

  Future<void> writeBool(String key, bool value) async {
    await _sharedPreferences.setBool(key, value);
  }

  bool readBool(String key, {bool defaultValue = false}) {
    return _sharedPreferences.getBool(key) ?? defaultValue;
  }

  Future<void> remove(String key) async {
    await _sharedPreferences.remove(key);
  }
}

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError('StorageService must be overridden in bootstrap');
});
