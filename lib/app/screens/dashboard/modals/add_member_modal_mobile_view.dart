import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/plan_dropdown.dart';
import '../../../../shared/widgets/app_modal_primary_button.dart';
import '../../authentication/widgets/app_constants.dart';
import 'subscription_utils.dart';
import '../../authentication/widgets/auth_form_field_section.dart';
import '../../authentication/widgets/auth_text_field.dart';
import 'package:saas/shared/constants/app_icons.dart';

class AddMemberModalMobileView extends StatelessWidget {
  const AddMemberModalMobileView({
    super.key,
    required this.fullNameController,
    required this.phoneController,
    required this.emailController,
    required this.selectedPlan,
    required this.startDate,
    required this.whatsApp,
    required this.email,
    required this.onPickStartDate,
    required this.onPlanChanged,
    required this.onWhatsAppChanged,
    required this.onEmailChanged,
    required this.onCancel,
    required this.onSave,
    required this.isSaveEnabled,
    required this.isNameEditable,
    this.title = 'Add Member',
    this.primaryButtonLabel = 'Save Member',
  });

  final TextEditingController fullNameController;
  final TextEditingController phoneController;
  final TextEditingController emailController;
  final String? selectedPlan;
  final DateTime? startDate;
  final bool whatsApp;
  final bool email;
  final VoidCallback onPickStartDate;
  final ValueChanged<String?> onPlanChanged;
  final ValueChanged<bool> onWhatsAppChanged;
  final ValueChanged<bool> onEmailChanged;
  final VoidCallback onCancel;
  final VoidCallback onSave;
  final bool isSaveEnabled;
  final bool isNameEditable;
  final String title;
  final String primaryButtonLabel;

  static const _filledFieldColor = Color(0xFFF8FAFC);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          onPressed: onCancel,
          icon: SvgPicture.asset(AppIcons.backButton, width: 20, height: 20),
          style: IconButton.styleFrom(
            minimumSize: Size.zero,
            padding: const EdgeInsets.all(12),
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
        title: Text(
          title,
          style: Get.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppConstants.labelColor,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(thickness: 1, color: Color(0xFFCBD5E1), height: 1),
        ),
      ),
      body: NotificationListener<ScrollStartNotification>(
        onNotification: (_) {
          void clearSelectionKeepCursor(TextEditingController c) {
            final sel = c.selection;
            if (!sel.isValid || sel.isCollapsed) return;
            final offset = sel.extentOffset.clamp(0, c.text.length);
            c.selection = TextSelection.collapsed(offset: offset);
          }

          clearSelectionKeepCursor(fullNameController);
          clearSelectionKeepCursor(phoneController);
          clearSelectionKeepCursor(emailController);
          return false;
        },
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.manual,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            _buildSectionTitle('Member Details'),
            const SizedBox(height: 16),
            AuthFormFieldSection(
              label: 'Full Name',
              spacingAfterLabel: 8,
              child: AuthTextField(
                controller: fullNameController,
                hint: 'E.g. John Doe',
                readOnly: !isNameEditable,
                fillColor: fullNameController.text.trim().isNotEmpty
                    ? _filledFieldColor
                    : Colors.white,
                dismissKeyboardOnTapOutside: false,
              ),
            ),
            const SizedBox(height: 16),
            AuthFormFieldSection(
              label: 'Phone Number',
              spacingAfterLabel: 8,
              child: SizedBox(
                height: AppConstants.fieldHeight,
                child: TextField(
                  controller: phoneController,
                  onTapOutside: (_) {},
                  style: Get.theme.textTheme.bodySmall?.copyWith(
                    color: AppConstants.labelColor,
                  ),
                  cursorColor: Colors.black,
                  decoration: InputDecoration(
                    prefixIcon: Padding(
                      padding: const EdgeInsets.only(left: 12, right: 4),
                      child: Align(
                        widthFactor: 1.0,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '+91 ',
                          style: Get.theme.textTheme.bodySmall?.copyWith(
                            color: AppConstants.labelColor,
                          ),
                        ),
                      ),
                    ),
                    prefixIconConstraints: const BoxConstraints(
                      minWidth: 0,
                      minHeight: 0,
                    ),
                    hintText: '00000 00000',
                    hintStyle: Get.theme.textTheme.bodySmall?.copyWith(
                      color: AppConstants.hintColor,
                    ),
                    filled: true,
                    fillColor: phoneController.text.trim().isNotEmpty
                        ? _filledFieldColor
                        : Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.fieldBorderRadius,
                      ),
                      borderSide: const BorderSide(
                        color: AppConstants.borderColor,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.fieldBorderRadius,
                      ),
                      borderSide: const BorderSide(
                        color: AppConstants.borderColor,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.fieldBorderRadius,
                      ),
                      borderSide: const BorderSide(
                        color: AppConstants.focusedBorderColor,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            AuthFormFieldSection(
              label: 'Email Address',
              spacingAfterLabel: 8,
              child: AuthTextField(
                controller: emailController,
                hint: 'E.g. John.doe@gmail.com',
                fillColor: emailController.text.trim().isNotEmpty
                    ? _filledFieldColor
                    : Colors.white,
                dismissKeyboardOnTapOutside: false,
              ),
            ),
            const SizedBox(height: 24),
            _buildSectionTitle('Subscription Details'),
            const SizedBox(height: 16),
            _requiredLabel('Plan'),
            const SizedBox(height: 8),
            _buildPlanDropdown(),
            const SizedBox(height: 16),
            _requiredLabel('Start Date'),
            const SizedBox(height: 8),
            _buildStartDatePicker(),
            const SizedBox(height: 16),
            _fieldHeader('Expiry Date'),
            const SizedBox(height: 8),
            _buildExpiryDisplay(),
            const SizedBox(height: 24),
            _buildSectionTitle('Reminder Channels'),
            const SizedBox(height: 16),
            _buildReminderChannels(),
            const SizedBox(height: 140),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Divider(thickness: 1, height: 1, color: Color(0xFFCBD5E1)),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                child: _buildActions(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.bodySmall?.copyWith(
        fontWeight: FontWeight.w600,
        color: AppConstants.labelColor,
      ),
    );
  }

  Widget _buildPlanDropdown() {
    void clearSelectionKeepCursor(TextEditingController c) {
      final sel = c.selection;
      if (!sel.isValid) return;
      final offset = sel.extentOffset.clamp(0, c.text.length);
      c.selection = TextSelection.collapsed(offset: offset);
    }

    return PlanDropdown(
      value: selectedPlan,
      onChanged: (v) {
        onPlanChanged(v);
        // When the popup closes on mobile, Flutter may restore focus to the
        // previously focused field. Explicitly clear selection and unfocus so
        // the email field does not come back in "select all" state.
        clearSelectionKeepCursor(fullNameController);
        clearSelectionKeepCursor(phoneController);
        clearSelectionKeepCursor(emailController);
        FocusManager.instance.primaryFocus?.unfocus();
      },
      hint: 'Choose a Plan',
      fillColor: Colors.white,
    );
  }

  Widget _buildStartDatePicker() {
    return SizedBox(
      height: AppConstants.fieldHeight,
      child: InkWell(
        onTap: onPickStartDate,
        borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: startDate != null ? _filledFieldColor : Colors.white,
            borderRadius: BorderRadius.circular(
              AppConstants.fieldBorderRadius,
            ),
            border: Border.all(color: AppConstants.borderColor),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  startDate != null
                      ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                      : 'Select Date',
                  style: Get.theme.textTheme.labelMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    height: 1,
                    color: startDate != null
                        ? AppConstants.textColor
                        : AppConstants.hintColor,
                  ),
                ),
              ),
              SvgPicture.asset(
                AppIcons.calendarDays,
                width: 18,
                height: 18,
                colorFilter: const ColorFilter.mode(
                  AppConstants.hintColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpiryDisplay() {
    final expiry = calculateExpiryDate(selectedPlan, startDate);
    return CustomPaint(
      foregroundPainter: _DashedBorderPainter(
        color: const Color(0xFFCBD5E1),
        borderRadius: AppConstants.fieldBorderRadius,
      ),
      child: Container(
        width: double.infinity,
        height: AppConstants.fieldHeight,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(AppConstants.fieldBorderRadius),
        ),
        child: Text(
          expiry != null ? '${expiry.day}/${expiry.month}/${expiry.year}' : '—',
          style: Get.theme.textTheme.bodySmall?.copyWith(
            color: expiry != null
                ? AppConstants.textColor
                : AppConstants.hintColor,
          ),
        ),
      ),
    );
  }

  Widget _requiredLabel(String text) {
    return Text(
      text,
      style: Get.theme.textTheme.labelMedium?.copyWith(
        color: AppConstants.labelColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _fieldHeader(String text) {
    return Text(
      text,
      style: Get.theme.textTheme.labelMedium?.copyWith(
        color: AppConstants.labelColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildReminderChannels() {
    return Row(
      children: [
        Expanded(
          child: _buildCheckbox('WhatsApp', whatsApp, onWhatsAppChanged),
        ),
        const SizedBox(width: 16),
        Expanded(child: _buildCheckbox('Email', email, onEmailChanged)),
      ],
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      child: Row(
        children: [
          SizedBox(
            width: 24,
            height: 24,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.transparent;
                }
                return null;
              }),
              checkColor: AppConstants.labelColor,
              side: WidgetStateBorderSide.resolveWith(
                (states) =>
                    const BorderSide(color: AppConstants.borderColor, width: 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            label,
            style: Get.textTheme.labelMedium?.copyWith(
              color: AppConstants.labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: onCancel,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppConstants.supportTextColor,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  AppConstants.fieldBorderRadius,
                ),
              ),
              side: const BorderSide(color: AppConstants.borderColor),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AppModalPrimaryButton(
            label: primaryButtonLabel,
            onPressed: isSaveEnabled ? onSave : null,
            padding: const EdgeInsets.symmetric(vertical: 12),
            borderRadius: 10,
          ),
        ),
      ],
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.borderRadius});

  final Color color;
  final double borderRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      Radius.circular(borderRadius - 1),
    );
    final path = Path()..addRRect(rrect);
    double distance = 0;
    for (final metric in path.computeMetrics()) {
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + dashSpace;
      }
      distance = 0;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
