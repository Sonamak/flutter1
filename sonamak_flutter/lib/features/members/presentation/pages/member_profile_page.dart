import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/features/members/data/members_models.dart';
import 'package:sonamak_flutter/features/members/data/members_repository.dart';

class MemberProfilePage extends StatefulWidget {
  /// Made optional to avoid requiring an argument at route registration time.
  final int? memberId;
  const MemberProfilePage({super.key, this.memberId});

  @override
  State<MemberProfilePage> createState() => _MemberProfilePageState();
}

class _MemberProfilePageState extends State<MemberProfilePage> {
  final _repo = MembersRepository();
  MemberDetail? _detail;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final id = widget.memberId;
    if (id == null) return; // No id provided yet; UI shows placeholders.
    setState(() => _loading = true);
    final d = await _repo.getUser(id);
    if (!mounted) return;
    setState(() {
      _detail = d;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final d = _detail;
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: Text(d?.name ?? 'Member')),
        body: _loading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Name: ${d?.name ?? ''}'),
              const SizedBox(height: 8),
              Text('Email: ${d?.email ?? ''}'),
              const SizedBox(height: 8),
              Text('Phone: ${d?.phone ?? ''}'),
              const SizedBox(height: 8),
              Text('Role: ${d?.role ?? ''}'),
            ],
          ),
        ),
      ),
    );
  }
}
