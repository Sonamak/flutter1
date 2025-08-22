import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/desktop/paths_windows.dart';
import 'package:sonamak_flutter/core/desktop/open_in_default.dart';
import 'package:sonamak_flutter/core/desktop/windowing/windowing.dart';
import 'package:sonamak_flutter/core/exports/http_download.dart';

class DesktopQaPage extends StatefulWidget {
  const DesktopQaPage({super.key});
  @override
  State<DesktopQaPage> createState() => _DesktopQaPageState();
}

class _DesktopQaPageState extends State<DesktopQaPage> {
  final _customPath = TextEditingController(text: '/users/excel-download');
  String? _lastSavedPath;
  String _status = '';

  Future<void> _bootstrapWindowing() async {
    try {
      await Windowing.I.bootstrap(
        minWidth: 1100, minHeight: 700,
        initialWidth: 1200, initialHeight: 800,
        title: 'Sonamak — Desktop QA',
        alwaysOnTop: false,
      );
      setState(() => _status = 'Windowing bootstrap attempted (NO-OP adapter unless plugin is added).');
    } catch (e) {
      setState(() => _status = 'Windowing bootstrap error: $e');
    }
  }

  Future<void> _download(String apiPath) async {
    setState(() => _status = 'Downloading $apiPath ...');
    try {
      final r = await HttpDownload.downloadAndSave(apiPath, openAfterSave: false);
      setState(() {
        _lastSavedPath = r.path;
        _status = 'Saved to: ${r.path}';
      });
    } catch (e) {
      setState(() => _status = 'Download error: $e');
    }
  }

  Future<void> _openLast() async {
    final p = _lastSavedPath;
    if (p == null) return;
    await OpenInDefault.open(p);
  }

  Future<void> _openExportsFolder() async {
    final dir = WindowsPaths.defaultExportsDir();
    if (!dir.existsSync()) dir.createSync(recursive: true);
    await OpenInDefault.open(dir.path);
  }

  @override
  Widget build(BuildContext context) {
    final isWin = Platform.isWindows;
    return Scaffold(
      appBar: AppBar(title: const Text('Windows Desktop QA — Printing & Exports')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              _tag('Platform', isWin ? 'Windows' : 'Not Windows'),
              const SizedBox(width: 12),
              ElevatedButton(onPressed: _bootstrapWindowing, child: const Text('Bootstrap Windowing')),
            ]),
            const SizedBox(height: 16),
            const Text('Quick Export Tests (server must support these paths)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              ElevatedButton(onPressed: () => _download('/schedules/excel-download'), child: const Text('Schedules Excel')),
              ElevatedButton(onPressed: () => _download('/users/excel-download'), child: const Text('Users Excel')),
              ElevatedButton(onPressed: () => _download('/settings/backup-download'), child: const Text('Settings Backup')),
            ]),
            const SizedBox(height: 16),
            const Text('Custom Download', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Row(children: [
              Expanded(child: TextField(controller: _customPath, decoration: const InputDecoration(labelText: 'API path (e.g., /invoice/print)', border: OutlineInputBorder()))),
              const SizedBox(width: 8),
              ElevatedButton(onPressed: () => _download(_customPath.text.trim()), child: const Text('Download')),
            ]),
            const SizedBox(height: 16),
            const Divider(),
            const Text('Exports Folder', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(spacing: 8, children: [
              ElevatedButton(onPressed: _openExportsFolder, child: const Text('Open Exports Folder')),
              ElevatedButton(onPressed: _openLast, child: const Text('Open Last File')),
            ]),
            const SizedBox(height: 12),
            if (_status.isNotEmpty) SelectableText(_status),
          ]),
        ),
      ),
    );
  }

  Widget _tag(String k, String v) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.black12),
      borderRadius: BorderRadius.circular(20),
      color: Colors.black12.withValues(alpha: 0.06),
    ),
    child: Text('$k: $v'),
  );
}
