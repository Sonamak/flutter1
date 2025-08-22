
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:sonamak_flutter/app/localization/app_localizations.dart';

typedef LocaleResolutionCallback = Locale? Function(Locale? locale, Iterable<Locale> supportedLocales);

class L10n {
  static const supportedLocales = <Locale>[Locale('en'), Locale('ar')];

  static const localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    AppLocalizations.delegate,
  ];

  static List<LocalizationsDelegate<dynamic>> get delegates => localizationsDelegates;

  static LocaleResolutionCallback get localeResolution => localeResolutionCallback;

  static Locale? localeResolutionCallback(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) return supportedLocales.first;
    for (final l in supportedLocales) {
      if (l.languageCode == locale.languageCode) return l;
    }
    return supportedLocales.first;
  }
}
