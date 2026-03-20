import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'view_business_modal.dart';

class AdminBusinessContent extends StatelessWidget {
  const AdminBusinessContent({
    super.key,
    required this.isMobile,
    required this.onAddBusinessTap,
    required this.onEditBusinessTap,
  });

  final bool isMobile;
  final VoidCallback onAddBusinessTap;
  final ValueChanged<ViewBusinessData> onEditBusinessTap;

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _activeBadge = Color(0xFFDCFCE7);
  static const _activeText = Color(0xFF166534);
  static const _expiringBadge = Color(0xFFFEF3C7);
  static const _expiringText = Color(0xFF92400E);
  static const _expiredBadge = Color(0xFFFEE2E2);
  static const _expiredText = Color(0xFF991B1B);

  static const _businessRows = [
    (
      business: 'T-rex Fitness Club',
      owner: 'Kattapadi Suresh',
      plan: 'Yearly',
      status: 'Active',
      expiry: '18/03/2027',
    ),
    (
      business: 'Iron Forge Gym',
      owner: 'Rahul Menon',
      plan: 'Half Yearly',
      status: 'Expiring',
      expiry: '02/04/2026',
    ),
    (
      business: 'Urban Pulse Fitness',
      owner: 'Nikhil Shetty',
      plan: 'Quarterly',
      status: 'Expired',
      expiry: '14/02/2026',
    ),
    (
      business: 'Alpha Strength Studio',
      owner: 'Pranav Nair',
      plan: 'Yearly',
      status: 'Active',
      expiry: '11/11/2026',
    ),
    (
      business: 'Spartan Arena Gym',
      owner: 'Akhil Raj',
      plan: 'Monthly',
      status: 'Expiring',
      expiry: '28/03/2026',
    ),
    (
      business: 'Core Nation Fitness',
      owner: 'Arjun Pillai',
      plan: 'Yearly',
      status: 'Active',
      expiry: '30/12/2026',
    ),
    (
      business: 'LiftLab Performance',
      owner: 'Dinesh Kumar',
      plan: 'Quarterly',
      status: 'Expired',
      expiry: '05/01/2026',
    ),
    (
      business: 'Beast Mode Club',
      owner: 'Midhun Das',
      plan: 'Half Yearly',
      status: 'Active',
      expiry: '19/08/2026',
    ),
    (
      business: 'PeakFit Training Hub',
      owner: 'Srinath R',
      plan: 'Monthly',
      status: 'Expiring',
      expiry: '25/03/2026',
    ),
    (
      business: 'PowerHouse Athletics',
      owner: 'Vivek Balan',
      plan: 'Yearly',
      status: 'Active',
      expiry: '09/10/2026',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(),
          SizedBox(height: isMobile ? 20 : 32),
          _buildFilters(),
          SizedBox(height: isMobile ? 20 : 32),
          if (isMobile)
            _buildMobileList(context)
          else
            _buildDesktopTable(context),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Businesses',
                style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: _textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Manage All Onboarded Businesses',
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _textMuted,
                ),
              ),
              const SizedBox(height: 16),
              PrimaryActionButton(
                label: 'Add Business',
                onPressed: onAddBusinessTap,
                useFixedSize: false,
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Businesses',
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Manage All Onboarded Businesses',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _textMuted,
                    ),
                  ),
                ],
              ),
              PrimaryActionButton(
                label: 'Add Business',
                onPressed: onAddBusinessTap,
              ),
            ],
          );
  }

  Widget _buildFilters() {
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildSearchField(),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildDropdown('Status')),
              const SizedBox(width: 12),
              Expanded(child: _buildDropdown('Plan')),
            ],
          ),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: _buildClearFilters()),
        ],
      );
    }
    return Row(
      children: [
        SizedBox(width: 320, child: _buildSearchField()),
        const Spacer(),
        SizedBox(width: 160, child: _buildDropdown('Status')),
        const SizedBox(width: 16),
        SizedBox(width: 160, child: _buildDropdown('Plan')),
        const SizedBox(width: 16),
        _buildClearFilters(),
      ],
    );
  }

  Widget _buildSearchField() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.search,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(_textMuted, BlendMode.srcIn),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by name or phone number',
                hintStyle: Get.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF94A3B8),
                  fontSize: 14,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
              style: Get.textTheme.bodyMedium?.copyWith(
                color: _textDark,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(String hint) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _border),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            hint,
            style: Get.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF94A3B8),
              fontSize: 14,
            ),
          ),
          const Icon(Icons.keyboard_arrow_down, color: _textMuted, size: 20),
        ],
      ),
    );
  }

  Widget _buildClearFilters() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          'Clear Filters',
          style: Get.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: Table(
        columnWidths: const {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(2),
          2: FlexColumnWidth(1),
          3: FlexColumnWidth(1.2),
          4: FlexColumnWidth(1),
        },
        children: [
          TableRow(
            decoration: const BoxDecoration(
              color: Color(0xFFEEF2FF),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            children: [
              _headerCell('Business'),
              _headerCell('Owner'),
              _headerCell('Plan'),
              _headerCell('Status', align: Alignment.center),
              _headerCell('Expiry', align: Alignment.center),
            ],
          ),
          for (final row in _businessRows)
            TableRow(
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.transparent)),
              ),
              children: [
                _dataCell(
                  row.business,
                  onTap: () => _openViewBusinessModal(
                    context,
                    businessName: row.business,
                    ownerName: row.owner,
                    plan: row.plan,
                    statusLabel: row.status,
                    expiryDate: row.expiry,
                  ),
                ),
                _dataCell(row.owner),
                _dataCell(row.plan),
                _statusCell(row.status),
                _dataCell(row.expiry, align: Alignment.center),
              ],
            ),
        ],
      ),
    );
  }

  Widget _headerCell(String text, {Alignment align = Alignment.centerLeft}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Align(
        alignment: align,
        child: Text(
          text,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF475569),
          ),
        ),
      ),
    );
  }

  Widget _dataCell(
    String text, {
    Alignment align = Alignment.centerLeft,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Align(
        alignment: align,
        child: onTap == null
            ? Text(
                text,
                style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
              )
            : InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(8),
                child: Text(
                  text,
                  style: Get.textTheme.bodyMedium?.copyWith(color: _textDark),
                ),
              ),
      ),
    );
  }

  Widget _buildMobileList(BuildContext context) {
    return Column(
      children: [
        for (final row in _businessRows)
          _buildMobileRow(
            row.business,
            row.owner,
            row.plan,
            row.status,
            row.expiry,
            context,
          ),
      ],
    );
  }

  Widget _buildMobileRow(
    String business,
    String owner,
    String plan,
    String status,
    String expiry,
    BuildContext context,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: _border),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => _openViewBusinessModal(
              context,
              businessName: business,
              ownerName: owner,
              plan: plan,
              statusLabel: status,
              expiryDate: expiry,
            ),
            borderRadius: BorderRadius.circular(8),
            child: Text(
              business,
              style: Get.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: _textDark,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            owner,
            style: Get.textTheme.bodySmall?.copyWith(color: _textMuted),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Plan: $plan',
                style: Get.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Expiry: $expiry',
                style: Get.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: _statusBadgeColor(status),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              status,
              style: Get.textTheme.labelMedium?.copyWith(
                color: _statusTextColor(status),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _openViewBusinessModal(
    BuildContext context, {
    required String businessName,
    required String ownerName,
    required String plan,
    required String statusLabel,
    required String expiryDate,
  }) {
    // TODO: Replace placeholders with real data from your backend model.
    const phoneNumber = '+91 86065 49327';
    const emailAddress = 'sureshkattapadi06@gmail.com';
    const gstNumber = 'GSTIN8046579562';
    const buildingName = 'Viceroy Legacy';
    const streetAddress = '8th Cross, Indiranagar';
    const city = 'Bengaluru';
    const state = 'Karnataka';
    const pincode = '560093';
    const startDate = '18/03/2026';

    final modal = ViewBusinessModal(
      onEditBusinessTap: onEditBusinessTap,
      business: ViewBusinessData(
        businessName: businessName,
        ownerName: ownerName,
        phoneNumber: phoneNumber,
        emailAddress: emailAddress,
        gstNumber: gstNumber,
        buildingName: buildingName,
        streetAddress: streetAddress,
        city: city,
        state: state,
        pincode: pincode,
        plan: plan,
        startDate: startDate,
        expiryDate: expiryDate,
        statusLabel: statusLabel,
        statusColor: _statusTextColor(statusLabel),
        isActive: statusLabel.toLowerCase() == 'active',
      ),
    );

    if (MediaQuery.sizeOf(context).width < 600) {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          fullscreenDialog: true,
          builder: (_) => modal,
        ),
      );
      return;
    }

    showDialog<void>(
      context: context,
      builder: (_) => modal,
    );
  }

  Widget _statusCell(String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: _statusBadgeColor(status),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(
            status,
            style: Get.textTheme.labelMedium?.copyWith(
              color: _statusTextColor(status),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Color _statusBadgeColor(String status) {
    switch (status.toLowerCase()) {
      case 'expired':
        return _expiredBadge;
      case 'expiring':
        return _expiringBadge;
      default:
        return _activeBadge;
    }
  }

  Color _statusTextColor(String status) {
    switch (status.toLowerCase()) {
      case 'expired':
        return _expiredText;
      case 'expiring':
        return _expiringText;
      default:
        return _activeText;
    }
  }
}
