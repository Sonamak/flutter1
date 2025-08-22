class JsonDiffEntry {
  final String path;
  final String message;
  const JsonDiffEntry(this.path, this.message);
}
class JsonDiff {
  static List<JsonDiffEntry> compare(dynamic a, dynamic b, {String path = r'$'}) {
    final out = <JsonDiffEntry>[];
    if (a is Map && b is Map) {
      final aKeys = a.keys.map((e) => e.toString()).toSet();
      final bKeys = b.keys.map((e) => e.toString()).toSet();
      for (final k in aKeys.difference(bKeys)) { out.add(JsonDiffEntry('$path.$k', 'present in A, missing in B')); }
      for (final k in bKeys.difference(aKeys)) { out.add(JsonDiffEntry('$path.$k', 'present in B, missing in A')); }
      for (final k in aKeys.intersection(bKeys)) { out.addAll(compare(a[k], b[k], path: '$path.$k')); }
      return out;
    }
    if (a is List && b is List) {
      final minLen = a.length < b.length ? a.length : b.length;
      if (a.length != b.length) out.add(JsonDiffEntry(path, 'array length A=${a.length}, B=${b.length}'));
      for (var i = 0; i < minLen; i++) { out.addAll(compare(a[i], b[i], path: '$path[$i]')); }
      return out;
    }
    if (!_equalsLoose(a, b)) out.add(JsonDiffEntry(path, 'A=$a  B=$b'));
    return out;
  }
  static bool _equalsLoose(dynamic a, dynamic b) {
    if (a == b) return true;
    if (a is num && b is String) { final n = num.tryParse(b); return n != null && a == n; }
    if (b is num && a is String) { final n = num.tryParse(a); return n != null && b == n; }
    return false;
  }
}
