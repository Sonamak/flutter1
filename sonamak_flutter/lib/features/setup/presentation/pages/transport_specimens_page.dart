import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/network/envelope_inspector.dart';
import 'package:sonamak_flutter/core/network/error_normalizer.dart';

class TransportSpecimensPage extends StatefulWidget {
  const TransportSpecimensPage({super.key});

  @override
  State<TransportSpecimensPage> createState() => _TransportSpecimensPageState();
}

class _TransportSpecimensPageState extends State<TransportSpecimensPage> {
  final _endpoint = TextEditingController(text: '/settings/profile');
  String _method = 'GET';
  final _body = TextEditingController(text: '{\n  \n}');
  EnvelopeAnalysis? _analysis;
  bool _loading = false;

  final _methods = const ['GET', 'POST', 'PUT', 'DELETE', 'PATCH'];

  Future<void> _run() async {
    setState(() { _loading = true; _analysis = null; });
    try {
      final ep = _endpoint.text.trim().isEmpty ? '/' : _endpoint.text.trim();
      Response res;
      final dio = HttpClient.I;

      switch (_method) {
        case 'POST':
          res = await dio.post(ep, data: _parseBody());
          break;
        case 'PUT':
          res = await dio.put(ep, data: _parseBody());
          break;
        case 'DELETE':
          res = await dio.delete(ep, data: _parseBody());
          break;
        case 'PATCH':
          res = await dio.patch(ep, data: _parseBody());
          break;
        case 'GET':
        default:
          res = await dio.get(ep);
      }

      setState(() { _analysis = EnvelopeInspector.fromResponse(res); });
    } on DioException catch (e) {
      setState(() { _analysis = EnvelopeInspector.fromError(e); });
    } catch (e) {
      setState(() { _analysis = EnvelopeAnalysis(kind: 'other', message: e.toString()); });
    } finally {
      setState(() { _loading = false; });
    }
  }

  dynamic _parseBody() {
    final raw = _body.text.trim();
    if (raw.isEmpty) return null;
    try { return jsonDecode(raw); } catch (_) { return raw; }
  }

  @override
  Widget build(BuildContext context) {
    final a = _analysis;
    return Scaffold(
      appBar: AppBar(title: const Text('Transport Specimens & Envelope Inspector')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Preset examples', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Wrap(spacing: 8, children: [
              OutlinedButton(onPressed: _loading ? null : () { setState(() { _method = 'GET'; _endpoint.text = '/settings/profile'; }); }, child: const Text('Success (GET /settings/profile)')),
              OutlinedButton(onPressed: _loading ? null : () { setState(() { _method = 'GET'; _endpoint.text = '/me'; }); }, child: const Text('Auth (GET /me)')),
              OutlinedButton(onPressed: _loading ? null : () { setState(() { _method = 'POST'; _endpoint.text = '/patients'; _body.text = '{ }'; }); }, child: const Text('Validation (POST /patients {})')),
            ]),
            const SizedBox(height: 16),
            const Text('Custom specimen', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              DropdownButton<String>(
                value: _method,
                items: _methods.map((m) => DropdownMenuItem(value: m, child: Text(m))).toList(),
                onChanged: _loading ? null : (v) => setState(() => _method = v ?? 'GET'),
              ),
              const SizedBox(width: 12),
              Expanded(child: TextField(
                controller: _endpoint,
                decoration: const InputDecoration(labelText: 'Endpoint (e.g., /settings/profile)', border: OutlineInputBorder()),
              )),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _loading ? null : _run, child: _loading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Run')),
            ]),
            const SizedBox(height: 12),
            if (_method != 'GET') TextField(
              controller: _body,
              maxLines: 6,
              decoration: const InputDecoration(labelText: 'Body (JSON)', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 16),
            const Divider(),
            const Text('Analysis', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            if (a == null)
              const Text('No specimen run yet.')
            else ...[
              _kv('Kind', a.kind),
              _kv('Status', a.statusCode?.toString() ?? '-'),
              _kv('Content-Type', a.contentType ?? '-'),
              if (a.message != null) _kv('Message', a.message!),
              if (a.validationErrors != null) _kv('Validation', ErrorNormalizer.flattenValidation(a).join('\n')),
              if (a.payload != null) _section('Payload', _pretty(a.payload)),
              if (a.jsonBody != null) _section('JSON Body', _pretty(a.jsonBody)),
              if (a.rawBodyPreview != null) _section('Raw Preview', a.rawBodyPreview!),
            ],
          ]),
        ),
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

  String _pretty(dynamic v) {
    try { return const JsonEncoder.withIndent('  ').convert(v); } catch (_) { return v.toString(); }
  }
}
