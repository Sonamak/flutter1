import 'package:flutter/material.dart';

class LocaleManager {
  static Locale _current = const Locale('en');

  static Locale get current => _current;

  static void set(Locale locale) {
    _current = locale;
  }

  static String headerValue() {
    final code = _current.languageCode.toLowerCase();
    switch (code) {
      case 'ar':
      case 'en':
      case 'tr':
      case 'es':
        return code;
      default:
        return 'en';
    }
  }
}
