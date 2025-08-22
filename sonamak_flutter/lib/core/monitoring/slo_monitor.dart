library slo_monitor;

import 'rolling_counter.dart';

/// SLOMonitor — tracks request latency and error rates vs targets.
class SLOMonitor {
  final int targetLatencyMsP95;
  final double targetErrorRatePct;
  final RollingCounter _errors;
  final RollingCounter _requests;
  final List<int> _latencies = <int>[]; // bounded

  final int _latencyKeep; // how many latency samples to keep

  SLOMonitor({
    this.targetLatencyMsP95 = 1200,
    this.targetErrorRatePct = 1.0,
    int counterWindowMinutes = 5,
    int latencyKeep = 200,
  })  : _latencyKeep = latencyKeep,
        _errors = RollingCounter(bucketSeconds: 60, bucketCount: counterWindowMinutes.clamp(1, 60)),
        _requests = RollingCounter(bucketSeconds: 60, bucketCount: counterWindowMinutes.clamp(1, 60));

  void record({required int durationMs, required bool success}) {
    if (!success) _errors.add(1);
    _requests.add(1);
    _latencies.add(durationMs);
    if (_latencies.length > _latencyKeep) _latencies.removeAt(0);
  }

  bool healthy() => p95LatencyMs() <= targetLatencyMsP95 && errorRatePct() <= targetErrorRatePct;

  double errorRatePct({int minutes = 5}) {
    final e = _errors.sum(minutes: minutes);
    final r = _requests.sum(minutes: minutes);
    if (r == 0) return 0;
    return (e * 100.0) / r;
  }

  int p95LatencyMs() {
    if (_latencies.isEmpty) return 0;
    final sorted = List<int>.from(_latencies)..sort();
    final idx = ((sorted.length - 1) * 0.95).round();
    return sorted[idx];
  }

  Map<String, dynamic> snapshot() => {
        'p95LatencyMs': p95LatencyMs(),
        'errorRatePct': errorRatePct(),
        'withinTargets': healthy(),
        'targets': {'p95LatencyMs': targetLatencyMsP95, 'errorRatePct': targetErrorRatePct},
      };
}
