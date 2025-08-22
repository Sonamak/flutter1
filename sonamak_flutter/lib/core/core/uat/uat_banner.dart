import 'package:flutter/material.dart';
import 'package:sonamak_flutter/core/uat/uat_flags.dart';

/// Place near the top of your app shell to show a persistent UAT banner when enabled.
class UatBanner extends StatelessWidget {
  const UatBanner({super.key});
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: UatFlags.enabled,
      builder: (_, on, __) {
        if (!on) return const SizedBox.shrink();
        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          color: Colors.amber.shade700,
          child: Row(children: [
            const Icon(Icons.flag, size: 16, color: Colors.black87),
            const SizedBox(width: 8),
            const Text('UAT MODE', style: TextStyle(fontWeight: FontWeight.w800)),
            const SizedBox(width: 8),
            ValueListenableBuilder<String?>(
              valueListenable: UatFlags.sessionId,
              builder: (_, id, __) => Text(id == null ? '' : '(session: $id)'),
            ),
          ]),
        );
      },
    );
  }
}
