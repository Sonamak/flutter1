
import 'dart:convert';
import 'package:encrypt/encrypt.dart';

/// AES/CBC/PKCS7 cipher utilities compatible with CryptoJS-style payloads.
/// Keys are provided as base64 strings. If key/iv are empty, operations are no-ops.
class AESCipher {
  AESCipher({required this.keyBase64, required this.ivBase64});

  final String keyBase64;
  final String ivBase64;

  bool get enabled => keyBase64.isNotEmpty && ivBase64.isNotEmpty;

  String encryptJson(Map<String, dynamic> jsonMap) {
    if (!enabled) {
      return jsonEncode(jsonMap);
    }
    final key = Key.fromBase64(keyBase64);
    final iv = IV.fromBase64(ivBase64);
    final e = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    final plain = jsonEncode(jsonMap);
    return e.encrypt(plain, iv: iv).base64;
  }

  /// Decrypts a base64 ciphertext into a UTF-8 string. Returns input if disabled.
  String decryptToString(String base64Cipher) {
    if (!enabled) return base64Cipher;
    final key = Key.fromBase64(keyBase64);
    final iv = IV.fromBase64(ivBase64);
    final e = Encrypter(AES(key, mode: AESMode.cbc, padding: 'PKCS7'));
    return e.decrypt(Encrypted.fromBase64(base64Cipher), iv: iv);
  }

  /// Attempts to decrypt a JSON ciphertext and decode to Map. If parsing fails,
  /// returns null to let callers fallback gracefully.
  Map<String, dynamic>? tryDecryptToJson(String base64Cipher) {
    try {
      final txt = decryptToString(base64Cipher);
      return jsonDecode(txt) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }
}
