import 'dart:convert';
import 'dart:typed_data';
import 'package:encrypt/encrypt.dart' as enc;
import 'package:crypto/crypto.dart' as crypto;

class CryptoJsCompat {
  static const String _magic = 'Salted__';

  static Map<String, Uint8List> _evpBytesToKey(Uint8List pass, Uint8List salt, int keyLen, int ivLen) {
    final int total = keyLen + ivLen;
    List<int> out = [];
    List<int> prev = [];
    while (out.length < total) {
      final md = crypto.md5.convert(Uint8List.fromList(prev + pass + salt)).bytes;
      prev = md;
      out.addAll(md);
    }
    final key = Uint8List.fromList(out.sublist(0, keyLen));
    final iv  = Uint8List.fromList(out.sublist(keyLen, keyLen + ivLen));
    return {'key': key, 'iv': iv};
  }

  static String encryptString(String passphrase, String plain) {
    final salt = enc.SecureRandom(8).bytes;
    final pass = Uint8List.fromList(utf8.encode(passphrase));
    final deriv = _evpBytesToKey(pass, Uint8List.fromList(salt), 32, 16);
    final key = enc.Key(deriv['key']!);
    final iv  = enc.IV(deriv['iv']!);
    final aes = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final cipher = aes.encrypt(plain, iv: iv).bytes;
    final packet = Uint8List.fromList(utf8.encode(_magic) + salt + cipher);
    return base64Encode(packet);
  }

  static String decryptToString(String passphrase, String base64) {
    final raw = base64Decode(base64);
    if (raw.length < 16) throw ArgumentError('Cipher too short');
    final magic = utf8.decode(raw.sublist(0, 8), allowMalformed: true);
    if (magic != _magic) throw ArgumentError('Bad magic');
    final salt = Uint8List.fromList(raw.sublist(8, 16));
    final cipher = Uint8List.fromList(raw.sublist(16));
    final pass = Uint8List.fromList(utf8.encode(passphrase));
    final deriv = _evpBytesToKey(pass, salt, 32, 16);
    final key = enc.Key(deriv['key']!);
    final iv  = enc.IV(deriv['iv']!);
    final aes = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    return aes.decrypt(enc.Encrypted(cipher), iv: iv);
  }
}
