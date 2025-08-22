import 'dart:convert';

class JsonNormalizer {
  static dynamic unwrapPayload(dynamic body) {
    if (body is Map && body.containsKey('payload')) return body['payload'];
    return body;
  }
  static String canonicalString(dynamic v) => const JsonEncoder.withIndent('  ').convert(_canonicalize(v));
  static dynamic _canonicalize(dynamic v) {
    if (v is Map) {
      final keys = v.keys.map((e) => e.toString()).toList()..sort();
      return { for (final k in keys) k: _canonicalize(v[k]) };
    }
    if (v is List) return v.map(_canonicalize).toList();
    return v;
  }
}
