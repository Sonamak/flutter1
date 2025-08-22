/// RolloutManager — helpers for pilot cohorts and percentage-based rollouts.
class RolloutManager {
  /// Deterministically place an identifier (e.g., user or clinic id) into [0, 99].
  static int bucketOf(String id) {
    int sum = 0;
    for (final r in id.runes) {
      sum = (sum + r) % 100;
    }
    return sum;
  }

  /// True if [id] is within the first [percentage] buckets (0..percentage-1).
  static bool inCohort(String id, int percentage) {
    final p = percentage.clamp(0, 100);
    return bucketOf(id) < p;
  }
}
