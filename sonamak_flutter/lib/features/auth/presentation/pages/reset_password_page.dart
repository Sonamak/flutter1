
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/data/services/users_api.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  final _phone = TextEditingController();
  final _country = TextEditingController(text: '20');
  final _password = TextEditingController();
  final _confirm = TextEditingController();

  @override
  void dispose() {
    _phone.dispose();
    _country.dispose();
    _password.dispose();
    _confirm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_password.text != _confirm.text) {
      AppSnackbar.showError(context, 'Passwords do not match');
      return;
    }
    final data = {
      'phone': _phone.text.trim(),
      'country_code': _country.text.trim(),
      'password': _password.text,
      'password_confirmation': _confirm.text,
    };
    await UsersApi.resetPassword(data);
    if (!mounted) return;
    AppSnackbar.showSuccess(context, 'Password updated');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Reset Password')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(children: [
                Expanded(child: TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()))),
                const SizedBox(width: 12),
                SizedBox(width: 100, child: TextField(controller: _country, decoration: const InputDecoration(labelText: 'CC', border: OutlineInputBorder()))),
              ]),
              const SizedBox(height: 12),
              TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'New password', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm password', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(onPressed: _submit, child: const Text('Save password')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
