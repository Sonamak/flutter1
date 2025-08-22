import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/settings/data/settings_repository.dart';

class ProfileSettingsPage extends StatefulWidget {
  const ProfileSettingsPage({super.key});
  @override
  State<ProfileSettingsPage> createState() => _ProfileSettingsPageState();
}

class _ProfileSettingsPageState extends State<ProfileSettingsPage> {
  late final SettingsRepository repo;
  @override
  void initState() { super.initState(); repo = SettingsRepository(); }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Profile')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final form = FormData.fromMap({'name': 'User'});
              try { await repo.profileSettingsUpdate(form: form); if (mounted) AppSnackbar.showSuccess(context, 'Saved'); }
              catch (_) { if (mounted) AppSnackbar.showError(context, 'Failed'); }
            },
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
