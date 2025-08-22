import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/utils/locale_manager.dart';

class ConnectionDiagnosticsResult {
  ConnectionDiagnosticsResult({
    required this.baseUrl,
    required this.origin,
    required this.host,
    required this.aesEnabled,
    required this.localizationHeader,
    this.pingEndpoint,
    this.statusCode,
    this.responsePreview,
    this.errorMessage,
  });

  final String baseUrl;
  final String origin;
  final String host;
  final bool aesEnabled;
  final String localizationHeader;
  final String? pingEndpoint;
  final int? statusCode;
  final String? responsePreview; // pretty JSON or raw text slice
  final String? errorMessage;
}

class ConnectionDiagnosticsService {
  static String _deriveOrigin(String baseUrl) {
    final idx = baseUrl.indexOf('/api');
    return idx > 0 ? baseUrl.substring(0, idx) : baseUrl;
  }

  static bool _isSonamakHost(String baseUrl) {
    final uri = Uri.tryParse(baseUrl);
    final host = uri?.host ?? '';
    return host.endsWith('sonamak.net') || host.endsWith('sonamak.app');
  }

  static ConnectionDiagnosticsResult snapshot({String? pingEndpoint}) {
    final baseUrl = HttpClient.I.options.baseUrl;
    final origin = _deriveOrigin(baseUrl);
    final host = Uri.tryParse(baseUrl)?.host ?? '';
    final aes = _isSonamakHost(baseUrl);
    final loc = LocaleManager.headerValue();
    return ConnectionDiagnosticsResult(
      baseUrl: baseUrl,
      origin: origin,
      host: host,
      aesEnabled: aes,
      localizationHeader: loc,
      pingEndpoint: pingEndpoint,
    );
  }

  static Future<ConnectionDiagnosticsResult> ping(String endpoint) async {
    final snap = snapshot(pingEndpoint: endpoint);
    try {
      final res = await HttpClient.I.get(endpoint);
      String? preview;
      if (res.data is String) {
        final s = res.data as String;
        preview = s.length > 2000 ? s.substring(0, 2000) : s;
      } else {
        try {
          final pretty = const JsonEncoder.withIndent('  ').convert(res.data);
          preview = pretty.length > 2000 ? pretty.substring(0, 2000) : pretty;
        } catch (_) {
          preview = res.data.toString();
        }
      }
      return ConnectionDiagnosticsResult(
        baseUrl: snap.baseUrl,
        origin: snap.origin,
        host: snap.host,
        aesEnabled: snap.aesEnabled,
        localizationHeader: snap.localizationHeader,
        pingEndpoint: endpoint,
        statusCode: res.statusCode,
        responsePreview: preview,
      );
    } on DioException catch (e) {
      String? preview;
      final data = e.response?.data;
      if (data != null) {
        try {
          final pretty = const JsonEncoder.withIndent('  ').convert(data);
          preview = pretty.length > 2000 ? pretty.substring(0, 2000) : pretty;
        } catch (_) {
          preview = data.toString();
        }
      }
      return ConnectionDiagnosticsResult(
        baseUrl: snap.baseUrl,
        origin: snap.origin,
        host: snap.host,
        aesEnabled: snap.aesEnabled,
        localizationHeader: snap.localizationHeader,
        pingEndpoint: endpoint,
        statusCode: e.response?.statusCode,
        responsePreview: preview,
        errorMessage: e.message,
      );
    } catch (e) {
      return ConnectionDiagnosticsResult(
        baseUrl: snap.baseUrl,
        origin: snap.origin,
        host: snap.host,
        aesEnabled: snap.aesEnabled,
        localizationHeader: snap.localizationHeader,
        pingEndpoint: endpoint,
        errorMessage: e.toString(),
      );
    }
  }
}
