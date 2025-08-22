import 'package:flutter/material.dart';

typedef FilePickFn = Future<List<PickedFile>> Function();
typedef OnAttach = void Function(List<PickedFile> files);

class PickedFile {
  final String name;
  final int? sizeBytes;
  final Object handle; // opaque object from picker plugin (e.g., XFile/File)
  const PickedFile({required this.name, required this.handle, this.sizeBytes});
}

class FileAttachSheet extends StatefulWidget {
  const FileAttachSheet({super.key, required this.pickFiles, required this.onAttach, this.title = 'Attach files'});
  final FilePickFn pickFiles;
  final OnAttach onAttach;
  final String title;

  static Future<void> show(BuildContext context, {required FilePickFn pickFiles, required OnAttach onAttach, String title = 'Attach files'}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => FileAttachSheet(pickFiles: pickFiles, onAttach: onAttach, title: title),
    );
  }

  @override
  State<FileAttachSheet> createState() => _FileAttachSheetState();
}

class _FileAttachSheetState extends State<FileAttachSheet> {
  final List<PickedFile> _files = [];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(),
                IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () async {
                    final picked = await widget.pickFiles();
                    if (!mounted) return;
                    setState(() { _files.addAll(picked); });
                  },
                  icon: const Icon(Icons.file_upload),
                  label: const Text('Pick files'),
                ),
                const SizedBox(width: 12),
                if (_files.isNotEmpty)
                  ElevatedButton(
                    onPressed: () { widget.onAttach(_files); Navigator.pop(context); },
                    child: const Text('Attach'),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Flexible(
              child: _files.isEmpty
                ? const Text('No files selected')
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: _files.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (ctx, i) {
                      final f = _files[i];
                      final kb = f.sizeBytes != null ? ' • ${(f.sizeBytes!/1024).toStringAsFixed(1)} KB' : '';
                      return ListTile(
                        leading: const Icon(Icons.insert_drive_file),
                        title: Text(f.name, overflow: TextOverflow.ellipsis),
                        subtitle: Text(kb),
                        trailing: IconButton(icon: const Icon(Icons.close), onPressed: () => setState(() { _files.removeAt(i); })),
                      );
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
