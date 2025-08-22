
import 'package:flutter/material.dart';

class PaymentSlipPage extends StatelessWidget {
  const PaymentSlipPage({super.key, this.args = const {}});
  final Map<String, dynamic> args;

  @override
  Widget build(BuildContext context) {
    final title = args['title']?.toString() ?? 'Payment slip';
    final amount = args['amount']?.toString();
    final note = args['note']?.toString();
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Amount: ${amount ?? '-'}'),
            const SizedBox(height: 8),
            Text('Note: ${note ?? '-'}'),
          ],
        ),
      ),
    );
  }
}
