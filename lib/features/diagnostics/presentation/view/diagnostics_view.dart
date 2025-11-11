import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/diagnostic_snapshot.dart';
import '../../../../core/providers/diagnostics_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class DiagnosticsView extends ConsumerWidget {
  const DiagnosticsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(diagnosticsProvider);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final isRtl = localization.isRtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('diagnostics_title')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () => ref.read(diagnosticsProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 120),
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                _ConnectivityCard(snapshot: state.snapshot).animate().fadeIn(duration: AppAnimations.medium),
                const SizedBox(height: 16),
                _StorageCard(snapshot: state.snapshot).animate().fadeIn(duration: AppAnimations.medium, delay: 150.ms),
                const SizedBox(height: 16),
                _SystemToggles(snapshot: state.snapshot).animate().fadeIn(duration: AppAnimations.medium, delay: 220.ms),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
          child: AppCTAButton(
            onPressed: state.isChecking
                ? null
                : () => ref.read(diagnosticsProvider.notifier).refresh(),
            label: state.isChecking
                ? localization.translate('diagnostics_checking')
                : localization.translate('diagnostics_run_check'),
          ),
        ),
      ),
    );
  }
}

class _ConnectivityCard extends StatelessWidget {
  const _ConnectivityCard({required this.snapshot});

  final DiagnosticSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);

    final statusKey = switch (snapshot.connectivity) {
      ConnectivityStatus.online => 'diagnostics_connection_online',
      ConnectivityStatus.limited => 'diagnostics_connection_limited',
      ConnectivityStatus.offline => 'diagnostics_connection_offline',
    };

    final statusColor = switch (snapshot.connectivity) {
      ConnectivityStatus.online => theme.colorScheme.primary,
      ConnectivityStatus.limited => theme.colorScheme.tertiary,
      ConnectivityStatus.offline => theme.colorScheme.error,
    };

    final latency = snapshot.latencyMs.isInfinite
        ? localization.translate('diagnostics_latency_unreachable')
        : '${snapshot.latencyMs.toStringAsFixed(0)} ms';

    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.wifi_rounded, color: statusColor),
              const SizedBox(width: 12),
              Text(
                localization.translate('diagnostics_connection_status'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            localization.translate(statusKey),
            style: theme.textTheme.headlineSmall?.copyWith(color: statusColor, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            localization
                .translate('diagnostics_latency_label')
                .replaceAll('{latency}', latency),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            localization
                .translate('diagnostics_last_checked')
                .replaceAll('{time}', _formatTime(snapshot.lastChecked)),
            style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final localization = AppLocalizations.of(context);
    final difference = DateTime.now().difference(time);
    if (difference.inMinutes < 1) {
      return localization.translate('diagnostics_relative_now');
    }
    if (difference.inHours < 1) {
      return localization
          .translate('diagnostics_relative_minutes')
          .replaceAll('{value}', difference.inMinutes.toString());
    }
    if (difference.inHours < 24) {
      return localization
          .translate('diagnostics_relative_hours')
          .replaceAll('{value}', difference.inHours.toString());
    }
    return localization
        .translate('diagnostics_relative_days')
        .replaceAll('{value}', difference.inDays.toString());
  }
}

class _StorageCard extends StatelessWidget {
  const _StorageCard({required this.snapshot});

  final DiagnosticSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final usedPercent = snapshot.storageUsedGb / snapshot.storageTotalGb;

    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.storage_rounded, color: theme.colorScheme.secondary),
              const SizedBox(width: 12),
              Text(
                localization.translate('diagnostics_storage_title'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: usedPercent.clamp(0, 1),
            minHeight: 8,
          ),
          const SizedBox(height: 8),
          Text(
            localization
                .translate('diagnostics_storage_summary')
                .replaceAll('{used}', snapshot.storageUsedGb.toStringAsFixed(1))
                .replaceAll('{total}', snapshot.storageTotalGb.toStringAsFixed(1)),
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            localization
                .translate('diagnostics_cache_size')
                .replaceAll('{size}', snapshot.cacheSizeMb.toStringAsFixed(0)),
            style: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}

class _SystemToggles extends StatelessWidget {
  const _SystemToggles({required this.snapshot});

  final DiagnosticSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return GlassContainer(
      borderRadius: AppRadiusTokens.lg,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.shield_moon_rounded, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Text(
                localization.translate('diagnostics_toggles_title'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _ToggleRow(
            label: localization.translate('diagnostics_toggle_notifications'),
            value: snapshot.notificationsEnabled,
          ),
          _ToggleRow(
            label: localization.translate('diagnostics_toggle_background_audio'),
            value: snapshot.backgroundAudioEnabled,
          ),
          _ToggleRow(
            label: localization.translate('diagnostics_toggle_downloads'),
            value: !snapshot.downloadsPaused,
          ),
          _ToggleRow(
            label: localization.translate('diagnostics_toggle_offline_ready'),
            value: snapshot.offlineModeEnabled,
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  const _ToggleRow({required this.label, required this.value});

  final String label;
  final bool value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(
            value ? Icons.check_circle_rounded : Icons.radio_button_unchecked,
            color: value ? theme.colorScheme.primary : theme.colorScheme.outline,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: theme.textTheme.bodyMedium)),
        ],
      ),
    );
  }
}
