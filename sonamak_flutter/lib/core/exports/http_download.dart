import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/exports/mime_util.dart';
import 'package:sonamak_flutter/core/exports/export_saver.dart';

class DownloadResult {
  final String path;
  final String? contentType;
  final String? fileName;
  const DownloadResult({required this.path, this.contentType, this.fileName});
}

class HttpDownload {
  /// Download as bytes via HttpClient, save to default exports dir, and optionally open.
  /// [path] is API path (e.g., '/financial_transaction/excel-download').
  static Future<DownloadResult> downloadAndSave(String path, {
    Map<String, dynamic>? query,
    String? overrideFileName,
    bool openAfterSave = false,
  }) async {
    final res = await HttpClient.I.get<List<int>>(
      path,
      queryParameters: query,
      options: Options(responseType: ResponseType.bytes, followRedirects: false, validateStatus: (c) => c != null && c >= 200 && c < 600),
    );

    final headers = <String, List<String>>{};
    res.headers.forEach((k, v) => headers[k] = v);

    final disp = MimeUtil.parseHeaders(headers);
    final bytes = Uint8List.fromList(res.data ?? const []);
    final name = overrideFileName ?? disp.fileName ?? _defaultNameFor(disp.contentType);
    final saved = await ExportSaver.saveBytes(bytes: bytes, suggestedName: name, openAfterSave: openAfterSave);
    return DownloadResult(path: saved.path, contentType: disp.contentType, fileName: name);
  }

  static String _defaultNameFor(String? contentType) {
    switch (contentType) {
      case 'application/pdf': return 'export.pdf';
      case 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet': return 'export.xlsx';
      default: return 'export.bin';
    }
  }
}
