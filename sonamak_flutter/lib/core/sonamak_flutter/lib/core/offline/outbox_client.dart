import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/offline/outbox_processor.dart';

/// Wrapper helpers to send writes with automatic offline enqueue on network/5xx.
class OutboxClient {
  static Future<Response<T>> post<T>(String path, {dynamic data, Map<String, String>? headers}) async {
    try {
      final res = await HttpClient.I.post<T>(path, data: data, options: Options(headers: headers));
      if ((res.statusCode ?? 0) >= 500) {
        await OutboxProcessor.I.enqueue(method: 'POST', path: path, headers: headers, body: data);
      }
      return res;
    } on DioException {
      await OutboxProcessor.I.enqueue(method: 'POST', path: path, headers: headers, body: data);
      rethrow;
    }
  }

  static Future<Response<T>> put<T>(String path, {dynamic data, Map<String, String>? headers}) async {
    try {
      final res = await HttpClient.I.put<T>(path, data: data, options: Options(headers: headers));
      if ((res.statusCode ?? 0) >= 500) {
        await OutboxProcessor.I.enqueue(method: 'PUT', path: path, headers: headers, body: data);
      }
      return res;
    } on DioException {
      await OutboxProcessor.I.enqueue(method: 'PUT', path: path, headers: headers, body: data);
      rethrow;
    }
  }

  static Future<Response<T>> delete<T>(String path, {dynamic data, Map<String, String>? headers}) async {
    try {
      final res = await HttpClient.I.delete<T>(path, data: data, options: Options(headers: headers));
      if ((res.statusCode ?? 0) >= 500) {
        await OutboxProcessor.I.enqueue(method: 'DELETE', path: path, headers: headers, body: data);
      }
      return res;
    } on DioException {
      await OutboxProcessor.I.enqueue(method: 'DELETE', path: path, headers: headers, body: data);
      rethrow;
    }
  }
}
