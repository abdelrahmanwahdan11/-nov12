import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/license_entry.dart';
import '../models/license_report.dart';
import '../services/mock/mock_data.dart';
import '../services/storage_service.dart';

@immutable
class LicensingState {
  const LicensingState({
    required this.entries,
    required this.reports,
    required this.consentAccepted,
  });

  final List<LicenseEntry> entries;
  final List<LicenseReport> reports;
  final bool consentAccepted;

  LicensingState copyWith({
    List<LicenseEntry>? entries,
    List<LicenseReport>? reports,
    bool? consentAccepted,
  }) {
    return LicensingState(
      entries: entries ?? this.entries,
      reports: reports ?? this.reports,
      consentAccepted: consentAccepted ?? this.consentAccepted,
    );
  }
}

final licensingProvider = StateNotifierProvider<LicensingNotifier, LicensingState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final storedReports = storage.readStringList(StorageService.licensingReportsKey)
      .map(LicenseReport.fromJson)
      .toList();
  final consent = storage.readBool(StorageService.licensingConsentKey, defaultValue: true);

  return LicensingNotifier(
    storage,
    LicensingState(
      entries: MockData.licensingEntries(),
      reports: storedReports,
      consentAccepted: consent,
    ),
  );
});

class LicensingNotifier extends StateNotifier<LicensingState> {
  LicensingNotifier(this._storage, super.state);

  final StorageService _storage;

  Future<void> toggleConsent(bool value) async {
    state = state.copyWith(consentAccepted: value);
    await _storage.writeBool(StorageService.licensingConsentKey, value);
  }

  Future<bool> submitReport({required String categoryKey, required String message}) async {
    if (message.trim().isEmpty) {
      return false;
    }
    final report = LicenseReport(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      categoryKey: categoryKey,
      message: message.trim(),
      statusKey: 'licensing_report_status_received',
      submittedAt: DateTime.now(),
    );
    final updatedReports = <LicenseReport>[report, ...state.reports];
    state = state.copyWith(reports: updatedReports);
    await _storage.writeStringList(
      StorageService.licensingReportsKey,
      updatedReports.map((entry) => entry.toJson()).toList(),
    );
    return true;
  }
}
