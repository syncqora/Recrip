import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/themes/popup_menu_interaction_theme.dart';
import 'view_business_modal.dart';

class AdminBusinessContent extends StatelessWidget {
  const AdminBusinessContent({
    super.key,
    required this.isMobile,
    required this.onAddBusinessTap,
    required this.onEditBusinessTap,
    this.isTablet = false,
  });

  final bool isMobile;
  final bool isTablet;
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
  static const _searchFieldWidthWeb = 360.0;
  static const _searchFieldWidthTablet = 900.0;
  static const _dropdownWidthTablet = 132.0;
  static const _dropdownHeightTablet = 40.0;
  static const _desktopColumnWidths = <int, TableColumnWidth>{
    0: FlexColumnWidth(2),
    1: FlexColumnWidth(2),
    2: FlexColumnWidth(1),
    3: FlexColumnWidth(1.2),
    4: FlexColumnWidth(1),
  };
  static const _planOptions = ['Monthly', 'Quarterly', 'Half Yearly', 'Yearly'];
  static const _statusOptions = ['Active', 'Expiring', 'Expired'];
  static const _statusColors = [_activeText, _expiringText, _expiredText];

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
    if (!isMobile && !isTablet) {
      return Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            _buildFilters(),
            const SizedBox(height: 32),
            Expanded(child: _buildDesktopScrollableTable(context)),
          ],
        ),
      );
    }

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
          else if (isTablet)
            _buildTabletCards(context)
          else
            _buildDesktopTable(context),
        ],
      ),
    );
  }

  Widget _buildDesktopScrollableTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Column(
          children: [
            Table(
              columnWidths: _desktopColumnWidths,
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: Color(0xFFEEF2FF)),
                  children: [
                    _headerCell('Business'),
                    _headerCell('Owner'),
                    _headerCell('Plan'),
                    _headerCell('Status', align: Alignment.center),
                    _headerCell('Expiry', align: Alignment.center),
                  ],
                ),
              ],
            ),
            Expanded(
              child: SingleChildScrollView(child: _buildDesktopTable(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopTable(BuildContext context) {
    return Table(
      columnWidths: _desktopColumnWidths,
      children: [
        for (final row in _businessRows)
          TableRow(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(color: _border.withValues(alpha: 0.9)),
              ),
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
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Status',
                  options: _statusOptions,
                  optionColors: _statusColors,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildFilterDropdown(
                  label: 'Plan',
                  options: _planOptions,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Align(alignment: Alignment.centerRight, child: _buildClearFilters()),
        ],
      );
    }

    final searchField = _buildSearchField(isTablet: isTablet);

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
        SizedBox(
          width: isTablet ? _dropdownWidthTablet : 160,
          child: _buildFilterDropdown(
            label: 'Status',
            options: _statusOptions,
            optionColors: _statusColors,
            height: isTablet ? _dropdownHeightTablet : null,
          ),
        ),
        const SizedBox(width: 16),
        SizedBox(
          width: isTablet ? _dropdownWidthTablet : 160,
          child: _buildFilterDropdown(
            label: 'Plan',
            options: _planOptions,
            height: isTablet ? _dropdownHeightTablet : null,
          ),
        ),
        const SizedBox(width: 16),
        _buildClearFilters(),
      ],
    );
  }

  Widget _buildSearchField({bool isTablet = false}) {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        cursorColor: _textDark,
        decoration: InputDecoration(
          hintText: 'Search by name or phone number',
          hintStyle: Get.textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF94A3B8),
            fontSize: 14,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: SvgPicture.asset(
              AppIcons.search,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(_textMuted, BlendMode.srcIn),
            ),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 44,
            minHeight: 24,
          ),
          border: InputBorder.none,
          contentPadding: isTablet
              ? const EdgeInsets.fromLTRB(0, 12, 16, 12)
              : const EdgeInsets.fromLTRB(0, 14, 16, 14),
          isDense: true,
        ),
        style: Get.textTheme.bodyMedium?.copyWith(
          color: _textDark,
          fontSize: 14,
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, {double? height}) {
    final h = height ?? 44.0;
    return Container(
      height: h,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: h <= 40 ? 12 : 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            hint,
            style: Get.textTheme.labelMedium?.copyWith(
              color: const Color(0xFF94A3B8),
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          SvgPicture.asset(AppIcons.dropdownDown, width: 24, height: 24),
        ],
      ),
    );
  }

  Widget _buildFilterDropdown({
    required String label,
    required List<String> options,
    List<Color>? optionColors,
    double? height,
  }) {
    return _BusinessFilterDropdown(
      label: label,
      options: options,
      optionColors: optionColors,
      height: height ?? 44,
    );
  }

  Widget _buildClearFilters() {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(
          'Clear Filters',
          style: Get.textTheme.labelMedium?.copyWith(
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w600,
          ),
        ),
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

  Widget _buildTabletCards(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _businessRows.length,
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 500,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        mainAxisExtent: 240,
      ),
      itemBuilder: (context, index) {
        final row = _businessRows[index];
        return _buildTabletCard(
          context: context,
          business: row.business,
          owner: row.owner,
          plan: row.plan,
          status: row.status,
          expiry: row.expiry,
        );
      },
    );
  }

  Widget _buildTabletCard({
    required BuildContext context,
    required String business,
    required String owner,
    required String plan,
    required String status,
    required String expiry,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openViewBusinessModal(
          context,
          businessName: business,
          ownerName: owner,
          plan: plan,
          statusLabel: status,
          expiryDate: expiry,
        ),
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      business,
                      style: Get.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _textDark,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  _statusPill(status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                owner,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: _textMuted,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              const Divider(height: 1, thickness: 1, color: _border),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _infoColumn('Plan', plan),
                  _infoColumn('Expiry', expiry, alignRight: true),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoColumn(String label, String value, {bool alignRight = false}) {
    return Column(
      crossAxisAlignment: alignRight
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Get.textTheme.labelSmall?.copyWith(
            color: _textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: Get.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: _textDark,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _statusPill(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _statusBadgeColor(status),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        status,
        style: Get.textTheme.labelMedium?.copyWith(
          color: _statusTextColor(status),
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
      ),
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
        MaterialPageRoute<void>(fullscreenDialog: true, builder: (_) => modal),
      );
      return;
    }

    showDialog<void>(context: context, builder: (_) => modal);
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

class _BusinessFilterDropdown extends StatefulWidget {
  const _BusinessFilterDropdown({
    required this.label,
    required this.options,
    required this.height,
    this.optionColors,
  });

  final String label;
  final List<String> options;
  final List<Color>? optionColors;
  final double height;

  @override
  State<_BusinessFilterDropdown> createState() =>
      _BusinessFilterDropdownState();
}

class _BusinessFilterDropdownState extends State<_BusinessFilterDropdown> {
  static const _border = Color(0xFFE2E8F0);
  static const _hint = Color(0xFF94A3B8);
  static const _text = Color(0xFF0F172A);

  final _dropdownKey = GlobalKey();
  String? _selected;

  @override
  Widget build(BuildContext context) {
    final display = _selected ?? widget.label;
    return Theme(
      data: popupMenuInteractionTheme(context),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _showMenu,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            key: _dropdownKey,
            height: widget.height,
            padding: EdgeInsets.symmetric(
              horizontal: widget.height <= 40 ? 12 : 16,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _border),
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
                    color: _selected == null ? _hint : _text,
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

  double _menuWidth() {
    final box = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
    if (box != null && box.hasSize) return box.size.width;
    return 169;
  }

  RelativeRect _menuPosition(BuildContext context) {
    final box = _dropdownKey.currentContext?.findRenderObject() as RenderBox?;
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

  Future<void> _showMenu() async {
    final menuWidth = _menuWidth();
    final menuContext = _dropdownKey.currentContext ?? context;
    final result = await showMenu<String>(
      context: menuContext,
      position: _menuPosition(menuContext),
      constraints: BoxConstraints.tightFor(width: menuWidth),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      elevation: 8,
      items: List.generate(widget.options.length, (i) {
        final value = widget.options[i];
        final isLast = i == widget.options.length - 1;
        final color =
            widget.optionColors != null && i < widget.optionColors!.length
            ? widget.optionColors![i]
            : const Color(0xFF334155);
        return PopupMenuItem<String>(
          value: value,
          child: Container(
            width: menuWidth,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : const Border(bottom: BorderSide(color: _border, width: 1)),
            ),
            child: Text(
              value,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        );
      }),
    );

    if (result != null) {
      setState(() => _selected = result);
    }
  }
}
