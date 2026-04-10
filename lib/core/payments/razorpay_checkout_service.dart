import 'dart:convert';

import 'package:saas/core/payments/razorpay_checkout_js.dart';
import 'package:saas/core/payments/razorpay_config.dart';

/// Opens Razorpay Checkout on web (direct mode, no backend order API).
class RazorpayCheckoutService {
  RazorpayCheckoutService();

  /// Sandbox flow: open Checkout.js directly (without `order_id`).
  Future<String> startTestCheckout({
    required int amountPaise,
    String businessName = 'Recrip',
    String description = 'Test payment (sandbox)',
  }) async {
    if (RazorpayConfig.keyId.isEmpty) {
      throw StateError(
        'Missing RAZORPAY_KEY_ID. Pass --dart-define=RAZORPAY_KEY_ID=... when running.',
      );
    }

    final options = <String, dynamic>{
      'key': RazorpayConfig.keyId,
      'amount': amountPaise.toString(),
      'currency': 'INR',
      'name': businessName,
      'description': description,
      'theme': <String, dynamic>{'color': '#4F46E5'},
    };

    return openRazorpayCheckoutJson(jsonEncode(options));
  }

  void close() {}
}
