import 'package:flutter/material.dart';

class RevenueRow {
  final String planName;
  final String totalMembers;
  final String renewals;
  final String missedRenewals;
  final String renewalRate;
  final String revenue;

  RevenueRow({
    required this.planName,
    required this.totalMembers,
    required this.renewals,
    required this.missedRenewals,
    required this.renewalRate,
    required this.revenue,
  });
}

class ReportsMobileView extends StatelessWidget {
  const ReportsMobileView({
    super.key,
    required this.revenueData,
    required this.kpiCards,
  });

  final List<RevenueRow> revenueData;
  final List<Widget> kpiCards;

  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
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
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.3,
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
                fontSize: 16,
              ),
            ),
            _buildMonthlyFilter(),
          ],
        ),
        const SizedBox(height: 12),
        ...revenueData.map((row) => _buildRevenueCard(row)),
      ],
    );
  }

  Widget _buildMonthlyFilter() {
    return Container(
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: _border),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('Monthly', style: TextStyle(color: _textDark, fontSize: 12)),
          SizedBox(width: 4),
          Icon(Icons.keyboard_arrow_down, size: 16, color: _textMuted),
        ],
      ),
    );
  }

  Widget _buildRevenueCard(RevenueRow row) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                row.planName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: _textDark,
                ),
              ),
              Text(
                row.revenue,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF16A34A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoItem('Members', row.totalMembers),
              _infoItem('Renewals', row.renewals),
              _infoItem('Missed', row.missedRenewals),
              _infoItem('Rate', row.renewalRate),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: _textMuted, fontSize: 11)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: _textDark,
          ),
        ),
      ],
    );
  }
}
