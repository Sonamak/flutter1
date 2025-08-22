import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/navigation/route_hub.dart';
import 'package:sonamak_flutter/core/security/secure_storage.dart';
import 'package:sonamak_flutter/core/utils/country_codes.dart';
import 'package:sonamak_flutter/data/repositories/auth_repository.dart';
import 'package:sonamak_flutter/features/auth/controllers/login_controller.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late final LoginController controller;
  final _phone = TextEditingController();
  final _password = TextEditingController();
  String _selectedId = '1|United States';
  bool _remember = false;
  bool _obscure = true;
  bool _loadingPrefill = true;

  String _idFor(CountryCode c) => '${c.dial}|${c.name}';
  String _digitsFromId(String id) => id.split('|').first.replaceAll(RegExp(r'[^0-9]'), '');

  @override
  void initState() {
    super.initState();
    controller = LoginController(AuthRepository());
    controller.addListener(_onState);
    _loadPrefs();
  }

  Future<void> _loadPrefs() async {
    try {
      final p = await SecureStorage.read('login_phone');
      final cc = await SecureStorage.read('login_cc');
      final rm = await SecureStorage.read('login_remember');
      if (p != null && p.isNotEmpty) _phone.text = p;
      if (rm == '1') _remember = true;
      if (cc != null && cc.isNotEmpty) {
        final match = CountryCodes.all.firstWhere(
          (c) => c.dial == cc,
          orElse: () => CountryCodes.all.first,
        );
        _selectedId = _idFor(match);
      } else {
        _selectedId = _idFor(CountryCodes.all.first);
      }
    } finally {
      if (mounted) setState(() => _loadingPrefill = false);
    }
  }

  @override
  void dispose() {
    controller.removeListener(_onState);
    controller.dispose();
    _phone.dispose();
    _password.dispose();
    super.dispose();
  }

  void _onState() {
    final st = controller.state;
    if (st.error != null) {
      final msg = st.error.toString().replaceFirst('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
    }
  }

  Future<void> _submit() async {
    final phone = _phone.text.trim();
    final pw = _password.text;
    final ccDigits = _digitsFromId(_selectedId);
    if (phone.isEmpty || ccDigits.isEmpty || pw.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Phone, country code, and password are required.')));
      return;
    }
    // Optimistically save preferences even on failure so the form stays filled
    await SecureStorage.write('login_phone', phone);
    await SecureStorage.write('login_cc', ccDigits);
    await SecureStorage.write('login_remember', _remember ? '1' : '0');

    final ok = await controller.loginWithPhonePassword(
      phone: phone,
      countryCode: ccDigits,
      password: pw,
      rememberMe: _remember,
    );
    if (!mounted) return;
    if (ok) {
      RouteHub.navKey.currentState?.pushNamedAndRemoveUntil('/admin', (r) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loadingPrefill) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final st = controller.state;
          return Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _phone,
                        decoration: const InputDecoration(
                          labelText: 'Phone',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 220,
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Country',
                          border: OutlineInputBorder(),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: _selectedId,
                            items: [
                              for (final c in CountryCodes.all)
                                DropdownMenuItem(
                                  value: _idFor(c),
                                  child: Text('${c.name} (+${c.dial})', overflow: TextOverflow.ellipsis),
                                )
                            ],
                            onChanged: (v) {
                              if (v == null) return;
                              setState(() => _selectedId = v);
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _password,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscure = !_obscure),
                      tooltip: _obscure ? 'Show password' : 'Hide password',
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? false)),
                    const Text('Remember me'),
                    const Spacer(),
                    TextButton(onPressed: () => RouteHub.go('/reset-password'), child: const Text('Forgot password?')),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: st.loading ? null : _submit,
                    child: st.loading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Text('Login'),
                  ),
                ),
                const SizedBox(height: 12),
                InkWell(
                  onTap: () => RouteHub.navKey.currentState?.pushReplacementNamed('/setup'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Text('Change server URL', style: TextStyle(color: Colors.blue)),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
