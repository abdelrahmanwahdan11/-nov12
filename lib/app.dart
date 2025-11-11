import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import 'core/l10n/app_localizations.dart';
import 'core/providers/app_theme_provider.dart';
import 'core/providers/locale_provider.dart';
import 'core/theme/app_theme.dart';
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
        final textScaleFactor = MediaQuery.of(context).textScaleFactor.clamp(0.8, 1.3);
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScaleFactor)),
          child: child ?? const SizedBox.shrink(),
        );
      },
    );
  }
}

TextTheme _buildTextTheme(TextTheme base) {
  return GoogleFonts.urbanistTextTheme(base);
}

ThemeData buildLightTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    colorScheme: buildLightColorScheme(),
    scaffoldBackgroundColor: buildLightColorScheme().background,
  );
}

ThemeData buildDarkTheme() {
  final base = ThemeData.dark(useMaterial3: true);
  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    colorScheme: buildDarkColorScheme(),
    scaffoldBackgroundColor: buildDarkColorScheme().background,
  );
}
