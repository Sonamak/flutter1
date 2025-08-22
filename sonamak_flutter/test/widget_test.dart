
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sonamak_flutter/app/app.dart';

void main() {
  testWidgets('app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const App());
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
