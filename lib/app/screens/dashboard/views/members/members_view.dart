import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';

import '../../modals/add_member_modal.dart';
import '../../modals/view_member_modal.dart';
import 'members_mobile_view.dart';
import 'members_tablet_view.dart';

/// Members page content: header, search/filters, table, pagination.
/// Used inside the dashboard main content area when Members nav is selected.
class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  static const _purple = Color(0xFF4F46E5);
  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _iconCircleOrange = Color(0xFFFEF3C7);
  static const _iconCircleRed = Color(0xFFFEE2E2);
  static const _iconCircleGreen = Color(0xFFDCFCE7);

  final _planDropdownKey = GlobalKey();
  final _statusDropdownKey = GlobalKey();

  String? _selectedPlan;
  String? _selectedStatus;

  static const _planOptions = ['Monthly', 'Quarterly', 'Yearly'];
  static const _statusOptions = ['Active', 'Expiring', 'Expired'];
  static const _statusColors = [
    Color(0xFF166534), // Active text
    Color(0xFF92400E), // Expiring text
    Color(0xFF991B1B), // Expired text
  ];

  static final _tableData = [
    MemberRow(
      name: 'Rahul Kamath',
      phone: '+91 98642 13565',
      email: 'rahul.kamath@gmail.com',
      plan: 'Yearly',
      expiry: '08/07/2027',
      status: MemberStatus.active,
    ),
    MemberRow(
      name: 'Mithun Shetty',
      phone: '+91 98642 13565',
      email: 'mithunshetty96@gmail.com',
      plan: 'Quarterly',
      expiry: '31/12/2025',
      status: MemberStatus.expired,
    ),
    MemberRow(
      name: 'Vishal AV',
      phone: '+91 98642 13565',
      email: 'vishal.av@gmail.com',
      plan: 'Monthly',
      expiry: '02/02/2026',
      status: MemberStatus.expiring,
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
          const SizedBox(height: 32),
          _buildSearchRow(isMobile, isTablet: isTablet),
          const SizedBox(height: 16),
          if (isMobile)
            MembersMobileView(
              tableData: _tableData,
              onOpenViewMember: _openViewMember,
            )
          else if (isTablet)
            MembersTabletView(
              tableData: _tableData,
              onOpenViewMember: _openViewMember,
            )
          else
            _buildDesktopTable(),
          const SizedBox(height: 16),
          _buildPagination(isMobile),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isMobile) {
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
                    'Members',
                    style: Get.textTheme.bodyLarge?.copyWith(color: _textDark),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Manage all your members and their subscriptions',
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
                label: 'Add Member',
                onPressed: () => Get.dialog(const AddMemberModal()),
              ),
          ],
        ),
        if (isMobile) ...[
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: PrimaryActionButton(
              label: 'Add Member',
              onPressed: () => Get.dialog(const AddMemberModal()),
              useFixedSize: false,
            ),
          ),
        ],
      ],
    );
  }

  static const _searchFieldWidth = 320.0;
  static const _searchFieldWidthTablet = 480.0;

  Widget _buildSearchRow(bool isMobile, {bool isTablet = false}) {
    if (isMobile) {
      return Column(
        children: [
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            ),
            child: TextField(
              style: const TextStyle(fontSize: 14, color: Colors.black),
              cursorColor: Colors.black,
              decoration: InputDecoration(
                hintText: 'Search by name or phone',
                hintStyle: const TextStyle(
                  color: Color(0xFF94A3B8),
                  fontSize: 13,
                ),
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(left: 12, right: 8),
                  child: SvgPicture.asset(
                    'assets/icons/search.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(
                      Color(0xFF64748B),
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
                  key: _statusDropdownKey,
                  label: 'Status',
                  selected: _selectedStatus,
                  onTap: _showStatusMenu,
                  width: 169,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFilterDropdown(
                  key: _planDropdownKey,
                  label: 'Plan',
                  selected: _selectedPlan,
                  onTap: _showPlanMenu,
                  width: 169,
                ),
              ),
            ],
          ),
        ],
      );
    }
    return Row(
      children: [
        Flexible(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: isTablet ? _searchFieldWidthTablet : _searchFieldWidth,
            ),
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
                  color: const Color(0xFF0F172A),
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search by name or phone number',
                  hintStyle: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 14,
                  ),
                  prefixIcon: Padding(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    child: SvgPicture.asset(
                      'assets/icons/search.svg',
                      width: 20,
                      height: 20,
                      colorFilter: const ColorFilter.mode(
                        Color(0xFF64748B),
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
          ),
        ),
        const Spacer(),
        _buildFilterDropdown(
          key: _statusDropdownKey,
          label: 'Status',
          selected: _selectedStatus,
          onTap: _showStatusMenu,
          width: 169,
        ),
        const SizedBox(width: 16),
        _buildFilterDropdown(
          key: _planDropdownKey,
          label: 'Plan',
          selected: _selectedPlan,
          onTap: _showPlanMenu,
          width: 169,
        ),
        const SizedBox(width: 16),
        TextButton(
          onPressed: () {},
          child: Text(
            'Clear Filters',
            style: Get.textTheme.labelMedium?.copyWith(
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  double _dropdownTriggerWidth(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) return box.size.width;
    return 169;
  }

  RelativeRect _dropdownPosition(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
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
    final menuWidth = _dropdownTriggerWidth(_planDropdownKey);
    final result = await showMenu<String>(
      context: context,
      position: _dropdownPosition(_planDropdownKey),
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
                      bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
            ),
            child: Text(
              value,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF334155),
                fontSize: 14,
              ),
            ),
          ),
        );
      }).toList(),
    );
    if (result != null) setState(() => _selectedPlan = result);
  }

  Future<void> _showStatusMenu() async {
    final menuWidth = _dropdownTriggerWidth(_statusDropdownKey);
    final result = await showMenu<String>(
      context: context,
      position: _dropdownPosition(_statusDropdownKey),
      constraints: BoxConstraints.tightFor(width: menuWidth),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 8,
      items: List.generate(_statusOptions.length, (i) {
        final value = _statusOptions[i];
        final color = _statusColors[i];
        final isLast = i == _statusOptions.length - 1;
        return PopupMenuItem<String>(
          value: value,
          child: Container(
            width: menuWidth,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                    ),
            ),
            child: Text(
              value,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: color,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        );
      }),
    );
    if (result != null) setState(() => _selectedStatus = result);
  }

  Widget _buildFilterDropdown({
    required GlobalKey key,
    required String label,
    required String? selected,
    required VoidCallback onTap,
    double? width,
  }) {
    final display = selected ?? label;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          key: key,
          width: width,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE2E8F0)),
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
                      ? const Color(0xFF0F172A)
                      : const Color(0xFF94A3B8),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              SvgPicture.asset(
                'assets/icons/dropdown_down.svg',
                width: 24,
                height: 24,
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
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
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
              decoration: const BoxDecoration(color: Color(0xFFEEF2FF)),
              children: [
                _tableCell(
                  'Name',
                  isHeader: true,
                  align: Alignment.centerLeft,
                  isNameColumn: true,
                ),
                _tableCell(
                  'Phone Number',
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell(
                  'Email Address',
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell('Plan', isHeader: true, align: Alignment.center),
                _tableCell(
                  'Expiry Date',
                  isHeader: true,
                  align: Alignment.center,
                ),
                _tableCell('Status', isHeader: true, align: Alignment.center),
              ],
            ),
            ..._tableData.asMap().entries.map(
              (entry) => TableRow(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  border: Border(
                    bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
                  ),
                ),
                children: [
                  _tapableCell(
                    entry.value,
                    entry.value.name,
                    align: Alignment.centerLeft,
                    isNameColumn: true,
                  ),
                  _tapableCell(
                    entry.value,
                    entry.value.phone,
                    align: Alignment.center,
                  ),
                  _tapableCell(
                    entry.value,
                    entry.value.email,
                    align: Alignment.center,
                  ),
                  _tapableCell(
                    entry.value,
                    entry.value.plan,
                    align: Alignment.center,
                  ),
                  _tapableCell(
                    entry.value,
                    entry.value.expiry,
                    align: Alignment.center,
                  ),
                  _tapableCell(
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

  void _openViewMember(MemberRow row) {
    final (String label, Color color) = switch (row.status) {
      MemberStatus.active => ('Active', _iconCircleGreen),
      MemberStatus.expired => ('Expired', _iconCircleRed),
      MemberStatus.expiring => ('Expiring', _iconCircleOrange),
    };
    Get.dialog(
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
    MemberRow row,
    dynamic content, {
    Alignment align = Alignment.centerLeft,
    bool isNameColumn = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openViewMember(row),
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
        'Active',
        _iconCircleGreen,
        const Color(0xFF166534),
      ),
      MemberStatus.expired => (
        'Expired',
        _expiredBadge,
        const Color(0xFF991B1B),
      ),
      MemberStatus.expiring => (
        'Expiring',
        _expiringBadge,
        const Color(0xFF92400E),
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
          'Showing 1-10 of 248 members',
          style: Get.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF64748B),
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
                : Border.all(color: const Color(0xFFE2E8F0)),
          ),
          alignment: Alignment.center,
          child: Icon(
            icon,
            color: isActive ? Colors.white : const Color(0xFF64748B),
            size: 20,
          ),
        ),
      ),
    );
  }
}
