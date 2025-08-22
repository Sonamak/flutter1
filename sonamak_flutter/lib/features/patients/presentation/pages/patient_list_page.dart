
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/app/admin/widgets/admin_top_nav.dart';
import 'package:sonamak_flutter/features/patients/data/patient_models.dart';
import 'package:sonamak_flutter/features/patients/data/patient_repository.dart';
import 'package:sonamak_flutter/features/setup/branches/branch_selector.dart';
import 'package:sonamak_flutter/features/setup/branches/server_branch_source.dart';

class PatientListPage extends StatefulWidget {
  const PatientListPage({super.key});

  @override
  State<PatientListPage> createState() => _PatientListPageState();
}

class _PatientListPageState extends State<PatientListPage> {
  final _repo = PatientRepository();
  final _search = TextEditingController();
  List<PatientLite> _patients = const [];
  PatientProfile? _selectedProfile;
  List<Map<String, dynamic>> _exams = const [];
  bool _loadingList = false;
  bool _loadingProfile = false;
  int? _branchId;

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    setState(() => _loadingList = true);
    try {
      final term = _search.text.trim();
      _patients = term.isEmpty
          ? await _repo.listAllAllPages(branchId: _branchId, perPage: 200)
          : await _repo.searchAllPages(term, branchId: _branchId, perPage: 200);
      if (_patients.isNotEmpty && _selectedProfile == null) {
        await _select(_patients.first.id);
      } else if (_patients.isEmpty) {
        _selectedProfile = null; _exams = const [];
      }
    } finally {
      if (mounted) setState(() => _loadingList = false);
    }
  }

  Future<void> _select(int id) async {
    setState(() => _loadingProfile = true);
    try {
      final p = await _repo.getProfile(id);
      final exams = await _repo.examinations(id);
      if (mounted) setState(() { _selectedProfile = p; _exams = exams; });
    } finally {
      if (mounted) setState(() => _loadingProfile = false);
    }
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Patients')),
        body: Column(
          children: [
            const AdminTopNav(active: 'Patients'),
            // Branch selector row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  BranchSelector(
                    dataSource: ServerBranchSource(),
                    onChanged: (br) async {
                      final id = int.tryParse(br?.id ?? '');
                      if (_branchId != id) {
                        setState(() => _branchId = id);
                        await _loadList();
                      }
                    },
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    width: 320,
                    child: TextField(
                      controller: _search,
                      onSubmitted: (_) => _loadList(),
                      decoration: const InputDecoration(
                        hintText: 'Search by Name',
                        prefixIcon: Icon(Icons.search),
                        isDense: true,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(onPressed: _loadList, icon: const Icon(Icons.tune), label: const Text('Filter')),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Row(
                children: [
                  // Left pane — Patients list
                  SizedBox(
                    width: 360,
                    child: _loadingList
                        ? const Center(child: CircularProgressIndicator())
                        : ListView.separated(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _patients.length,
                            separatorBuilder: (_, __) => const Divider(height: 1),
                            itemBuilder: (context, i) {
                              final p = _patients[i];
                              final selected = _selectedProfile?.id == p.id;
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                                leading: CircleAvatar(child: Text(p.name.isNotEmpty ? p.name.characters.first.toUpperCase() : '?')),
                                title: Text(p.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                                subtitle: Text(p.phone ?? '', maxLines: 1, overflow: TextOverflow.ellipsis),
                                trailing: IconButton(icon: const Icon(Icons.chevron_right), onPressed: () => _select(p.id)),
                                selected: selected,
                                onTap: () => _select(p.id),
                              );
                            },
                          ),
                  ),
                  const VerticalDivider(width: 1),
                  // Right pane — Patient profile
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: _loadingProfile
                          ? const Center(child: CircularProgressIndicator())
                          : _selectedProfile == null
                              ? const Center(child: Text('Select a patient from the list'))
                              : _ProfilePanel(profile: _selectedProfile!, examinations: _exams),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.person_add_alt),
          label: const Text('Add New Patient'),
        ),
      ),
    );
  }
}

class _ProfilePanel extends StatelessWidget {
  const _ProfilePanel({required this.profile, required this.examinations});
  final PatientProfile profile;
  final List<Map<String, dynamic>> examinations;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Row(
              children: [
                CircleAvatar(radius: 28, child: Text(profile.name.isNotEmpty ? profile.name.characters.first.toUpperCase() : '?')),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(profile.name, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Wrap(spacing: 20, runSpacing: 8, children: [
                        Row(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.flag, size: 16), const SizedBox(width: 6), Text(profile.phone ?? '—')]),
                        Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.email_outlined, size: 16), SizedBox(width: 6), Text('No email')]),
                        Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.cake_outlined, size: 16), SizedBox(width: 6), Text('No Date of Birth')]),
                        Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.accessibility_new_outlined, size: 16), SizedBox(width: 6), Text('No Age')]),
                        Row(mainAxisSize: MainAxisSize.min, children: const [Icon(Icons.bloodtype_outlined, size: 16), SizedBox(width: 6), Text('Blood Type: No Type')]),
                      ]),
                    ],
                  ),
                ),
                TextButton.icon(onPressed: () {}, icon: const Icon(Icons.delete_outline, color: Colors.red), label: const Text('Delete', style: TextStyle(color: Colors.red))),
                const SizedBox(width: 8),
                OutlinedButton(onPressed: () {}, child: const Text('View Profile')),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Examinations section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.dividerColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Examinations', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 12),
                if (examinations.isEmpty)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.insert_drive_file_outlined, size: 48, color: theme.disabledColor),
                      const SizedBox(height: 8),
                      Text('No Data', style: theme.textTheme.bodySmall?.copyWith(color: theme.disabledColor)),
                    ],
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: examinations.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final m = examinations[i];
                      final date = (m['date'] ?? m['created_at'] ?? '').toString();
                      final title = (m['title'] ?? m['name'] ?? 'Examination').toString();
                      final result = (m['result'] ?? m['report'] ?? '').toString();
                      return ListTile(
                        leading: const Icon(Icons.description_outlined),
                        title: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
                        subtitle: Text(result, maxLines: 1, overflow: TextOverflow.ellipsis),
                        trailing: Text(date, style: theme.textTheme.labelSmall),
                        onTap: () {},
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
