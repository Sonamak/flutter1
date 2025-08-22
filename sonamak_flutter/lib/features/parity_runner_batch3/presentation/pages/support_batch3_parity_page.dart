import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/network/envelope_inspector.dart';
import 'package:sonamak_flutter/core/network/error_normalizer.dart';

class EndpointSpec { final String method; final String path; const EndpointSpec({required this.method, required this.path}); }

class SupportBatch3ParityPage extends StatefulWidget { const SupportBatch3ParityPage({super.key}); @override State<SupportBatch3ParityPage> createState() => _SupportBatch3ParityPageState(); }

class _SupportBatch3ParityPageState extends State<SupportBatch3ParityPage> {
  final _body = TextEditingController(text: '{}');
  EndpointSpec? _selected;
  EnvelopeAnalysis? _analysis;
  bool _loading = false;

  static final specs = <EndpointSpec>[
  // No endpoints auto-detected
  ];

  Future<void> _run() async {
    final sel = _selected;
    if (sel == null) return;
    setState(() => _loading = true);
    try {
      Response res;
      final dio = HttpClient.I;
      switch (sel.method) {
        case 'POST': res = await dio.post(sel.path, data: _parse()); break;
        case 'PUT': res = await dio.put(sel.path, data: _parse()); break;
        case 'DELETE': res = await dio.delete(sel.path, data: _parse()); break;
        case 'PATCH': res = await dio.patch(sel.path, data: _parse()); break;
        case 'GET':
        default: res = await dio.get(sel.path);
      }
      setState(() => _analysis = EnvelopeInspector.fromResponse(res));
    } on DioException catch (e) {
      setState(() => _analysis = EnvelopeInspector.fromError(e));
    } catch (e) {
      setState(() => _analysis = EnvelopeAnalysis(kind: 'other', message: e.toString()));
    } finally {
      setState(() => _loading = false);
    }
  }

  dynamic _parse() {
    final raw = _body.text.trim();
    if (raw.isEmpty) return null;
    try { return jsonDecode(raw); } catch (_) { return raw; }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Support — Parity Runner')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            width: 420,
            child: DropdownButtonFormField<EndpointSpec>(
              items: specs.map((s) => DropdownMenuItem(value: s, child: Text('${s.method}  ${s.path}'))).toList(),
              onChanged: (v) => setState(() => _selected = v),
              decoration: const InputDecoration(labelText: 'Endpoint (from React usage)', border: OutlineInputBorder()),
            ),
          ),
          const SizedBox(height: 12),
          if (_selected != null && _selected!.method != 'GET') TextField(
            controller: _body, maxLines: 6,
            decoration: const InputDecoration(labelText: 'Body (JSON or text)', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 160,
            child: ElevatedButton(onPressed: _loading ? null : _run, child: _loading
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Text('Run')),
          ),
          const SizedBox(height: 16),
          const Divider(),
          const Text('Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: _analysis == null
                ? const Text('Choose an endpoint and Run. (Expect 401 for protected routes until logged in.)')
                : _renderAnalysis(_analysis!),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _kv(String k, String v) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 2),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(width: 150, child: Text(k, style: const TextStyle(fontWeight: FontWeight.w600))),
      const SizedBox(width: 8),
      Expanded(child: SelectableText(v)),
    ]),
  );

  Widget _section(String title, String content) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 6),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
      const SizedBox(height: 4),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black12),
          borderRadius: BorderRadius.circular(8),
          color: Colors.black12.withValues(alpha: 0.03),
        ),
        child: SelectableText(content),
      ),
    ]),
  );

  Widget _renderAnalysis(EnvelopeAnalysis a) {
    final validations = ErrorNormalizer.flattenValidation(a);
    final hasVal = validations.isNotEmpty;
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _kv('Kind', a.kind),
      _kv('Status', a.statusCode?.toString() ?? '-'),
      _kv('Content-Type', a.contentType ?? '-'),
      if (a.message != null) _kv('Message', a.message!),
      if (hasVal) _section('Validation', validations.join('\n')),
      if (a.payload != null) _section('Payload', _pretty(a.payload)),
      if (a.jsonBody != null) _section('JSON Body', _pretty(a.jsonBody)),
      if (a.rawBodyPreview != null) _section('Raw Preview', _pretty(a.rawBodyPreview)),
    ]);
  }

  String _pretty(dynamic v) {
    try { return const JsonEncoder.withIndent('  ').convert(v); } catch (_) { return v.toString(); }
  }
}
