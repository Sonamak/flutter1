import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/uat/uat_flags.dart';
import 'package:sonamak_flutter/core/uat/uat_session_interceptor.dart';

class UatCenterPage extends StatefulWidget {
  const UatCenterPage({super.key});
  @override
  State<UatCenterPage> createState() => _UatCenterPageState();
}

class _UatCenterPageState extends State<UatCenterPage> {
  final _session = TextEditingController();
  final _status = ValueNotifier<String>('');

  UatSessionInterceptor? _interceptor;

  @override
  void initState() {
    super.initState();
    UatFlags.load();
    _session.text = UatFlags.sessionId.value ?? '';
  }

  void _attachHeader() {
    final dio = HttpClient.I;
    _interceptor ??= UatSessionInterceptor();
    if (!dio.interceptors.contains(_interceptor)) {
      dio.interceptors.add(_interceptor!);
    }
    _status.value = 'X-UAT-Session header will be added to outgoing requests.';
  }

  void _detachHeader() {
    final dio = HttpClient.I;
    if (_interceptor != null) {
      dio.interceptors.remove(_interceptor);
    }
    _status.value = 'X-UAT-Session header detached.';
  }

  void _nav(String path) {
    Navigator.of(context).pushNamed(path);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('UAT Center — Cut-over Controls')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          const Text('UAT Mode', style: TextStyle(fontWeight: FontWeight.w700)),
          ValueListenableBuilder<bool>(
            valueListenable: UatFlags.enabled,
            builder: (_, on, __) => Row(children: [
              Switch(value: on, onChanged: (v) => UatFlags.setEnabled(v)),
              Text(on ? 'Enabled' : 'Disabled'),
            ]),
          ),
          const SizedBox(height: 12),
          const Text('UAT Session ID (for server-side correlation)', style: TextStyle(fontWeight: FontWeight.w700)),
          Row(children: [
            Expanded(child: TextField(controller: _session, decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'e.g., UAT-2025-08-TenantA'), onChanged: (s) => UatFlags.setSessionId(s))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _attachHeader, child: const Text('Attach header')),
            const SizedBox(width: 8),
            OutlinedButton(onPressed: _detachHeader, child: const Text('Detach')),
          ]),
          const SizedBox(height: 8),
          ValueListenableBuilder<String>(valueListenable: _status, builder: (_, s, __) => Text(s)),
          const Divider(height: 24),
          const Text('Diagnostics & Harnesses', style: TextStyle(fontWeight: FontWeight.w700)),
          Wrap(spacing: 8, runSpacing: 8, children: [
            OutlinedButton(onPressed: () => _nav('/setup/diagnostics'), child: const Text('Connection Diagnostics')),
            OutlinedButton(onPressed: () => _nav('/setup/specimens'), child: const Text('Transport Specimens')),
            OutlinedButton(onPressed: () => _nav('/parity/lab'), child: const Text('Parity Lab')),
            OutlinedButton(onPressed: () => _nav('/desktop/qa'), child: const Text('Windows QA')),
            OutlinedButton(onPressed: () => _nav('/mobile/qa'), child: const Text('Mobile QA')),
            OutlinedButton(onPressed: () => _nav('/reliability/qa'), child: const Text('Reliability QA')),
            OutlinedButton(onPressed: () => _nav('/security/qa'), child: const Text('Security/Permissions QA')),
            OutlinedButton(onPressed: () => _nav('/i18n-a11y/qa'), child: const Text('i18n & A11y QA')),
          ]),
          const Divider(height: 24),
          const Text('Cut-over helper notes', style: TextStyle(fontWeight: FontWeight.w700)),
          const Text('• Enable UAT Mode to show a banner globally (add UatBanner to your app shell).'),
          const Text('• Set a UAT Session ID and click Attach header — backend logs will capture X-UAT-Session.'),
          const Text('• Use the diagnostics above to validate parity and performance before switching tenants.'),
        ]),
      ),
    );
  }
}
