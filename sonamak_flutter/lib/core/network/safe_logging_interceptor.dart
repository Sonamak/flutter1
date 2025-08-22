import 'dart:convert';
import 'package:dio/dio.dart';

/// SafeLoggingInterceptor — request/response logging without leaking secrets
/// or decrypted payloads. Bodies are NEVER logged for sonamak.* hosts.
class SafeLoggingInterceptor extends Interceptor {
  final void Function(String line) sink;
  SafeLoggingInterceptor({void Function(String)? sink})
      : sink = sink ?? ((l) => print('[NET] $l'));

  static const _redacted = '***';
  static const _maxBody = 512; // truncate non-sensitive bodies

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.extra['__start_ms'] = DateTime.now().millisecondsSinceEpoch;
    final host = Uri.tryParse(options.baseUrl)?.host ?? '';
    final isSonamak = host.endsWith('sonamak.net') || host.endsWith('sonamak.app');

    final method = options.method;
    final path = options.path;
    final headers = _sanitizeHeaders(options.headers);

    String bodyInfo = '';
    if (!isSonamak) {
      bodyInfo = _summarizeData(options.data);
    } else {
      bodyInfo = '(body: hidden for encrypted host)';
    }

    sink('→ $method $path  headers: $headers  $bodyInfo');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    final start = response.requestOptions.extra['__start_ms'] as int?;
    final dur = start != null ? (DateTime.now().millisecondsSinceEpoch - start) : null;
    final status = response.statusCode;
    final host = Uri.tryParse(response.requestOptions.baseUrl)?.host ?? '';
    final isSonamak = host.endsWith('sonamak.net') || host.endsWith('sonamak.app');

    String bodyInfo = '';
    if (!isSonamak) {
      bodyInfo = _summarizeData(response.data);
    } else {
      bodyInfo = '(body: hidden for encrypted host)';
    }

    sink('← $status ${response.requestOptions.method} ${response.requestOptions.path}  ${dur != null ? dur.toString() + "ms" : ""}  $bodyInfo');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final start = err.requestOptions.extra['__start_ms'] as int?;
    final dur = start != null ? (DateTime.now().millisecondsSinceEpoch - start) : null;
    final status = err.response?.statusCode;
    sink('× ${status ?? "-"} ${err.requestOptions.method} ${err.requestOptions.path}  ${dur != null ? dur.toString() + "ms" : ""}  ${err.type}');
    handler.next(err);
  }

  Map<String, dynamic> _sanitizeHeaders(Map<String, dynamic> inHeaders) {
    final out = <String, dynamic>{};
    inHeaders.forEach((k, v) {
      final lk = k.toString().toLowerCase();
      if (lk == 'authorization') {
        out[k] = _redacted;
      } else if (lk == 'cookie' || lk == 'set-cookie') {
        out[k] = _redacted;
      } else {
        out[k] = v is String && v.length > 120 ? v.substring(0, 120) + '…' : v;
      }
    });
    return out;
  }

  String _summarizeData(dynamic data) {
    try {
      if (data == null) return '';
      if (data is String) {
        return 'body: "${data.substring(0, data.length.clamp(0, _maxBody))}${data.length>_maxBody ? '…' : ''}"';
      }
      final jsonStr = jsonEncode(data);
      final snip = jsonStr.substring(0, jsonStr.length.clamp(0, _maxBody));
      return 'json: "$snip${jsonStr.length>_maxBody ? '…' : ''}"';
    } catch (_) {
      return '(body: <unserializable>)';
    }
  }
}
