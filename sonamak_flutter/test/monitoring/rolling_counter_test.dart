import 'package:flutter_test/flutter_test.dart';
import 'package:sonamak_flutter/core/monitoring/rolling_counter.dart';

void main() {
  test('RollingCounter basic add/sum', () async {
    final rc = RollingCounter(bucketSeconds: 1, bucketCount: 3);
    rc.add();
    await Future<void>.delayed(const Duration(milliseconds: 1100));
    rc.add(2);
    final s = rc.sum(minutes: 1);
    expect(s >= 2, true);
  });
}
