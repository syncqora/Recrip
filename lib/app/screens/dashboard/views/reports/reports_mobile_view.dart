import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
    required this.onExport,
  });

  final List<RevenueRow> revenueData;
  final List<Widget> kpiCards;
  final VoidCallback onExport;

  static const _textDark = Color(0xFF0F172A);
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
                fontSize: 15,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ExportButton(onPressed: onExport),
                const SizedBox(width: 8),
                _buildMonthlyFilter(),
              ],
            ),
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
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Monthly', style: TextStyle(color: _textDark, fontSize: 12)),
          const SizedBox(width: 4),
          SvgPicture.asset(
            'assets/icons/dropdown_down.svg',
            width: 16,
            height: 16,
            colorFilter: ColorFilter.mode(_textMuted, BlendMode.srcIn),
          ),
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
                  fontSize: 14,
                  color: _textDark,
                ),
              ),
              Text(
                row.revenue,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
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

class _ExportButton extends StatelessWidget {
  const _ExportButton({required this.onPressed});

  final VoidCallback? onPressed;

  static const double _width = 122;
  static const double _height = 40;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(width: 1, color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/icons/download.svg',
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(Color(0xFF0F172A), BlendMode.srcIn),
                ),
                const SizedBox(width: 8),
                const Text(
                  'Export',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
