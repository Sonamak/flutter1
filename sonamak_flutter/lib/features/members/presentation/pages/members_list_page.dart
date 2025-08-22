import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/features/members/data/members_models.dart';
import 'package:sonamak_flutter/features/members/data/members_repository.dart';

class MembersListPage extends StatefulWidget {
  const MembersListPage({super.key});

  @override
  State<MembersListPage> createState() => _MembersListPageState();
}

class _MembersListPageState extends State<MembersListPage> {
  final _repo = MembersRepository();
  List<MemberLite> _members = const [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final items = await _repo.listUsers();
    if (!mounted) return;
    setState(() {
      _members = items;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Members')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _members.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) {
            final m = _members[i];
            final phone = (m.phone ?? '');
            final role = (m.role ?? '');
            final hasPhone = phone.isNotEmpty; // ✅ null-safe
            return ListTile(
              title: Text(m.name),
              subtitle: Text(
                [
                  if (role.isNotEmpty) 'Role: $role',
                  if (hasPhone) 'Phone: $phone',
                ].join(' • '),
              ),
            );
          },
        ),
      ),
    );
  }
}
