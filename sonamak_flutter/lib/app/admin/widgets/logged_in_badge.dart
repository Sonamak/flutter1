
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sonamak_flutter/data/services/auth_api.dart';

class LoggedInBadge extends StatefulWidget {
  const LoggedInBadge({super.key});
  @override
  State<LoggedInBadge> createState() => _LoggedInBadgeState();
}

class _LoggedInBadgeState extends State<LoggedInBadge> {
  String? _name, _role;

  @override
  void initState() { super.initState(); _load(); }

  Future<void> _load() async {
    try {
      final Response<Map<String, dynamic>> res = await AuthApi.me();
      dynamic body = res.data;
      if (body is String) { try { body = jsonDecode(body); } catch (_) {} }
      final Map<String, dynamic> m = (body is Map<String, dynamic>) ? body : <String, dynamic>{};
      final Map u = (m['user'] is Map) ? (m['user'] as Map) : (m['data'] is Map ? m['data'] as Map : m);
      final name = (u['name'] ?? u['username'] ?? u['full_name'] ?? u['email'])?.toString();
      final role = (u['role'] ?? (u['is_admin'] == true ? 'Admin' : null) ?? u['type'] ?? u['title'])?.toString();
      if (mounted) setState(() { _name = name; _role = role; });
    } catch (_) { if (mounted) setState(() { _name = null; _role = null; }); }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final label = [_name, if (_role != null && _role!.isNotEmpty) '($_role)'].whereType<String>().join(' ');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.account_circle_outlined, size: 18),
        const SizedBox(width: 6),
        Text(label.isEmpty ? 'User' : label, style: theme.textTheme.bodySmall),
      ],
    );
  }
}
