import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/core/network/http_client.dart';
import 'package:sonamak_flutter/core/network/interceptors.dart' show NetKeys;
import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/core/permissions/permission_service.dart';
import 'package:sonamak_flutter/core/permissions/permission_ids.dart';
import 'package:sonamak_flutter/core/permissions/action_gate.dart';
import 'package:sonamak_flutter/core/a11y/semantic_button.dart';
import 'package:sonamak_flutter/core/utils/locale_manager.dart';

class SecurityQaPage extends StatefulWidget {
  const SecurityQaPage({super.key});
  @override
  State<SecurityQaPage> createState() => _SecurityQaPageState();
}

class _SecurityQaPageState extends State<SecurityQaPage> {
  String _status = '';
  final _permInput = TextEditingController(text: '${PermissionIds.ALL_PREVLIEGE},${PermissionIds.DELETE_PATIENT}');
  String _lang = LocaleManager.current.languageCode;

  Future<void> _test401() async {
    setState(() => _status = 'Calling /me ...');
    try {
      final res = await HttpClient.I.get('/me');
      setState(() => _status = 'Status: ${res.statusCode}; Body: ${res.data.toString().substring(0, res.data.toString().length.clamp(0, 300))}');
    } on DioException catch (e) {
      final code = e.response?.statusCode;
      setState(() => _status = 'DioException: HTTP $code');
    } catch (e) {
      setState(() => _status = 'Error: $e');
    }
  }

  Future<void> _clearToken() async {
    await SecureStorage.delete(NetKeys.authTokenStorageKey);
    setState(() => _status = 'Token cleared; SessionInterceptor should redirect on next 401.');
  }

  Future<void> _setDummyToken() async {
    await SecureStorage.write(NetKeys.authTokenStorageKey, 'dummy');
    setState(() => _status = 'Dummy token written (for dev only).');
  }

  void _applyPerms() {
    final raw = _permInput.text;
    final ids = <int>[];
    for (final part in raw.split(',')) {
      final t = part.trim();
      final n = int.tryParse(t);
      if (n != null) ids.add(n);
    }
    PermissionService.setPermissions(ids);
    setState(() => _status = 'Permissions set: ${ids.join(', ')}');
  }

  void _switchLang(String code) {
    LocaleManager.set(Locale(code));
    setState(() => _lang = code);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Security / Permissions / i18n / A11y QA')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(children: [
          const Text('Auth lifecycle', style: TextStyle(fontWeight: FontWeight.w700)),
          Wrap(spacing: 8, children: [
            ElevatedButton(onPressed: _test401, child: const Text('Test 401 (GET /me)')),
            ElevatedButton(onPressed: _clearToken, child: const Text('Clear token')),
            OutlinedButton(onPressed: _setDummyToken, child: const Text('Set dummy token')),
          ]),
          const Divider(height: 24),
          const Text('Permissions', style: TextStyle(fontWeight: FontWeight.w700)),
          Row(children: [
            Expanded(child: TextField(controller: _permInput, decoration: const InputDecoration(labelText: 'IDs (comma-separated)', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: _applyPerms, child: const Text('Apply')),
          ]),
          const SizedBox(height: 8),
          const Text('ActionGate demo:'),
          Wrap(spacing: 12, children: [
            ActionGate(anyOf: const [PermissionIds.DELETE_PATIENT], child: ElevatedButton(onPressed: () {}, child: const Text('Delete patient'))),
            ActionGate(anyOf: const [PermissionIds.DELETE_PATIENT], hideIfUnauthorized: true, child: ElevatedButton(onPressed: () {}, child: const Text('Delete (hidden if unauthorized)'))),
            ActionGate(anyOf: const [PermissionIds.DELETE_QUEUE], child: OutlinedButton(onPressed: () {}, child: const Text('Delete queue'))),
          ]),
          const Divider(height: 24),
          const Text('Localization', style: TextStyle(fontWeight: FontWeight.w700)),
          Wrap(spacing: 8, children: [
            ElevatedButton(onPressed: () => _switchLang('en'), child: const Text('EN')),
            ElevatedButton(onPressed: () => _switchLang('ar'), child: const Text('AR')),
            Text('Current: $_lang'),
          ]),
          const Divider(height: 24),
          const Text('Accessibility (Semantics)', style: TextStyle(fontWeight: FontWeight.w700)),
          Wrap(spacing: 8, children: [
            SemanticButton(onPressed: () {}, child: const Text('Save'), semanticLabel: 'Save changes', semanticHint: 'Saves the current settings'),
            SemanticButton(onPressed: () {}, child: const Text('Cancel'), semanticLabel: 'Cancel', semanticHint: 'Returns without saving'),
          ]),
          const SizedBox(height: 12),
          if (_status.isNotEmpty) SelectableText(_status),
        ]),
      ),
    );
  }
}
