import 'package:flutter_test/flutter_test.dart';
import 'package:sonamak_flutter/core/uat/feedback_reporter.dart';

void main() {
  test('UATFeedback JSON structure', () {
    final fb = UATFeedback(
      module: 'finance',
      severity: 'high',
      summary: 'Extra fees not persisted',
      steps: '1) Add fees 200\n2) Save',
      expected: 'Total includes fees immediately',
      actual: 'Page shows old total until refresh',
      extra: {'route': '/admin/finance'},
      attachRecentLogs: false,
    );
    final j = fb.toJson();
    expect(j['module'], 'finance');
    expect(j['severity'], 'high');
    expect(j['summary'], isNotEmpty);
  });
}
