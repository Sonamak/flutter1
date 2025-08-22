import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sonamak_flutter/data/repositories/auth_repository.dart';
import 'package:sonamak_flutter/data/services/auth_api.dart';

class LoginState {
  final bool loading;
  final Object? error;
  const LoginState({required this.loading, this.error});
  factory LoginState.initial() => const LoginState(loading: false);
}

class LoginController extends ChangeNotifier {
  LoginController(this._repo);
  final AuthRepository _repo;

  LoginState _state = LoginState.initial();
  LoginState get state => _state;

  Map<String, dynamic>? _asMap(dynamic v) {
    if (v is Map) return v.map((k, val) => MapEntry(k.toString(), val));
    return null;
  }

  /// Depth search: authorisation.token, authorisation_token, message/error anywhere.
  String? _deepFindStringByKeys(dynamic node, List<String> keys, {int maxDepth = 6}) {
    String? visit(dynamic n, int d) {
      if (d > maxDepth) return null;
      if (n is Map) {
        // direct keys
        for (final k in keys) {
          if (n.containsKey(k)) {
            final v = n[k];
            if (v is String && v.isNotEmpty) return v;
          }
        }
        // descend
        for (final e in n.values) {
          final s = visit(e, d + 1);
          if (s != null) return s;
        }
      } else if (n is List) {
        for (final e in n) {
          final s = visit(e, d + 1);
          if (s != null) return s;
        }
      }
      return null;
    }
    return visit(node, 0);
  }

  dynamic _unwrap(dynamic v) {
    while (true) {
      final m = _asMap(v);
      if (m == null) return v;
      if (m.containsKey('original') && _asMap(m['original']) != null) { v = m['original']; continue; }
      if (m.containsKey('payload') && _asMap(m['payload']) != null) { v = m['payload']; continue; }
      if (m.containsKey('data') && _asMap(m['data']) != null) { v = m['data']; continue; }
      return m;
    }
  }

  Future<bool> loginWithPhonePassword({
    required String phone,
    required String countryCode,
    required String password,
    bool rememberMe = false,
  }) async {
    _state = const LoginState(loading: true);
    notifyListeners();
    try {
      final res = await AuthApi.loginPhone(
        phone: phone,
        countryCode: countryCode,
        password: password,
        rememberMe: rememberMe,
      );

      dynamic body = res.data;
      if (body is String) { try { body = jsonDecode(body); } catch (_) {} }
      body = _unwrap(body);

      final m = _asMap(body);
      String token = '';
      String? message;

      if (m != null) {
        // Try standard locations
        final auth = _asMap(m['authorisation']);
        if (auth != null) {
          final t = auth['token'];
          if (t is String && t.isNotEmpty) token = t;
          final msg = auth['message'];
          if (msg is String && msg.isNotEmpty) message = msg;
        }
        if (token.isEmpty) {
          final t2 = m['authorisation_token'];
          if (t2 is String && t2.isNotEmpty) token = t2;
        }
        if (message == null || message.isEmpty) {
          final m1 = m['message'];
          if (m1 is String && m1.isNotEmpty) message = m1;
          final e1 = m['error'];
          if ((message == null || message.isEmpty) && e1 is String && e1.isNotEmpty) message = e1;
          final sc = m['status_code'];
          if ((message == null || message.isEmpty) && sc is int && sc != 200) {
            message = 'Login failed (status_code: $sc)';
          }
        }
        // Deep search as last resort for stubborn wrappers
        if (token.isEmpty) {
          token = _deepFindStringByKeys(m, const ['token','authorisation_token']) ?? '';
        }
        if (message == null || message.isEmpty) {
          message = _deepFindStringByKeys(m, const ['message','error']);
        }
      }

      if (token.isEmpty) {
        throw Exception(message ?? 'Empty token');
      }

      await _repo.setToken(token);
      await _repo.bootstrap();
      _state = const LoginState(loading: false);
      notifyListeners();
      return true;
    } catch (e) {
      _state = LoginState(loading: false, error: e);
      notifyListeners();
      return false;
    }
  }
}
