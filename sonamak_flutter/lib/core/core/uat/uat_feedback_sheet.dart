import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/uat/feedback_reporter.dart';

/// Bottom sheet to capture UAT feedback with required fields.
class UATFeedbackSheet extends StatefulWidget {
  const UATFeedbackSheet({super.key, required this.onSubmit});
  final void Function(UATFeedback) onSubmit;

  static Future<void> show(BuildContext context, void Function(UATFeedback) onSubmit) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: UATFeedbackSheet(onSubmit: onSubmit),
      ),
    );
  }

  @override
  State<UATFeedbackSheet> createState() => _UATFeedbackSheetState();
}

class _UATFeedbackSheetState extends State<UATFeedbackSheet> {
  final _form = GlobalKey<FormState>();
  final _module = TextEditingController();
  final _summary = TextEditingController();
  final _steps = TextEditingController();
  final _expected = TextEditingController();
  final _actual = TextEditingController();
  String _severity = 'medium';
  bool _attachLogs = true;

  @override
  void dispose() {
    _module.dispose();
    _summary.dispose();
    _steps.dispose();
    _expected.dispose();
    _actual.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Text('UAT Feedback', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const Spacer(),
                  IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                ],
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _module,
                decoration: const InputDecoration(labelText: 'Module (e.g., finance, calendar)', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              DropdownButtonFormField<String>(
                value: _severity,
                items: const [
                  DropdownMenuItem(value: 'low', child: Text('Low')),
                  DropdownMenuItem(value: 'medium', child: Text('Medium')),
                  DropdownMenuItem(value: 'high', child: Text('High')),
                  DropdownMenuItem(value: 'critical', child: Text('Critical')),
                ],
                onChanged: (v) => setState(() => _severity = v ?? 'medium'),
                decoration: const InputDecoration(labelText: 'Severity', border: OutlineInputBorder()),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _summary,
                decoration: const InputDecoration(labelText: 'Summary (short title)', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _steps,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Steps to reproduce', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _expected,
                maxLines: 2,
                decoration: const InputDecoration(labelText: 'Expected behavior', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _actual,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Actual behavior', border: OutlineInputBorder()),
                validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 8),
              SwitchListTile(
                value: _attachLogs,
                onChanged: (v) => setState(() => _attachLogs = v),
                title: const Text('Attach recent logs (sanitized)'),
              ),
              const SizedBox(height: 12),
              ElevatedButton.icon(
                onPressed: () {
                  if (!_form.currentState!.validate()) return;
                  final fb = UATFeedback(
                    module: _module.text.trim(),
                    severity: _severity,
                    summary: _summary.text.trim(),
                    steps: _steps.text.trim(),
                    expected: _expected.text.trim(),
                    actual: _actual.text.trim(),
                    extra: <String, dynamic>{},
                    attachRecentLogs: _attachLogs,
                  );
                  widget.onSubmit(fb);
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.send),
                label: const Text('Submit'),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
