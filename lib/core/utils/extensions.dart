// Shared Dart extensions used across the app. Keep this file small —
// extensions earn their place by removing duplicated logic from
// multiple call sites, not by being clever.

extension RelativeTimeExt on DateTime {
  /// Human-readable "12s ago" / "3m ago" / "2h ago" / "5d ago" string.
  String relativeFromNow() {
    final delta = DateTime.now().difference(toLocal());
    final s = delta.abs();
    if (s.inSeconds < 60) return '${s.inSeconds}s ago';
    if (s.inMinutes < 60) return '${s.inMinutes}m ago';
    if (s.inHours < 24) return '${s.inHours}h ago';
    return '${s.inDays}d ago';
  }
}

extension NullIfEmptyExt on String {
  /// Returns null when the string is empty after trimming, otherwise
  /// the trimmed value. Avoids "" sneaking into nullable columns.
  String? nullIfEmpty() {
    final t = trim();
    return t.isEmpty ? null : t;
  }
}
