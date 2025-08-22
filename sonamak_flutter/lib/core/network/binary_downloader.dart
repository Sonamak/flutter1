
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class BinaryDownloader {
  /// Fetch bytes from an API path or absolute URL.
  static Future<Uint8List> getBytes(String path, {Map<String, dynamic>? query}) async {
    final res = await HttpClient.I.get<Uint8List>(
      path,
      queryParameters: query,
      options: Options(responseType: ResponseType.bytes),
    );
    final data = res.data;
    if (data == null) {
      throw DioException(
        requestOptions: res.requestOptions,
        error: 'Empty binary response',
      );
    }
    return data;
  }
}
