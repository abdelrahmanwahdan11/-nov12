import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/models/license_entry.dart';
import '../../../../core/models/license_report.dart';
import '../../../../core/providers/licensing_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/app_cta_button.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class LicensingCenterView extends ConsumerStatefulWidget {
  const LicensingCenterView({super.key});

  @override
  ConsumerState<LicensingCenterView> createState() => _LicensingCenterViewState();
}

class _LicensingCenterViewState extends ConsumerState<LicensingCenterView> {
  late TextEditingController _messageController;
  late String _selectedCategory;

  @override
  void initState() {
    super.initState();
    final state = ref.read(licensingProvider);
    _selectedCategory = state.entries.isNotEmpty ? state.entries.first.id : '';
    _messageController = TextEditingController();
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final state = ref.watch(licensingProvider);
    final isRtl = localization.isRtl;

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('licensing_title')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
            children: [
              Text(
                localization.translate('licensing_subtitle'),
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 16),
              ...state.entries.map((entry) => _LicenseCard(entry: entry)),
              const SizedBox(height: 24),
              GlassContainer(
                borderRadius: AppRadiusTokens.lg,
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localization.translate('licensing_report_heading'),
                      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: state.entries.any((entry) => entry.id == _selectedCategory)
                          ? _selectedCategory
                          : (state.entries.isNotEmpty ? state.entries.first.id : null),
                      decoration: InputDecoration(
                        labelText: localization.translate('licensing_report_subject_hint'),
                        border: OutlineInputBorder(borderRadius: AppRadiusTokens.md),
                      ),
                      items: state.entries
                          .map((entry) => DropdownMenuItem<String>(
                                value: entry.id,
                                child: Text(localization.translate(entry.titleKey)),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedCategory = value;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _messageController,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: localization.translate('licensing_report_message_hint'),
                        border: OutlineInputBorder(borderRadius: AppRadiusTokens.md),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile.adaptive(
                      value: state.consentAccepted,
                      onChanged: (value) => ref.read(licensingProvider.notifier).toggleConsent(value),
                      title: Text(localization.translate('licensing_consent_toggle')),
                    ),
                    const SizedBox(height: 12),
                    AppCtaButton(
                      label: localization.translate('licensing_report_submit'),
                      leading: const Icon(IconlyBold.send, color: Colors.black),
                      onPressed: () async {
                        if (!state.consentAccepted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(localization.translate('licensing_consent_required'))),
                          );
                          return;
                        }
                        final selectedEntry = state.entries.firstWhere(
                          (entry) => entry.id == _selectedCategory,
                          orElse: () => state.entries.first,
                        );
                        final submitted = await ref
                            .read(licensingProvider.notifier)
                            .submitReport(categoryKey: selectedEntry.titleKey, message: _messageController.text);
                        if (!mounted) return;
                        final message = submitted
                            ? localization.translate('licensing_report_toast')
                            : localization.translate('licensing_report_error');
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                        if (submitted) {
                          _messageController.clear();
                        }
                      },
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: AppAnimations.medium),
              const SizedBox(height: 24),
              Text(
                localization.translate('licensing_reports_recent'),
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              if (state.reports.isEmpty)
                GlassContainer(
                  borderRadius: AppRadiusTokens.lg,
                  padding: const EdgeInsets.all(20),
                  child: Text(localization.translate('licensing_reports_empty')),
                )
              else
                ...state.reports.map((report) => _ReportTile(report: report)),
            ],
          ),
        ),
      ),
    );
  }
}

class _LicenseCard extends StatelessWidget {
  const _LicenseCard({required this.entry});

  final LicenseEntry entry;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlassContainer(
        borderRadius: AppRadiusTokens.lg,
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: AppRadiusTokens.md,
              child: CachedNetworkImage(
                imageUrl: entry.illustrationUrl,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localization.translate(entry.titleKey),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    localization.translate(entry.descriptionKey),
                    style: theme.textTheme.bodySmall,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: entry.highlightKeys
                        .map((key) => Chip(
                              label: Text(localization.translate(key)),
                              avatar: const Icon(IconlyLight.shield_done, size: 16),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportTile extends StatelessWidget {
  const _ReportTile({required this.report});

  final LicenseReport report;

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        borderRadius: AppRadiusTokens.lg,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(IconlyBold.document, size: 18),
                const SizedBox(width: 8),
                Text(
                  localization.translate(report.categoryKey),
                  style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const Spacer(),
                Chip(
                  label: Text(localization.translate(report.statusKey)),
                  backgroundColor: theme.colorScheme.primary.withOpacity(0.12),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              report.message,
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              localization
                  .translate('licensing_report_timestamp')
                  .replaceFirst('{time}', TimeOfDay.fromDateTime(report.submittedAt).format(context)),
              style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
