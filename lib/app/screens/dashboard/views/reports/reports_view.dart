import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:saas/shared/widgets/hover_elevated_card.dart';
import 'package:saas/shared/constants/app_strings.dart';

import 'reports_mobile_view.dart';
import 'reports_tablet_view.dart';
import 'package:saas/shared/constants/app_icons.dart';

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

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _valueBlue = Color(0xFF4F46E5);
  static const _valueRed = Color(0xFFDC2626);
  static const _valueGreen = Color(0xFF16A34A);
  static const _valueBlack = Color(0xFF0F172A);

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
      padding: isMobile
          ? const EdgeInsets.all(16)
          : (isTablet ? const EdgeInsets.all(24) : EdgeInsets.zero),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isMobile),
          const SizedBox(height: 24),
          if (isMobile)
            ReportsMobileView(
              revenueData: _revenueData
                  .map(
                    (e) => RevenueRow(
                      planName: e.planName,
                      totalMembers: e.totalMembers,
                      renewals: e.renewals,
                      missedRenewals: e.missedRenewals,
                      renewalRate: e.renewalRate,
                      revenue: e.revenue,
                    ),
                  )
                  .toList(),
              kpiCards: [
                _kpiCard(
                  title: AppStrings.totalRenewalsTitle,
                  value: '96',
                  valueColor: _valueBlue,
                  description: AppStrings.successfulRenewalsDescription,
                ),
                _kpiCard(
                  title: AppStrings.missedRenewalsTitle,
                  value: '12',
                  valueColor: _valueRed,
                  description: AppStrings.notRenewedAfterExpiryDescription,
                ),
                _kpiCard(
                  title: AppStrings.renewalRateTitle,
                  value: '88%',
                  valueColor: _valueBlack,
                  description: AppStrings.renewalsPlusExpiringDescription,
                ),
                _kpiCard(
                  title: AppStrings.revenueRecoveredTitle,
                  value: '₹ 1,24,000/-',
                  valueColor: _valueGreen,
                  description: AppStrings.fromRenewedSubscriptionsDescription,
                ),
              ],
              onExport: _exportRevenueTableToPdf,
            )
          else if (isTablet)
            ReportsTabletView(
              revenueData: _revenueData
                  .map(
                    (e) => RevenueRow(
                      planName: e.planName,
                      totalMembers: e.totalMembers,
                      renewals: e.renewals,
                      missedRenewals: e.missedRenewals,
                      renewalRate: e.renewalRate,
                      revenue: e.revenue,
                    ),
                  )
                  .toList(),
              kpiCards: [
                _kpiCard(
                  title: AppStrings.totalRenewalsTitle,
                  value: '96',
                  valueColor: _valueBlue,
                  description: AppStrings.successfulRenewalsDescription,
                ),
                _kpiCard(
                  title: AppStrings.missedRenewalsTitle,
                  value: '12',
                  valueColor: _valueRed,
                  description: AppStrings.notRenewedAfterExpiryDescription,
                ),
                _kpiCard(
                  title: AppStrings.renewalRateTitle,
                  value: '88%',
                  valueColor: _valueBlack,
                  description: AppStrings.renewalsPlusExpiringDescription,
                ),
                _kpiCard(
                  title: AppStrings.revenueRecoveredTitle,
                  value: '₹ 1,24,000/-',
                  valueColor: _valueGreen,
                  description: AppStrings.fromRenewedSubscriptionsDescription,
                ),
              ],
              onExport: _exportRevenueTableToPdf,
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
            AppStrings.reportsTitle,
            style: Get.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: _textDark,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.reportsSubtitle,
            style: Get.textTheme.bodySmall?.copyWith(
              color: _textMuted,
              fontWeight: FontWeight.w600,
            ),
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
              AppStrings.reportsTitle,
              style: Get.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppStrings.reportsSubtitle,
              style: Get.textTheme.bodySmall?.copyWith(
                color: _textMuted,
                fontWeight: FontWeight.w600,
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
            title: AppStrings.totalRenewalsTitle,
            value: '96',
            valueColor: _valueBlue,
            description: AppStrings.successfulRenewalsDescription,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _kpiCard(
            title: AppStrings.missedRenewalsTitle,
            value: '12',
            valueColor: _valueRed,
            description: AppStrings.notRenewedAfterExpiryDescription,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _kpiCard(
            title: AppStrings.renewalRateTitle,
            value: '88%',
            valueColor: _textDark,
            description: AppStrings.renewalsPlusExpiringDescription,
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: _kpiCard(
            title: AppStrings.revenueRecoveredTitle,
            value: '₹ 1,24,000/-',
            valueColor: _valueGreen,
            description: AppStrings.fromRenewedSubscriptionsDescription,
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
    return HoverElevatedCard(
      accentColor: valueColor,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: _textMuted,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: valueColor,
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
        ),
      ),
    );
  }

  static const _headerRowColor = Color(0xFFEEF2FF);
  static const _rowBorderColor = Color(0xFFE2E8F0);
  static const _buttonBg = Color(0xFFF1F5F9);
  static const _buttonBorder = Color(0xFFE2E8F0);

  Future<void> _exportRevenueTableToPdf() async {
    final fontData = await rootBundle.load('assets/fonts/Poppins-Regular.ttf');
    final font = pw.Font.ttf(fontData);
    final boldFontData = await rootBundle.load('assets/fonts/Poppins-Bold.ttf');
    final boldFont = pw.Font.ttf(boldFontData);
    final theme = pw.ThemeData.withFont(base: font, bold: boldFont);
    final doc = pw.Document(theme: theme);

    final headers = [
      AppStrings.tableHeaderName,
      AppStrings.tableHeaderTotalMembers,
      AppStrings.renewalsTitle,
      AppStrings.missedRenewalsTitle,
      AppStrings.renewalRateTitle,
      AppStrings.tableHeaderRevenue,
    ];
    final data = _revenueData
        .map(
          (r) => [
            r.planName,
            r.totalMembers,
            r.renewals,
            r.missedRenewals,
            r.renewalRate,
            r.revenue,
          ],
        )
        .toList();

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(24),
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  AppStrings.revenueAnalysisTitle,
                  style: pw.TextStyle(
                    font: boldFont,
                    fontSize: 18,
                    fontWeight: pw.FontWeight.bold,
                  ),
                ),
                pw.SizedBox(height: 16),
                pw.TableHelper.fromTextArray(
                  context: context,
                  headers: headers,
                  data: data,
                  headerStyle: pw.TextStyle(
                    font: boldFont,
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                  ),
                  cellStyle: pw.TextStyle(font: font, fontSize: 10),
                  cellAlignment: pw.Alignment.center,
                  headerAlignment: pw.Alignment.center,
                  cellPadding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  headerPadding: const pw.EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 6,
                  ),
                  border: pw.TableBorder.all(width: 0.5),
                ),
              ],
            ),
          );
        },
      ),
    );

    final bytes = await doc.save();
    await Printing.sharePdf(bytes: bytes, filename: 'Revenue-Analysis.pdf');
  }

  Widget _buildRevenueSection() {
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    AppStrings.revenueAnalysisTitle,
                    style: Get.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                      fontSize: 18,
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _primaryStyleButton(
                        label: AppStrings.exportLabel,
                        iconAsset: AppIcons.download,
                        onPressed: _exportRevenueTableToPdf,
                      ),
                      const SizedBox(width: 10),
                      _primaryStyleButton(
                        label: AppStrings.thisMonthLabel,
                        iconAsset: AppIcons.dropdownDown,
                        onPressed: () {},
                        width: 145,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            _buildRevenueTable(),
          ],
        ),
      ),
    );
  }

  static const double _primaryButtonWidth = 122;
  static const double _primaryButtonHeight = 44;
  static const double _primaryButtonRadius = 10;
  static const Color _primaryButtonBg = Color(0xFFFFFFFF);

  Widget _primaryStyleButton({
    required String label,
    required String iconAsset,
    required VoidCallback onPressed,
    double? width,
  }) {
    return SizedBox(
      width: width ?? _primaryButtonWidth,
      height: _primaryButtonHeight,
      child: Material(
        color: _primaryButtonBg,
        borderRadius: BorderRadius.circular(_primaryButtonRadius),
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(_primaryButtonRadius),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(_primaryButtonRadius),
              border: Border.all(width: 1, color: _buttonBorder),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: Get.textTheme.labelMedium?.copyWith(
                    color: const Color(0xFF0F172A),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(iconAsset, width: 24, height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _outlineButton({
    required String label,
    required Widget icon,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: _buttonBg,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _buttonBorder),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: _textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              icon,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRevenueTable() {
    return Table(
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
          decoration: const BoxDecoration(color: _headerRowColor),
          children: [
            _tableCell(
              AppStrings.tableHeaderPlanName,
              isHeader: true,
              align: Alignment.centerLeft,
              isNameColumn: true,
            ),
            _tableCell(
              AppStrings.tableHeaderTotalMembers,
              isHeader: true,
              align: Alignment.center,
            ),
            _tableCell(
              AppStrings.renewalsTitle,
              isHeader: true,
              align: Alignment.center,
            ),
            _tableCell(
              AppStrings.missedRenewalsTitle,
              isHeader: true,
              align: Alignment.center,
            ),
            _tableCell(
              AppStrings.renewalRateTitle,
              isHeader: true,
              align: Alignment.center,
            ),
            _tableCell(
              AppStrings.tableHeaderRevenue,
              isHeader: true,
              align: Alignment.center,
            ),
          ],
        ),
        ..._revenueData.map(
          (row) => TableRow(
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                bottom: BorderSide(color: _rowBorderColor, width: 1),
              ),
            ),
            children: [
              _tableCell(
                row.planName,
                align: Alignment.centerLeft,
                isNameColumn: true,
              ),
              _tableCell(row.totalMembers, align: Alignment.center),
              _tableCell(row.renewals, align: Alignment.center),
              _tableCell(row.missedRenewals, align: Alignment.center),
              _tableCell(row.renewalRate, align: Alignment.center),
              _tableCell(row.revenue, align: Alignment.center),
            ],
          ),
        ),
      ],
    );
  }

  static const _cellPaddingHorizontal = 16.0;
  static const _cellPaddingVertical = 14.0;
  static const _nameColumnLeftPadding = 24.0;

  Widget _tableCell(
    String text, {
    bool isHeader = false,
    Alignment align = Alignment.center,
    bool isNameColumn = false,
  }) {
    return TableCell(
      verticalAlignment: TableCellVerticalAlignment.middle,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(
          isNameColumn ? _nameColumnLeftPadding : _cellPaddingHorizontal,
          _cellPaddingVertical,
          _cellPaddingHorizontal,
          _cellPaddingVertical,
        ),
        alignment: align,
        child: Text(
          text,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: isHeader ? FontWeight.w600 : FontWeight.w400,
            color: _textDark,
          ),
        ),
      ),
    );
  }
}
