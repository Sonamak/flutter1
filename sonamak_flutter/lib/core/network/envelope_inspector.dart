import 'dart:convert';
import 'package:dio/dio.dart';

/// Canonicalizes Sonamak API responses/errors into
/// a single model the UI can assert against.
class EnvelopeAnalysis {
  EnvelopeAnalysis({
    required this.kind,
    this.statusCode,
    this.contentType,
    this.rawBodyPreview,
    this.jsonBody,
    this.payload,
    this.validationErrors,
    this.message,
  });

  /// success | validation | auth | binary | other
  final String kind;
  final int? statusCode;
  final String? contentType;
  final String? rawBodyPreview;
  final Map<String, dynamic>? jsonBody;
  final dynamic payload;
  final Map<String, List<String>>? validationErrors;
  final String? message;

  Map<String, dynamic> toJson() => {
    'kind': kind,
    'statusCode': statusCode,
    'contentType': contentType,
    'rawBodyPreview': rawBodyPreview,
    'jsonBody': jsonBody,
    'payload': payload,
    'validationErrors': validationErrors,
    'message': message,
  };
}

class EnvelopeInspector {
  static const _xlsx = 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';
  static const _pdf = 'application/pdf';

  static bool _isBinary(String ct) {
    final c = ct.toLowerCase();
    return c.contains(_pdf) || c.contains(_xlsx);
  }

  static Map<String, dynamic>? _parseJson(dynamic data) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) return data;
    if (data is String) {
      try { return jsonDecode(data) as Map<String, dynamic>; } catch (_) { return null; }
    }
    return null;
  }

  static dynamic _unwrapPayload(Map<String, dynamic> body) {
    return body.containsKey('payload') ? body['payload'] : body;
  }

  static Map<String, List<String>>? _extractValidation(Map<String, dynamic> body) {
    // Laravel validation usually under errors or message bag
    final errors = <String, List<String>>{};
    for (final key in const ['errors', 'error', 'validation_errors']) {
      final v = body[key];
      if (v is Map) {
        v.forEach((k, val) {
          if (val is List) {
            errors[k.toString()] = val.map((e) => e.toString()).toList();
          } else if (val != null) {
            errors[k.toString()] = [val.toString()];
          }
        });
        if (errors.isNotEmpty) return errors;
      }
    }
    return null;
  }

  /// Analyze a Dio Response into canonical categories.
  static EnvelopeAnalysis fromResponse(Response res) {
    final status = res.statusCode;
    final ct = (res.headers.value('content-type') ?? '').toLowerCase();

    if (_isBinary(ct)) {
      return EnvelopeAnalysis(
        kind: 'binary',
        statusCode: status,
        contentType: ct,
        rawBodyPreview: 'BINARY_RESPONSE(${ct})',
      );
    }

    final asMap = _parseJson(res.data);
    if (asMap != null) {
      final payload = _unwrapPayload(asMap);
      // Validation? Often 422 with field map
      final validation = _extractValidation(asMap);
      if (status == 422 && validation != null) {
        return EnvelopeAnalysis(
          kind: 'validation',
          statusCode: status,
          contentType: ct,
          jsonBody: asMap,
          payload: payload,
          validationErrors: validation,
          message: asMap['message']?.toString(),
        );
      }
      // Auth?
      if (status == 401 || status == 419) {
        return EnvelopeAnalysis(
          kind: 'auth',
          statusCode: status,
          contentType: ct,
          jsonBody: asMap,
          payload: payload,
          message: asMap['message']?.toString(),
        );
      }
      // Success (or non-422/401 error with JSON body)
      return EnvelopeAnalysis(
        kind: (status != null && status >= 200 && status < 300) ? 'success' : 'other',
        statusCode: status,
        contentType: ct,
        jsonBody: asMap,
        payload: payload,
        message: asMap['message']?.toString(),
      );
    }

    // Non-JSON: treat as other text
    final s = res.data?.toString();
    final preview = s == null ? null : (s.length > 2000 ? s.substring(0, 2000) : s);
    return EnvelopeAnalysis(
      kind: (status != null && status >= 200 && status < 300) ? 'success' : 'other',
      statusCode: status,
      contentType: ct,
      rawBodyPreview: preview,
    );
  }

  /// Analyze a DioException into canonical categories.
  static EnvelopeAnalysis fromError(DioException e) {
    final res = e.response;
    if (res != null) return fromResponse(res);
    return EnvelopeAnalysis(
      kind: 'other',
      message: e.message,
    );
  }
}
