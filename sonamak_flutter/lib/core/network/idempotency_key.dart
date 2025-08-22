library idempotency_key;

import 'dart:math';

/// Small, dependency-free id generator (uuid-like) for idempotency keys.
class IdempotencyKey {
  static final _rand = Random();

  static String generate({String prefix = 'idem'}) {
    String hex(int n) => List.generate(n, (_) => _rand.nextInt(16).toRadixString(16)).join();
    // 8-4-4-4-12 pattern
    return '$prefix-${hex(8)}-${hex(4)}-${hex(4)}-${hex(4)}-${hex(12)}';
  }
}
