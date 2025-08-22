import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/security/cryptojs_compat.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/core/utils/locale_manager.dart';
import 'package:sonamak_flutter/core/utils/server_config.dart';
import 'package:sonamak_flutter/core/network/multipart_cipher.dart';

class NetKeys {
  static const authHeader = 'Authorization';
  static const bearer = 'Bearer ';
  static const lang = 'X-localization';
  static const authTokenStorageKey = 'auth_token';
  static const tokenKey = authTokenStorageKey;
}

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await SecureStorage.read(NetKeys.authTokenStorageKey);
    if ((token ?? '').isNotEmpty) {
      options.headers[NetKeys.authHeader] = '${NetKeys.bearer}$token';
    }
    handler.next(options);
  }
}

class LocaleInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers[NetKeys.lang] = LocaleManager.headerValue();
    handler.next(options);
  }
}

class OriginInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final origin = ServerConfig.origin; // non-nullable String
    if (origin.isNotEmpty) {
      options.headers.putIfAbsent('Origin', () => origin);
      options.headers.putIfAbsent('Referer', () => origin.endsWith('/') ? origin : '$origin/');
    }
    handler.next(options);
  }
}

/// AES transport parity for sonamak.{net,app} hosts.
class SonamakCipherInterceptor extends Interceptor {
  static const _secret = 'my32charsecretkeymy32charse';

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (_isSonamakHost(options.baseUrl)) {
      final data = options.data;
      if (data is FormData) {
        final encForm = MultipartCipher.encryptNonFileFields(data, _secret);
        options.data = encForm;
        options.headers.remove(Headers.contentTypeHeader);
      } else if (data != null) {
        final plain = (data is String) ? data : jsonEncode(data);
        final cipher = CryptoJsCompat.encryptString(_secret, plain);
        options.data = jsonEncode(cipher);
        options.headers[Headers.contentTypeHeader] = 'application/json';
      }
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final ct = (response.headers.value(Headers.contentTypeHeader) ?? '').toLowerCase();
    if (ct.contains('application/pdf') || ct.contains('application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')) {
      handler.next(response);
      return;
    }

    dynamic body = response.data;
    if (body is String) { try { body = jsonDecode(body); } catch (_) {} }

    try {
      final m = _asMap(body);
      if (m != null) {
        final pl = m['payload'];
        if (pl is String && _looksEncrypted(pl)) {
          final dec = CryptoJsCompat.decryptToString(_secret, pl);
          final parsed = jsonDecode(dec);
          m['payload'] = parsed;
          body = m;
        }
      } else if (body is String && _looksEncrypted(body)) {
        final dec = CryptoJsCompat.decryptToString(_secret, body);
        body = jsonDecode(dec);
      }
    } catch (_) {}

    final mm = _asMap(body);
    response.data = (mm != null) ? _unwrap(mm) : body;
    handler.next(response);
  }
}

bool _isSonamakHost(String baseUrl) {
  final host = Uri.tryParse(baseUrl)?.host ?? '';
  return host.endsWith('sonamak.net') || host.endsWith('sonamak.app');
}

bool _looksEncrypted(String s) {
  if (s.length < 16) return false;
  if (!s.startsWith('U2FsdGVkX1')) return false;
  try {
    final raw = base64Decode(s);
    final head = utf8.decode(raw.sublist(0, 8), allowMalformed: true);
    return head == 'Salted__';
  } catch (_) { return false; }
}

Map<String, dynamic>? _asMap(dynamic v) {
  if (v is Map) return v.map((k, v) => MapEntry(k.toString(), v));
  return null;
}

dynamic _unwrap(Map<String, dynamic> m) {
  if (m.containsKey('payload')) return m['payload'];
  return m;
}
