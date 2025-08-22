
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';

/// Persists user's chosen locale; defaults to system if none set.
class LocalePersistence {
  static const _k = 'app_locale_code';

  static Future<void> save(Locale locale) async {
    await SecureStorage.write(_k, locale.languageCode.toLowerCase());
  }

  static Future<Locale?> load() async {
    final v = await SecureStorage.read(_k);
    if (v == null || v.isEmpty) return null;
    return Locale(v);
  }

  static Future<void> clear() => SecureStorage.delete(_k);
}
