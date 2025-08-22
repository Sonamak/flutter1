
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

/// A lightweight performance banner that shows average frame time.
/// Intended for DEV builds. Do not ship enabled in production.
class PerformanceBanner extends StatefulWidget {
  const PerformanceBanner({super.key, this.aligned = Alignment.topRight});
  final Alignment aligned;

  @override
  State<PerformanceBanner> createState() => _PerformanceBannerState();
}

class _PerformanceBannerState extends State<PerformanceBanner> {
  final List<double> _lastMs = <double>[];
  late final TimingsCallback _cb;

  @override
  void initState() {
    super.initState();
    _cb = (List<FrameTiming> timings) {
      for (final t in timings) {
        final ms = (t.totalSpan.inMicroseconds / 1000.0).toDouble();
        _lastMs.add(ms);
        if (_lastMs.length > 60) _lastMs.removeAt(0); // last ~1s
      }
      if (mounted) setState(() {});
    };
    SchedulerBinding.instance.addTimingsCallback(_cb);
  }

  @override
  void dispose() {
    SchedulerBinding.instance.removeTimingsCallback(_cb);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avg = _lastMs.isEmpty ? 0.0 : _lastMs.reduce((a,b)=>a+b) / _lastMs.length;
    final fps = avg == 0 ? 0 : (1000.0 / avg);
    final base = fps >= 55 ? Colors.green : (fps >= 40 ? Colors.orange : Colors.red);
    final color = base.withValues(alpha: 0.85);
    return Align(
      alignment: widget.aligned,
      child: Container(
        margin: const EdgeInsets.all(8),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(6)),
        child: Text('${fps.toStringAsFixed(0)} FPS', style: const TextStyle(color: Colors.white, fontSize: 12)),
      ),
    );
  }
}
