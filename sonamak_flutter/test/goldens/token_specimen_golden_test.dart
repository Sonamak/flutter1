
import 'package:flutter/material.dart';
import 'package:golden_toolkit/golden_toolkit.dart';
import 'golden_test_config.dart';
import 'package:sonamak_flutter/app/theme/token_specimen.dart';

void main() {
  testGoldens('Token specimen — desktop/mobile', (tester) async {
    await tester.pumpWidgetBuilder(const SizedBox(width: 1200, height: 800, child: TokenSpecimen()));
    await multiScreenGolden(tester, 'token_specimen', devices: [desktop, mobile]);
  });
}
