
import 'package:sonamak_flutter/features/logs/data/logs_api.dart';
import 'package:sonamak_flutter/features/logs/data/logs_models.dart';

class LogsRepository {
  Future<({List<LogRow> rows, int total, String pageBase})> initial() async {
    final res = await LogsApi.getLogs();
    final payload = res.data;
    // React expects payload[0] = rows, payload['total']
    List<LogRow> rows = const [];
    int total = 0;
    String base = '/logs/all-logs?page=';
    if (payload is Map) {
      final list = payload[0];
      if (list is List) {
        rows = list.whereType<Map<String, dynamic>>().map((e) => LogRow.fromJson(e)).toList(growable: false);
      }
      final t = payload['total'];
      if (t is int) total = t; else if (t != null) total = int.tryParse('$t') ?? 0;
    } else if (payload is List) {
      rows = payload.whereType<Map<String, dynamic>>().map((e) => LogRow.fromJson(e)).toList(growable: false);
    }
    return (rows: rows, total: total, pageBase: base);
  }

  Future<({List<LogRow> rows, int total, String pageBase})> filter({required List<String> date}) async {
    final res = await LogsApi.filterLog(date: date);
    final payload = res.data;
    List<LogRow> rows = const [];
    int total = 0;
    String base = '/logs/all-logs?page=';
    if (payload is Map) {
      final list = payload[0];
      if (list is List) rows = list.whereType<Map<String, dynamic>>().map((e) => LogRow.fromJson(e)).toList(growable: false);
      final t = payload['total']; if (t is int) total = t; else if (t != null) total = int.tryParse('$t') ?? 0;
      final pages = payload['pages']?.toString();
      if (pages != null && pages.isNotEmpty) {
        base = pages.split('&page=')[0] + '&page=';
      }
    }
    return (rows: rows, total: total, pageBase: base);
  }

  Future<List<LogRow>> page(String pageBase, int page) async {
    final res = await LogsApi.getLogsPage(pageBase, page);
    final payload = res.data;
    // Endpoint returns payload with structure like earlier; we just extract first index list
    if (payload is Map && payload[0] is List) {
      return (payload[0] as List).whereType<Map<String, dynamic>>().map((e) => LogRow.fromJson(e)).toList(growable: false);
    }
    if (payload is List) {
      return payload.whereType<Map<String, dynamic>>().map((e) => LogRow.fromJson(e)).toList(growable: false);
    }
    return const <LogRow>[];
  }
}
