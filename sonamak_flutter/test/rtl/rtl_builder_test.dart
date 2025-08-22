
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonamak_flutter/app/localization/rtl_builder.dart';

void main() {
  testWidgets('RtlBuilder applies RTL for ar locale', (tester) async {
    const child = Text('x');
    await tester.pumpWidget(const MaterialApp(
      locale: Locale('ar'),
      home: RtlBuilder(child: child),
    ));
    final dir = tester.widget<Directionality>(find.byType(Directionality)).textDirection;
    expect(dir, TextDirection.rtl);
  });
}
