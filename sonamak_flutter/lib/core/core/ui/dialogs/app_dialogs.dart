import 'package:flutter/material.dart';

class AppDialogs {
  static Future<bool> confirm(BuildContext context, {required String title, required String message, String okText = 'OK', String cancelText = 'Cancel'}) async {
    final res = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(false), child: Text(cancelText)),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(true), child: Text(okText)),
        ],
      ),
    );
    return res ?? false;
  }

  static Future<String?> prompt(BuildContext context, {required String title, String? label, String? initialValue, String okText = 'OK', String cancelText = 'Cancel'}) async {
    final ctl = TextEditingController(text: initialValue ?? '');
    final res = await showDialog<String?>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: ctl,
          decoration: InputDecoration(labelText: label ?? 'Value', border: const OutlineInputBorder()),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(null), child: Text(cancelText)),
          ElevatedButton(onPressed: () => Navigator.of(ctx).pop(ctl.text), child: Text(okText)),
        ],
      ),
    );
    return res;
  }
}
