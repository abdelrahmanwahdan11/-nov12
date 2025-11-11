import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/l10n/app_localizations.dart';
import 'core/providers/app_theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/gradients.dart';
import 'router/app_router.dart';

class App extends ConsumerWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(appThemeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'AI Covers Studio',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      routerConfig: router,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        final mediaQuery = MediaQuery.of(context);
        final clampedTextScaler = TextScaler.linear(mediaQuery.textScaleFactor.clamp(0.8, 1.3));
        final gradient = AppGradients.background(Theme.of(context).brightness);
        return MediaQuery(
          data: mediaQuery.copyWith(textScaler: clampedTextScaler),
          child: DecoratedBox(
            decoration: BoxDecoration(gradient: gradient),
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },
    );
  }
}
