
import 'package:flutter/material.dart';

class RtlBuilder extends StatelessWidget {
  const RtlBuilder({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl ||
        Localizations.localeOf(context).languageCode.toLowerCase() == 'ar';
    return Directionality(textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr, child: child);
  }
}
