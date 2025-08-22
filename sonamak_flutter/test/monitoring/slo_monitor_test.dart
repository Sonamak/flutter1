import 'package:flutter_test/flutter_test.dart';
import 'package:sonamak_flutter/core/monitoring/slo_monitor.dart';

void main() {
  test('SLOMonitor p95 & error rate', () {
    final m = SLOMonitor(targetLatencyMsP95: 100, targetErrorRatePct: 50.0);
    // 10 successes with varied latencies
    for (final d in [10,20,30,40,50,60,70,80,90,100]) { m.record(durationMs: d, success: true); }
    // 2 errors
    m.record(durationMs: 50, success: false);
    m.record(durationMs: 70, success: false);
    expect(m.p95LatencyMs() >= 90, true);
    final er = m.errorRatePct();
    expect(er > 0, true);
  });
}
