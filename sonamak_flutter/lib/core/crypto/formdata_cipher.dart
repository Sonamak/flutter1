
import 'package:dio/dio.dart';

/// In the original React app, multipart/form-data uploads are NOT AES-encrypted.
/// This helper exists to keep the intent explicit.
bool isMultipart(RequestOptions options) {
  final contentType = options.headers['Content-Type']?.toString().toLowerCase() ?? '';
  return contentType.contains('multipart/form-data') || options.data is FormData;
}
