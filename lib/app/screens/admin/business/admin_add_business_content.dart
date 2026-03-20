import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/utils/app_date_picker.dart';
import 'package:saas/shared/widgets/primary_action_button.dart';
import 'view_business_modal.dart';

import '../../dashboard/modals/subscription_utils.dart';

class AdminAddBusinessContent extends StatelessWidget {
  const AdminAddBusinessContent({
    super.key,
    required this.isMobile,
    required this.onBack,
    this.isEditMode = false,
    this.initialBusiness,
  });

  final bool isMobile;
  final VoidCallback onBack;
  final bool isEditMode;
  final ViewBusinessData? initialBusiness;

  static const _textDark = Color(0xFF0F172A);
  static const _textMuted = Color(0xFF64748B);
  static const _border = Color(0xFFE2E8F0);
  static const _bgFooter = Colors.white;

  @override
  Widget build(BuildContext context) {
    final planValue = initialBusiness?.plan ?? '';
    final statusValue = initialBusiness?.statusLabel ?? '';
    final startDateValue = initialBusiness?.startDate ?? '';
    final startDate = _tryParseDate(startDateValue);
    final expiryFromPlan = calculateExpiryDate(planValue, startDate);
    final expiryText = expiryFromPlan == null ? '' : _formatDate(expiryFromPlan);

    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isMobile ? 16 : 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                SizedBox(height: isMobile ? 24 : 32),
                _buildSectionHeader('Business Details'),
                const SizedBox(height: 16),
                _buildResponsiveGrid(
                  children: [
                    _buildTextField(
                      'Business Name',
                      'E.g. T-rex',
                      initialValue: initialBusiness?.businessName,
                    ),
                    _buildTextField(
                      'Owner Name',
                      'E.g. John Doe',
                      initialValue: initialBusiness?.ownerName,
                    ),
                    _buildPhoneNumberField(initialValue: initialBusiness?.phoneNumber),
                    _buildTextField(
                      'Email Address',
                      'E.g. John.doe@gmail.com',
                      initialValue: initialBusiness?.emailAddress,
                    ),
                    _buildTextField(
                      'GST Number',
                      'E.g. GSTIN8046579562',
                      initialValue: initialBusiness?.gstNumber,
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 24 : 32),
                _buildSectionHeader('Business Address'),
                const SizedBox(height: 16),
                _buildResponsiveGrid(
                  children: [
                    _buildTextField(
                      'Building Name',
                      'Enter Building Name',
                      initialValue: initialBusiness?.buildingName,
                    ),
                    _buildTextField(
                      'Street Address',
                      'Enter Street Address',
                      initialValue: initialBusiness?.streetAddress,
                    ),
                    _buildTextField(
                      'City',
                      'Enter City Name',
                      initialValue: initialBusiness?.city,
                    ),
                    _buildDropdownField(
                      'State',
                      initialBusiness?.state ?? 'Select State',
                    ),
                    _buildTextField(
                      'Pincode',
                      'Enter Pin code',
                      initialValue: initialBusiness?.pincode,
                    ),
                  ],
                ),
                SizedBox(height: isMobile ? 24 : 32),
                _buildSectionHeader('Subscription Details'),
                const SizedBox(height: 16),
                _buildResponsiveGrid(
                  children: [
                    _buildDropdownField(
                      'Plan',
                      planValue.isNotEmpty ? planValue : 'Choose a Plan',
                    ),
                    _buildDropdownField(
                      'Status',
                      statusValue.isNotEmpty ? statusValue : 'Select Status',
                    ),
                    _buildDatePickerField(
                      context,
                      'Start Date',
                      startDateValue.isNotEmpty ? startDateValue : 'Select Date',
                      initialDate: startDate,
                    ),
                    _buildExpiryDateField(expiryText: expiryText),
                  ],
                ),
              ],
            ),
          ),
        ),
        _buildFooter(context),
      ],
    );
  }

  Widget _buildHeader() {
    return isMobile
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    isEditMode ? 'Edit Business' : 'Add Business',
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  _buildGoBackButton(),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                isEditMode ? 'Make changes in the business here' : 'Add a business here',
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _textMuted,
                ),
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isEditMode ? 'Edit Business' : 'Add Business',
                    style: Get.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: _textDark,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isEditMode ? 'Make changes in the business here' : 'Add a business here',
                    style: Get.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: _textMuted,
                    ),
                  ),
                ],
              ),
              _buildGoBackButton(),
            ],
          );
  }

  Widget _buildGoBackButton() {
    return OutlinedButton(
      onPressed: onBack,
      style: OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF475569),
        side: const BorderSide(color: _border),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
      child: const Text(
        'Go Back',
        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: Get.textTheme.titleSmall?.copyWith(
        fontWeight: FontWeight.bold,
        color: const Color(0xFF334155),
      ),
    );
  }

  Widget _buildResponsiveGrid({required List<Widget> children}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 4;
        if (isMobile || constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 1000) {
          crossAxisCount = 2;
        }

        final spacing = 16.0;
        final runSpacing = 16.0;
        final itemWidth =
            (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
            crossAxisCount;

        return Wrap(
          spacing: spacing,
          runSpacing: runSpacing,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }

  Widget _buildFieldWrapper(String label, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          label,
          style: Get.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E293B),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTextField(
    String label,
    String hint, {
    String? initialValue,
  }) {
    return _buildFieldWrapper(
      label,
      Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        alignment: Alignment.centerLeft,
        child: TextField(
          controller: TextEditingController(text: initialValue ?? ''),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Get.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF94A3B8),
              fontSize: 13,
            ),
            border: InputBorder.none,
            isDense: true,
            contentPadding: EdgeInsets.zero,
          ),
          style: Get.textTheme.bodyMedium?.copyWith(
            color: _textDark,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildPhoneNumberField({String? initialValue}) {
    final digits = (initialValue ?? '').replaceAll('+91', '').trim();
    return _buildFieldWrapper(
      'Phone Number',
      Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _border),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: Text(
                '+91',
                style: Get.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: _textDark,
                  fontSize: 13,
                ),
              ),
            ),
            Expanded(
              child: TextField(
                controller: TextEditingController(text: digits),
                decoration: InputDecoration(
                  hintText: '00000 00000',
                  hintStyle: Get.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: const EdgeInsets.only(right: 16),
                ),
                keyboardType: TextInputType.phone,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: _textDark,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField(String label, String hint) {
    final isPlaceholder = hint == 'Choose a Plan' ||
        hint == 'Select Status' ||
        hint == 'Select State';
    return _buildFieldWrapper(
      label,
      Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: _border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              hint,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: isPlaceholder ? const Color(0xFF94A3B8) : _textDark,
                fontSize: 13,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down, color: _textMuted, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePickerField(
    BuildContext context,
    String label,
    String hint,
    {DateTime? initialDate}
  ) {
    return _buildFieldWrapper(
      label,
      InkWell(
        onTap: () {
          showAppDatePicker(
            context: context,
            initialDate: initialDate ?? DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
        },
        child: Container(
          height: 48,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: _border),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                hint,
                style: Get.textTheme.bodyMedium?.copyWith(
                  color: hint == 'Select Date'
                      ? const Color(0xFF94A3B8)
                      : _textDark,
                  fontSize: 13,
                ),
              ),
              SvgPicture.asset(
                AppIcons.calendarDays,
                width: 20,
                height: 20,
                colorFilter: const ColorFilter.mode(
                  _textMuted,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpiryDateField({required String expiryText}) {
    return _buildFieldWrapper(
      'Expiry Date',
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            height: 48,
            // Dashed border is easiest simulated via a CustomPainter or just a box decoration if package not available.
            // A simple solid border for fallback.
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFCBD5E1),
                style: BorderStyle.solid,
              ),
            ),
            alignment: Alignment.centerLeft,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              expiryText,
              style: Get.textTheme.bodyMedium?.copyWith(
                color: _textDark,
                fontSize: 13,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Calculated automatically',
            style: Get.textTheme.labelSmall?.copyWith(
              color: const Color(0xFF94A3B8),
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _tryParseDate(String input) {
    final trimmed = input.trim();
    if (trimmed.isEmpty) return null;
    final parts = trimmed.split('/');
    if (parts.length != 3) return null;
    final day = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);
    if (day == null || month == null || year == null) return null;
    return DateTime(year, month, day);
  }

  String _formatDate(DateTime d) {
    final dd = d.day.toString().padLeft(2, '0');
    final mm = d.month.toString().padLeft(2, '0');
    return '$dd/$mm/${d.year}';
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: _bgFooter,
        border: Border(top: BorderSide(color: _border)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 16 : 32,
        vertical: 16,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton(
            onPressed: onBack,
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xFF475569),
              side: const BorderSide(color: _border),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            ),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
          const SizedBox(width: 16),
          PrimaryActionButton(
            label: isEditMode ? 'Save Changes' : 'Add Business',
            onPressed: () {
              // TODO: validate and call API to create/update the business.
              if (!isEditMode) {
                _showBusinessAddedDialog(context);
              }
            },
          ),
        ],
      ),
    );
  }

  void _showBusinessAddedDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: Container(
          constraints: const BoxConstraints(maxWidth: 640),
          padding: const EdgeInsets.fromLTRB(32, 34, 32, 30),
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Container(
                    width: 26,
                    height: 26,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.6),
                    ),
                    child: const Icon(Icons.check, size: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 22),
              Text(
                'Business Added Successfully',
                textAlign: TextAlign.center,
                style: Get.textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w700,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'An email has been sent to the business with the username & password.\n'
                'Please ask the business to login with the credentials to continue.\n'
                'Thank you!',
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyLarge?.copyWith(
                  color: const Color(0xFF0F172A),
                  fontWeight: FontWeight.w500,
                  fontSize: 15,
                  height: 1.25,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
