// Basic unit tests for NumberParser (run with `flutter test`)
import 'package:flutter_test/flutter_test.dart';
import 'package:sonamak_flutter/core/utils/number_parser.dart';

void main() {
  group('NumberParser', () {
    test('Arabic-Indic digits parse', () {
      expect(NumberParser.tryParseAmount('١٢٣'), 123);
      expect(NumberParser.tryParseAmount('١٢٣٫٤٥'), 123.45);
    });

    test('Eastern Arabic/Persian digits parse', () {
      expect(NumberParser.tryParseAmount('۱۲۳'), 123);
      expect(NumberParser.tryParseAmount('۱۲۳٫۴۵'), 123.45);
    });

    test('Comma decimal respected', () {
      expect(NumberParser.tryParseAmount('1.234,56'), 1234.56);
    });

    test('Thousands removed', () {
      expect(NumberParser.tryParseAmount('1,234.56'), 1234.56);
      expect(NumberParser.tryParseAmount('1.234,56'), 1234.56);
      expect(NumberParser.tryParseAmount('1٬234٫56'), 1234.56);
    });

    test('Negative and fraction rules', () {
      expect(NumberParser.tryParseAmount('-123'), -123);
      expect(NumberParser.sanitizeAmountString('abc'), null);
    });
  });
}
