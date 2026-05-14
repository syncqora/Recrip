import 'dart:math';

/// Returns an RFC 4122 version-4 UUID string (random), lowercase hex with hyphens.
String newUuidV4() {
  final r = Random.secure();
  final b = List<int>.generate(16, (_) => r.nextInt(256));
  b[6] = (b[6] & 0x0f) | 0x40;
  b[8] = (b[8] & 0x3f) | 0x80;
  const hex = '0123456789abcdef';
  String nybblePair(int i) => '${hex[b[i] >> 4]}${hex[b[i] & 0x0f]}';
  return '${nybblePair(0)}${nybblePair(1)}${nybblePair(2)}${nybblePair(3)}-'
      '${nybblePair(4)}${nybblePair(5)}-'
      '${nybblePair(6)}${nybblePair(7)}-'
      '${nybblePair(8)}${nybblePair(9)}-'
      '${nybblePair(10)}${nybblePair(11)}${nybblePair(12)}${nybblePair(13)}${nybblePair(14)}${nybblePair(15)}';
}
