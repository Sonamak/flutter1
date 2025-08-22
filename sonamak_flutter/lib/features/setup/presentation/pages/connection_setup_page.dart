import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/core/utils/locale_manager.dart';
import 'package:sonamak_flutter/core/utils/server_config.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';

class ConnectionSetupPage extends StatefulWidget {
  const ConnectionSetupPage({super.key});

  @override
  State<ConnectionSetupPage> createState() => _ConnectionSetupPageState();
}

class _ConnectionSetupPageState extends State<ConnectionSetupPage> {
  final _subdomainOrUrl = TextEditingController();
  String _lang = LocaleManager.current.languageCode;
  bool _loading = true;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _prefill();
  }

  Future<void> _prefill() async {
    try {
      final sub = ServerConfig.subdomain ?? '';
      final origin = ServerConfig.origin;
      final prefill = sub.isNotEmpty ? sub : (origin.isNotEmpty ? origin : '');
      if (prefill.isNotEmpty) _subdomainOrUrl.text = prefill;
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  void dispose() {
    _subdomainOrUrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final raw = _subdomainOrUrl.text.trim();
    if (raw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a subdomain or full URL.')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ServerConfig.applyFromInput(raw);
      // persist language
      LocaleManager.set(Locale(_lang));
      await SecureStorage.write('locale_code', _lang);
      // Clear token because base URL changed; force re-login to new server
      await SecureStorage.delete('auth_token');

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved. Please log in to the selected server.')));
      RouteHub.navKey.currentState?.pushNamedAndRemoveUntil('/login', (r) => false);
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Directionality(textDirection: TextDirection.ltr, child: Center(child: CircularProgressIndicator()));
    }
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(title: const Text('Connection Setup')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Clinic Subdomain or Full URL'),
            const SizedBox(height: 6),
            TextField(
              controller: _subdomainOrUrl,
              decoration: const InputDecoration(border: OutlineInputBorder(), hintText: 'clinic  OR  https://clinic.sonamak.net'),
            ),
            const SizedBox(height: 16),
            Row(children: [
              const Text('Language:'),
              const SizedBox(width: 12),
              DropdownButton<String>(
                value: _lang,
                onChanged: (v) => setState(() => _lang = v ?? 'en'),
                items: const [
                  DropdownMenuItem(value: 'en', child: Text('English')),
                  DropdownMenuItem(value: 'ar', child: Text('Arabic')),
                  DropdownMenuItem(value: 'tr', child: Text('Turkish')),
                  DropdownMenuItem(value: 'es', child: Text('Spanish')),
                ],
              ),
            ]),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _save,
                child: _saving ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Save'),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
