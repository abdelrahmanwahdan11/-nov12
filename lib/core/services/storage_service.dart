import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  StorageService({required SharedPreferences sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  final SharedPreferences _sharedPreferences;

  static const String themeModeKey = 'theme_mode';
  static const String localeKey = 'locale';
  static const String lastVoiceIdKey = 'last_voice_id';
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

  Future<void> writeString(String key, String value) async {
    await _sharedPreferences.setString(key, value);
  }

  String? readString(String key) => _sharedPreferences.getString(key);

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
