
import 'package:flutter/material.dart';

class ReportsHubPage extends StatefulWidget {
  const ReportsHubPage({super.key});

  @override
  State<ReportsHubPage> createState() => _ReportsHubPageState();
}

class _ReportsHubPageState extends State<ReportsHubPage> {
  DateTimeRange? _range;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reports')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              ElevatedButton(
                onPressed: () async {
                  final now = DateTime.now();
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(now.year - 1),
                    lastDate: DateTime(now.year + 1),
                    initialDateRange: _range,
                  );
                  if (picked != null) setState(() => _range = picked);
                },
                child: const Text('Pick date range'),
              ),
              const SizedBox(width: 12),
              Text(_range == null ? 'No range selected' : '${_range!.start.toIso8601String().split("T").first} → ${_range!.end.toIso8601String().split("T").first}'),
            ]),
            const SizedBox(height: 16),
            const Text('Choose a report and export…'),
          ],
        ),
      ),
    );
  }
}
