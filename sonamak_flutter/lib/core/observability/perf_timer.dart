/// PerfTimer — small helper to measure async durations with labels.
class PerfTimer {
  final String label;
  final int _start = DateTime.now().millisecondsSinceEpoch;
  PerfTimer(this.label);

  int get elapsedMs => DateTime.now().millisecondsSinceEpoch - _start;

  @override
  String toString() => '$label: ${elapsedMs}ms';
}
