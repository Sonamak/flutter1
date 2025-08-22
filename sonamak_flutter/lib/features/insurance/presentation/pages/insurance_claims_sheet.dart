
import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/widgets/app_snackbar.dart';
import 'package:sonamak_flutter/features/insurance/controllers/insurance_claims_controller.dart';
import 'package:sonamak_flutter/features/insurance/data/insurance_repository.dart';

class InsuranceClaimsSheet extends StatefulWidget {
  const InsuranceClaimsSheet({super.key, required this.insuranceId, required this.insuranceName});
  final int insuranceId;
  final String insuranceName;

  @override
  State<InsuranceClaimsSheet> createState() => _InsuranceClaimsSheetState();
}

class _InsuranceClaimsSheetState extends State<InsuranceClaimsSheet> {
  late final InsuranceClaimsController controller;
  final _from = TextEditingController();
  final _to = TextEditingController();
  int _status = 0; // 0 NOT_CLAIMED, 1 CLAIMED, 2 UNDER_COLLECTION

  @override
  void initState() {
    super.initState();
    controller = InsuranceClaimsController(InsuranceRepository(), insuranceId: widget.insuranceId);
    controller.load(claimStatus: _status);
  }

  @override
  void dispose() {
    _from.dispose();
    _to.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      expand: false,
      builder: (context, scroll) {
        return Scaffold(
          appBar: AppBar(title: Text('Claims — ${widget.insuranceName}')),
          body: AnimatedBuilder(
            animation: controller,
            builder: (context, _) {
              final st = controller.state;
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Row(children: [
                      DropdownButton<int>(
                        value: _status,
                        items: const [
                          DropdownMenuItem(value: 0, child: Text('Not claimed')),
                          DropdownMenuItem(value: 1, child: Text('Claimed')),
                          DropdownMenuItem(value: 2, child: Text('Under collection')),
                        ],
                        onChanged: (v) async {
                          if (v == null) return;
                          setState(() => _status = v);
                          await controller.load(from: _from.text.trim().isEmpty ? null : _from.text.trim(), to: _to.text.trim().isEmpty ? null : _to.text.trim(), claimStatus: v);
                        },
                      ),
                      const SizedBox(width: 8),
                      SizedBox(width: 160, child: TextField(controller: _from, decoration: const InputDecoration(labelText: 'From (YYYY-MM-DD)', border: OutlineInputBorder()))),
                      const SizedBox(width: 8),
                      SizedBox(width: 160, child: TextField(controller: _to, decoration: const InputDecoration(labelText: 'To (YYYY-MM-DD)', border: OutlineInputBorder()))),
                      const SizedBox(width: 8),
                      ElevatedButton(onPressed: () {
                        controller.load(from: _from.text.trim().isEmpty ? null : _from.text.trim(), to: _to.text.trim().isEmpty ? null : _to.text.trim(), claimStatus: _status);
                      }, child: const Text('Apply'))
                    ]),
                    const SizedBox(height: 12),
                    if (st.loading) const LinearProgressIndicator(),
                    const SizedBox(height: 8),
                    Expanded(
                      child: _ClaimsList(
                        items: st.items,
                        onGenerate: (ids) async {
                          final ok = await controller.generateClaim(ids);
                          if (!mounted) return;
                          ok ? AppSnackbar.showSuccess(context, 'Claim generated') : AppSnackbar.showError(context, 'Failed');
                        },
                        onPay: (rows, paid) async {
                          final ok = await controller.payClaim(claimed: rows, paid: paid);
                          if (!mounted) return;
                          ok ? AppSnackbar.showSuccess(context, 'Payment saved') : AppSnackbar.showError(context, 'Failed');
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _ClaimsList extends StatefulWidget {
  const _ClaimsList({required this.items, required this.onGenerate, required this.onPay});
  final List items;
  final Future<void> Function(List<int> ids) onGenerate;
  final Future<void> Function(List<Map<String, dynamic>> rows, dynamic paid) onPay;

  @override
  State<_ClaimsList> createState() => _ClaimsListState();
}

class _ClaimsListState extends State<_ClaimsList> {
  final _checked = <int, bool>{};
  final _paidCtrl = TextEditingController();

  @override
  void dispose() {
    _paidCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final items = widget.items;
    if (items.isEmpty) return const Center(child: Text('No rows'));
    num totalSelected = 0;
    for (final e in items) {
      final claim = (e.cost * e.count + e.labCost) * (e.percentage) / 100;
      if (_checked[e.id] ?? false) totalSelected += claim;
    }
    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, i) {
              final e = items[i];
              final checked = _checked[e.id] ?? false;
              final claim = (e.cost * e.count + e.labCost) * (e.percentage) / 100;
              return CheckboxListTile(
                value: checked,
                onChanged: (v) => setState(() => _checked[e.id] = v ?? false),
                title: Text('Row #${e.id} — claim: $claim'),
                subtitle: Text('count: ${e.count} • cost: ${e.cost} • lab: ${e.labCost} • %: ${e.percentage}'),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(child: Text('Selected total: $totalSelected')),
            SizedBox(width: 160, child: TextField(controller: _paidCtrl, decoration: const InputDecoration(labelText: 'Paid', border: OutlineInputBorder()))),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () async {
              final ids = _checked.entries.where((e) => e.value).map((e) => e.key).toList(growable: false);
              if (ids.isEmpty) {
                AppSnackbar.showError(context, 'No rows checked');
                return;
              }
              await widget.onGenerate(ids);
            }, child: const Text('Generate claim')),
            const SizedBox(width: 8),
            ElevatedButton(onPressed: () async {
              final rows = _checked.entries.where((e) => e.value).map((e) {
                final item = items.firstWhere((x) => x.id == e.key);
                final claim = (item.cost * item.count + item.labCost) * (item.percentage) / 100;
                return {'id': item.id, 'claim': claim};
              }).toList(growable: false);
              if (rows.isEmpty) {
                AppSnackbar.showError(context, 'No rows checked');
                return;
              }
              await widget.onPay(rows, _paidCtrl.text.trim());
            }, child: const Text('Pay claim')),
          ],
        ),
      ],
    );
  }
}
