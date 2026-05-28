import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/landing_page/controllers/faq_chatbot_controller.dart';

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
          height: 620,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF4F46E5), width: 1.2),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF7C3AED), Color(0xFF3B82F6)],
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.support_agent_rounded,
                            color: Color(0xFF6366F1),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Chatbot',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w800,
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
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
                    child: Column(
                      children: [
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
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: _messageBubble(context, message),
                                  ),
                                ),
                                if (widget.controller.isBotTyping.value)
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: _TypingBubble(),
                                  ),
                                if (widget.controller.showMajorQuestions.value)
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: widget.controller.majorEntries
                                        .map(
                                          (entry) => _quickActionChip(
                                            context,
                                            label: entry.question,
                                            onTap: () => widget.controller
                                                .submitQuestion(entry.question),
                                          ),
                                        )
                                        .toList(growable: false),
                                  ),
                              ],
                            );
                          }),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.only(left: 10, right: 6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: widget.controller.inputController,
                                  onSubmitted: widget.controller.submitQuestion,
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: const Color(0xFF111827),
                                        fontWeight: FontWeight.w500,
                                      ),
                                  decoration: InputDecoration(
                                    hintText: 'Type your question...',
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: const Color(0xFF9CA3AF),
                                        ),
                                    isDense: false,
                                    filled: true,
                                    fillColor: const Color(0xFFF8FAFC),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 10,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFFE2E8F0),
                                        width: 1,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                        color: Color(0xFF6366F1),
                                        width: 1.3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 40,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      Color(0xFF7C3AED),
                                      Color(0xFF3B82F6),
                                    ],
                                  ),
                                ),
                                child: IconButton(
                                  padding: EdgeInsets.zero,
                                  onPressed: () =>
                                      widget.controller.submitQuestion(
                                        widget.controller.inputController.text,
                                      ),
                                  icon: const Icon(
                                    Icons.send_rounded,
                                    color: Colors.white,
                                    size: 18,
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

  Widget _messageBubble(BuildContext context, FaqChatMessage message) {
    final bubbleColor = message.isBot
        ? const Color(0xFFF8FAFC)
        : const Color(0xFF4F46E5);
    final textColor = message.isBot ? const Color(0xFF111827) : Colors.white;
    final alignment = message.isBot
        ? Alignment.centerLeft
        : Alignment.centerRight;

    return Align(
      alignment: alignment,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 280),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.circular(16),
          border: message.isBot
              ? Border.all(color: const Color(0xFFE2E8F0), width: 1)
              : null,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0F172A).withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 5),
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
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(14),
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
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFF6366F1), width: 1),
            color: _hovered
                ? const Color(0xFF6366F1).withValues(alpha: 0.08)
                : Colors.transparent,
          ),
          child: InkWell(
            onTap: widget.onTap,
            borderRadius: BorderRadius.circular(999),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Text(
                widget.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF6366F1),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
