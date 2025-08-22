
import 'package:flutter/material.dart';

class PatientForm extends StatefulWidget {
  const PatientForm({super.key, required this.onSubmit});
  final ValueChanged<Map<String, dynamic>> onSubmit;

  @override
  State<PatientForm> createState() => _PatientFormState();
}

class _PatientFormState extends State<PatientForm> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _age = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _age.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _age, decoration: const InputDecoration(labelText: 'Age', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {
            widget.onSubmit({
              'name': _name.text.trim(),
              'phone': _phone.text.trim(),
              'age': _age.text.trim(),
            });
          }, child: const Text('Save'))),
        ],
      ),
    );
  }
}
