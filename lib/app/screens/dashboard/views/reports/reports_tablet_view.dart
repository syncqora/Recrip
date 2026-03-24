import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/widgets/report_period_dropdown.dart';
import 'reports_mobile_view.dart';
import 'package:saas/shared/constants/app_icons.dart';

class ReportsTabletView extends StatelessWidget {
  const ReportsTabletView({
    super.key,
    required this.revenueData,
    required this.kpiCards,
    required this.onExport,
  });

  final List<RevenueRow> revenueData;
  final List<Widget> kpiCards;
  final VoidCallback onExport;

  static const _textDark = Color(0xFF0F172A);
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
              AppStrings.revenueAnalysisTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: _textDark,
                fontSize: 18,
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ExportButton(onPressed: onExport),
                const SizedBox(width: 8),
                const ReportPeriodDropdown(width: 132, height: 40),
              ],
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
              _tableCell(AppStrings.tableHeaderPlanName, isHeader: true),
              _tableCell(AppStrings.tableHeaderTotalMembers, isHeader: true),
              _tableCell(AppStrings.renewalsTitle, isHeader: true),
              _tableCell(AppStrings.missedRenewalsTitle, isHeader: true),
              _tableCell(AppStrings.renewalRateTitle, isHeader: true),
              _tableCell(AppStrings.tableHeaderRevenue, isHeader: true),
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

class _ExportButton extends StatelessWidget {
  const _ExportButton({required this.onPressed});

  final VoidCallback onPressed;

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
                  AppIcons.download,
                  width: 18,
                  height: 18,
                  colorFilter: ColorFilter.mode(
                    const Color(0xFF0F172A),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 8),
                const Text(
                  AppStrings.exportLabel,
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
