import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/monitoring/healthcheck_service.dart';
import 'package:sonamak_flutter/core/monitoring/slo_monitor.dart';
import 'package:sonamak_flutter/core/monitoring/runtime_diagnostics.dart';
import 'package:sonamak_flutter/core/uat/ring_logger.dart';

/// DevPanel — runtime dashboard for post‑release monitoring (Windows + mobile).
class DevPanel extends StatefulWidget {
  const DevPanel({super.key, required this.monitor});
  final SLOMonitor monitor;

  @override
  State<DevPanel> createState() => _DevPanelState();
}

class _DevPanelState extends State<DevPanel> {
  final _hc = HealthcheckService(path: '/health', interval: const Duration(seconds: 30));
  HealthSample? _lastSample;
  StreamSubscription? _sub;

  @override
  void initState() {
    super.initState();
    _sub = _hc.stream.listen((s) => setState(() => _lastSample = s));
    _hc.start();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _hc.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final diag = RuntimeDiagnostics.snapshot();
    final slo = widget.monitor.snapshot();
    final logs = RingLogger.I.lines(max: 120).join('\n');

    return Scaffold(
      appBar: AppBar(title: const Text('Dev Panel — Monitoring')),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            _section('Health', [
              Text('State: ${_lastSample?.state ?? HealthState.unknown}'),
              Text('Latency: ${_lastSample?.latencyMs ?? 0} ms  at: ${_lastSample?.at.toIso8601String() ?? '-'}'),
              Row(
                children: [
                  ElevatedButton(onPressed: _hc.start, child: const Text('Start')),
                  const SizedBox(width: 8),
                  ElevatedButton(onPressed: _hc.stop, child: const Text('Stop')),
                ],
              )
            ]),
            _section('SLO', [
              Text('p95 latency: ${slo['p95LatencyMs']} ms (target ${slo['targets']['p95LatencyMs']})'),
              Text('Error rate:  ${slo['errorRatePct'].toStringAsFixed(2)}% (target ${slo['targets']['errorRatePct']}%)'),
              Text('Within targets: ${slo['withinTargets']}'),
            ]),
            _section('Runtime Diagnostics', [
              Text(const JsonEncoder.withIndent('  ').convert(diag)),
            ]),
            _section('Recent Logs (sanitized)', [
              SelectableText(logs.isEmpty ? '(no logs)' : logs, style: const TextStyle(fontFamily: 'monospace')),
              const SizedBox(height: 8),
              Row(children: [
                ElevatedButton(onPressed: () => setState(() {}), child: const Text('Refresh')),
                const SizedBox(width: 8),
                ElevatedButton(onPressed: () { RingLogger.I.clear(); setState(() {}); }, child: const Text('Clear')),
              ]),
            ]),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, List<Widget> children) => Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ...children,
          ]),
        ),
      );
}
