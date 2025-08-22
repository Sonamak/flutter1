import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/settings/data/settings_repository.dart';

class ClinicSettingsPage extends StatefulWidget {
  const ClinicSettingsPage({super.key});
  @override
  State<ClinicSettingsPage> createState() => _ClinicSettingsPageState();
}

class _ClinicSettingsPageState extends State<ClinicSettingsPage> {
  late final SettingsRepository repo;
  @override
  void initState() { super.initState(); repo = SettingsRepository(); }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Clinic settings')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final form = FormData.fromMap({'name': 'Clinic'});
              try { await repo.clinicSettingsUpdate(form: form); if (mounted) AppSnackbar.showSuccess(context, 'Saved'); }
              catch (_) { if (mounted) AppSnackbar.showError(context, 'Failed'); }
            },
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
