import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'add_member_modal.dart';
import 'view_member_modal.dart';

enum MemberStatus { active, expired, expiring }

class _MemberRow {
  final String name;
  final String phone;
  final String email;
  final String plan;
  final String expiry;
  final MemberStatus status;

  _MemberRow({
    required this.name,
    required this.phone,
    required this.email,
    required this.plan,
    required this.expiry,
    required this.status,
  });
}

/// Members page content: header, search/filters, table, pagination.
/// Used inside the dashboard main content area when Members nav is selected.
class MembersView extends StatefulWidget {
  const MembersView({super.key});

  @override
  State<MembersView> createState() => _MembersViewState();
}

class _MembersViewState extends State<MembersView> {
  static const _purple = Color(0xFF4F46E5);
  static const _textDark = Color(0xFF333333);
  static const _textMuted = Color(0xFF666666);
  static const _border = Color(0xFFE5E7EB);
  static const _iconCircleOrange = Color(0xFFF59E0B);
  static const _iconCircleRed = Color(0xFFDC2626);
  static const _iconCircleGreen = Color(0xFF16A34A);

  final _planDropdownKey = GlobalKey();
  final _statusDropdownKey = GlobalKey();

  String? _selectedPlan;
  String? _selectedStatus;

  static const _planOptions = ['Monthly', 'Quarterly', 'Yearly'];
  static const _statusOptions = ['Active', 'Expiring', 'Expired'];
  static const _statusColors = [
    _iconCircleGreen,  // Active
    Color(0xFFB45309), // Expiring (orange-brown)
    _iconCircleRed,    // Expired
  ];

  static final _tableData = [
    _MemberRow(
      name: 'Rahul Kamath',
      phone: '+91 98642 13565',
      email: 'rahul.kamath@gmail.com',
      plan: 'Yearly',
      expiry: '08/07/2027',
      status: MemberStatus.active,
    ),
    _MemberRow(
      name: 'Mithun Shetty',
      phone: '+91 98642 13565',
      email: 'mithunshetty96@gmail.com',
      plan: 'Quarterly',
      expiry: '31/12/2025',
      status: MemberStatus.expired,
    ),
    _MemberRow(
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
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 20),
          _buildSearchRow(),
          const SizedBox(height: 16),
          _buildTable(),
          const SizedBox(height: 16),
          _buildPagination(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Members',
              style: Get.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage all your members and their subscriptions',
              style: Get.textTheme.bodyMedium?.copyWith(color: _textMuted),
            ),
          ],
        ),
        FilledButton(
          onPressed: () => Get.dialog(const AddMemberModal()),
          style: FilledButton.styleFrom(
            backgroundColor: _purple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text('Add Member'),
        ),
      ],
    );
  }

  static const _searchFieldWidth = 380.0;

  Widget _buildSearchRow() {
    return Row(
      children: [
        SizedBox(
          width: _searchFieldWidth,
          child: Container(
            height: 44,
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
            child: TextField(
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
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(left: 14, right: 10),
                  child: Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
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
        const Spacer(),
        _buildFilterDropdown(
          key: _statusDropdownKey,
          label: 'Status',
          selected: _selectedStatus,
          onTap: _showStatusMenu,
        ),
        const SizedBox(width: 12),
        _buildFilterDropdown(
          key: _planDropdownKey,
          label: 'Plan',
          selected: _selectedPlan,
          onTap: _showPlanMenu,
        ),
        const SizedBox(width: 12),
        TextButton(
          onPressed: () {},
          child: Text(
            'Clear Filters',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  RelativeRect _dropdownPosition(GlobalKey key) {
    final box = key.currentContext?.findRenderObject() as RenderBox?;
    final size = MediaQuery.sizeOf(context);
    if (box == null || !box.hasSize) {
      return RelativeRect.fromLTRB(24, 200, size.width - 200, size.height - 300);
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
    final result = await showMenu<String>(
      context: context,
      position: _dropdownPosition(_planDropdownKey),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 8,
      items: _planOptions.asMap().entries.map((entry) {
        final value = entry.value;
        final isLast = entry.key == _planOptions.length - 1;
        return PopupMenuItem<String>(
          value: value,
          child: Container(
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
    final result = await showMenu<String>(
      context: context,
      position: _dropdownPosition(_statusDropdownKey),
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
  }) {
    final display = selected ?? label;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          key: key,
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
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                display,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: selected != null
                      ? const Color(0xFF0F172A)
                      : const Color(0xFF334155),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: Color(0xFF64748B),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
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
              color: Color(0xFFEEF2FF),
              border: Border(
                bottom: BorderSide(color: Color(0xFFE2E8F0), width: 1),
              ),
            ),
            children: [
              _tableCell('Name', isHeader: true),
              _tableCell('Phone Number', isHeader: true),
              _tableCell('Email Address', isHeader: true),
              _tableCell('Plan', isHeader: true),
              _tableCell('Expiry Date', isHeader: true),
              _tableCell('Status', isHeader: true),
            ],
          ),
          ..._tableData.asMap().entries.map(
            (entry) => TableRow(
              decoration: BoxDecoration(
                color: entry.key.isEven
                    ? Colors.white
                    : const Color(0xFFFAFAFA),
                border: Border(bottom: BorderSide(color: _border, width: 1)),
              ),
              children: [
                _tapableCell(entry.value, entry.value.name),
                _tapableCell(entry.value, entry.value.phone),
                _tapableCell(entry.value, entry.value.email),
                _tapableCell(entry.value, entry.value.plan),
                _tapableCell(entry.value, entry.value.expiry),
                _tapableCell(entry.value, _statusPill(entry.value.status)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _openViewMember(_MemberRow row) {
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

  Widget _tapableCell(_MemberRow row, dynamic content) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => _openViewMember(row),
        child: _tableCell(content),
      ),
    );
  }

  Widget _tableCell(dynamic content, {bool isHeader = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Align(
        alignment: Alignment.centerLeft,
        child: content is String
            ? Text(
                content as String,
                style: Get.textTheme.bodySmall?.copyWith(
                  fontWeight: isHeader ? FontWeight.w600 : FontWeight.normal,
                  color: isHeader ? const Color(0xFF475569) : _textDark,
                  fontSize: 14,
                ),
              )
            : content as Widget,
      ),
    );
  }

  Widget _statusPill(MemberStatus status) {
    final (String label, Color bg) = switch (status) {
      MemberStatus.active => ('Active', _iconCircleGreen),
      MemberStatus.expired => ('Expired', _iconCircleRed),
      MemberStatus.expiring => ('Expiring', _iconCircleOrange),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: Get.textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Showing 1-10 of 248 members',
          style: Get.textTheme.bodySmall?.copyWith(
            color: const Color(0xFF64748B),
            fontSize: 14,
          ),
        ),
        const SizedBox(width: 24),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.chevron_left,
                color: Color(0xFF64748B),
                size: 20,
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _purple,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: const Icon(
                Icons.chevron_right,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
