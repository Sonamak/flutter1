import 'package:flutter/material.dart';
import 'package:sonamak_flutter/features/lab/data/lab_api.dart';
import 'package:sonamak_flutter/features/lab/data/lab_repository.dart';
import 'package:sonamak_flutter/features/lab/data/lab_models.dart';

class LabPage extends StatefulWidget {
  const LabPage({super.key});
  @override
  State<LabPage> createState() => _LabPageState();
}

class _LabPageState extends State<LabPage> {
  final _repo = LabRepository();
  bool _loading = true;
  Object? _error;
  List<LabOrderLite> _rows = const [];
  LabSection _section = LabSection.analysis;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() { _loading = true; _error = null; });
    try {
      final list = await _repo.fetch(section: _section, page: 1, perPage: 25);
      setState(() { _rows = list; _loading = false; });
    } catch (e) {
      setState(() { _error = e; _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lab'),
        actions: [
          PopupMenuButton<LabSection>(
            initialValue: _section,
            onSelected: (s) { setState(() => _section = s); _load(); },
            itemBuilder: (_) => const [
              PopupMenuItem(value: LabSection.analysis, child: Text('Laboratory')),
              PopupMenuItem(value: LabSection.scanCenter, child: Text('Scan Center')),
              PopupMenuItem(value: LabSection.dentistry, child: Text('Dentistry')),
            ],
          ),
          IconButton(onPressed: _load, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Padding(padding: const EdgeInsets.all(16), child: SelectableText('Error: ${_error}')))
              : _rows.isEmpty
                  ? const Center(child: Text('No lab orders'))
                  : ListView.separated(
                      padding: const EdgeInsets.all(12),
                      itemCount: _rows.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, i) {
                        final r = _rows[i];
                        return ListTile(
                          title: Text(r.patientName),
                          subtitle: Text('${r.status} — ${r.createdAt ?? '-'}'),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (r.total != null) Text('Total: ${r.total}'),
                              if (r.rest != null) Text('Rest: ${r.rest}'),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}