import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../../authentication/widgets/app_constants.dart';
import 'package:saas/shared/constants/app_strings.dart';
import 'package:saas/shared/themes/popup_menu_interaction_theme.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';

import '../../modals/add_member_modal.dart';
import '../../modals/modal_route_helper.dart';
import '../../modals/view_member_modal.dart';
import 'members_mobile_view.dart';
import 'members_tablet_view.dart';
import 'members_controller.dart';
import 'package:saas/shared/constants/app_icons.dart';

/// Members page content: header, search/filters, table, pagination.
/// Used inside the dashboard main content area when Members nav is selected.
class MembersView extends GetView<MembersController> {
  const MembersView({super.key});

  static const _purple = AppConstants.titleColor;
  static const _textDark = AppConstants.textColor;
  static const _textMuted = AppConstants.mutedTextColor;
  static const _expiredBadge = AppConstants.expiredBadgeColor;
  static const _expiringBadge = AppConstants.expiringBadgeColor;
  static const _iconCircleOrange = AppConstants.expiringBadgeColor;
  static const _iconCircleRed = AppConstants.expiredBadgeColor;
  static const _iconCircleGreen = AppConstants.activeBadgeColor;

  static const _planOptions = AppStrings.commonPlanOptions;
  static const _statusOptions = AppStrings.membersStatusOptions;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<MembersController>()) {
      Get.put(MembersController(), permanent: true);
    }
    final width = MediaQuery.sizeOf(context).width;
    final isMobile = width < 600;
    final isTablet = width >= 600 && width < 1024;

    return Obx(() {
      final tableData = List<MemberRow>.from(controller.tableData);
      final isLoading = controller.isLoading.value;
      final errorMessage = controller.errorMessage.value;
      return SingleChildScrollView(
        padding: isMobile
            ? const EdgeInsets.all(16)
            : (isTablet ? const EdgeInsets.all(24) : EdgeInsets.zero),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, isMobile),
            const SizedBox(height: 32),
            _buildSearchRow(context, isMobile, isTablet: isTablet),
            const SizedBox(height: 16),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 48),
                child: Center(child: CircularProgressIndicator()),
              )
            else if (errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  errorMessage,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: const Color(0xFFB91C1C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              )
            else if (tableData.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  AppStrings.membersEmptyState,
                  style: Get.textTheme.bodySmall?.copyWith(
                    color: AppConstants.hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              )
            else if (isMobile)
              MembersMobileView(
                tableData: tableData,
                onOpenViewMember: (row) => _openViewMember(context, row),
              )
            else if (isTablet)
              MembersTabletView(
                tableData: tableData,
                onOpenViewMember: (row) => _openViewMember(context, row),
              )
            else
              _buildDesktopTable(context, tableData),
            const SizedBox(height: 16),
            if (tableData.isNotEmpty) _buildPagination(isMobile),
          ],
        ),
      );
    });
  }

  Widget _buildHeader(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppStrings.membersTitle,
                    style: Get.textTheme.bodyLarge?.copyWith(color: _textDark),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    AppStrings.membersSubtitle,
                    style: Get.textTheme.bodySmall?.copyWith(
                      color: _textMuted,
                      fontWeight: FontWeight.w600,
                      fontSize: isMobile ? 13 : 14,
                    ),
                  ),
                ],
              ),
            ),
            if (!isMobile)
              PrimaryActionButton(
                label: AppStrings.addMember,
                onPressed: () =>
                    openModalWithTransition(context, const AddMemberModal()),
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: AppStrings.addMember,
              onPressed: () =>
                  openModalWithTransition(context, const AddMemberModal()),
              useFixedSize: false,
            ),
          ),
        ],
      ],
    );
  }

  // Tablet mode gets the wider search box, while web/desktop should stay compact.
  static const _searchFieldWidthWeb = 360.0;
  static const _searchFieldWidthTablet = 900.0;
  static const _dropdownWidthTablet = 132.0;
  static const _dropdownHeightTablet = 40.0;

  Widget _buildSearchRow(
    BuildContext context,
    bool isMobile, {
    bool isTablet = false,
  }) {
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
              style: const TextStyle(fontSize: 14, color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: AppStrings.searchByNameOrPhoneShort,
                hintStyle: const TextStyle(
                  color: AppConstants.hintColor,
                  fontSize: 13,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: SvgPicture.asset(
                    AppIcons.search,
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      AppConstants.slateMutedColor,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                prefixIconConstraints: const BoxConstraints(
                  minWidth: 40,
                  minHeight: 24,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 11),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildFilterDropdown(
                  context: context,
                  label: AppStrings.status,
                  selected: controller.selectedStatus.value,
                  options: _statusOptions,
                  onSelected: controller.setSelectedStatus,
                  width: 169,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFilterDropdown(
                  context: context,
                  label: AppStrings.plan,
                  selected: controller.selectedPlan.value,
                  options: _planOptions,
                  onSelected: controller.setSelectedPlan,
                  width: 169,
                ),
              ),
            ],
          ),
        ],
      );
    }
    final searchField = Container(
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

    return Row(
      children: [
        if (isTablet)
          Expanded(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: _searchFieldWidthTablet,
              ),
              child: searchField,
            ),
          )
        else
          SizedBox(width: _searchFieldWidthWeb, child: searchField),
        if (!isTablet) const Spacer(),
        const SizedBox(width: 20),
        _buildFilterDropdown(
          context: context,
          label: AppStrings.status,
          selected: controller.selectedStatus.value,
          options: _statusOptions,
          onSelected: controller.setSelectedStatus,
          width: isTablet ? _dropdownWidthTablet : 169,
          height: isTablet ? _dropdownHeightTablet : null,
        ),
        const SizedBox(width: 16),
        _buildFilterDropdown(
          context: context,
          label: AppStrings.plan,
          selected: controller.selectedPlan.value,
          options: _planOptions,
          onSelected: controller.setSelectedPlan,
          width: isTablet ? _dropdownWidthTablet : 169,
          height: isTablet ? _dropdownHeightTablet : null,
        ),
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

  Widget _buildFilterDropdown({
    required BuildContext context,
    required String label,
    required String? selected,
    required List<String> options,
    required ValueChanged<String> onSelected,
    double? width,
    double? height,
  }) {
    final display = selected ?? label;
    final h = height ?? 44;
    final menuWidth = width ?? 169;
    final isStatusDropdown = label == AppStrings.status;
    return Theme(
      data: popupMenuInteractionTheme(context),
      child: PopupMenuButton<String>(
        onSelected: onSelected,
        color: Colors.white,
        elevation: 8,
        position: PopupMenuPosition.under,
        offset: const Offset(0, 4),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        constraints: BoxConstraints.tightFor(width: menuWidth),
        itemBuilder: (context) => options.asMap().entries.map((entry) {
          final value = entry.value;
          final isLast = entry.key == options.length - 1;
          return PopupMenuItem<String>(
            value: value,
            height: 52,
            child: Container(
              width: menuWidth,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
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
                style: Get.textTheme.labelMedium?.copyWith(
                  color: isStatusDropdown
                      ? controller.statusColor(value)
                      : const Color(0xFF64748B),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1,
                ),
              ),
            ),
          );
        }).toList(),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            width: width,
            height: h,
            padding: EdgeInsets.symmetric(horizontal: h <= 40 ? 12 : 16),
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
                    color: selected != null
                        ? (isStatusDropdown
                              ? controller.statusColor(selected)
                              : AppConstants.textColor)
                        : AppConstants.hintColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 8),
                SvgPicture.asset(AppIcons.dropdownDown, width: 24, height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static const _tableBorderRadius = 12.0;

  Widget _buildDesktopTable(BuildContext context, List<MemberRow> tableData) {
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
            0: FlexColumnWidth(1.5),
            1: FlexColumnWidth(1.4),
            2: FlexColumnWidth(1.8),
            3: FlexColumnWidth(0.9),
            4: FlexColumnWidth(1.1),
            5: FlexColumnWidth(1),
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
                  AppStrings.tableHeaderEmailAddress,
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell(
                  AppStrings.plan,
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell(
                  AppStrings.tableHeaderExpiryDate,
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell(
                  AppStrings.status,
                  isHeader: true,
                  align: Alignment.center,
                ),
              ],
            ),
            ...tableData.asMap().entries.map(
              (entry) => TableRow(
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
                  _tapableCell(
                    context,
                    entry.value,
                    entry.value.name,
                    align: Alignment.centerLeft,
                    isNameColumn: true,
                  ),
                  _tapableCell(
                    context,
                    entry.value,
                    entry.value.phone,
                    align: Alignment.center,
                  ),
                  _tapableCell(
                    context,
                    entry.value,
                    entry.value.email,
                    align: Alignment.center,
                  ),
                  _tapableCell(
                    context,
                    entry.value,
                    entry.value.plan,
                    align: Alignment.center,
                  ),
                  _tapableCell(
                    context,
                    entry.value,
                    entry.value.expiry,
                    align: Alignment.center,
                  ),
                  _tapableCell(
                    context,
                    entry.value,
                    _statusPill(entry.value.status),
                    align: Alignment.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openViewMember(BuildContext context, MemberRow row) {
    final (String label, Color color) = switch (row.status) {
      MemberStatus.active => (AppStrings.active, _iconCircleGreen),
      MemberStatus.expired => (AppStrings.expired, _iconCircleRed),
      MemberStatus.expiring => (AppStrings.expiring, _iconCircleOrange),
    };
    openModalWithTransition(
      context,
      ViewMemberModal(
        member: ViewMemberData(
          name: row.name,
          phone: row.phone,
          email: row.email,
          plan: row.plan,
          expiry: row.expiry,
          statusLabel: label,
          statusColor: color,
        ),
      ),
    );
  }

  Widget _tapableCell(
    BuildContext context,
    MemberRow row,
    dynamic content, {
    Alignment align = Alignment.centerLeft,
    bool isNameColumn = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openViewMember(context, row),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: _tableCell(content, align: align, isNameColumn: isNameColumn),
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

  Widget _statusPill(MemberStatus status) {
    final (String label, Color bg, Color textColor) = switch (status) {
      MemberStatus.active => (
        AppStrings.active,
        _iconCircleGreen,
        AppConstants.activeBadgeTextColor,
      ),
      MemberStatus.expired => (
        AppStrings.expired,
        _expiredBadge,
        AppConstants.expiredBadgeTextColor,
      ),
      MemberStatus.expiring => (
        AppStrings.expiring,
        _expiringBadge,
        AppConstants.expiringBadgeTextColor,
      ),
    };
    return Container(
      width: 92,
      height: 32,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        label,
        style: Get.textTheme.labelMedium?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      ),
    );
  }

  Widget _buildPagination(bool isMobile) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _paginationButton(Icons.chevron_left, false),
        const SizedBox(width: 24),
        Text(
          AppStrings.paginationMembers,
          style: Get.textTheme.bodySmall?.copyWith(
            color: AppConstants.slateMutedColor,
            fontSize: isMobile ? 12 : 14,
          ),
        ),
        const SizedBox(width: 24),
        _paginationButton(Icons.chevron_right, true),
      ],
    );
  }

  Widget _paginationButton(IconData icon, bool isActive) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? _purple : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: isActive
                ? null
                : Border.all(color: AppConstants.borderColor),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isActive ? Colors.white : AppConstants.slateMutedColor,
            size: 20,
          ),
        ),
      ),
    );
  }
}
