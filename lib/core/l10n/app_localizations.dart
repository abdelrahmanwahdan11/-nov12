import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppLocalizations {
  AppLocalizations(this.locale);

  final Locale locale;

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('ar'),
  ];

  static const Map<String, Map<String, String>> _localizedValues = <String, Map<String, String>>{
    'en': <String, String>{
      'app_title': 'AI Covers Studio',
      'create_cover': 'Create new cover',
      'paste_link': 'Paste YouTube link',
      'select_voice': 'Select a voice',
      'login': 'Log in',
      'guest_mode': 'Continue as Guest',
      'password_strength': 'Password strength',
    },
    'ar': <String, String>{
      'app_title': 'استوديو أغلفة الذكاء الاصطناعي',
      'create_cover': 'أنشئ غلافًا جديدًا',
      'paste_link': 'ألصق رابط يوتيوب',
      'select_voice': 'اختر صوتًا',
      'login': 'تسجيل الدخول',
      'guest_mode': 'المتابعة كضيف',
      'password_strength': 'قوة كلمة المرور',
    },
  };

  String translate(String key) {
    final languageCode = locale.languageCode;
    final localizedStrings = _localizedValues[languageCode] ?? _localizedValues['en']!;
    return localizedStrings[key] ?? key;
  }

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
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture<AppLocalizations>(AppLocalizations(locale));

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) => false;
}
