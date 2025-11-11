import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/providers/locale_provider.dart';
import '../core/providers/onboarding_provider.dart';
import '../features/auth/presentation/view/auth_view.dart';
import '../features/history/presentation/view/history_view.dart';
import '../features/home_create/presentation/view/home_create_view.dart';
import '../features/library/presentation/view/library_view.dart';
import '../features/onboarding/presentation/view/onboarding_view.dart';

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

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          final targetLocation = _locationFromIndex(index);
          if (targetLocation != location) {
            context.go(targetLocation);
          }
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.library_music), label: 'Covers'),
          NavigationDestination(icon: Icon(Icons.add_circle_outline), label: 'Create'),
          NavigationDestination(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
