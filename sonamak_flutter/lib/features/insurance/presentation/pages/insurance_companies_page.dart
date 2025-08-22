
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/insurance/controllers/insurance_companies_controller.dart';
import 'package:sonamak_flutter/features/insurance/data/insurance_models.dart';
import 'package:sonamak_flutter/features/insurance/data/insurance_repository.dart';
import 'package:sonamak_flutter/features/insurance/presentation/pages/insurance_claims_sheet.dart';

class InsuranceCompaniesPage extends StatefulWidget {
  const InsuranceCompaniesPage({super.key});

  @override
  State<InsuranceCompaniesPage> createState() => _InsuranceCompaniesPageState();
}

class _InsuranceCompaniesPageState extends State<InsuranceCompaniesPage> {
  late final InsuranceCompaniesController controller;

  @override
  void initState() {
    super.initState();
    controller = InsuranceCompaniesController(InsuranceRepository())..bootstrap();
  }

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Insurance Companies'),
          actions: [
            IconButton(onPressed: _createCompanyDialog, icon: const Icon(Icons.add_business_outlined), tooltip: 'Add company'),
          ],
        ),
        body: AnimatedBuilder(
          animation: controller,
          builder: (context, _) {
            final st = controller.state;
            return Row(
              children: [
                SizedBox(
                  width: 280,
                  child: Column(
                    children: [
                      if (st.loading) const LinearProgressIndicator(),
                      Expanded(
                        child: ListView.builder(
                          itemCount: st.companies.length,
                          itemBuilder: (context, i) {
                            final c = st.companies[i];
                            final active = c.id == st.active?.id;
                            return ListTile(
                              selected: active,
                              leading: const Icon(Icons.apartment_outlined),
                              title: Text(c.name),
                              onTap: () => controller.select(c.id),
                              trailing: active
                                  ? PopupMenuButton<String>(
                                      onSelected: (v) {
                                        if (v == 'edit') _editCompanyDialog();
                                        if (v == 'delete') _deleteCompany();
                                      },
                                      itemBuilder: (context) => const [
                                        PopupMenuItem(value: 'edit', child: Text('Edit')),
                                        PopupMenuItem(value: 'delete', child: Text('Delete')),
                                      ],
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const VerticalDivider(width: 1),
                Expanded(
                  child: st.active == null
                      ? const Center(child: Text('No company selected'))
                      : Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(st.active!.name, style: Theme.of(context).textTheme.titleLarge),
                                  const Spacer(),
                                  ElevatedButton.icon(
                                    onPressed: _addSegmentDialog,
                                    icon: const Icon(Icons.add), label: const Text('Add segment'),
                                  ),
                                  const SizedBox(width: 8),
                                  ElevatedButton.icon(
                                    onPressed: _openClaims,
                                    icon: const Icon(Icons.assignment_outlined), label: const Text('Claims'),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text('Segments', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              if (st.segments.isEmpty) const Text('No segments')
                              else Wrap(
                                spacing: 12,
                                runSpacing: 12,
                                children: st.segments.map((s) => _SegmentCard(seg: s)).toList(growable: false),
                              ),
                              const SizedBox(height: 16),
                              Text('Payments', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Expanded(
                                child: Row(
                                  children: [
                                    Expanded(child: _PaymentsList(items: st.paid, title: 'Paid claims')),
                                    const SizedBox(width: 12),
                                    Expanded(child: _PaymentsList(items: st.required, title: 'Required claims')),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _createCompanyDialog() async {
    final name = TextEditingController();
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Create company'),
        content: TextField(controller: name, decoration: const InputDecoration(labelText: 'Company name', border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Create')),
        ],
      ),
    ) ?? false;
    if (!ok) return;
    final ok2 = await controller.createCompany({'name': name.text.trim()});
    if (!mounted) return;
    ok2 ? AppSnackbar.showSuccess(context, 'Created') : AppSnackbar.showError(context, 'Create failed');
  }

  Future<void> _editCompanyDialog() async {
    final active = controller.state.active;
    if (active == null) return;
    final name = TextEditingController(text: active.name);
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Edit company'),
        content: TextField(controller: name, decoration: const InputDecoration(labelText: 'Company name', border: OutlineInputBorder())),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    ) ?? false;
    if (!ok) return;
    final ok2 = await controller.updateCompany({'id': active.id, 'name': name.text.trim()});
    if (!mounted) return;
    ok2 ? AppSnackbar.showSuccess(context, 'Saved') : AppSnackbar.showError(context, 'Save failed');
  }

  Future<void> _deleteCompany() async {
    final active = controller.state.active;
    if (active == null) return;
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete company'),
        content: Text('Delete ${active.name}?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    ) ?? false;
    if (!ok) return;
    final ok2 = await controller.deleteCompany(active.id);
    if (!mounted) return;
    ok2 ? AppSnackbar.showSuccess(context, 'Deleted') : AppSnackbar.showError(context, 'Delete failed');
  }

  Future<void> _addSegmentDialog() async {
    final active = controller.state.active;
    if (active == null) return;
    final name = TextEditingController();
    final phone = TextEditingController();
    final approval = TextEditingController();
    final priceList = TextEditingController();
    final startDate = TextEditingController();

    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Add segment'),
        content: SizedBox(
          width: 420,
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            TextField(controller: name, decoration: const InputDecoration(labelText: 'Name', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: phone, decoration: const InputDecoration(labelText: 'Phone', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: approval, decoration: const InputDecoration(labelText: 'Approval', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: priceList, decoration: const InputDecoration(labelText: 'Pricing list (id)', border: OutlineInputBorder())),
            const SizedBox(height: 8),
            TextField(controller: startDate, decoration: const InputDecoration(labelText: 'Start date (YYYY-MM-DD)', border: OutlineInputBorder())),
          ]),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('Save')),
        ],
      ),
    ) ?? false;
    if (!ok) return;
    final data = {
      'insurance_id': active.id,
      'name': name.text.trim(),
      if (phone.text.trim().isNotEmpty) 'phone': phone.text.trim(),
      if (approval.text.trim().isNotEmpty) 'approval': approval.text.trim(),
      if (priceList.text.trim().isNotEmpty) 'pricing_list': int.tryParse(priceList.text.trim()) ?? priceList.text.trim(),
      if (startDate.text.trim().isNotEmpty) 'start_date': startDate.text.trim(),
    };
    final ok2 = await controller.addSegment(data);
    if (!mounted) return;
    ok2 ? AppSnackbar.showSuccess(context, 'Saved') : AppSnackbar.showError(context, 'Save failed');
  }

  void _openClaims() {
    final active = controller.state.active;
    if (active == null) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => InsuranceClaimsSheet(insuranceId: active.id, insuranceName: active.name),
    );
  }
}

class _SegmentCard extends StatelessWidget {
  const _SegmentCard({required this.seg});
  final InsuranceSegment seg;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(seg.name, style: Theme.of(context).textTheme.titleMedium),
            if (seg.phone != null) Text('Phone: ${seg.phone}'),
            if (seg.approval != null) Text('Approval: ${seg.approval}'),
            if (seg.pricingList != null) Text('Pricing list: ${seg.pricingList}'),
            if (seg.startDate != null) Text('Start date: ${seg.startDate}'),
          ],
        ),
      ),
    );
  }
}

class _PaymentsList extends StatelessWidget {
  const _PaymentsList({required this.items, required this.title});
  final List<PaymentRow> items;
  final String title;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Expanded(
              child: items.isEmpty
                  ? const Center(child: Text('No data'))
                  : ListView.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, __) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final r = items[i];
                        return ListTile(
                          leading: const Icon(Icons.request_page_outlined),
                          title: Text('Total: ${r.total}'),
                          subtitle: Text(r.date ?? '—'),
                          trailing: _PaymentStatusChip(status: r.paymentStatus),
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

class _PaymentStatusChip extends StatelessWidget {
  const _PaymentStatusChip({required this.status});
  final int status;
  @override
  Widget build(BuildContext context) {
    final label = switch (status) { 0 => 'Pending', 1 => 'Paid', _ => '—' };
    return Chip(label: Text(label));
  }
}
