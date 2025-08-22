import 'package:flutter/widgets.dart';
import 'breakpoints.dart';

class HideOnSmall extends StatelessWidget {
  const HideOnSmall({super.key, required this.child, this.threshold = AppBreakpoints.mobile});
  final Widget child;
  final double threshold;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w < threshold ? const SizedBox.shrink() : child;
  }
}

class ShowOnSmall extends StatelessWidget {
  const ShowOnSmall({super.key, required this.child, this.threshold = AppBreakpoints.mobile});
  final Widget child;
  final double threshold;
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.sizeOf(context).width;
    return w < threshold ? child : const SizedBox.shrink();
  }
}
