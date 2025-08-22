import 'package:flutter_test/flutter_test.dart';
import 'package:sonamak_flutter/core/feature_flags/feature_flags.dart';
import 'package:sonamak_flutter/core/feature_flags/feature_flag_keys.dart';

void main() {
  test('FeatureFlags load and default read is boolean', () async {
    await FeatureFlags.I.load();
    expect(FeatureFlags.I.isEnabled(FF.calendar), isA<bool>());
  });
}
