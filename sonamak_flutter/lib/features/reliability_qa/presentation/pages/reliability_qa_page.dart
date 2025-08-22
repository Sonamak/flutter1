import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/network/chaos_interceptor.dart';
import 'package:sonamak_flutter/core/network/retry_interceptor.dart';
import 'package:sonamak_flutter/core/network/version_header_interceptor.dart';
import 'package:sonamak_flutter/core/offline/outbox_processor.dart';
import 'package:sonamak_flutter/core/offline/outbox_persistence.dart';

class ReliabilityQaPage extends StatefulWidget {
  const ReliabilityQaPage({super.key});
  @override
  State<ReliabilityQaPage> createState() => _ReliabilityQaPageState();
}

class _ReliabilityQaPageState extends State<ReliabilityQaPage> {
  final _endpoint = TextEditingController(text: '/settings/profile');
  final _batch = TextEditingController(text: '5');
  int _minLatency = 0;
  int _maxLatency = 0;
  double _errorRate = 0.0;
  bool _retryOn = false;
  bool _versionOn = false;
  String _status = '';
  int _ok = 0, _fail = 0, _queued = 0;

  ChaosInterceptor? _chaos;
  RetryInterceptor? _retry;
  VersionHeaderInterceptor? _version;

  @override
  void initState() {
    super.initState();
    _refreshQueue();
  }

  void _applyChaos() {
    final dio = HttpClient.I;
    // Remove previous instance if present
    dio.interceptors.remove(_chaos);
    _chaos = ChaosInterceptor(minLatencyMs: _minLatency, maxLatencyMs: _maxLatency, errorRate: _errorRate);
    dio.interceptors.add(_chaos!);
    setState(() => _status = 'Chaos enabled: ${_minLatency}-${_maxLatency}ms, errorRate=${_errorRate.toStringAsFixed(2)}');
  }

  void _toggleRetry(bool v) {
    final dio = HttpClient.I;
    if (v) {
      _retry ??= RetryInterceptor(dio: HttpClient.I, maxRetries: 3);
      dio.interceptors.add(_retry!);
    } else {
      dio.interceptors.remove(_retry);
    }
    setState(() => _retryOn = v);
  }

  void _toggleVersion(bool v) {
    final dio = HttpClient.I;
    if (v) {
      _version ??= VersionHeaderInterceptor(version: 'phase8');
      dio.interceptors.add(_version!);
    } else {
      dio.interceptors.remove(_version);
    }
    setState(() => _versionOn = v);
  }

  Future<void> _refreshQueue() async {
    final items = await OutboxPersistence.readAll();
    setState(() => _queued = items.length);
  }

  Future<void> _runBatch() async {
    setState(() { _ok = 0; _fail = 0; _status = 'Running...'; });
    final dio = HttpClient.I;
    final n = int.tryParse(_batch.text.trim()) ?? 5;
    final ep = _endpoint.text.trim();
    for (var i = 0; i < n; i++) {
      try {
        final res = await dio.get(ep);
        if ((res.statusCode ?? 0) >= 200 && (res.statusCode ?? 0) < 300) {
          _ok++;
        } else {
          _fail++;
        }
      } catch (_) {
        _fail++;
      }
      setState(() {});
    }
    setState(() => _status = 'Done. OK: $_ok, FAIL: $_fail');
  }

  Future<void> _flushOutbox() async {
    setState(() => _status = 'Flushing outbox...');
    try {
      await OutboxProcessor.I.flush();
    } catch (_) {}
    await _refreshQueue();
    setState(() => _status = 'Flush triggered. Queue: $_queued');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reliability & Performance QA')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Chaos (dev-only)', style: TextStyle(fontWeight: FontWeight.w700)),
            Row(children: [
              _num('Min ms', _minLatency, (v) => setState(() => _minLatency = v)),
              const SizedBox(width: 8),
              _num('Max ms', _maxLatency, (v) => setState(() => _maxLatency = v)),
              const SizedBox(width: 8),
              _slider('Error rate', _errorRate, (v) => setState(() => _errorRate = v)),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _applyChaos, child: const Text('Apply Chaos')),
            ]),
            const SizedBox(height: 12),
            Row(children: [
              Switch(value: _retryOn, onChanged: _toggleRetry), const Text('Enable Retry (3x backoff+jitter)'),
            ]),
            Row(children: [
              Switch(value: _versionOn, onChanged: _toggleVersion), const Text('Attach X-Client-Version/Platform headers'),
            ]),
            const Divider(height: 24),
            const Text('Batch test', style: TextStyle(fontWeight: FontWeight.w700)),
            Row(children: [
              SizedBox(width: 320, child: TextField(controller: _endpoint, decoration: const InputDecoration(labelText: 'Endpoint', border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              SizedBox(width: 120, child: TextField(controller: _batch, decoration: const InputDecoration(labelText: 'Count', border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _runBatch, child: const Text('Run')),
            ]),
            const SizedBox(height: 8),
            Text('OK: $_ok   FAIL: $_fail'),
            const Divider(height: 24),
            const Text('Outbox', style: TextStyle(fontWeight: FontWeight.w700)),
            Row(children: [
              Text('Queued: $_queued'),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _refreshQueue, child: const Text('Refresh')),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: _flushOutbox, child: const Text('Flush')),
            ]),
            const SizedBox(height: 12),
            if (_status.isNotEmpty) SelectableText(_status),
          ]),
        ),
      ),
    );
  }

  Widget _num(String label, int v, void Function(int) onChanged) => SizedBox(
    width: 160,
    child: TextField(
      controller: TextEditingController(text: '$v'),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, border: const OutlineInputBorder()),
      onSubmitted: (s) => onChanged(int.tryParse(s.trim()) ?? v),
    ),
  );

  Widget _slider(String label, double v, void Function(double) onChanged) => Row(children: [
    SizedBox(width: 120, child: Text(label)),
    SizedBox(width: 200, child: Slider(value: v, onChanged: onChanged, min: 0, max: 1, divisions: 20)),
  ]);
}
