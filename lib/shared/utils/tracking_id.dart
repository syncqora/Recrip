import 'dart:math';

/// Generates a UUID v4–style string for `X-Tracking-Id` headers.
String newTrackingId() {
  final r = Random.secure();
  const hex = '0123456789abcdef';
  String n(int len) =>
      List.generate(len, (_) => hex[r.nextInt(16)]).join();
  return '${n(8)}-${n(4)}-${n(4)}-${n(4)}-${n(12)}';
}
