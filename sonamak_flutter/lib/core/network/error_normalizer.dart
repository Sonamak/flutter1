import 'envelope_inspector.dart';

/// Small helper to present validation errors in a user-friendly manner.
class ErrorNormalizer {
  static List<String> flattenValidation(EnvelopeAnalysis a) {
    if (a.validationErrors == null) return const [];
    final out = <String>[];
    a.validationErrors!.forEach((field, msgs) {
      for (final m in msgs) {
        out.add('$field: $m');
      }
    });
    return out;
  }
}
