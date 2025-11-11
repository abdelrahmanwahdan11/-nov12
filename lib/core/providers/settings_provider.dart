import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../services/storage_service.dart';

enum AudioQuality { kbps96, kbps128, kbps192, kbps320 }

enum ExportFormat { mp3, wav }

enum AccentPalette { aurora, sapphire, sunset }

extension AudioQualityX on AudioQuality {
  String label(AppLocalizations localization) {
    switch (this) {
      case AudioQuality.kbps96:
        return localization.translate('audio_quality_option_96');
      case AudioQuality.kbps128:
        return localization.translate('audio_quality_option_128');
      case AudioQuality.kbps192:
        return localization.translate('audio_quality_option_192');
      case AudioQuality.kbps320:
        return localization.translate('audio_quality_option_320');
    }
  }
}

extension ExportFormatX on ExportFormat {
  String label(AppLocalizations localization) {
    switch (this) {
      case ExportFormat.mp3:
        return localization.translate('export_format_mp3');
      case ExportFormat.wav:
        return localization.translate('export_format_wav');
    }
  }
}

extension AccentPaletteX on AccentPalette {
  LinearGradient gradient(ThemeData theme) {
    switch (this) {
      case AccentPalette.aurora:
        return LinearGradient(colors: <Color>[theme.colorScheme.primary, theme.colorScheme.secondary]);
      case AccentPalette.sapphire:
        return const LinearGradient(colors: <Color>[Color(0xFF54C2F8), Color(0xFF8A6CFF)]);
      case AccentPalette.sunset:
        return const LinearGradient(colors: <Color>[Color(0xFFFAD961), Color(0xFFF76B1C)]);
    }
  }
}

class SettingsState {
  const SettingsState({
    required this.audioQuality,
    required this.exportFormat,
    required this.normalizeAudio,
    required this.fadeEdges,
    required this.accent,
    required this.notificationsEnabled,
    required this.sampleRate,
    required this.loudnessTarget,
  });

  final AudioQuality audioQuality;
  final ExportFormat exportFormat;
  final bool normalizeAudio;
  final bool fadeEdges;
  final AccentPalette accent;
  final bool notificationsEnabled;
  final int sampleRate;
  final double loudnessTarget;

  SettingsState copyWith({
    AudioQuality? audioQuality,
    ExportFormat? exportFormat,
    bool? normalizeAudio,
    bool? fadeEdges,
    AccentPalette? accent,
    bool? notificationsEnabled,
    int? sampleRate,
    double? loudnessTarget,
  }) {
    return SettingsState(
      audioQuality: audioQuality ?? this.audioQuality,
      exportFormat: exportFormat ?? this.exportFormat,
      normalizeAudio: normalizeAudio ?? this.normalizeAudio,
      fadeEdges: fadeEdges ?? this.fadeEdges,
      accent: accent ?? this.accent,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      sampleRate: sampleRate ?? this.sampleRate,
      loudnessTarget: loudnessTarget ?? this.loudnessTarget,
    );
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final audioValue = storage.readString(StorageService.audioQualityKey);
  final exportValue = storage.readString(StorageService.exportFormatKey);
  final accentValue = storage.readString(StorageService.accentColorKey);
  final notifications = storage.readBool(StorageService.notificationsEnabledKey, defaultValue: true);
  final normalize = storage.readBool(StorageService.normalizeKey, defaultValue: true);
  final fade = storage.readBool(StorageService.fadeEdgesKey, defaultValue: true);
  final sampleRate = storage.readInt(StorageService.sampleRateKey, defaultValue: 48000);
  final loudness = storage.readDouble(StorageService.loudnessTargetKey, defaultValue: -14.0);

  AudioQuality parseQuality(String? value) {
    return AudioQuality.values.firstWhere(
      (element) => element.name == value,
      orElse: () => AudioQuality.kbps192,
    );
  }

  ExportFormat parseFormat(String? value) {
    return ExportFormat.values.firstWhere(
      (element) => element.name == value,
      orElse: () => ExportFormat.mp3,
    );
  }

  AccentPalette parseAccent(String? value) {
    return AccentPalette.values.firstWhere(
      (element) => element.name == value,
      orElse: () => AccentPalette.aurora,
    );
  }

  return SettingsNotifier(
    storage,
    SettingsState(
      audioQuality: parseQuality(audioValue),
      exportFormat: parseFormat(exportValue),
      normalizeAudio: normalize,
      fadeEdges: fade,
      accent: parseAccent(accentValue),
      notificationsEnabled: notifications,
      sampleRate: sampleRate,
      loudnessTarget: loudness,
    ),
  );
});

class SettingsNotifier extends StateNotifier<SettingsState> {
  SettingsNotifier(this._storage, super.state);

  final StorageService _storage;

  Future<void> updateAudioQuality(AudioQuality quality) async {
    state = state.copyWith(audioQuality: quality);
    await _storage.writeString(StorageService.audioQualityKey, quality.name);
  }

  Future<void> updateExportFormat(ExportFormat format) async {
    state = state.copyWith(exportFormat: format);
    await _storage.writeString(StorageService.exportFormatKey, format.name);
  }

  Future<void> toggleNormalize(bool value) async {
    state = state.copyWith(normalizeAudio: value);
    await _storage.writeBool(StorageService.normalizeKey, value);
  }

  Future<void> toggleFade(bool value) async {
    state = state.copyWith(fadeEdges: value);
    await _storage.writeBool(StorageService.fadeEdgesKey, value);
  }

  Future<void> toggleNotifications(bool value) async {
    state = state.copyWith(notificationsEnabled: value);
    await _storage.writeBool(StorageService.notificationsEnabledKey, value);
  }

  Future<void> updateAccent(AccentPalette accent) async {
    state = state.copyWith(accent: accent);
    await _storage.writeString(StorageService.accentColorKey, accent.name);
  }

  Future<void> updateSampleRate(int value) async {
    state = state.copyWith(sampleRate: value);
    await _storage.writeInt(StorageService.sampleRateKey, value);
  }

  Future<void> updateLoudnessTarget(double value) async {
    state = state.copyWith(loudnessTarget: value);
    await _storage.writeDouble(StorageService.loudnessTargetKey, value);
  }
}
