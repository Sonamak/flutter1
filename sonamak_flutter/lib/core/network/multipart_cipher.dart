import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/security/cryptojs_compat.dart';

class MultipartCipher {
  static FormData encryptNonFileFields(FormData form, String secret) {
    final result = FormData();
    for (final entry in form.fields) {
      final key = entry.key;
      final value = entry.value;
      final cipher = CryptoJsCompat.encryptString(secret, value);
      result.fields.add(MapEntry(key, cipher));
    }
    for (final entry in form.files) {
      result.files.add(MapEntry(entry.key, entry.value));
    }
    return result;
  }
}
