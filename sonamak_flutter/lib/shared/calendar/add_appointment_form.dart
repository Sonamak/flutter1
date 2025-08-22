
import 'package:flutter/material.dart';

class AddAppointmentForm extends StatefulWidget {
  const AddAppointmentForm({super.key, required this.onSubmit, required this.initialDate});
  final ValueChanged<Map<String, dynamic>> onSubmit;
  final DateTime initialDate;

  @override
  State<AddAppointmentForm> createState() => _AddAppointmentFormState();
}

class _AddAppointmentFormState extends State<AddAppointmentForm> {
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _duration = TextEditingController(text: '30');
  TimeOfDay _time = const TimeOfDay(hour: 9, minute: 0);

  @override
  void dispose() {
    _name.dispose();
    _phone.dispose();
    _duration.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(context: context, initialTime: _time);
    if (t != null) setState(() => _time = t);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: _name, decoration: const InputDecoration(labelText: 'Patient name', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          TextField(controller: _phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
          const SizedBox(height: 12),
          Row(children: [
            Expanded(child: TextField(controller: _duration, decoration: const InputDecoration(labelText: 'Duration (min)', border: OutlineInputBorder()))),
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(onPressed: _pickTime, icon: const Icon(Icons.access_time), label: Text(_time.format(context))),
            ),
          ]),
          const SizedBox(height: 12),
          SizedBox(width: double.infinity, child: ElevatedButton(onPressed: () {
            final start = DateTime(widget.initialDate.year, widget.initialDate.month, widget.initialDate.day, _time.hour, _time.minute);
            final dur = int.tryParse(_duration.text.trim()) ?? 30;
            widget.onSubmit({
              'name': _name.text.trim(),
              'phone': _phone.text.trim(),
              'start': start.toIso8601String(),
              'duration': dur,
            });
          }, child: const Text('Create appointment'))),
        ],
      ),
    );
  }
}
