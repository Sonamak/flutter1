import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/settings/data/settings_repository.dart';

class TeamSettingsPage extends StatefulWidget {
  const TeamSettingsPage({super.key});
  @override
  State<TeamSettingsPage> createState() => _TeamSettingsPageState();
}

class _TeamSettingsPageState extends State<TeamSettingsPage> {
  late final SettingsRepository repo;
  @override
  void initState() { super.initState(); repo = SettingsRepository(); }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Team')),
        body: Center(
          child: ElevatedButton(
            onPressed: () async {
              final form = FormData.fromMap({'team': 'A'});
              try { await repo.teamSettingsUpdate(form: form); if (mounted) AppSnackbar.showSuccess(context, 'Saved'); }
              catch (_) { if (mounted) AppSnackbar.showError(context, 'Failed'); }
            },
            child: const Text('Save'),
          ),
        ),
      ),
    );
  }
}
