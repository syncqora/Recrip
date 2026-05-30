import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/landing_page/controllers/faq_chatbot_controller.dart';
import 'package:saas/shared/constants/app_icons.dart';

/// FAQ chatbot card used in the landing page FAQ section.
class LandingFaqChatbotCard extends StatefulWidget {
  /// Creates the landing FAQ chatbot card.
  const LandingFaqChatbotCard({super.key, required this.controller});

  /// Controller that handles chatbot logic and state.
  final FaqChatbotController controller;

  @override
  State<LandingFaqChatbotCard> createState() => _LandingFaqChatbotCardState();
}

class _LandingFaqChatbotCardState extends State<LandingFaqChatbotCard> {
  bool _isVisible = false;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _isVisible = true);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedOpacity(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
      opacity: _isVisible ? 1 : 0,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOutBack,
        scale: _isVisible ? 1 : 0.96,
        child: Container(
          width: 380,
          height: 720,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF4F46E5), width: 1.1),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF312E81), Color(0xFF5B21B6), Color(0xFF2563EB)],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1E1B4B).withValues(alpha: 0.18),
                blurRadius: 32,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.16),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.18),
                            ),
                          ),
                          child: Center(
                            child: SvgPicture.asset(
                              AppIcons.headset,
                              width: 24,
                              height: 24,
                              colorFilter: const ColorFilter.mode(
                                Colors.white,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            'Recrip Assistant',
                            style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(999),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.16),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF86EFAC),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Online',
                                style: theme.textTheme.labelMedium?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
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
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
                    child: Column(
                      children: [
                        _buildSuggestionsPanel(context),
                        const SizedBox(height: 12),
                        Expanded(
                          child: Obx(() {
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!_scrollController.hasClients) return;
                              _scrollController.animateTo(
                                _scrollController.position.maxScrollExtent,
                                duration: const Duration(milliseconds: 260),
                                curve: Curves.easeOut,
                              );
                            });

                            return ListView(
                              controller: _scrollController,
                              children: [
                                ...widget.controller.messages.map(
                                  (message) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: _messageBubble(context, message),
                                  ),
                                ),
                                if (widget.controller.isBotTyping.value)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 12),
                                    child: _TypingBubble(),
                                  ),
                              ],
                            );
                          }),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: const Color(0xFFE2E8F0),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(
                                  0xFF0F172A,
                                ).withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: widget.controller.inputController,
                                  onSubmitted: widget.controller.submitQuestion,
                                  minLines: 1,
                                  maxLines: 3,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: const Color(0xFF111827),
                                    fontWeight: FontWeight.w500,
                                    height: 1.35,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Ask about pricing, plans, reminders, reports...',
                                    hintStyle: theme.textTheme.bodySmall
                                        ?.copyWith(
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                    isDense: true,
                                    filled: false,
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 10,
                                    ),
                                    border: InputBorder.none,
                                    enabledBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF7C3AED),
                                      Color(0xFF2563EB),
                                    ],
                                  ),
                                ),
                                child: IconButton(
                                  padding: const EdgeInsets.all(12),
                                  onPressed: () =>
                                      widget.controller.submitQuestion(
                                        widget.controller.inputController.text,
                                      ),
                                  icon: Image.asset(
                                    'assets/icons/circle-arrow-right.png',
                                    width: 18,
                                    height: 18,
                                    color: Colors.white,
                                    colorBlendMode: BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ],
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
      ),
    );
  }

  Widget _buildSuggestionsPanel(BuildContext context) {
    return Obx(() {
      final entries = widget.controller.suggestedEntries.toList(growable: false);
      final hasConversation = widget.controller.messages.length > 1;

      return Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              hasConversation ? 'Suggested follow-ups' : 'Popular questions',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: const Color(0xFF0F172A),
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              hasConversation
                  ? 'Continue the conversation with related questions.'
                  : 'Start with one of the common questions below.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF64748B),
                height: 1.35,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: entries
                  .map(
                    (entry) => _quickActionChip(
                      context,
                      label: entry.question,
                      onTap: () => widget.controller.submitQuestion(
                        entry.question,
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          ],
        ),
      );
    });
  }

  Widget _messageBubble(BuildContext context, FaqChatMessage message) {
    final bubbleColor = message.isBot
        ? Colors.white
        : const Color(0xFF4338CA);
    final textColor = message.isBot ? const Color(0xFF111827) : Colors.white;
    final alignment = message.isBot
        ? Alignment.centerLeft
        : Alignment.centerRight;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(message.isBot ? 6 : 18),
            bottomRight: Radius.circular(message.isBot ? 18 : 6),
          ),
          border: message.isBot
              ? Border.all(color: const Color(0xFFE2E8F0), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.05),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Text(
          message.text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w500,
            height: 1.35,
          ),
        ),
      ),
    );
  }

  Widget _quickActionChip(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
  }) {
    return _InteractiveQuickChip(label: label, onTap: onTap);
  }
}

class _TypingBubble extends StatefulWidget {
  const _TypingBubble();

  @override
  State<_TypingBubble> createState() => _TypingBubbleState();
}

class _TypingBubbleState extends State<_TypingBubble>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Align(
          alignment: Alignment.centerLeft,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TypingDot(progress: _controller.value, phase: 0),
                const SizedBox(width: 5),
                _TypingDot(progress: _controller.value, phase: 1),
                const SizedBox(width: 5),
                _TypingDot(progress: _controller.value, phase: 2),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _TypingDot extends StatelessWidget {
  const _TypingDot({required this.progress, required this.phase});

  final double progress;
  final int phase;

  @override
  Widget build(BuildContext context) {
    final shifted = (progress + (phase * 0.2)) % 1;
    final opacity = 0.35 + (0.65 * (1 - (shifted - 0.5).abs() * 2));
    return Container(
      width: 6,
      height: 6,
      decoration: BoxDecoration(
        color: const Color(0xFF9CA3AF).withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _InteractiveQuickChip extends StatefulWidget {
  const _InteractiveQuickChip({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  State<_InteractiveQuickChip> createState() => _InteractiveQuickChipState();
}

class _InteractiveQuickChipState extends State<_InteractiveQuickChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 140),
        scale: _hovered ? 1.03 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: _hovered
                  ? const Color(0xFF4338CA)
                  : const Color(0xFFC7D2FE),
              width: 1,
            ),
            color: _hovered
                ? const Color(0xFFEEF2FF)
                : const Color(0xFFF8FAFC),
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(14),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF4338CA),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
