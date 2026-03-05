import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'reports_mobile_view.dart'; // For RevenueRow

class ReportsTabletView extends StatelessWidget {
  const ReportsTabletView({
    super.key,
    required this.revenueData,
    required this.kpiCards,
  });

  final List<RevenueRow> revenueData;
  final List<Widget> kpiCards;

  static const _textDark = Color(0xFF333333);
  static const _border = Color(0xFFE5E7EB);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildKpiGrid(),
        const SizedBox(height: 24),
        _buildRevenueSection(),
      ],
    );
  }

  Widget _buildKpiGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 2.2,
      children: kpiCards,
    );
  }

  Widget _buildRevenueSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Revenue Analysis',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textDark,
                fontSize: 18,
              ),
            ),
            _buildMonthlyFilter(),
          ],
        ),
        const SizedBox(height: 16),
        _buildRevenueTable(),
      ],
    );
  }

  Widget _buildMonthlyFilter() {
    return Container(
      height: 40,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: _border),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Monthly', style: TextStyle(color: _textDark, fontSize: 14)),
          SizedBox(width: 8),
          Icon(Icons.keyboard_arrow_down, size: 20, color: Color(0xFF666666)),
        ],
      ),
    );
  }

  Widget _buildRevenueTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
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
            decoration: const BoxDecoration(color: Color(0xFFF1F5F9)),
            children: [
              _tableCell('Plan Name', isHeader: true),
              _tableCell('Total Members', isHeader: true),
              _tableCell('Renewals', isHeader: true),
              _tableCell('Missed Renewals', isHeader: true),
              _tableCell('Renewal Rate', isHeader: true),
              _tableCell('Revenue', isHeader: true),
            ],
          ),
          ...revenueData.map(
            (row) => TableRow(
              decoration: const BoxDecoration(color: Colors.white),
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
