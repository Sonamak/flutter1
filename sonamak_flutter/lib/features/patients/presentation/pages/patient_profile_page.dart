
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/patients/controllers/patient_profile_controller.dart';
import 'package:sonamak_flutter/features/patients/data/patient_repository.dart';

class PatientProfilePage extends StatefulWidget {
  const PatientProfilePage({super.key, this.initialPatientId});
  final int? initialPatientId;

  @override
  State<PatientProfilePage> createState() => _PatientProfilePageState();
}

class _PatientProfilePageState extends State<PatientProfilePage> {
  late final PatientProfileController controller;
  final _idCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = PatientProfileController(PatientRepository());
    if (widget.initialPatientId != null) {
      _idCtrl.text = widget.initialPatientId.toString();
      controller.load(widget.initialPatientId!);
    }
  }

  @override
  void dispose() {
    _idCtrl.dispose();
    super.dispose();
  }

  Future<void> _load() async {
    final id = int.tryParse(_idCtrl.text.trim());
    if (id == null) return;
    await controller.load(id);
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Patient profile')),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final st = controller.state;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    SizedBox(width: 200, child: TextField(controller: _idCtrl, decoration: const InputDecoration(labelText: 'Patient ID', border: OutlineInputBorder()))),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: _load, child: const Text('Load')),
                  ]),
                  const SizedBox(height: 16),
                  if (st.loading) const LinearProgressIndicator(),
                  if (st.profile != null) ...[
                    Text('Name: ${st.profile!.name}', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 4),
                    Text('Phone: ${st.profile!.phone}'),
                    const SizedBox(height: 12),
                    Text('Examinations: ${st.examinations.length}'),
                    const SizedBox(height: 16),
                    Row(children: [
                      ElevatedButton.icon(onPressed: () {
                        AppSnackbar.showInfo(context, 'Edit UI can be expanded in later phases');
                      }, icon: const Icon(Icons.edit_outlined), label: const Text('Edit info')),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(onPressed: () => AppSnackbar.showInfo(context, 'Upload photo not implemented in this phase'), icon: const Icon(Icons.image_outlined), label: const Text('Upload photo')),
                    ]),
                  ] else if (!st.loading) const Text('No patient loaded'),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
