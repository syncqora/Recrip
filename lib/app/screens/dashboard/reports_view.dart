import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'reports_mobile_view.dart';
import 'reports_tablet_view.dart';

class _RevenueRow {
  final String planName;
  final String totalMembers;
  final String renewals;
  final String missedRenewals;
  final String renewalRate;
  final String revenue;

  _RevenueRow({
    required this.planName,
    required this.totalMembers,
    required this.renewals,
    required this.missedRenewals,
    required this.renewalRate,
    required this.revenue,
  });
}

/// Reports page content: header, KPI cards, revenue analysis table.
/// Used inside the dashboard main content area when Reports nav is selected.
class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _valueBlue = Color(0xFF4F46E5);
  static const _valueRed = Color(0xFFDC2626);
  static const _valueGreen = Color(0xFF16A34A);

  static final _revenueData = [
    _RevenueRow(
      planName: 'Monthly',
      totalMembers: '42',
      renewals: '31',
      missedRenewals: '12',
      renewalRate: '86%',
      revenue: '₹21,800',
    ),
    _RevenueRow(
      planName: 'Quarterly',
      totalMembers: '56',
      renewals: '42',
      missedRenewals: '16',
      renewalRate: '81%',
      revenue: '₹16,000',
    ),
    _RevenueRow(
      planName: 'Half Yearly',
      totalMembers: '24',
      renewals: '16',
      missedRenewals: '8',
      renewalRate: '73%',
      revenue: '₹52,000',
    ),
    _RevenueRow(
      planName: 'Yearly',
      totalMembers: '18',
      renewals: '9',
      missedRenewals: '9',
      renewalRate: '50%',
      revenue: '₹36,000',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return SingleChildScrollView(
      padding: isMobile ? const EdgeInsets.all(16) : (isTablet ? const EdgeInsets.all(24) : EdgeInsets.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 24),
          if (isMobile)
            ReportsMobileView(
              revenueData: _revenueData
                  .map((e) => RevenueRow(
                        planName: e.planName,
                        totalMembers: e.totalMembers,
                        renewals: e.renewals,
                        missedRenewals: e.missedRenewals,
                        renewalRate: e.renewalRate,
                        revenue: e.revenue,
                      ))
                  .toList(),
              kpiCards: [
                _kpiCard(
                  title: 'Total Renewals',
                  value: '96',
                  valueColor: _valueBlue,
                  description: 'Successful renewals',
                ),
                _kpiCard(
                  title: 'Missed Renewals',
                  value: '12',
                  valueColor: _valueRed,
                  description: 'Not renewed after expiry',
                ),
                _kpiCard(
                  title: 'Renewal Rate',
                  value: '88%',
                  valueColor: _textDark,
                  description: 'Renewals + Expiring',
                ),
                _kpiCard(
                  title: 'Revenue Recovered',
                  value: '₹ 1,24,000/-',
                  valueColor: _valueGreen,
                  description: 'From renewed subscriptions',
                ),
              ],
            )
          else if (isTablet)
            ReportsTabletView(
              revenueData: _revenueData
                  .map((e) => RevenueRow(
                        planName: e.planName,
                        totalMembers: e.totalMembers,
                        renewals: e.renewals,
                        missedRenewals: e.missedRenewals,
                        renewalRate: e.renewalRate,
                        revenue: e.revenue,
                      ))
                  .toList(),
              kpiCards: [
                _kpiCard(
                  title: 'Total Renewals',
                  value: '96',
                  valueColor: _valueBlue,
                  description: 'Successful renewals',
                ),
                _kpiCard(
                  title: 'Missed Renewals',
                  value: '12',
                  valueColor: _valueRed,
                  description: 'Not renewed after expiry',
                ),
                _kpiCard(
                  title: 'Renewal Rate',
                  value: '88%',
                  valueColor: _textDark,
                  description: 'Renewals + Expiring',
                ),
                _kpiCard(
                  title: 'Revenue Recovered',
                  value: '₹ 1,24,000/-',
                  valueColor: _valueGreen,
                  description: 'From renewed subscriptions',
                ),
              ],
            )
          else ...[
            _buildKpiCards(),
            const SizedBox(height: 24),
            _buildRevenueSection(),
          ],
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reports',
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Analyze renewals, revenue, and performance',
            style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.download_outlined, size: 18),
                  label: const Text('Export'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _textDark,
                    side: BorderSide(color: _border),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.calendar_today_outlined, size: 18),
                  label: const Text('This Month'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: _textDark,
                    side: BorderSide(color: _border),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Reports',
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Analyze renewals, revenue, and performance',
              style: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
            ),
          ],
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_outlined, size: 18),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _textDark,
                side: BorderSide(color: _border),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 12),
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.calendar_today_outlined, size: 18),
              label: const Text('This Month'),
              style: OutlinedButton.styleFrom(
                foregroundColor: _textDark,
                side: BorderSide(color: _border),
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }


  Widget _buildKpiCards() {
    return Row(
      children: [
        Expanded(
          child: _kpiCard(
            title: 'Total Renewals',
            value: '96',
            valueColor: _valueBlue,
            description: 'Successful renewals',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _kpiCard(
            title: 'Missed Renewals',
            value: '12',
            valueColor: _valueRed,
            description: 'Not renewed after expiry',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _kpiCard(
            title: 'Renewal Rate',
            value: '88%',
            valueColor: _textDark,
            description: 'Renewals + Expiring',
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _kpiCard(
            title: 'Revenue Recovered',
            value: '₹ 1,24,000/-',
            valueColor: _valueGreen,
            description: 'From renewed subscriptions',
          ),
        ),
      ],
    );
  }

  Widget _kpiCard({
    required String title,
    required String value,
    required Color valueColor,
    required String description,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: Get.textTheme.bodySmall?.copyWith(
              color: _textMuted,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: Get.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: valueColor,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: Get.textTheme.bodySmall?.copyWith(
              color: _textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRevenueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Revenue Analysis',
              style: Get.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textDark,
                fontSize: 18,
              ),
            ),
            Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: _border),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Monthly',
                    style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.keyboard_arrow_down, size: 20, color: _textMuted),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _buildRevenueTable(),
      ],
    );
  }

  Widget _buildRevenueTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(1.2),
          1: FlexColumnWidth(1),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1.2),
          4: FlexColumnWidth(1),
          5: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            decoration: BoxDecoration(color: Color(0xFFF1F5F9)),
            children: [
              _tableCell('Plan Name', isHeader: true),
              _tableCell('Total Members', isHeader: true),
              _tableCell('Renewals', isHeader: true),
              _tableCell('Missed Renewals', isHeader: true),
              _tableCell('Renewal Rate', isHeader: true),
              _tableCell('Revenue', isHeader: true),
            ],
          ),
          ..._revenueData.map(
            (row) => TableRow(
              decoration: BoxDecoration(color: Colors.white),
              children: [
                _tableCell(row.planName),
                _tableCell(row.totalMembers),
                _tableCell(row.renewals),
                _tableCell(row.missedRenewals),
                _tableCell(row.renewalRate),
                _tableCell(row.revenue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tableCell(String text, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
            color: _textDark,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
