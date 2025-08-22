
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/utils/locale_persistence.dart';
import 'package:sonamak_flutter/core/utils/locale_manager.dart';

/// App-wide locale controller. Not wired to UI by default;
/// can be used by any settings screen to change language at runtime.
class LocaleController extends ChangeNotifier {
  LocaleController(this._locale);

  Locale _locale;

  Locale get locale => _locale;

  Future<void> setLocale(Locale locale) async {
    _locale = locale;
    LocaleManager.set(locale);
    await LocalePersistence.save(locale);
    notifyListeners();
  }

  static Future<LocaleController> createWithSaved(Locale fallback) async {
    final saved = await LocalePersistence.load();
    final initial = saved ?? fallback;
    LocaleManager.set(initial);
    return LocaleController(initial);
  }
}
