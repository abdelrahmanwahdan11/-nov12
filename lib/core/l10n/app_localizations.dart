import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  AppLocalizations(this.locale, this._localizedStrings);

  final Locale locale;
  final Map<String, String> _localizedStrings;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  static Future<AppLocalizations> load(Locale locale) async {
    final languageCode = supportedLocales
        .map((supported) => supported.languageCode)
        .contains(locale.languageCode)
        ? locale.languageCode
        : 'en';

    final fallbackStrings = await _loadLocalizedStrings('en');
    final localeStrings = languageCode == 'en' ? fallbackStrings : await _loadLocalizedStrings(languageCode);
    final merged = <String, String>{...fallbackStrings, ...localeStrings};
    return AppLocalizations(locale, merged);
  }

  static Future<Map<String, String>> _loadLocalizedStrings(String languageCode) async {
    final jsonString = await rootBundle.loadString('lib/core/l10n/app_\${languageCode}.arb');
    final Map<String, dynamic> jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    return jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  String translate(String key) => _localizedStrings[key] ?? key;

  bool get isRtl => locale.languageCode == 'ar';

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }
}

class AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .map((supported) => supported.languageCode)
      .contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) => AppLocalizations.load(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
