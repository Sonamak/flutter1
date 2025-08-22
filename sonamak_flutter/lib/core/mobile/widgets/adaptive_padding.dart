import 'package:flutter/widgets.dart';
import '../breakpoints.dart';

class AdaptivePadding extends StatelessWidget {
  const AdaptivePadding({super.key, required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    EdgeInsets pad;
    if (w < AppBreakpoints.mobile) {
      pad = const EdgeInsets.all(8);
    } else if (w < AppBreakpoints.tablet) {
      pad = const EdgeInsets.all(12);
    } else if (w < AppBreakpoints.desktop) {
      pad = const EdgeInsets.all(16);
    } else {
      pad = const EdgeInsets.all(20);
    }
    return Padding(padding: pad, child: child);
  }
}
