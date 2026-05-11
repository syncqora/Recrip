import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:saas/shared/constants/app_strings.dart';

/// Payments & Renewals tab content used inside the Settings page.
///
/// Renders four blocks by default:
///  1. A warning banner with the next payment due date.
///  2. The currently active plan with feature highlights.
///  3. The upcoming bill breakdown with Change Plan / Renew actions.
///  4. A historical payments table.
///
/// Tapping "Browse other Plans" swaps the main view for a plan comparison
/// view; the back arrow returns to the main view.
///
/// Layout adapts to width:
///  - `>= 1100px` → 2-column (Current Plan left, Upcoming Bill + History right)
///  - smaller     → single column, blocks stacked
class PaymentsRenewalsView extends StatefulWidget {
  const PaymentsRenewalsView({super.key});

  @override
  State<PaymentsRenewalsView> createState() => _PaymentsRenewalsViewState();
}

class _PaymentsRenewalsViewState extends State<PaymentsRenewalsView> {
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _purple = Color(0xFF4F46E5);
  static const _purpleBorder = Color(0xFFC7D2FE);
  static const _bannerBg = Color(0xFFFFF8E1);
  static const _bannerBorder = Color(0xFFF59E0B);
  static const _bannerIconBg = Color(0xFFFDE68A);
  static const _warning = Color(0xFFB45309);
  static const _amountAccent = Color(0xFFDC2626);
  static const _historyHeaderBg = Color(0xFFF8FAFC);
  static const _paidBg = Color(0xFFDCFCE7);
  static const _paidText = Color(0xFF15803D);
  static const _disabledBg = Color(0xFFF1F5F9);
  static const _disabledText = Color(0xFF94A3B8);

  static const _planFeatures = <String>[
    'Unlimited Members',
    'WhatsApp/Email Reminders',
    'Advanced Insights',
    'Renewal Alerts',
    'Custom Reminders',
    'Custom Ad Template',
    'Priority Support',
    'Export Report (Custom Preference)',
  ];

  static const _starterFeatures = <String>[
    '300 Members',
    'WhatsApp Reminders',
    'Renewal Alerts',
    'Default Reminders',
    'Export Report (Current Month)',
  ];

  bool _showBrowsePlans = false;

  void _openBrowsePlans() => setState(() => _showBrowsePlans = true);
  void _closeBrowsePlans() => setState(() => _showBrowsePlans = false);

  @override
  Widget build(BuildContext context) {
    return _showBrowsePlans ? _buildBrowsePlansView() : _buildMainView();
  }

  // -------- Main view --------

  Widget _buildMainView() {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= 1100;
    final stackBillCard = width < 1120;
    // Anything below ~720 doesn't have room for the desktop history table.
    // Mirror the members/dashboard mobile screens and render history as a
    // vertical stack of small list-cards instead.
    final compactHistory = width < 720;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildBanner(),
        const SizedBox(height: 16),
        if (isWide)
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 320, child: _buildCurrentPlanCard()),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildUpcomingBillCard(stack: stackBillCard),
                    const SizedBox(height: 16),
                    _buildPaymentHistoryCard(compact: compactHistory),
                  ],
                ),
              ),
            ],
          )
        else ...[
          _buildCurrentPlanCard(),
          const SizedBox(height: 16),
          _buildUpcomingBillCard(stack: true),
          const SizedBox(height: 16),
          _buildPaymentHistoryCard(compact: compactHistory),
        ],
      ],
    );
  }

  // -------- Banner --------

  Widget _buildBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _bannerBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _bannerBorder.withValues(alpha: 0.45)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: _bannerIconBg,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              size: 22,
              color: _warning,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.paymentDueBannerTitle,
                  style: Get.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: _warning,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppStrings.paymentDueBannerSubtitle,
                  style: Get.textTheme.bodySmall?.copyWith(color: _warning),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // -------- Current Plan --------

  Widget _buildCurrentPlanCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _purpleBorder, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.currentPlanLabel,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: _purple,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              AppStrings.currentPlanName,
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.currentPlanActiveSince,
            style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
              children: [
                const TextSpan(text: AppStrings.currentPlanPrice),
                TextSpan(
                  text: AppStrings.currentPlanPriceSuffix,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: _textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ..._planFeatures.map(
            (feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                feature,
                style: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: _openBrowsePlans,
              style: OutlinedButton.styleFrom(
                foregroundColor: _textDark,
                side: const BorderSide(color: _border),
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text(
                AppStrings.browseOtherPlans,
                style: Get.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -------- Upcoming Bill --------

  Widget _buildUpcomingBillCard({required bool stack}) {
    final summary = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.upcomingBillLabel,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          AppStrings.upcomingBillAmount,
          style: Get.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 8),
        RichText(
          text: TextSpan(
            style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
            children: [
              const TextSpan(text: AppStrings.upcomingBillDuePrefix),
              TextSpan(
                text: AppStrings.upcomingBillDueDate,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: _amountAccent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ],
    );

    final breakdown = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        _billRow(
          AppStrings.upcomingBillPlanLine,
          AppStrings.upcomingBillPlanAmount,
        ),
        const SizedBox(height: 12),
        _billRow(
          AppStrings.upcomingBillTaxLine,
          AppStrings.upcomingBillTaxAmount,
        ),
        const SizedBox(height: 12),
        _billRow(
          AppStrings.upcomingBillTotalLine,
          AppStrings.upcomingBillTotalAmount,
          bold: true,
        ),
        const SizedBox(height: 20),
        _buildBillActionsRow(stretch: stack),
      ],
    );

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: stack
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                summary,
                const SizedBox(height: 16),
                const Divider(height: 1, color: _border),
                const SizedBox(height: 16),
                breakdown,
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(width: 200, child: summary),
                const SizedBox(width: 24),
                Expanded(child: breakdown),
              ],
            ),
    );
  }

  /// Change Plan + Renew. Right-aligned on desktop, 50/50 full-width on mobile.
  Widget _buildBillActionsRow({required bool stretch}) {
    final cancel = OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: _textDark,
        side: const BorderSide(color: _border),
        padding: EdgeInsets.symmetric(
          horizontal: stretch ? 0 : 20,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        AppStrings.changePlan,
        style: Get.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: _textDark,
        ),
      ),
    );

    final renew = FilledButton(
      onPressed: () {},
      style: FilledButton.styleFrom(
        backgroundColor: _purple,
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(
          horizontal: stretch ? 0 : 28,
          vertical: 12,
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(
        AppStrings.renew,
        style: Get.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );

    if (stretch) {
      return Row(
        children: [
          Expanded(child: cancel),
          const SizedBox(width: 12),
          Expanded(child: renew),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [cancel, const SizedBox(width: 12), renew],
    );
  }

  Widget _billRow(String label, String amount, {bool bold = false}) {
    final weight = bold ? FontWeight.w700 : FontWeight.w500;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: bold ? _textDark : _textMuted,
            fontWeight: weight,
          ),
        ),
        Text(
          amount,
          style: Get.textTheme.bodyMedium?.copyWith(
            color: _textDark,
            fontWeight: weight,
          ),
        ),
      ],
    );
  }

  // -------- Payment History --------

  static const _paymentHistory = <_PaymentRow>[
    _PaymentRow(
      date: '10/04/2026',
      plan: AppStrings.currentPlanName,
      amount: AppStrings.upcomingBillTotalAmount,
    ),
  ];

  Widget _buildPaymentHistoryCard({required bool compact}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppStrings.paymentHistoryLabel,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 12),
          if (compact) _buildHistoryList() else _buildHistoryTable(),
        ],
      ),
    );
  }

  /// Desktop / tablet view: standard table with 5 columns.
  Widget _buildHistoryTable() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Table(
        columnWidths: const <int, TableColumnWidth>{
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(2),
          3: FlexColumnWidth(2),
          4: FlexColumnWidth(1.2),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: [
          TableRow(
            decoration: const BoxDecoration(color: _historyHeaderBg),
            children: [
              _headerCell(AppStrings.paymentHistoryDate),
              _headerCell(AppStrings.paymentHistoryPlan),
              _headerCell(AppStrings.paymentHistoryAmount),
              _headerCell(AppStrings.paymentHistoryStatus),
              _headerCell(AppStrings.paymentHistoryInvoice),
            ],
          ),
          for (final row in _paymentHistory)
            TableRow(
              children: [
                _bodyCell(row.date),
                _bodyCell(row.plan),
                _bodyCell(row.amount),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: _paidPill(),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: () {},
                    tooltip: AppStrings.paymentHistoryInvoice,
                    icon: const Icon(
                      Icons.file_download_outlined,
                      color: _textMuted,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  /// Mobile / narrow tablet view: each payment as a list-card, matching the
  /// pattern used in [`MembersMobileView`] and [`DashboardMobileView`].
  Widget _buildHistoryList() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [for (final row in _paymentHistory) _buildHistoryListCard(row)],
    );
  }

  Widget _buildHistoryListCard(_PaymentRow row) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row.date,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: _textDark,
                  fontWeight: FontWeight.w700,
                ),
              ),
              _paidPill(),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1, color: _border),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.paymentHistoryPlan,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: _textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      row.plan,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: _textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.paymentHistoryAmount,
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: _textMuted,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      row.amount,
                      style: Get.textTheme.bodyMedium?.copyWith(
                        color: _textDark,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              _invoiceIconButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _invoiceIconButton() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFEEF2FF),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.file_download_outlined,
            size: 18,
            color: _purple,
          ),
        ),
      ),
    );
  }

  Widget _headerCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Text(
        text,
        style: Get.textTheme.bodySmall?.copyWith(
          color: _textMuted,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _bodyCell(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Text(
        text,
        style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
      ),
    );
  }

  Widget _paidPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: _paidBg,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        AppStrings.paymentHistoryStatusPaid,
        style: Get.textTheme.bodySmall?.copyWith(
          color: _paidText,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // -------- Browse Plans view --------

  Widget _buildBrowsePlansView() {
    final width = MediaQuery.sizeOf(context).width;
    final stackCards = width < 760;

    final cards = <Widget>[
      _buildPlanCard(
        name: AppStrings.planStarterName,
        price: AppStrings.planStarterPrice,
        features: _starterFeatures,
        action: _PlanCardAction.downgrade,
      ),
      const SizedBox(width: 16, height: 16),
      _buildPlanCard(
        name: AppStrings.currentPlanName,
        price: AppStrings.currentPlanPrice,
        features: _planFeatures,
        action: _PlanCardAction.selected,
      ),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          onTap: _closeBrowsePlans,
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.all(6),
            child: Icon(Icons.arrow_back, color: _textDark, size: 22),
          ),
        ),
        const SizedBox(height: 12),
        if (stackCards)
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: cards,
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 300, child: cards[0]),
              cards[1],
              SizedBox(width: 300, child: cards[2]),
            ],
          ),
      ],
    );
  }

  Widget _buildPlanCard({
    required String name,
    required String price,
    required List<String> features,
    required _PlanCardAction action,
  }) {
    final isSelected = action == _PlanCardAction.selected;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isSelected ? _purple : _border,
          width: isSelected ? 1.6 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _planPill(name, filled: isSelected),
          const SizedBox(height: 16),
          RichText(
            text: TextSpan(
              style: Get.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
              children: [
                TextSpan(text: price),
                TextSpan(
                  text: AppStrings.currentPlanPriceSuffix,
                  style: Get.textTheme.bodyMedium?.copyWith(
                    color: _textMuted,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text(
                feature,
                style: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildPlanActionButton(action),
        ],
      ),
    );
  }

  Widget _planPill(String label, {required bool filled}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: filled ? _purple : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: filled ? null : Border.all(color: _purple, width: 1.4),
      ),
      child: Text(
        label,
        style: Get.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
          color: filled ? Colors.white : _purple,
        ),
      ),
    );
  }

  Widget _buildPlanActionButton(_PlanCardAction action) {
    switch (action) {
      case _PlanCardAction.selected:
        return SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: null,
            style: FilledButton.styleFrom(
              disabledBackgroundColor: _disabledBg,
              disabledForegroundColor: _disabledText,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              AppStrings.selected,
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: _disabledText,
              ),
            ),
          ),
        );
      case _PlanCardAction.downgrade:
        return SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              foregroundColor: _textDark,
              side: const BorderSide(color: _border),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              AppStrings.downgrade,
              style: Get.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
                color: _textDark,
              ),
            ),
          ),
        );
    }
  }
}

enum _PlanCardAction { selected, downgrade }

class _PaymentRow {
  const _PaymentRow({
    required this.date,
    required this.plan,
    required this.amount,
  });

  final String date;
  final String plan;
  final String amount;
}
