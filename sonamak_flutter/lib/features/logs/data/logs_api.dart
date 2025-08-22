
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class LogsApi {
  static Future<Response<dynamic>> getLogs() => HttpClient.I.get<dynamic>('/logs/all-logs');

  /// The React app passes an array of two dates to 'date' param.
  static Future<Response<dynamic>> filterLog({required List<String> date}) =>
      HttpClient.I.get<dynamic>('/logs/filter', queryParameters: {'date': date});

  /// Fetch an arbitrary logs page from a 'page base' url string (e.g., '/logs/filter?date[]=..&date[]=..&page=')
  static Future<Response<dynamic>> getLogsPage(String pageBase, int page) {
    // Normalize the base into path+query, then append page=
    final uri = Uri.parse(pageBase);
    String pathQuery;
    if (uri.scheme.isNotEmpty) {
      pathQuery = '${uri.path}?${uri.query}';
    } else {
      pathQuery = pageBase.startsWith('/') ? pageBase : '/$pageBase';
    }
    // ensure it ends with 'page='
    if (!pathQuery.contains('page=')) {
      pathQuery = pathQuery.contains('?') ? '$pathQuery&page=' : '$pathQuery?page=';
    } else {
      pathQuery = pathQuery.split(RegExp(r'[&?]page='))[0];
      pathQuery = pathQuery.contains('?') ? '$pathQuery&page=' : '$pathQuery?page=';
    }
    return HttpClient.I.get<dynamic>(pathQuery + page.toString());
  }
}
