import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/offline/fs_db.dart';
import 'package:sonamak_flutter/core/offline/outbox.dart';

class SyncCenterPage extends StatefulWidget {
  const SyncCenterPage({super.key});

  @override
  State<SyncCenterPage> createState() => _SyncCenterPageState();
}

class _SyncCenterPageState extends State<SyncCenterPage> {
  late FsDb _db;
  List<OutboxEntry> _outbox = const [];
  bool _loading = false;
  String? _message;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _db = await FsDb.open();
    await _refresh();
  }

  Future<void> _refresh() async {
    final outbox = await Outbox(_db).list();
    setState(() => _outbox = outbox);
  }

  Future<void> _process() async {
    setState(() { _loading = true; _message = null; });
    try {
      await Outbox(_db).processAll();
      await _refresh();
      setState(() { _message = 'Sync completed'; });
    } catch (e) {
      setState(() { _message = 'Sync error: $e'; });
    } finally {
      setState(() { _loading = false; });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sync Center')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: _loading ? null : _process,
                  icon: const Icon(Icons.sync),
                  label: const Text('Sync now'),
                ),
                const SizedBox(width: 12),
                Text('Outbox: ${_outbox.length}'),
              ],
            ),
            if (_message != null) Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(_message!, style: const TextStyle(color: Colors.blue)),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.separated(
                itemCount: _outbox.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final e = _outbox[i];
                  return ListTile(
                    leading: CircleAvatar(child: Text('${e.id}')),
                    title: Text('${e.method} ${e.endpoint}'),
                    subtitle: Text('Attempts: ${e.attempts} • Created: ${e.createdAt.toIso8601String()}'),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
