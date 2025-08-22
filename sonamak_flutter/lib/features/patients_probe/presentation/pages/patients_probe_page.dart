import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';

class PatientsProbePage extends StatefulWidget {
  const PatientsProbePage({super.key});
  @override State<PatientsProbePage> createState() => _PatientsProbePageState();
}

class _PatientsProbePageState extends State<PatientsProbePage> {
  String _status = 'Idle';
  String _body = '';
  Future<void> _probe() async {
    setState(() { _status = 'Fetching /patients?per_page=25&page=1 ...'; _body = ''; });
    try {
      final res = await HttpClient.I.get('/patients', queryParameters: {'per_page': 25, 'page': 1});
      final data = res.data;
      int? count;
      if (data is Map && data['payload'] is Map && data['payload']['data'] is List) {
        count = (data['payload']['data'] as List).length;
      } else if (data is Map && data['data'] is List) {
        count = (data['data'] as List).length;
      } else if (data is List) {
        count = data.length;
      }
      setState(() {
        _status = 'HTTP ${res.statusCode}; rows: ${count ?? '-'}';
        _body = const JsonEncoder.withIndent('  ').convert(data);
      });
    } on DioException catch (e) {
      setState(() { _status = 'DioException: ${e.response?.statusCode ?? '-'} ${e.message}'; _body = '${e.response?.data ?? ''}'; });
    } catch (e) {
      setState(() { _status = 'Error: $e'; _body = ''; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patients Probe')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          ElevatedButton(onPressed: _probe, child: const Text('Fetch /patients?per_page=25&page=1')),
          const SizedBox(height: 8),
          Text(_status, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Expanded(child: SingleChildScrollView(child: SelectableText(_body.isEmpty ? '(no body)' : _body))),
        ]),
      ),
    );
  }
}