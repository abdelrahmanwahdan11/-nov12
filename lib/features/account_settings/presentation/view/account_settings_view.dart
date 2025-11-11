import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../../../../core/l10n/app_localizations.dart';
import '../../../../core/providers/app_theme_provider.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/locale_provider.dart';
import '../../../../core/providers/settings_provider.dart';
import '../../../../core/theme/animations.dart';
import '../../../../core/theme/gradients.dart';
import '../../../../core/theme/tokens.dart';
import '../../../../core/widgets/atoms/glass_container.dart';

class AccountSettingsView extends ConsumerStatefulWidget {
  const AccountSettingsView({super.key});

  @override
  ConsumerState<AccountSettingsView> createState() => _AccountSettingsViewState();
}

class _AccountSettingsViewState extends ConsumerState<AccountSettingsView> {
  late final TextEditingController _nameController;
  ProviderSubscription<AuthSessionState>? _sessionSubscription;
  bool _nameDirty = false;

  @override
  void initState() {
    super.initState();
    final session = ref.read(authSessionProvider);
    _nameController = TextEditingController(text: session.displayName);
    _sessionSubscription = ref.listen<AuthSessionState>(
      authSessionProvider,
      (previous, next) {
        if (!_nameDirty && _nameController.text != next.displayName) {
          _nameController.text = next.displayName;
        }
      },
    );
  }

  @override
  void dispose() {
    _sessionSubscription?.close();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final session = ref.watch(authSessionProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(localeProvider);
    final settings = ref.watch(settingsProvider);
    final isRtl = localization.isRtl;
    final resolvedLocale = locale ?? Localizations.localeOf(context);
    final List<_LanguageChipOption> languageOptions = const <_LanguageChipOption>[
      _LanguageChipOption(labelKey: 'language_system'),
      _LanguageChipOption(labelKey: 'language_english', locale: Locale('en')),
      _LanguageChipOption(labelKey: 'language_arabic', locale: Locale('ar')),
    ];

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(localization.translate('account_settings')),
          flexibleSpace: Opacity(
            opacity: 0.9,
            child: Container(
              decoration: const BoxDecoration(gradient: AppGradients.aurora),
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 48),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GlassContainer(
                      borderRadius: AppRadiusTokens.xl,
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(28),
                                child: CachedNetworkImage(
                                  imageUrl: session.avatarUrl,
                                  width: 96,
                                  height: 96,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Container(
                                    width: 96,
                                    height: 96,
                                    color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                                  ),
                                  errorWidget: (context, url, error) => Container(
                                    width: 96,
                                    height: 96,
                                    color: theme.colorScheme.surfaceVariant.withOpacity(0.2),
                                    child: const Icon(IconlyLight.profile),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 24),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      localization.translate('account_details_section'),
                                      style: theme.textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Text(
                                      session.isGuest
                                          ? localization.translate('account_guest_badge')
                                          : localization.translate('account_signed_in_badge'),
                                      style: theme.textTheme.labelLarge?.copyWith(
                                        color: theme.colorScheme.secondary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 24),
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: localization.translate('account_display_name'),
                              prefixIcon: const Icon(IconlyLight.profile),
                            ),
                            onChanged: (_) => setState(() => _nameDirty = true),
                          ),
                          const SizedBox(height: 16),
                          _AccountFieldTile(
                            icon: IconlyLight.message,
                            label: localization.translate('account_email'),
                            value: session.email ?? localization.translate('account_email_placeholder'),
                          ),
                          const SizedBox(height: 20),
                          Align(
                            alignment: AlignmentDirectional.centerEnd,
                            child: FilledButton.icon(
                              onPressed: _nameDirty && _nameController.text.trim().isNotEmpty
                                  ? () => _saveProfile(localization)
                                  : null,
                              icon: const Icon(IconlyLight.tick_square),
                              label: Text(localization.translate('account_save_changes')),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: AppAnimations.medium),
                    const SizedBox(height: 32),
                    GlassContainer(
                      borderRadius: AppRadiusTokens.xl,
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localization.translate('account_preferences_section'),
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 18),
                          Text(localization.translate('theme_mode'), style: theme.textTheme.titleSmall),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            children: ThemeMode.values.map((mode) {
                              final isSelected = mode == themeMode;
                              final label = localization.translate('theme_${mode.name}');
                              return ChoiceChip(
                                label: Text(label),
                                selected: isSelected,
                                avatar: Icon(
                                  mode == ThemeMode.dark
                                      ? IconlyBold.moon
                                      : mode == ThemeMode.light
                                          ? IconlyBold.sun
                                          : IconlyBold.activity,
                                ),
                                onSelected: (_) async {
                                  await ref.read(appThemeModeProvider.notifier).update(mode);
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 20),
                          Text(localization.translate('language'), style: theme.textTheme.titleSmall),
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: languageOptions.map((option) {
                              final isSelected = option.locale == null
                                  ? locale == null
                                  : resolvedLocale.languageCode == option.locale!.languageCode && locale != null;
                              return ChoiceChip(
                                label: Text(localization.translate(option.labelKey)),
                                selected: isSelected,
                                onSelected: (_) async {
                                  final notifier = ref.read(localeProvider.notifier);
                                  if (option.locale == null) {
                                    await notifier.useSystemLocale();
                                  } else {
                                    await notifier.update(option.locale!);
                                  }
                                },
                              );
                            }).toList(),
                          ),
                          const SizedBox(height: 24),
                          SwitchListTile.adaptive(
                            value: settings.notificationsEnabled,
                            onChanged: (value) async {
                              await ref.read(settingsProvider.notifier).toggleNotifications(value);
                            },
                            title: Text(localization.translate('notifications_toggle_label')),
                            secondary: Icon(
                              settings.notificationsEnabled
                                  ? IconlyBold.notification
                                  : IconlyLight.notification,
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: AppAnimations.medium, delay: AppAnimations.medium),
                    const SizedBox(height: 32),
                    GlassContainer(
                      borderRadius: AppRadiusTokens.xl,
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localization.translate('account_security_section'),
                            style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: double.infinity,
                            child: FilledButton.icon(
                              style: FilledButton.styleFrom(
                                backgroundColor: theme.colorScheme.error.withOpacity(0.12),
                                foregroundColor: theme.colorScheme.error,
                              ),
                              onPressed: () => _logout(localization, session.isGuest),
                              icon: const Icon(IconlyLight.logout),
                              label: Text(
                                session.isGuest
                                    ? localization.translate('account_logout_guest')
                                    : localization.translate('account_logout'),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(
                          duration: AppAnimations.medium,
                          delay: AppAnimations.medium + AppAnimations.fast,
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile(AppLocalizations localization) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      return;
    }
    await ref.read(authSessionProvider.notifier).updateDisplayName(name);
    if (!mounted) {
      return;
    }
    setState(() => _nameDirty = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localization.translate('account_saved_toast'))),
    );
  }

  Future<void> _logout(AppLocalizations localization, bool wasGuest) async {
    await ref.read(authSessionProvider.notifier).logout();
    if (!mounted) {
      return;
    }
    final messageKey = wasGuest ? 'account_logout_guest_toast' : 'account_logout_toast';
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(localization.translate(messageKey))),
    );
    context.go('/auth');
  }
}

class _AccountFieldTile extends StatelessWidget {
  const _AccountFieldTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GlassContainer(
      borderRadius: AppRadiusTokens.md,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      borderOpacity: 0.15,
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: theme.textTheme.labelLarge,
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageChipOption {
  const _LanguageChipOption({required this.labelKey, this.locale});

  final String labelKey;
  final Locale? locale;
}
