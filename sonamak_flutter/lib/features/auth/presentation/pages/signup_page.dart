
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/data/services/register_api.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _clinicName = TextEditingController();
  final _phone = TextEditingController();
  final _country = TextEditingController(text: '20');
  final _password = TextEditingController();
  final _confirm = TextEditingController();
  String? _plan;

  @override
  void dispose() {
    _clinicName.dispose();
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
    final form = FormData();
    form.fields.addAll([
      MapEntry('clinic_name', _clinicName.text.trim()),
      MapEntry('phone', _phone.text.trim()),
      MapEntry('country_code', _country.text.trim()),
      MapEntry('password', _password.text),
      MapEntry('password_confirmation', _confirm.text),
    ]);
    await RegisterApi.register(form);
    if (!mounted) return;
    AppSnackbar.showSuccess(context, 'Registered successfully');
    if (_plan != null) {
      await RegisterApi.choosePlan({'plan': _plan});
    }
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Sign Up')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(controller: _clinicName, decoration: const InputDecoration(labelText: 'Clinic name', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              Row(children: [
                Expanded(child: TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder()))),
                const SizedBox(width: 12),
                SizedBox(width: 100, child: TextField(controller: _country, decoration: const InputDecoration(labelText: 'CC', border: OutlineInputBorder()))),
              ]),
              const SizedBox(height: 12),
              TextField(controller: _password, obscureText: true, decoration: const InputDecoration(labelText: 'Password', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              TextField(controller: _confirm, obscureText: true, decoration: const InputDecoration(labelText: 'Confirm password', border: OutlineInputBorder())),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _plan,
                items: const [
                  DropdownMenuItem(value: 'basic', child: Text('Basic')),
                  DropdownMenuItem(value: 'pro', child: Text('Pro')),
                  DropdownMenuItem(value: 'enterprise', child: Text('Enterprise')),
                ],
                onChanged: (v) => setState(() => _plan = v),
                decoration: const InputDecoration(labelText: 'Plan', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: ElevatedButton(onPressed: _submit, child: const Text('Create account'))),
            ],
          ),
        ),
      ),
    );
  }
}
