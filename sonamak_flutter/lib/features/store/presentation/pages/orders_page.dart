import 'package:flutter/material.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';
import 'package:sonamak_flutter/features/store/controllers/orders_controller.dart';
import 'package:sonamak_flutter/features/store/data/store_models.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  final c = OrdersController();

  @override
  void initState() {
    super.initState();
    c.load();
    c.addListener(_onChanged);
  }

  @override
  void dispose() {
    c.removeListener(_onChanged);
    super.dispose();
  }

  void _onChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return RtlBuilder(
      child: Scaffold(
        appBar: AppBar(title: const Text('Orders')),
        body: c.loading
            ? const Center(child: CircularProgressIndicator())
            : ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: c.rows.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (_, i) => _OrderTile(row: c.rows[i], onStatus: c.setStatus, onRefund: c.setRefund),
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final OrderRow row;
  final Future<void> Function(int, String) onStatus;
  final Future<void> Function(int, String) onRefund;

  const _OrderTile({required this.row, required this.onStatus, required this.onRefund});

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if ((row.item ?? '').isNotEmpty) 'Item: ${row.item}',
      if ((row.patient ?? '').isNotEmpty) 'Patient: ${row.patient}',
      if ((row.quantity ?? 0) > 0) 'Qty: ${row.quantity}',
      if ((row.status ?? '').isNotEmpty) 'Status: ${row.status}',
    ].join(' • ');

    return ListTile(
      title: Text('Order #${row.id}'),
      subtitle: subtitle.isEmpty ? null : Text(subtitle),
      trailing: PopupMenuButton<String>(
        onSelected: (v) async {
          if (v.startsWith('status:')) {
            await onStatus(row.id, v.substring(7));
          } else if (v.startsWith('refund:')) {
            await onRefund(row.id, v.substring(7));
          }
        },
        itemBuilder: (_) => const [
          PopupMenuItem(value: 'status:pending', child: Text('Set status: pending')),
          PopupMenuItem(value: 'status:paid', child: Text('Set status: paid')),
          PopupMenuItem(value: 'refund:requested', child: Text('Set refund: requested')),
          PopupMenuItem(value: 'refund:approved', child: Text('Set refund: approved')),
        ],
      ),
    );
  }
}
