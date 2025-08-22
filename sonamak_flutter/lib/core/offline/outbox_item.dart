library outbox;

import 'dart:convert';

class OutboxItem {
  final String id;                 // unique id (also used for idempotency key)
  final String method;             // POST/PUT/DELETE/PATCH
  final String url;                // relative API path (e.g., '/financial_transaction/create')
  final Map<String, String>? headers; // extra headers (Authorization will be added by interceptors)
  final dynamic body;              // JSON-serializable or FormData-encoded map
  final DateTime createdAt;
  final int attempts;
  final int maxAttempts;
  final String idempotencyKey;

  const OutboxItem({
    required this.id,
    required this.method,
    required this.url,
    this.headers,
    this.body,
    required this.createdAt,
    this.attempts = 0,
    this.maxAttempts = 5,
    required this.idempotencyKey,
  });

  OutboxItem copyWith({int? attempts}) => OutboxItem(
    id: id,
    method: method,
    url: url,
    headers: headers,
    body: body,
    createdAt: createdAt,
    attempts: attempts ?? this.attempts,
    maxAttempts: maxAttempts,
    idempotencyKey: idempotencyKey,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'method': method,
    'url': url,
    'headers': headers,
    'body': body,
    'createdAt': createdAt.toIso8601String(),
    'attempts': attempts,
    'maxAttempts': maxAttempts,
    'idempotencyKey': idempotencyKey,
  };

  static OutboxItem fromJson(Map<String, dynamic> m) => OutboxItem(
    id: m['id'] as String,
    method: m['method'] as String,
    url: m['url'] as String,
    headers: (m['headers'] as Map?)?.map((k, v) => MapEntry(k.toString(), v.toString())),
    body: m['body'],
    createdAt: DateTime.parse(m['createdAt'] as String),
    attempts: (m['attempts'] as num?)?.toInt() ?? 0,
    maxAttempts: (m['maxAttempts'] as num?)?.toInt() ?? 5,
    idempotencyKey: m['idempotencyKey'] as String,
  );
}

class OutboxStore {
  final String serialized;
  final List<OutboxItem> items;
  const OutboxStore(this.serialized, this.items);

  static String serialize(List<OutboxItem> items) => jsonEncode(items.map((e) => e.toJson()).toList());

  static OutboxStore parse(String? text) {
    if (text == null || text.trim().isEmpty) return const OutboxStore('[]', []);
    try {
      final arr = jsonDecode(text);
      if (arr is List) {
        final items = arr.whereType<Map>().map((m) => OutboxItem.fromJson(m.cast<String, dynamic>())).toList();
        return OutboxStore(text, items);
      }
    } catch (_) {}
    return const OutboxStore('[]', []);
  }
}
