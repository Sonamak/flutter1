import 'package:flutter/material.dart';
import 'package:sonamak_flutter/features/setup/data/connection_diagnostics_service.dart';
import 'package:sonamak_flutter/features/setup/presentation/widgets/kv_row.dart';

class ConnectionDiagnosticsPage extends StatefulWidget {
  const ConnectionDiagnosticsPage({super.key});

  @override
  State<ConnectionDiagnosticsPage> createState() => _ConnectionDiagnosticsPageState();
}

class _ConnectionDiagnosticsPageState extends State<ConnectionDiagnosticsPage> {
  final _endpoint = TextEditingController(text: '/settings/profile');
  ConnectionDiagnosticsResult? _snap;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _snap = ConnectionDiagnosticsService.snapshot(pingEndpoint: _endpoint.text.trim());
  }

  Future<void> _runPing() async {
    final ep = _endpoint.text.trim().isEmpty ? '/' : _endpoint.text.trim();
    setState(() => _loading = true);
    try {
      final res = await ConnectionDiagnosticsService.ping(ep);
      setState(() => _snap = res);
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final s = _snap;
    return Scaffold(
      appBar: AppBar(title: const Text('Connection Diagnostics')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Active configuration', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            if (s != null) ...[
              KvRow(label: 'Base URL', value: s.baseUrl, mono: true),
              KvRow(label: 'Origin', value: s.origin, mono: true),
              KvRow(label: 'Host', value: s.host, mono: true),
              KvRow(label: 'AES (host-gated)', value: s.aesEnabled ? 'ON (sonamak host)' : 'OFF', mono: false),
              KvRow(label: 'X-localization', value: s.localizationHeader, mono: true),
            ],
            const Divider(height: 32),
            const Text('Ping endpoint', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            TextField(
              controller: _endpoint,
              decoration: const InputDecoration(
                labelText: 'Endpoint (e.g., /settings/profile)',
                hintText: '/settings/profile',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (_) => _runPing(),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _loading ? null : _runPing,
                child: _loading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                    : const Text('Ping'),
              ),
            ),
            const SizedBox(height: 16),
            if (s != null) ...[
              const Text('Ping result', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 8),
              Wrap(spacing: 24, runSpacing: 12, children: [
                Text('Status: ${s.statusCode ?? '-'}', style: const TextStyle(fontWeight: FontWeight.w600)),
                Text('Endpoint: ${s.pingEndpoint ?? '-'}'),
              ]),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.black12.withValues(alpha: 0.03),
                ),
                constraints: const BoxConstraints(minHeight: 120),
                child: SelectableText(s.responsePreview ?? s.errorMessage ?? 'No content'),
              ),
            ],
          ]),
        ),
      ),
    );
  }
}
