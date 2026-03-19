import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../shared/widgets/success_toast.dart';
import '../../../../shared/widgets/app_close_button.dart';
import '../../../../shared/widgets/app_modal_primary_button.dart';
import '../../authentication/widgets/auth_constants.dart';
import 'create_template_modal_mobile_view.dart';
import 'create_template_modal_tablet_view.dart';

class CreateTemplateModal extends StatefulWidget {
  const CreateTemplateModal({
    super.key,
    this.onCreate,
    this.title = 'Create Template',
    this.initialTrigger,
    this.initialTiming,
    this.initialAudience,
    this.initialStatus,
    this.initialMessageContent,
    this.initialWhatsApp,
    this.initialEmail,
  });

  final VoidCallback? onCreate;
  final String title;
  final String? initialTrigger;
  final String? initialTiming;
  final String? initialAudience;
  final String? initialStatus;
  final String? initialMessageContent;
  final bool? initialWhatsApp;
  final bool? initialEmail;

  @override
  State<CreateTemplateModal> createState() => _CreateTemplateModalState();
}

class _CreateTemplateModalState extends State<CreateTemplateModal> {
  String? _selectedTrigger;
  String? _selectedTiming;
  String? _selectedAudience;
  String? _selectedStatus;
  late final TextEditingController _messageController;
  bool _whatsApp = true;
  bool _email = false;

  bool get _isEditMode => widget.title == 'Edit Template';

  static const _triggerOptions = ['Before Expiry', 'On Expiry', 'After Expiry'];
  static const _timingOptions = [
    '1 Day before',
    '3 Days before',
    '7 Days before',
    '14 Days before',
  ];
  static const _audienceOptions = ['All Members', 'Expiring Soon', 'Expired'];
  static const _statusOptions = ['Active', 'Inactive'];

  bool get _isCreateEnabled =>
      _selectedTrigger != null &&
      _selectedTiming != null &&
      _selectedAudience != null &&
      _selectedStatus != null;

  static const double _menuBorderRadius = 12;
  static const double _menuElevation = 8;
  static const EdgeInsets _itemPadding = EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 16,
  );

  @override
  void initState() {
    super.initState();
    _messageController = TextEditingController(text: widget.initialMessageContent);
    _selectedTrigger = widget.initialTrigger;
    _selectedTiming = widget.initialTiming;
    _selectedAudience = widget.initialAudience;
    _selectedStatus = widget.initialStatus;
    if (widget.initialWhatsApp != null) _whatsApp = widget.initialWhatsApp!;
    if (widget.initialEmail != null) _email = widget.initialEmail!;
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _showSelectMenu({
    required BuildContext context,
    required List<String> options,
    required ValueChanged<String?> onSelected,
  }) async {
    final box = context.findRenderObject() as RenderBox?;
    if (box == null || !box.hasSize) return;

    final overlayState = Overlay.of(context);
    final overlayRender =
        overlayState.context.findRenderObject() as RenderBox?;
    if (overlayRender == null) return;

    final topLeft = box.localToGlobal(Offset.zero, ancestor: overlayRender);
    final size = box.size;
    final oSize = overlayRender.size;
    const gap = 4.0;

    // Anchor a thin rect *just below* the field (same idea as PlanDropdown) so the
    // menu opens under the dropdown, not on top of it.
    final overlayRect = Offset.zero & oSize;
    final anchorLeft = topLeft.dx.clamp(0.0, oSize.width);
    final anchorTop =
        (topLeft.dy + size.height + gap).clamp(0.0, oSize.height);
    final anchorWidth =
        size.width.clamp(1.0, (oSize.width - anchorLeft).clamp(1.0, oSize.width));
    final anchorBelow = Rect.fromLTWH(anchorLeft, anchorTop, anchorWidth, 1);
    final position = RelativeRect.fromRect(anchorBelow, overlayRect);

    final items = <PopupMenuEntry<String>>[];
    for (var i = 0; i < options.length; i++) {
      if (i > 0) items.add(const PopupMenuDivider(height: 1));
      items.add(
        PopupMenuItem<String>(
          value: options[i],
          padding: _itemPadding,
          child: Text(
            options[i],
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: AuthConstants.labelColor,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    final selected = await showMenu<String>(
      context: context,
      position: position,
      constraints: BoxConstraints(minWidth: size.width, maxWidth: size.width),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(_menuBorderRadius),
      ),
      color: Colors.white,
      elevation: _menuElevation,
      items: items,
    );
    if (selected != null) onSelected(selected);
  }

  void _onCreate() {
    if (widget.onCreate != null) {
      widget.onCreate!();
    } else {
      SuccessToast.show(
        context,
        title: _isEditMode
            ? 'Template updated successfully'
            : 'Template created successfully',
        popRoute: true,
      );
    }
  }

  void _onUploadAttachment() {
    // TODO: file picker
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < 600) {
      return CreateTemplateModalMobileView(
        title: widget.title,
        selectedTrigger: _selectedTrigger,
        selectedTiming: _selectedTiming,
        selectedAudience: _selectedAudience,
        selectedStatus: _selectedStatus,
        messageController: _messageController,
        whatsApp: _whatsApp,
        email: _email,
        onTriggerTap: (anchor) => _showSelectMenu(
          context: anchor,
          options: _triggerOptions,
          onSelected: (v) => setState(() => _selectedTrigger = v),
        ),
        onTimingTap: (anchor) => _showSelectMenu(
          context: anchor,
          options: _timingOptions,
          onSelected: (v) => setState(() => _selectedTiming = v),
        ),
        onAudienceTap: (anchor) => _showSelectMenu(
          context: anchor,
          options: _audienceOptions,
          onSelected: (v) => setState(() => _selectedAudience = v),
        ),
        onStatusTap: (anchor) => _showSelectMenu(
          context: anchor,
          options: _statusOptions,
          onSelected: (v) => setState(() => _selectedStatus = v),
        ),
        onUploadAttachment: _onUploadAttachment,
        onWhatsAppChanged: (v) => setState(() => _whatsApp = v),
        onEmailChanged: (v) => setState(() => _email = v),
        onCancel: () => Navigator.of(context).pop(),
        onCreate: _onCreate,
        isCreateEnabled: _isCreateEnabled,
      );
    }

    if (width < 1024) {
      return CreateTemplateModalTabletView(
        title: widget.title,
        selectedTrigger: _selectedTrigger,
        selectedTiming: _selectedTiming,
        selectedAudience: _selectedAudience,
        selectedStatus: _selectedStatus,
        messageController: _messageController,
        whatsApp: _whatsApp,
        email: _email,
        onTriggerTap: (anchor) => _showSelectMenu(
          context: anchor,
          options: _triggerOptions,
          onSelected: (v) => setState(() => _selectedTrigger = v),
        ),
        onTimingTap: (anchor) => _showSelectMenu(
          context: anchor,
          options: _timingOptions,
          onSelected: (v) => setState(() => _selectedTiming = v),
        ),
        onAudienceTap: (anchor) => _showSelectMenu(
          context: anchor,
          options: _audienceOptions,
          onSelected: (v) => setState(() => _selectedAudience = v),
        ),
        onStatusTap: (anchor) => _showSelectMenu(
          context: anchor,
          options: _statusOptions,
          onSelected: (v) => setState(() => _selectedStatus = v),
        ),
        onUploadAttachment: _onUploadAttachment,
        onWhatsAppChanged: (v) => setState(() => _whatsApp = v),
        onEmailChanged: (v) => setState(() => _email = v),
        onCancel: () => Navigator.of(context).pop(),
        onCreate: _onCreate,
        isCreateEnabled: _isCreateEnabled,
      );
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Container(
        width: 869,
        constraints: const BoxConstraints(maxHeight: 700),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const Divider(thickness: 1, color: Color(0xFFCBD5E1)),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionTitle('Message Rule Details'),
                    const SizedBox(height: 16),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const gap = 16.0;
                        final columnWidth =
                            (constraints.maxWidth - 2 * gap) / 3;
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: columnWidth,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _requiredLabel('Trigger'),
                                  const SizedBox(height: 8),
                                  _selectField(
                                    hint: 'Select Trigger',
                                    options: _triggerOptions,
                                    value: _selectedTrigger,
                                    onChanged: (v) =>
                                        setState(() => _selectedTrigger = v),
                                  ),
                                  const SizedBox(height: 16),
                                  _requiredLabel('Status'),
                                  const SizedBox(height: 8),
                                  _selectField(
                                    hint: 'Select Status',
                                    options: _statusOptions,
                                    value: _selectedStatus,
                                    onChanged: (v) =>
                                        setState(() => _selectedStatus = v),
                                  ),
                                  const SizedBox(height: 16),
                                  _buildSectionTitle('Reminder Channels'),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      _buildCheckbox(
                                        'WhatsApp',
                                        _whatsApp,
                                        (v) => setState(() => _whatsApp = v),
                                      ),
                                      const SizedBox(width: 32),
                                      _buildCheckbox(
                                        'Email',
                                        _email,
                                        (v) => setState(() => _email = v),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: gap),
                            SizedBox(
                              width: 2 * columnWidth + gap,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: columnWidth,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _requiredLabel('Timing'),
                                            const SizedBox(height: 8),
                                            _selectField(
                                              hint: 'Select Timing',
                                              options: _timingOptions,
                                              value: _selectedTiming,
                                              onChanged: (v) => setState(
                                                () => _selectedTiming = v,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: gap),
                                      SizedBox(
                                        width: columnWidth,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _requiredLabel('Audience'),
                                            const SizedBox(height: 8),
                                            _selectField(
                                              hint: 'Select Audience',
                                              options: _audienceOptions,
                                              value: _selectedAudience,
                                              onChanged: (v) => setState(
                                                () => _selectedAudience = v,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: columnWidth,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildSectionTitle('Attachment'),
                                            const SizedBox(height: 8),
                                            InkWell(
                                              onTap: _onUploadAttachment,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              child: Container(
                                                width: double.infinity,
                                                height: 120,
                                                decoration: BoxDecoration(
                                                  color: AuthConstants
                                                      .fieldFillColor,
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: CustomPaint(
                                                  painter: _DashedBorderPainter(
                                                    color: AuthConstants
                                                        .borderColor,
                                                    borderRadius: 10,
                                                  ),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      SvgPicture.asset(
                                                        'assets/icons/upload.svg',
                                                        width: 32,
                                                        height: 32,
                                                        colorFilter:
                                                            ColorFilter.mode(
                                                          AuthConstants
                                                              .hintColor,
                                                          BlendMode.srcIn,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        'Upload Attachment',
                                                        style: Get
                                                            .theme
                                                            .textTheme
                                                            .labelMedium
                                                            ?.copyWith(
                                                              color: AuthConstants
                                                                  .hintColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                            ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: gap),
                                      SizedBox(
                                        width: columnWidth,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            _buildSectionTitle(
                                              'Message Content',
                                            ),
                                            const SizedBox(height: 8),
                                            Container(
                                              height: 120,
                                              decoration: BoxDecoration(
                                                color: AuthConstants
                                                    .fieldFillColor,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                border: Border.all(
                                                  color:
                                                      AuthConstants.borderColor,
                                                ),
                                              ),
                                              child: TextField(
                                                controller: _messageController,
                                                maxLines: null,
                                                expands: true,
                                                textAlignVertical:
                                                    TextAlignVertical.top,
                                                style: Get.textTheme.bodyMedium
                                                    ?.copyWith(
                                                      color: AuthConstants
                                                          .textColor,
                                                    ),
                                                decoration: const InputDecoration(
                                                  hintText:
                                                      'Type your message here....',
                                                  hintStyle: TextStyle(
                                                    color:
                                                        AuthConstants.hintColor,
                                                    fontSize: 14,
                                                  ),
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.all(12),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            const Divider(thickness: 1, height: 1, color: Color(0xFFCBD5E1)),
            Padding(
              padding: const EdgeInsets.fromLTRB(32, 16, 32, 24),
              child: _buildActions(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(32, 24, 32, 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(width: 48),
          Expanded(
            child: Center(
              child: Text(
                widget.title,
                style: Get.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                  fontSize: 20,
                ),
              ),
            ),
          ),
          AppCloseButton(onPressed: () => Navigator.of(context).pop()),
        ],
      ),
    );
  }

  Widget _buildActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: 94,
          height: 44,
          child: TextButton(
            onPressed: () => Navigator.of(context).pop(),
            style: TextButton.styleFrom(
              foregroundColor: AuthConstants.supportTextColor,
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
              minimumSize: const Size(94, 44),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: const BorderSide(
                  width: 1,
                  color: AuthConstants.borderColor,
                ),
              ),
            ),
            child: const Text('Cancel'),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 180,
          height: 44,
          child: AppModalPrimaryButton(
            label: _isEditMode ? 'Update Template' : 'Create Template',
            onPressed: _isCreateEnabled ? _onCreate : null,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            minimumSize: const Size(180, 44),
            borderRadius: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: Get.textTheme.labelMedium?.copyWith(
        color: AuthConstants.labelColor,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _requiredLabel(String text) {
    return RichText(
      text: TextSpan(
        style: Get.textTheme.bodySmall?.copyWith(
          color: AuthConstants.labelColor,
          fontSize: 14,
        ),
        children: [
          TextSpan(text: text),
          const TextSpan(
            text: '*',
            style: TextStyle(color: Colors.red, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _selectField({
    required String hint,
    required List<String> options,
    required String? value,
    required ValueChanged<String?> onChanged,
  }) {
    return Builder(
      builder: (fieldContext) {
        return InkWell(
          onTap: () => _showSelectMenu(
            context: fieldContext,
            options: options,
            onSelected: onChanged,
          ),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: AuthConstants.fieldFillColor,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AuthConstants.borderColor),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value ?? hint,
                    style: value != null
                        ? Get.theme.textTheme.bodySmall?.copyWith(
                            color: AuthConstants.labelColor,
                            fontWeight: FontWeight.w600,
                          )
                        : Get.theme.textTheme.labelMedium?.copyWith(
                            color: AuthConstants.hintColor,
                            fontWeight: FontWeight.w500,
                          ),
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 20,
                  color: AuthConstants.hintColor,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildCheckbox(
    String label,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 22,
            height: 22,
            child: Checkbox(
              value: value,
              onChanged: (v) => onChanged(v ?? false),
              fillColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.transparent;
                }
                return null;
              }),
              checkColor: AuthConstants.labelColor,
              side: WidgetStateBorderSide.resolveWith((states) =>
                  const BorderSide(
                    color: AuthConstants.borderColor,
                    width: 1,
                  )),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: AuthConstants.labelColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.borderRadius});
  final Color color;
  final double borderRadius;
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color..style = PaintingStyle.stroke..strokeWidth = 1.5;
    const dashWidth = 6.0;
    const dashSpace = 4.0;
    final rrect = RRect.fromRectAndRadius(Rect.fromLTWH(1, 1, size.width - 2, size.height - 2), Radius.circular(borderRadius - 1));
    final path = Path()..addRRect(rrect);
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0.0, metric.length);
        canvas.drawPath(metric.extractPath(distance, end), paint);
        distance = end + dashSpace;
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
