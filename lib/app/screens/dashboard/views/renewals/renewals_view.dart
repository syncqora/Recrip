import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../../../../shared/widgets/success_toast.dart';
import '../../../authentication/widgets/app_constants.dart';
import 'package:saas/shared/constants/app_strings.dart';
import '../../modals/add_member_modal.dart';
import 'renewals_mobile_view.dart';
import 'renewals_tablet_view.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/utils/app_date_picker.dart';

/// Renewals page content: header, status tabs, search/filters, table.
/// Used inside the dashboard main content area when Renewals nav is selected.
class RenewalsView extends StatefulWidget {
  const RenewalsView({super.key});

  @override
  State<RenewalsView> createState() => _RenewalsViewState();
}

class _RenewalsViewState extends State<RenewalsView> {
  static const _purple = AppConstants.titleColor;
  static const _textDark = AppConstants.textColor;
  static const _textMuted = AppConstants.mutedTextColor;
  static const _border = AppConstants.softBorderColor;
  static const _headerBg = AppConstants.headerBackgroundColor;

  /// Light orange/yellow for "Expiring" badge
  static const _expiringBadge = AppConstants.expiringBadgeColor;

  /// Light red for "Expired" badge
  static const _expiredBadge = AppConstants.expiredBadgeColor;
  static const _expiredTextRed = AppConstants.dangerTextColor;
  static const _renewedBadge = AppConstants.renewedBadgeColor;
  static const _renewedText = AppConstants.renewedBadgeTextColor;

  int _selectedTabIndex = 0;
  static const _statusTabs = AppStrings.renewalsStatusTabs;

  final _planDropdownKey = GlobalKey();
  String? _selectedPlan;
  static const _planOptions = AppStrings.commonPlanOptions;

  DateTime? _selectedDate;

  static final _tableData = [
    RenewalRow(
      name: 'Vishal A V',
      phone: '+91 98642 13565',
      expiryDate: '15/02/2026',
      daysLeft: 7,
      plan: 'Monthly',
      status: RenewalStatus.expiring,
    ),
    RenewalRow(
      name: 'Rahul Kamath',
      phone: '+91 98642 13565',
      expiryDate: '01/01/2026',
      daysLeft: 0,
      plan: 'Quarterly',
      status: RenewalStatus.expired,
    ),
    RenewalRow(
      name: 'Vishal A V',
      phone: '+91 98642 13565',
      expiryDate: '15/02/2026',
      daysLeft: 7,
      plan: 'Monthly',
      status: RenewalStatus.expiring,
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
          _buildHeader(),
          const SizedBox(height: 32),
          _buildStatusTabs(isMobile),
          const SizedBox(height: 32),
          _buildSearchRow(isMobile, isTablet: isTablet),
          const SizedBox(height: 32),
          if (isMobile)
            RenewalsMobileView(tableData: _tableData)
          else if (isTablet)
            RenewalsTabletView(tableData: _tableData)
          else
            _buildDesktopTable(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.renewalsTitle,
          style: Get.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: _textDark,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.renewalsSubtitle,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: _textMuted,
          ),
        ),
      ],
    );
  }

  static const _statusTabsWidth = 520.0;
  static const _statusTabsHeight = 44.0;
  static const _segmentBorderRadius = 12.0;

  /// Outer border of the status tabs - darker grey so 1px border is clearly visible
  static const _tabDividerColor = AppConstants.dividerColor;

  /// Vertical dividers between segments
  static const _tabSegmentDividerColor = AppConstants.dividerColor;

  /// Width of the "All" tab segment (smaller than the others)
  static const _allTabWidth = 72.0;

  Widget _buildStatusTabs(bool isMobile) {
    return Container(
      width: isMobile ? double.infinity : _statusTabsWidth,
      height: _statusTabsHeight,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(_segmentBorderRadius)),
        border: Border.all(color: _tabDividerColor, width: 1),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(_segmentBorderRadius)),
        child: Row(
          children: [
            for (int i = 0; i < _statusTabs.length; i++) ...[
              if (i > 0)
                Container(
                  width: 1,
                  color: _tabSegmentDividerColor,
                  height: _statusTabsHeight,
                ),
              if (i == 0)
                SizedBox(
                  width: _allTabWidth,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => _selectedTabIndex = i),
                      child: Container(
                        height: _statusTabsHeight,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8 : 12,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == i
                              ? _purple
                              : Colors.white,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _statusTabs[i],
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: _selectedTabIndex == i
                                  ? Colors.white
                                  : _textDark,
                              fontWeight: _selectedTabIndex == i
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () => setState(() => _selectedTabIndex = i),
                      child: Container(
                        height: _statusTabsHeight,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 8 : 12,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedTabIndex == i
                              ? _purple
                              : Colors.white,
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            _statusTabs[i],
                            maxLines: 1,
                            softWrap: false,
                            overflow: TextOverflow.ellipsis,
                            style: Get.textTheme.bodySmall?.copyWith(
                              color: _selectedTabIndex == i
                                  ? Colors.white
                                  : _textDark,
                              fontWeight: _selectedTabIndex == i
                                  ? FontWeight.w600
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  // Tablet gets a wider search box; web/desktop should stay compact.
  static const _searchFieldWidthWeb = 360.0;
  static const _searchFieldWidthTablet = 900.0;

  Widget _buildSearchRow(bool isMobile, {required bool isTablet}) {
    if (isMobile) {
      return Column(
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppConstants.borderColor, width: 1),
            ),
            child: TextField(
              cursorColor: Colors.black,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppConstants.textColor,
                fontSize: 14,
              ),
              decoration: InputDecoration(
                hintText: AppStrings.searchByNameOrPhoneShort,
                hintStyle: const TextStyle(
                  color: AppConstants.hintColor,
                  fontSize: 14,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 14, right: 10),
                  child: SvgPicture.asset(
                    AppIcons.search,
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(
                      AppConstants.slateMutedColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 44,
                  minHeight: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
                isDense: true,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildSelectDatesFilterBox()),
              const SizedBox(width: 8),
              Expanded(child: _buildPlanFilterBox(isMobile: true)),
            ],
          ),
        ],
      );
    }
    return Row(
      children: [
        if (isTablet)
          Flexible(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _searchFieldWidthTablet,
              ),
              child: _buildDesktopSearchField(),
            ),
          )
        else
          SizedBox(
            width: _searchFieldWidthWeb,
            child: _buildDesktopSearchField(),
          ),
        if (!isTablet) const Spacer(),
        _buildSelectDatesFilterBox(),
        const SizedBox(width: 16),
        _buildPlanFilterBox(isMobile: false),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {},
          child: Text(
            AppStrings.clearFilters,
            style: Get.textTheme.labelMedium?.copyWith(
              color: AppConstants.hintColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDesktopSearchField() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppConstants.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        cursorColor: Colors.black,
        style: Get.textTheme.bodyMedium?.copyWith(
          color: AppConstants.textColor,
          fontSize: 14,
        ),
        decoration: InputDecoration(
          hintText: AppStrings.searchByNameOrPhoneLong,
          hintStyle: const TextStyle(
            color: AppConstants.hintColor,
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: SvgPicture.asset(
              AppIcons.search,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppConstants.slateMutedColor,
                BlendMode.srcIn,
              ),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 24,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.fromLTRB(0, 14, 16, 14),
          isDense: true,
        ),
      ),
    );
  }

  Widget _buildFilterBox(
    String label,
    IconData icon, {
    bool isDropdown = false,
  }) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!isDropdown) Icon(icon, size: 18, color: _textMuted),
          if (!isDropdown) const SizedBox(width: 8),
          Text(
            label,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: _textMuted,
              fontSize: 13,
            ),
          ),
          if (isDropdown) const SizedBox(width: 8),
          if (isDropdown) Icon(icon, size: 18, color: _textMuted),
        ],
      ),
    );
  }

  static const _selectDatesBoxWidth = 169.0;

  Future<void> _pickDate() async {
    final date = await showAppDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      helpText: AppStrings.selectDate,
    );
    if (date != null) setState(() => _selectedDate = date);
  }

  String get _formattedSelectedDate {
    if (_selectedDate == null) return AppStrings.selectDates;
    final d = _selectedDate!;
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  Widget _buildSelectDatesFilterBox() {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _pickDate,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: _selectDatesBoxWidth,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppConstants.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _formattedSelectedDate,
                style: Get.textTheme.labelMedium?.copyWith(
                  color: _selectedDate != null
                      ? AppConstants.textColor
                      : AppConstants.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                AppIcons.calendarDays,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppConstants.slateMutedColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _planDropdownTriggerWidth() {
    final box =
        _planDropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) return box.size.width;
    return 169;
  }

  RelativeRect _planDropdownPosition() {
    final box =
        _planDropdownKey.currentContext?.findRenderObject() as RenderBox?;
    final size = MediaQuery.sizeOf(context);
    if (box == null || !box.hasSize) {
      return RelativeRect.fromLTRB(
        24,
        200,
        size.width - 200,
        size.height - 300,
      );
    }
    final pos = box.localToGlobal(Offset.zero);
    final top = pos.dy + box.size.height + 4;
    return RelativeRect.fromLTRB(
      pos.dx,
      top,
      size.width - pos.dx - box.size.width,
      size.height - top,
    );
  }

  Future<void> _showPlanMenu() async {
    final menuWidth = _planDropdownTriggerWidth();
    final result = await showMenu<String>(
      context: context,
      position: _planDropdownPosition(),
      constraints: BoxConstraints.tightFor(width: menuWidth),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 8,
      items: _planOptions.asMap().entries.map((entry) {
        final value = entry.value;
        final isLast = entry.key == _planOptions.length - 1;
        return PopupMenuItem<String>(
          value: value,
          child: Container(
            width: menuWidth,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(
                        color: AppConstants.borderColor,
                        width: 1,
                      ),
                    ),
            ),
            child: Text(
              value,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: AppConstants.slate700Color,
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
    if (result != null) setState(() => _selectedPlan = result);
  }

  Widget _buildPlanFilterBox({required bool isMobile}) {
    const planBoxWidth = 169.0;
    final display = _selectedPlan ?? AppStrings.plan;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _showPlanMenu,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          key: _planDropdownKey,
          width: planBoxWidth,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppConstants.borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                display,
                style: Get.textTheme.labelMedium?.copyWith(
                  color: _selectedPlan != null
                      ? AppConstants.textColor
                      : AppConstants.hintColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                AppIcons.dropdownDown,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  AppConstants.slateMutedColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static const _tableBorderRadius = 12.0;

  Widget _buildDesktopTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(_tableBorderRadius)),
        border: Border.all(color: AppConstants.borderColor, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(_tableBorderRadius),
        child: Table(
          columnWidths: const {
            0: FlexColumnWidth(1.2),
            1: FlexColumnWidth(1.3),
            2: FlexColumnWidth(1),
            3: FlexColumnWidth(0.8),
            4: FlexColumnWidth(0.9),
            5: FlexColumnWidth(1),
            6: FlexColumnWidth(0.9),
          },
          children: [
            TableRow(
              decoration: const BoxDecoration(
                color: AppConstants.tableHeaderBackgroundColor,
              ),
              children: [
                _tableCell(
                  AppStrings.tableHeaderName,
                  isHeader: true,
                  align: Alignment.centerLeft,
                  isNameColumn: true,
                ),
                _tableCell(
                  AppStrings.tableHeaderPhoneNumber,
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell(
                  AppStrings.tableHeaderExpiryDate,
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell(
                  AppStrings.tableHeaderDaysLeft,
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell(
                  AppStrings.plan,
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell(
                  AppStrings.status,
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell(
                  AppStrings.tableHeaderAction,
                  isHeader: true,
                  align: Alignment.center,
                ),
              ],
            ),
            ..._tableData.map(
              (row) => TableRow(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(
                      color: AppConstants.borderColor,
                      width: 1,
                    ),
                  ),
                ),
                children: [
                  _tableCell(
                    row.name,
                    align: Alignment.centerLeft,
                    isNameColumn: true,
                  ),
                  _tableCell(row.phone, align: Alignment.center),
                  _tableCell(row.expiryDate, align: Alignment.center),
                  _tableCell(
                    Text(
                      row.daysLeft == 0
                          ? '0'
                          : row.daysLeft.toString().padLeft(2, '0'),
                      style: Get.textTheme.bodySmall?.copyWith(
                        color: row.daysLeft == 0 ? _expiredTextRed : _textDark,
                        fontWeight: row.daysLeft == 0 ? FontWeight.w600 : null,
                        fontSize: 14,
                      ),
                    ),
                    align: Alignment.center,
                  ),
                  _tableCell(row.plan, align: Alignment.center),
                  _tableCell(_statusPill(row.status), align: Alignment.center),
                  _tableCell(_actionIcons(row), align: Alignment.center),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static const _nameColumnLeftPadding = 40.0;
  static const _cellPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 14,
  );

  Widget _tableCell(
    dynamic content, {
    bool isHeader = false,
    Alignment align = Alignment.centerLeft,
    bool isNameColumn = false,
  }) {
    final padding = isNameColumn
        ? EdgeInsets.fromLTRB(
            _cellPadding.left + _nameColumnLeftPadding,
            _cellPadding.top,
            _cellPadding.right,
            _cellPadding.bottom,
          )
        : _cellPadding;
    return Padding(
      padding: padding,
      child: Align(
        alignment: align,
        child: content is String
            ? Text(
                content as String,
                style: Get.textTheme.bodySmall?.copyWith(
                  fontWeight: isHeader ? FontWeight.w500 : FontWeight.normal,
                  color: _textDark,
                  fontSize: 14,
                ),
              )
            : content as Widget,
      ),
    );
  }

  static const _statusPillWidth = 92.0;
  static const _statusPillHeight = 32.0;

  Widget _statusPill(RenewalStatus status) {
    final (String label, Color bg, Color textColor) = switch (status) {
      RenewalStatus.expiring => (
        AppStrings.expiring,
        _expiringBadge,
        AppConstants.expiringBadgeTextColorDark,
      ),
      RenewalStatus.expired => (
        AppStrings.expired,
        _expiredBadge,
        _expiredTextRed,
      ),
      RenewalStatus.renewed => (
        AppStrings.renewed,
        _renewedBadge,
        _renewedText,
      ),
    };
    return Container(
      width: _statusPillWidth,
      height: _statusPillHeight,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Text(
        label,
        style: Get.textTheme.bodySmall?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _actionIcons(RenewalRow row) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _actionIcon(
          AppIcons.renew,
          onTap: () => Get.dialog(
            AddMemberModal(
              initialFullName: row.name,
              initialPhone: row.phone,
              initialPlan: row.plan,
            ),
          ),
        ),
        _actionIcon(
          AppIcons.bellRing,
          onTap: () => SuccessToast.show(
            context,
            title: AppStrings.reminderSentTo(row.name),
            popRoute: false,
          ),
        ),
      ],
    );
  }

  Widget _actionIcon(String assetPath, {VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: AppConstants.tableHeaderBackgroundColor,
              shape: BoxShape.circle,
            ),
            padding: const EdgeInsets.all(6),
            child: SvgPicture.asset(
              assetPath,
              width: 18,
              height: 18,
              colorFilter: const ColorFilter.mode(_textMuted, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );
  }
}
