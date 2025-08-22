import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/uat/ring_logger.dart';

/// UATFeedback — model + helper to package a tester's report with optional logs.
class UATFeedback {
  final String module;         // e.g., 'finance', 'calendar'
  final String severity;       // 'low' | 'medium' | 'high' | 'critical'
  final String summary;        // short title
  final String steps;          // steps to reproduce
  final String expected;       // expected behavior
  final String actual;         // actual behavior
  final Map<String, dynamic>? extra;   // environment info (app/page/version/etc.)
  final bool attachRecentLogs; // include recent sanitized network lines

  UATFeedback({
    required this.module,
    required this.severity,
    required this.summary,
    required this.steps,
    required this.expected,
    required this.actual,
    this.extra,
    this.attachRecentLogs = true,
  });

  Map<String, dynamic> toJson() {
    return {
      'module': module,
      'severity': severity,
      'summary': summary,
      'steps': steps,
      'expected': expected,
      'actual': actual,
      'extra': extra ?? <String, dynamic>{},
      if (attachRecentLogs) 'logs': RingLogger.I.lines(max: 200),
    };
  }

  /// Optional submit helper — if your API has a feedback endpoint.
  Future<Response<Map<String, dynamic>>> submit(String path) {
    return HttpClient.I.post<Map<String, dynamic>>(path, data: toJson());
  }

  String toPrettyString() => const JsonEncoder.withIndent('  ').convert(toJson());
}
