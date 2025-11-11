import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconly/iconly.dart';

import '../core/l10n/app_localizations.dart';
import '../core/providers/locale_provider.dart';
import '../core/providers/onboarding_provider.dart';
import '../core/theme/tokens.dart';
import '../core/widgets/atoms/glass_container.dart';
import '../features/account_settings/presentation/view/account_settings_view.dart';
import '../features/auth/presentation/view/auth_view.dart';
import '../features/diagnostics/presentation/view/diagnostics_view.dart';
import '../features/download_manager/presentation/view/download_manager_view.dart';
import '../features/explore/presentation/view/explore_view.dart';
import '../features/history/presentation/view/history_view.dart';
import '../features/home_create/presentation/view/home_create_view.dart';
import '../features/library/presentation/view/library_view.dart';
import '../features/export_quality/presentation/view/export_quality_view.dart';
import '../features/referrals/presentation/view/referrals_view.dart';
import '../features/licensing_center/presentation/view/licensing_center_view.dart';
import '../features/changelog_labs/presentation/view/changelog_labs_view.dart';
import '../features/notifications_center/presentation/view/notifications_center_view.dart';
import '../features/offline_vault/presentation/view/offline_vault_view.dart';
import '../features/onboarding/presentation/view/onboarding_view.dart';
import '../features/generation_queue/presentation/view/generation_queue_view.dart';
import '../features/player/presentation/view/player_view.dart';
import '../features/projects/presentation/view/projects_view.dart';
import '../features/settings/presentation/view/settings_view.dart';
import '../features/batch_covers/presentation/view/batch_covers_view.dart';
import '../features/voice_studio/presentation/view/voice_studio_view.dart';
import '../features/voice_catalog/presentation/view/voice_catalog_view.dart';
import '../features/voice_catalog/presentation/view/voice_detail_view.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  // watch providers to trigger rebuild when state changes
  ref.watch(localeProvider);
  final onboardingCompleted = ref.watch(onboardingProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: onboardingCompleted ? '/create' : '/onboarding',
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingView(),
      ),
      GoRoute(
        path: '/auth',
        name: 'auth',
        builder: (context, state) => const AuthView(),
      ),
      ShellRoute(
        builder: (context, state, child) => _RootShell(child: child),
        routes: [
          GoRoute(
            path: '/create',
            name: 'home_create',
            builder: (context, state) => const HomeCreateView(),
          ),
          GoRoute(
            path: '/library',
            name: 'library',
            builder: (context, state) => const LibraryView(),
          ),
          GoRoute(
            path: '/history',
            name: 'history',
            builder: (context, state) => const HistoryView(),
          ),
        ],
      ),
      GoRoute(
        path: '/queue',
        name: 'queue',
        builder: (context, state) => const GenerationQueueView(),
      ),
      GoRoute(
        path: '/explore',
        name: 'explore',
        builder: (context, state) => const ExploreView(),
      ),
      GoRoute(
        path: '/voices',
        name: 'voice_catalog',
        builder: (context, state) => const VoiceCatalogView(),
      ),
      GoRoute(
        path: '/voice/:id',
        name: 'voice_details',
        builder: (context, state) {
          final voiceId = state.pathParameters['id'] ?? '';
          return VoiceDetailView(voiceId: voiceId);
        },
      ),
      GoRoute(
        path: '/account',
        name: 'account_settings',
        builder: (context, state) => const AccountSettingsView(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsView(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsCenterView(),
      ),
      GoRoute(
        path: '/export',
        name: 'export_quality',
        builder: (context, state) => const ExportQualityView(),
      ),
      GoRoute(
        path: '/downloads',
        name: 'downloads',
        builder: (context, state) => const DownloadManagerView(),
      ),
      GoRoute(
        path: '/vault',
        name: 'vault',
        builder: (context, state) => const OfflineVaultView(),
      ),
      GoRoute(
        path: '/projects',
        name: 'projects',
        builder: (context, state) => const ProjectsView(),
      ),
      GoRoute(
        path: '/referrals',
        name: 'referrals',
        builder: (context, state) => const ReferralsView(),
      ),
      GoRoute(
        path: '/licensing',
        name: 'licensing_center',
        builder: (context, state) => const LicensingCenterView(),
      ),
      GoRoute(
        path: '/diagnostics',
        name: 'diagnostics',
        builder: (context, state) => const DiagnosticsView(),
      ),
      GoRoute(
        path: '/batch',
        name: 'batch_covers',
        builder: (context, state) => const BatchCoversView(),
      ),
      GoRoute(
        path: '/studio',
        name: 'voice_studio',
        builder: (context, state) => const VoiceStudioView(),
      ),
      GoRoute(
        path: '/labs',
        name: 'changelog_labs',
        builder: (context, state) => const ChangelogLabsView(),
      ),
      GoRoute(
        path: '/player/:id',
        name: 'player',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'c1';
          return PlayerView(coverId: id);
        },
      ),
    ],
    redirect: (context, state) {
      final isOnboardingRoute = state.matchedLocation == '/onboarding';
      if (!onboardingCompleted && !isOnboardingRoute) {
        return '/onboarding';
      }
      if (onboardingCompleted && isOnboardingRoute) {
        return '/create';
      }
      return null;
    },
  );
});

class _RootShell extends StatefulWidget {
  const _RootShell({required this.child});

  final Widget child;

  @override
  State<_RootShell> createState() => _RootShellState();
}

class _RootShellState extends State<_RootShell> {
  int _indexFromLocation(String location) {
    if (location.startsWith('/library')) {
      return 0;
    }
    if (location.startsWith('/history')) {
      return 2;
    }
    return 1;
  }

  String _locationFromIndex(int index) {
    switch (index) {
      case 0:
        return '/library';
      case 2:
        return '/history';
      default:
        return '/create';
    }
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouter.of(context).location;
    final currentIndex = _indexFromLocation(location);
    final localization = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.transparent,
      body: widget.child,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: GlassContainer(
          borderRadius: AppRadiusTokens.lg,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: NavigationBar(
            selectedIndex: currentIndex,
            backgroundColor: Colors.transparent,
            indicatorColor: theme.colorScheme.primary.withOpacity(0.24),
            onDestinationSelected: (index) {
              final targetLocation = _locationFromIndex(index);
              if (targetLocation != location) {
                context.go(targetLocation);
              }
            },
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            destinations: [
              NavigationDestination(
                icon: const Icon(IconlyLight.folder),
                selectedIcon: const Icon(IconlyBold.folder),
                label: localization.translate('tab_covers'),
              ),
              NavigationDestination(
                icon: Badge(
                  alignment: AlignmentDirectional.topEnd,
                  backgroundColor: theme.colorScheme.tertiary,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  label: Text(
                    localization.translate('badge_pro'),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColorTokens.dark.bgBase,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  child: const Icon(IconlyLight.edit_square),
                ),
                selectedIcon: Badge(
                  alignment: AlignmentDirectional.topEnd,
                  backgroundColor: theme.colorScheme.tertiary,
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  label: Text(
                    localization.translate('badge_pro'),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColorTokens.dark.bgBase,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                    ),
                  ),
                  child: const Icon(IconlyBold.edit_square),
                ),
                label: localization.translate('tab_create'),
              ),
              NavigationDestination(
                icon: const Icon(IconlyLight.time_circle),
                selectedIcon: const Icon(IconlyBold.time_circle),
                label: localization.translate('tab_history'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
