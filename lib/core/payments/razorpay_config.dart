/// Build-time config for Razorpay test / sandbox.
///
/// Run web with:
/// `flutter run -d chrome --dart-define=RAZORPAY_KEY_ID=rzp_test_xxx`
///
/// Never put the Key Secret in Dart or `--dart-define`.
abstract final class RazorpayConfig {
  /// Local test fallback so checkout opens on normal `flutter run`.
  /// Override with `--dart-define=RAZORPAY_KEY_ID=...` when needed.
  static const String localTestKeyId = 'rzp_test_SbSmJZiqZf3EaP';

  static String get keyId {
    const fromDefine = String.fromEnvironment('RAZORPAY_KEY_ID', defaultValue: '');
    return fromDefine.isNotEmpty ? fromDefine : localTestKeyId;
  }
}
