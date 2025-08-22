import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/parity/json_normalizer.dart';
import 'package:sonamak_flutter/core/parity/json_diff.dart';

class ParityLabPage extends StatefulWidget { const ParityLabPage({super.key}); @override State<ParityLabPage> createState() => _ParityLabPageState(); }
class _ParityLabPageState extends State<ParityLabPage> {
  final _traceText = TextEditingController(text: '[\n  {\n    "method":"GET", "path":"/settings/profile", "expected": {"payload": {"ok": true}}, "status": 200\n  }\n]');
  bool _unwrapExpected = true; bool _unwrapActual = true; String _status = ''; List<_CaseResult> _results = [];
  Future<void> _run() async {
    setState(() { _status = 'Running...'; _results = []; });
    List<dynamic> items;
    try { items = jsonDecode(_traceText.text) as List<dynamic>; } catch (e) { setState(() { _status = 'Trace JSON parse error: $e'; }); return; }
    final out = <_CaseResult>[];
    for (final raw in items) {
      final it = raw as Map<String, dynamic>;
      final method = (it['method'] ?? 'GET').toString().toUpperCase();
      final path = (it['path'] ?? '/').toString();
      final body = it['body'];
      final expected = it['expected'];
      final exp = _unwrapExpected ? JsonNormalizer.unwrapPayload(expected) : expected;
      dynamic actualBody; int? code;
      try {
        Response res;
        switch (method) {
          case 'POST': res = await HttpClient.I.post(path, data: body); break;
          case 'PUT': res = await HttpClient.I.put(path, data: body); break;
          case 'DELETE': res = await HttpClient.I.delete(path, data: body); break;
          case 'PATCH': res = await HttpClient.I.patch(path, data: body); break;
          case 'GET': default: res = await HttpClient.I.get(path);
        }
        code = res.statusCode; actualBody = res.data;
      } on DioException catch (e) { code = e.response?.statusCode; actualBody = e.response?.data ?? {'error': e.message}; }
      final act = _unwrapActual ? JsonNormalizer.unwrapPayload(actualBody) : actualBody;
      final diffs = JsonDiff.compare(exp, act);
      out.add(_CaseResult(method, path, code, exp, act, diffs));
      setState(() { _results = List.of(out); _status = 'Completed ${out.length}/${items.length}'; });
    }
  }
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Parity Lab — Trace Replay & JSON Diff')),
      body: Padding(padding: const EdgeInsets.all(16), child: Column(children: [
        Row(children: [ Expanded(child: TextField(controller: _traceText, maxLines: 8, decoration: const InputDecoration(labelText: 'Paste React trace JSON here', border: OutlineInputBorder()))), ]),
        const SizedBox(height: 8),
        Row(children: [
          Checkbox(value: _unwrapExpected, onChanged: (v) => setState(() => _unwrapExpected = v ?? true)), const Text('Unwrap expected payload'),
          const SizedBox(width: 12),
          Checkbox(value: _unwrapActual, onChanged: (v) => setState(() => _unwrapActual = v ?? true)), const Text('Unwrap actual payload'),
          const Spacer(), ElevatedButton(onPressed: _run, child: const Text('Run Replay + Diff')),
        ]),
        const SizedBox(height: 8), Align(alignment: Alignment.centerLeft, child: Text(_status)), const SizedBox(height: 8),
        Expanded(child: ListView.builder(itemCount: _results.length, itemBuilder: (_, i) {
          final r = _results[i]; final ok = r.diffs.isEmpty;
          return Card(child: Padding(padding: const EdgeInsets.all(12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('${r.method} ${r.path}', style: const TextStyle(fontWeight: FontWeight.w700)),
            Text('HTTP: ${r.code ?? '-'}   Result: ${ok ? 'OK' : 'DIFFS'}'),
            if (!ok) ...[ const SizedBox(height: 6), const Text('Diffs:', style: TextStyle(fontWeight: FontWeight.w600)),
              for (final d in r.diffs.take(20)) Text('• ${d.path}: ${d.message}'),
              if (r.diffs.length > 20) Text('(+${r.diffs.length - 20} more)'),
              const SizedBox(height: 6),
              ExpansionTile(title: const Text('Expected (normalized)'), children: [SelectableText(JsonNormalizer.canonicalString(r.expected))]),
              ExpansionTile(title: const Text('Actual (normalized)'), children: [SelectableText(JsonNormalizer.canonicalString(r.actual))]),
            ],
          ])));
        }))
      ])),
    );
  }
}
class _CaseResult { final String method; final String path; final int? code; final dynamic expected; final dynamic actual; final List<JsonDiffEntry> diffs; _CaseResult(this.method, this.path, this.code, this.expected, this.actual, this.diffs); }
