import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:saas/core/payments/razorpay_config.dart';
import 'package:saas/core/payments/razorpay_checkout_service.dart';

class PaymentsView extends StatefulWidget {
  const PaymentsView({super.key});

  @override
  State<PaymentsView> createState() => _PaymentsViewState();
}

class _PaymentsViewState extends State<PaymentsView> {
  bool _busy = false;
  String? _lastResult;

  Future<void> _startCheckout({
    required String planName,
    required int amountPaise,
  }) async {
    if (!kIsWeb) {
      setState(() => _lastResult = 'Razorpay checkout is configured for web.');
      return;
    }
    setState(() {
      _busy = true;
      _lastResult = null;
    });
    final svc = RazorpayCheckoutService();
    try {
      final raw = await svc.startTestCheckout(
        amountPaise: amountPaise,
        businessName: 'Recrip',
        description: 'Subscription: $planName',
      );
      final obj = jsonDecode(raw);
      setState(() {
        _lastResult = const JsonEncoder.withIndent('  ').convert(obj);
      });
    } catch (e) {
      setState(() => _lastResult = e.toString());
    } finally {
      svc.close();
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final keyReady = RazorpayConfig.keyId.isNotEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose a subscription',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Pick a plan to open Razorpay checkout (sandbox).',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF475569),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Checkout diagnostics',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'RAZORPAY_KEY_ID: ${keyReady ? "configured" : "missing"}',
                style: const TextStyle(color: Color(0xFF334155)),
              ),
              const SizedBox(height: 4),
              const Text(
                'Mode: direct checkout (no create-order API)',
                style: TextStyle(color: Color(0xFF334155)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _PlanCard(
              title: 'Basic',
              priceText: '₹499 / month',
              features: const [
                'Core renewal tracking',
                'Reminders',
                'Basic analytics',
              ],
              busy: _busy,
              onTap: () => _startCheckout(planName: 'Basic', amountPaise: 49900),
            ),
            _PlanCard(
              title: 'Pro',
              priceText: '₹999 / month',
              features: const [
                'Everything in Basic',
                'Advanced analytics',
                'Priority support',
              ],
              highlight: true,
              busy: _busy,
              onTap: () => _startCheckout(planName: 'Pro', amountPaise: 99900),
            ),
          ],
        ),
        if (_lastResult != null) ...[
          const SizedBox(height: 18),
          const Divider(),
          const SizedBox(height: 12),
          Text(
            'Last checkout result',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: SelectableText(
                _lastResult!,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.priceText,
    required this.features,
    required this.onTap,
    required this.busy,
    this.highlight = false,
  });

  final String title;
  final String priceText;
  final List<String> features;
  final VoidCallback onTap;
  final bool busy;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor =
        highlight ? const Color(0xFF4F46E5) : const Color(0xFFCBD5E1);
    final bg = highlight ? const Color(0xFFF5F4FF) : Colors.white;
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(width: 320),
      child: Material(
        color: bg,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: busy ? null : onTap,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  priceText,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4F46E5),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 12),
                ...features.map(
                  (f) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check, size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            f,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: const Color(0xFF1E293B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                FilledButton(
                  onPressed: busy ? null : onTap,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFF4F46E5),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(busy ? 'Please wait…' : 'Choose $title'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

