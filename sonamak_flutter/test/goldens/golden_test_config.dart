
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:golden_toolkit/golden_toolkit.dart';

Future<void> pumpApp(WidgetTester tester, Widget child, {Size? size}) async {
  await loadAppFonts();
  await tester.pumpWidget(MaterialApp(home: SizedBox(width: size?.width ?? 1440, height: size?.height ?? 900, child: child)));
  await tester.pump();
}

const Device desktop = Device(name: 'Desktop1440', size: Size(1440, 900));
const Device mobile = Device(name: 'Mobile390', size: Size(390, 844));
