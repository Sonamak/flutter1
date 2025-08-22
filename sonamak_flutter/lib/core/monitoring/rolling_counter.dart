library rolling_counter;

/// RollingCounter — tracks counts in a sliding window using fixed time buckets.
/// Dependency‑free and suitable for simple SLO calculations in‑app.
class RollingCounter {
  final int bucketSeconds;
  final int bucketCount;
  late final List<int> _buckets;
  late int _startEpoch; // epoch seconds for the start of bucket[0]

  RollingCounter({this.bucketSeconds = 60, this.bucketCount = 5}) {
    _buckets = List<int>.filled(bucketCount, 0);
    _startEpoch = _nowSec();
  }

  void add([int n = 1]) {
    _rotate();
    _buckets[_idxFor(_nowSec())] += n;
  }

  int sum({int minutes = 5}) {
    _rotate();
    final take = (minutes * 60 ~/ bucketSeconds).clamp(1, bucketCount);
    int s = 0;
    for (int i = 0; i < take; i++) s += _buckets[i];
    return s;
  }

  void reset() {
    for (int i = 0; i < _buckets.length; i++) _buckets[i] = 0;
    _startEpoch = _nowSec();
  }

  void _rotate() {
    final now = _nowSec();
    final elapsedBuckets = ((now - _startEpoch) ~/ bucketSeconds);
    if (elapsedBuckets <= 0) return;
    if (elapsedBuckets >= bucketCount) {
      // the window moved beyond our history — clear all
      for (int i = 0; i < _buckets.length; i++) _buckets[i] = 0;
      _startEpoch = now - (now % bucketSeconds);
      return;
    }
    // shift buckets left by elapsedBuckets and zero the freed ones
    for (int i = 0; i < bucketCount - elapsedBuckets; i++) {
      _buckets[i] = _buckets[i + elapsedBuckets];
    }
    for (int i = bucketCount - elapsedBuckets; i < bucketCount; i++) {
      _buckets[i] = 0;
    }
    _startEpoch += elapsedBuckets * bucketSeconds;
  }

  int _idxFor(int epochSec) {
    final offset = (epochSec - _startEpoch) ~/ bucketSeconds;
    return offset.clamp(0, bucketCount - 1);
  }

  int _nowSec() => DateTime.now().millisecondsSinceEpoch ~/ 1000;
}
