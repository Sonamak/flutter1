
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/reports/controllers/invoice_controller.dart';
import 'package:sonamak_flutter/features/reports/data/reports_repository.dart';

class InvoicePage extends StatefulWidget {
  const InvoicePage({super.key});

  @override
  State<InvoicePage> createState() => _InvoicePageState();
}

class _InvoicePageState extends State<InvoicePage> {
  late final InvoiceController controller;
  final _id = TextEditingController();
  final _patientId = TextEditingController();
  final _createdAt = TextEditingController();
  final _invoice = TextEditingController();
  final _editKey = TextEditingController();
  final _editValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller = InvoiceController(ReportsRepository());
  }

  @override
  void dispose() {
    _id.dispose(); _patientId.dispose(); _createdAt.dispose(); _invoice.dispose(); _editKey.dispose(); _editValue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Invoice tools')),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final st = controller.state;
            return Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Load invoice data', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    SizedBox(width: 120, child: TextField(controller: _id, decoration: const InputDecoration(labelText: 'ID', border: OutlineInputBorder()))),
                    SizedBox(width: 140, child: TextField(controller: _patientId, decoration: const InputDecoration(labelText: 'Patient ID', border: OutlineInputBorder()))),
                    SizedBox(width: 180, child: TextField(controller: _createdAt, decoration: const InputDecoration(labelText: 'Created at', border: OutlineInputBorder()))),
                    SizedBox(width: 160, child: TextField(controller: _invoice, decoration: const InputDecoration(labelText: 'Invoice (opt.)', border: OutlineInputBorder()))),
                    ElevatedButton(onPressed: () async {
                      await controller.load(id: _id.text.trim(), patientId: _patientId.text.trim(), createdAt: _createdAt.text.trim().isEmpty ? null : _createdAt.text.trim(), invoice: _invoice.text.trim().isEmpty ? null : _invoice.text.trim());
                    }, child: const Text('Load'))
                  ]),
                  const SizedBox(height: 12),
                  if (st.loading) const LinearProgressIndicator(),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(border: Border.all(color: Theme.of(context).dividerColor)),
                      padding: const EdgeInsets.all(12),
                      child: SingleChildScrollView(child: Text('${st.data ?? {}}')),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Edit invoice price', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Row(children: [
                    SizedBox(width: 180, child: TextField(controller: _editKey, decoration: const InputDecoration(labelText: 'Field key', border: OutlineInputBorder()))),
                    const SizedBox(width: 8),
                    SizedBox(width: 160, child: TextField(controller: _editValue, decoration: const InputDecoration(labelText: 'Value', border: OutlineInputBorder()))),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: () async {
                      final ok = await controller.editPrice({'key': _editKey.text.trim(), 'value': _editValue.text.trim()});
                      if (!mounted) return;
                      ok ? AppSnackbar.showSuccess(context, 'Saved') : AppSnackbar.showError(context, 'Failed');
                    }, child: const Text('Save price')),
                  ]),
                  const SizedBox(height: 12),
                  Text('Print examination invoice', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ElevatedButton(onPressed: () async {
                    final ok = await controller.printExamination(params: {'id': _id.text.trim(), 'patientId': _patientId.text.trim()});
                    if (!mounted) return;
                    ok ? AppSnackbar.showSuccess(context, 'Requested') : AppSnackbar.showError(context, 'Failed');
                  }, child: const Text('Print')),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
