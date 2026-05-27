import 'dart:ui' show lerpDouble, PointerDeviceKind;
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:saas/app/screens/authentication/login/views/login_controller.dart';
import 'package:saas/app/screens/landing_page/landing_page_mobile_view.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/widgets/faq_section_heading.dart';
import 'package:saas/shared/widgets/landing_section_skeleton.dart';

part 'landing_page_tablet_view.dart';

/// Scroll-spy anchor: safe-area top + this offset lands below [_TopNav] padding
/// (18 top + 48 nav shell + 12 bottom).
const double _kLandingNavSpyAnchorBelowSafeTop = 78;

/// Extra pixels added to the spy line so a section counts as "active" when
/// [Scrollable.ensureVisible] stops with its top just below the anchor (small
/// [alignment] values leave `dy` slightly above the line otherwise).
const double _kLandingNavSpySectionTopSlackPx = 72;

/// Mouse, trackpad, touch, and stylus all scroll — avoids janky wheel handling on web/desktop.
class _LandingScrollBehavior extends MaterialScrollBehavior {
  const _LandingScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => PointerDeviceKind.values.toSet();
}

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  static const double tabletBreakpoint = 1100.0;
  static const double mobileBreakpoint = 760.0;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  static const double _fullScrollUnlockTarget = 1080;
  final _featuresKey = GlobalKey();
  final _stepsKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _scrollController = ScrollController();

  /// Isolated from scroll body so spy updates don’t rebuild the whole page.
  final ValueNotifier<_TopNavTab?> _navTabHighlight = ValueNotifier(null);

  /// Hero preview only — avoids rebuilding FAQ/features/grid on tab change.
  final ValueNotifier<_PreviewTab> _previewTabHighlight = ValueNotifier(
    _PreviewTab.dashboard,
  );

  bool _renderDeferredSections = false;
  bool _suppressScrollSpy = false;

  /// Scroll-spy runs at most once per frame (listener may fire many times/frame).
  bool _navSpyFramePending = false;

  @override
  void initState() {
    super.initState();
    LoginController.registerHeroIfNeeded();
    _scrollController.addListener(_scheduleNavSpyIfNeeded);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _renderDeferredSections = true);
      for (final path in const [
        AppIcons.recripLogo,
        'assets/images/dashboard-new.png',
        'assets/images/members-new.png',
        'assets/images/subscriptions-new.png',
        'assets/images/renewals-new.png',
      ]) {
        precacheImage(AssetImage(path), context);
      }
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncNavHighlightFromScroll();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scheduleNavSpyIfNeeded);
    _scrollController.dispose();
    _navTabHighlight.dispose();
    _previewTabHighlight.dispose();
    LoginController.deleteHeroIfRegistered();
    super.dispose();
  }

  void _scheduleNavSpyIfNeeded() {
    if (_suppressScrollSpy ||
        !_scrollController.hasClients ||
        _navSpyFramePending ||
        !_renderDeferredSections) {
      return;
    }
    _navSpyFramePending = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _navSpyFramePending = false;
      if (!mounted || _suppressScrollSpy) return;
      _syncNavHighlightFromScroll();
    });
  }

  Future<void> _scrollTo(GlobalKey key, {double alignment = 0.05}) async {
    final sectionContext = key.currentContext;
    if (sectionContext == null) return;
    await Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
      alignment: alignment,
    );
  }

  void _syncNavHighlightFromScroll() {
    if (!mounted || _suppressScrollSpy || !_scrollController.hasClients) {
      return;
    }
    Future.microtask(() {
      if (!mounted || _suppressScrollSpy || !_scrollController.hasClients) {
        return;
      }
      final next = _activeTabFromScrollPhysics(context);
      if (next != _navTabHighlight.value) {
        _navTabHighlight.value = next;
      }
    });
  }

  /// Last section (in order) whose top has crossed the anchor — above features
  /// leaves no tab selected.
  _TopNavTab? _activeTabFromScrollPhysics(BuildContext context) {
    final anchorY =
        MediaQuery.paddingOf(context).top + _kLandingNavSpyAnchorBelowSafeTop;
    final effectiveAnchor = anchorY + _kLandingNavSpySectionTopSlackPx;

    final tabs = <({_TopNavTab tab, GlobalKey key})>[
      (tab: _TopNavTab.features, key: _featuresKey),
      (tab: _TopNavTab.howItWorks, key: _stepsKey),
      (tab: _TopNavTab.pricing, key: _pricingKey),
      (tab: _TopNavTab.contact, key: _contactKey),
    ];

    _TopNavTab? chosen;
    for (final (:tab, :key) in tabs) {
      final target = key.currentContext;
      if (target == null) continue;
      final ro = target.findRenderObject();
      if (ro is! RenderBox || !ro.hasSize) continue;
      final dy = ro.localToGlobal(Offset.zero).dy;
      if (dy <= effectiveAnchor) {
        chosen = tab;
      }
    }
    return chosen;
  }

  Future<void> _onNavTap(_TopNavTab tab, GlobalKey key) async {
    if (!mounted) return;
    _suppressScrollSpy = true;
    _navTabHighlight.value = tab;
    await _scrollTo(key, alignment: 0.0);
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 460));
    if (!mounted) return;
    _suppressScrollSpy = false;
    _syncNavHighlightFromScroll();
  }

  Future<void> _scrollToFeaturesFromArrow() async {
    if (!_renderDeferredSections) {
      if (mounted) setState(() => _renderDeferredSections = true);
      await Future<void>.delayed(const Duration(milliseconds: 16));
    }

    final sectionContext = _featuresKey.currentContext;
    if (sectionContext != null && _scrollController.hasClients) {
      final renderObject = sectionContext.findRenderObject();
      if (renderObject is RenderBox) {
        final viewport = RenderAbstractViewport.of(renderObject);
        final revealOffset = viewport
            .getOffsetToReveal(renderObject, 0.05)
            .offset;
        final target = revealOffset.clamp(
          0.0,
          _scrollController.position.maxScrollExtent,
        );
        await _scrollController.animateTo(
          target,
          duration: const Duration(milliseconds: 520),
          curve: Curves.easeOutCubic,
        );
        return;
      }
    }

    if (_scrollController.hasClients) {
      final fallbackTarget = _fullScrollUnlockTarget.clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      await _scrollController.animateTo(
        fallbackTarget,
        duration: const Duration(milliseconds: 520),
        curve: Curves.easeOutCubic,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    if (width < LandingPage.mobileBreakpoint) {
      return const LandingPageMobileView();
    }

    if (width < LandingPage.tabletBreakpoint) {
      return const LandingPageTabletView();
    }

    final horizontalPadding = (width * 0.055).clamp(32.0, 144.0);

    return Scaffold(
      backgroundColor: const Color(0xFF090611),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF06030D),
              Color(0xFF170A36),
              Color(0xFF261159),
              Color(0xFF12061D),
            ],
            stops: [0.0, 0.3, 0.72, 1.0],
          ),
        ),
        child: Column(
          children: [
            SafeArea(
              bottom: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  18,
                  horizontalPadding,
                  12,
                ),
                child: ValueListenableBuilder<_TopNavTab?>(
                  valueListenable: _navTabHighlight,
                  builder: (context, activeNavTab, _) {
                    return _TopNav(
                      selectedTab: activeNavTab,
                      onFeatures: () =>
                          _onNavTap(_TopNavTab.features, _featuresKey),
                      onSteps: () =>
                          _onNavTap(_TopNavTab.howItWorks, _stepsKey),
                      onPricing: () =>
                          _onNavTap(_TopNavTab.pricing, _pricingKey),
                      onContact: () =>
                          _onNavTap(_TopNavTab.contact, _contactKey),
                    );
                  },
                ),
              ),
            ),
            Expanded(
              child: ScrollConfiguration(
                behavior: const _LandingScrollBehavior(),
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: ClampingScrollPhysics(),
                  ),
                  cacheExtent: 1200,
                  slivers: [
                    SliverToBoxAdapter(
                      child: ValueListenableBuilder<_PreviewTab>(
                        valueListenable: _previewTabHighlight,
                        builder: (context, selectedPreviewTab, _) {
                          return RepaintBoundary(
                            child: _HeroSection(
                              padding: horizontalPadding,
                              selectedTab: selectedPreviewTab,
                              onTabSelected: (tab) =>
                                  _previewTabHighlight.value = tab,
                              onPrimaryTap: () =>
                                  appNav.changePage(AppRoutes.login),
                              onSecondaryTap: () =>
                                  _onNavTap(_TopNavTab.contact, _contactKey),
                              onArrowTap: _scrollToFeaturesFromArrow,
                            ),
                          );
                        },
                      ),
                    ),
                    if (_renderDeferredSections) ...[
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: _FeatureSection(
                            key: _featuresKey,
                            padding: horizontalPadding,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: _StepSection(
                            key: _stepsKey,
                            padding: horizontalPadding,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: _PricingSection(
                            key: _pricingKey,
                            padding: horizontalPadding,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: _ContactSection(
                            key: _contactKey,
                            padding: horizontalPadding,
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: _FaqSection(padding: horizontalPadding),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: _BottomCtaSection(padding: horizontalPadding),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: RepaintBoundary(
                          child: _FooterSection(padding: horizontalPadding),
                        ),
                      ),
                    ] else
                      SliverToBoxAdapter(
                        child: LandingSectionSkeleton(
                          padding: horizontalPadding,
                          blockCount: 5,
                          includeWideBlock: true,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum _TopNavTab { features, howItWorks, pricing, contact }

class _TopNav extends StatelessWidget {
  const _TopNav({
    required this.selectedTab,
    required this.onFeatures,
    required this.onSteps,
    required this.onPricing,
    required this.onContact,
  });

  final _TopNavTab? selectedTab;
  final VoidCallback onFeatures;
  final VoidCallback onSteps;
  final VoidCallback onPricing;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    Widget navPill({
      required _TopNavTab tab,
      required String label,
      required VoidCallback onTap,
      required double pillHorizontalPadding,
    }) {
      final selected = selectedTab == tab;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 35,
          padding: EdgeInsets.symmetric(
            horizontal: pillHorizontalPadding,
            vertical: 4,
          ),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: selected ? const Color(0xFF3F37D8) : Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth;
        final compact = w < 1020;
        final tight = w < 900;
        final pillGap = compact ? 10.0 : 24.0;
        final pillHPad = tight ? 12.0 : 16.0;
        final navShellHPad = tight ? 4.0 : 8.0;

        final logoRow = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/brand-logo.png',
              width: 34,
              height: 34,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/images/recrip.png',
              height: 42,
              fit: BoxFit.contain,
            ),
          ],
        );

        final pillShell = SizedBox(
          height: 48,
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: navShellHPad,
              vertical: 6.5,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF4F46E5), width: 1),
              color: const Color(0x14000000),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                navPill(
                  tab: _TopNavTab.features,
                  label: 'Features',
                  onTap: onFeatures,
                  pillHorizontalPadding: pillHPad,
                ),
                SizedBox(width: pillGap),
                navPill(
                  tab: _TopNavTab.howItWorks,
                  label: 'How it works',
                  onTap: onSteps,
                  pillHorizontalPadding: pillHPad,
                ),
                SizedBox(width: pillGap),
                navPill(
                  tab: _TopNavTab.pricing,
                  label: 'Pricing',
                  onTap: onPricing,
                  pillHorizontalPadding: pillHPad,
                ),
                SizedBox(width: pillGap),
                navPill(
                  tab: _TopNavTab.contact,
                  label: 'Contact',
                  onTap: onContact,
                  pillHorizontalPadding: pillHPad,
                ),
              ],
            ),
          ),
        );

        final ctaRow = Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => appNav.changePage(AppRoutes.login),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: tight ? 12 : 20,
                  vertical: 14,
                ),
              ),
              child: Text(
                'Log in',
                style: Get.theme.textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            SizedBox(width: tight ? 8 : 12),
            SizedBox(
              width: tight ? 128 : 142,
              height: 48,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Color(0xFF4F46E5), Color(0xFF2C277F)],
                  ),
                ),
                child: FilledButton(
                  onPressed: () => appNav.changePage(AppRoutes.login),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    shadowColor: Colors.transparent,
                    padding: EdgeInsets.fromLTRB(
                      tight ? 16 : 24,
                      10,
                      tight ? 16 : 24,
                      10,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: Get.theme.textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

        return SizedBox(
          height: 48,
          width: w,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Align(alignment: Alignment.centerLeft, child: logoRow),
              Align(alignment: Alignment.centerRight, child: ctaRow),
              pillShell,
            ],
          ),
        );
      },
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.padding,
    required this.selectedTab,
    required this.onTabSelected,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
    required this.onArrowTap,
  });

  final double padding;
  final _PreviewTab selectedTab;
  final ValueChanged<_PreviewTab> onTabSelected;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;
  final VoidCallback onArrowTap;

  @override
  Widget build(BuildContext context) {
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final widthAdaptiveScale = (viewportWidth / 1512).clamp(0.76, 1.0);
    final heightAdaptiveScale = (viewportHeight / 900).clamp(0.76, 1.0);
    final dashboardScale = (widthAdaptiveScale * heightAdaptiveScale).clamp(
      0.72,
      1.0,
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 56, padding, 54),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 28),
                RichText(
                  text: TextSpan(
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      height: 1.12,
                      fontSize: 60,
                    ),
                    children: const [
                      TextSpan(text: 'Never Lose Revenue\nfrom '),
                      TextSpan(
                        text: 'Expired Subscriptions',
                        style: TextStyle(
                          color: Color(0xFF5F57F8),
                          fontWeight: FontWeight.w900,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Text(
                    'Recrip helps businesses automate renewals, track customers, and recover missed payments — all from one powerful dashboard.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFE2DDF7),
                      height: 1.55,
                      fontWeight: FontWeight.w400,
                      fontSize: 24,
                    ),
                  ),
                ),
                const SizedBox(height: 38),
                Row(
                  children: [
                    _HeroButton(
                      label: 'Book a Free Trial',
                      filled: true,
                      onTap: onPrimaryTap,
                    ),
                    const SizedBox(width: 18),
                    _HeroButton(
                      label: 'Schedule a Demo',
                      filled: false,
                      onTap: onSecondaryTap,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  'No credit card required • 14-day free trial • Cancel anytime',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF475569),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 90),
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1120),
              child: _HeroPreviewShowcase(
                selectedTab: selectedTab,
                onTabSelected: onTabSelected,
                dashboardScale: dashboardScale,
                isCompact: false,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Center(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onArrowTap,
              child: SizedBox(
                width: 72,
                height: 72,
                child: Center(
                  child: SvgPicture.asset(
                    'assets/icons/arrow-down.svg',
                    width: 36,
                    height: 36,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroButton extends StatelessWidget {
  const _HeroButton({
    required this.label,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = Get.theme.textTheme.headlineMedium?.copyWith(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    );

    if (filled) {
      return SizedBox(
        width: 208,
        height: 64,
        child: DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFF4F46E5), Color(0xFF2C277F)],
            ),
          ),
          child: FilledButton(
            onPressed: onTap,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(label, style: style),
          ),
        ),
      );
    }

    return SizedBox(
      width: 220,
      height: 64,
      child: CustomPaint(
        painter: const _GradientStrokePainter(),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: Text(label, style: style),
        ),
      ),
    );
  }
}

class _GradientStrokePainter extends CustomPainter {
  const _GradientStrokePainter();

  @override
  void paint(Canvas canvas, Size size) {
    const strokeWidth = 1.0;
    final rect = Offset.zero & size;
    final rRect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      const Radius.circular(30),
    );
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = const LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        colors: [Color(0xFF4F46E5), Color(0xFF2C277F)],
      ).createShader(rect);
    canvas.drawRRect(rRect, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroDashboardCard extends StatelessWidget {
  const _HeroDashboardCard({required this.imagePath, this.sizeScale = 1});

  final String imagePath;
  final double sizeScale;
  static const double _baseWidth = 725;
  static const double _baseHeight = 453;

  @override
  Widget build(BuildContext context) {
    final dpr = MediaQuery.devicePixelRatioOf(context);
    // Decode at full base size for the current DPR so tiny text in the
    // screenshot stays sharp even when the card is scaled down responsively.
    final cacheW = (_baseWidth * dpr).round().clamp(1, 8192);
    final cacheH = (_baseHeight * dpr).round().clamp(1, 8192);

    return SizedBox(
      width: _baseWidth * sizeScale,
      height: _baseHeight * sizeScale,
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFDCE3F3), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x44130A25),
              blurRadius: 36,
              offset: Offset(0, 24),
            ),
          ],
        ),
        child: RepaintBoundary(
          child: Image.asset(
            imagePath,
            fit: BoxFit.contain,
            alignment: Alignment.center,
            filterQuality: FilterQuality.high,
            gaplessPlayback: true,
            cacheWidth: cacheW,
            cacheHeight: cacheH,
          ),
        ),
      ),
    );
  }
}

enum _PreviewTab { dashboard, members, subscriptions, renewals }

/// Framed dashboard mockup with headline above the image, subcopy, and
/// centered horizontal preview pills (original showcase layout).
class _HeroPreviewShowcase extends StatelessWidget {
  const _HeroPreviewShowcase({
    required this.selectedTab,
    required this.onTabSelected,
    required this.dashboardScale,
    this.isCompact = false,
  });

  final _PreviewTab selectedTab;
  final ValueChanged<_PreviewTab> onTabSelected;
  final double dashboardScale;

  /// Tighter padding and type when used from tablet layout.
  final bool isCompact;

  @override
  Widget build(BuildContext context) {
    final outerPad = isCompact ? 18.0 : 28.0;
    final subcopySize = isCompact ? 14.0 : 16.0;

    final subcopyStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      color: const Color(0xFFE2DDF7),
      height: 1.55,
      fontSize: subcopySize,
      fontWeight: FontWeight.w400,
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(outerPad),
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF4F46E5)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x443C2DD8),
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style:
                  Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ) ??
                  TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
              children: const [
                TextSpan(text: 'Built for '),
                TextSpan(
                  text: 'Modern Teams',
                  style: TextStyle(color: Color(0xFF4F46E5)),
                ),
              ],
            ),
          ),
          SizedBox(height: isCompact ? 10 : 12),
          Text(
            'Switch between core product views to see how Recrip keeps your revenue operations organized.',
            textAlign: TextAlign.center,
            style: subcopyStyle,
          ),
          SizedBox(height: isCompact ? 18 : 22),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF08042A),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF4F46E5)),
            ),
            child: AspectRatio(
              aspectRatio: 1.6,
              child: _HeroDashboardCard(
                imagePath: _previewImageFor(selectedTab),
                sizeScale: isCompact ? 1.0 : dashboardScale,
              ),
            ),
          ),
          SizedBox(height: isCompact ? 18 : 22),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: isCompact ? 12 : 16,
            runSpacing: isCompact ? 12 : 16,
            children: _PreviewTab.values
                .map(
                  (tab) => _HeroPreviewTabChip(
                    label: _previewLabel(tab),
                    iconAsset: _previewIcon(tab),
                    selected: tab == selectedTab,
                    onTap: () => onTabSelected(tab),
                    compact: isCompact,
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HeroPreviewTabChip extends StatelessWidget {
  const _HeroPreviewTabChip({
    required this.label,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
    this.compact = true,
  });

  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final iconSize = compact ? 18.0 : 20.0;
    final hPad = compact ? 18.0 : 22.0;
    final vPad = compact ? 12.0 : 14.0;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: EdgeInsets.symmetric(horizontal: hPad, vertical: vPad),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAEFFC) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: iconSize,
              height: iconSize,
              colorFilter: ColorFilter.mode(
                selected ? const Color(0xFF5C57F4) : const Color(0xFF66739B),
                BlendMode.srcIn,
              ),
            ),
            SizedBox(width: compact ? 10 : 12),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selected
                    ? const Color(0xFF5C57F4)
                    : const Color(0xFF66739B),
                fontWeight: FontWeight.w700,
                fontSize: compact ? null : 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: padding),
            child: const _SectionTitle(
              title: 'Everything you need to',
              accent: 'scale faster',
              description:
                  'Stop manually tracking spreadsheets. Recrip automates the boring stuff so you can\nfocus on growth.',
            ),
          ),
          const SizedBox(height: 60),
          LayoutBuilder(
            builder: (context, constraints) {
              const columns = 3;
              final totalRows = (features.length / columns).ceil();
              final cardHorizontalPadding = lerpDouble(
                28,
                87,
                ((constraints.maxWidth - 1100) / 340).clamp(0.0, 1.0),
              )!;
              final childAspectRatio = lerpDouble(
                1.28,
                1.95,
                ((constraints.maxWidth - 1100) / 340).clamp(0.0, 1.0),
              )!;
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3B2F84)),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: features.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    childAspectRatio: childAspectRatio,
                  ),
                  itemBuilder: (context, index) {
                    final column = index % columns;
                    final row = index ~/ columns;
                    final showRightBorder = column < columns - 1;
                    final showBottomBorder = row < totalRows - 1;
                    return _FeatureCard(
                      feature: features[index],
                      showRightBorder: showRightBorder,
                      showBottomBorder: showBottomBorder,
                      horizontalPadding: cardHorizontalPadding,
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.feature,
    required this.showRightBorder,
    required this.showBottomBorder,
    required this.horizontalPadding,
  });

  final _Feature feature;
  final bool showRightBorder;
  final bool showBottomBorder;
  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 27,
        horizontal: horizontalPadding,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        border: Border(
          right: showRightBorder
              ? const BorderSide(color: Color(0xFF3B2F84))
              : BorderSide.none,
          bottom: showBottomBorder
              ? const BorderSide(color: Color(0xFF3B2F84))
              : BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: feature.color,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                feature.iconAsset,
                width: 32,
                height: 32,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            feature.title,
            textAlign: TextAlign.start,
            style: Get.theme.textTheme.bodyLarge?.copyWith(
              color: feature.color,
            ),

            // TextStyle(
            //   color: feature.color,
            //   fontWeight: FontWeight.w700,
            // ),
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            textAlign: TextAlign.start,
            style: Get.theme.textTheme.bodySmall!.copyWith(
              color: const Color(0xFFD7D7D7),
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _StepSection extends StatelessWidget {
  const _StepSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final outlineFontSize = lerpDouble(
      58,
      85,
      ((width - 1100) / 340).clamp(0.0, 1.0),
    )!;
    final connectorInset = lerpDouble(
      72,
      225,
      ((width - 1100) / 340).clamp(0.0, 1.0),
    )!;
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 10, padding, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
            title: 'Get started in',
            accent: '3 simple steps',
            description: null,
            accentOnNewLine: false,
          ),
          const SizedBox(height: 28),
          Text(
            'Identify, Support & Retain',
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w900,
              fontSize: outlineFontSize,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = const Color(0x33FFFFFF),
            ),
          ),
          const SizedBox(height: 62),
          Stack(
            children: [
              Positioned(
                left: connectorInset,
                right: connectorInset,
                top: 27,
                child: Container(height: 1, color: const Color(0xFF6A5AB5)),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps
                    .map(
                      (step) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _StepCard(step: step),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final descriptionFontSize = lerpDouble(
      18,
      24,
      ((width - 1100) / 340).clamp(0.0, 1.0),
    )!;

    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Color(0x40383737),
                offset: Offset(0, 13),
                blurRadius: 11.1,
              ),
            ],
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            step.iconAsset,
            width: 32,
            height: 32,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 22),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text(
                step.title,
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.bodyLarge?.copyWith(
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                step.description,
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  fontSize: descriptionFontSize,
                  color: const Color(0xFF969696),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _PricingSection extends StatelessWidget {
  const _PricingSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 8, padding, 120),
      child: Column(
        children: [
          _SectionTitle(
            title: 'Simple &',
            accent: 'transparent pricing',
            description: null,
            accentOnNewLine: false,
          ),
          const SizedBox(height: 114),
          LayoutBuilder(
            builder: (context, constraints) {
              final gap = lerpDouble(
                24,
                40,
                ((constraints.maxWidth - 1080) / 520).clamp(0.0, 1.0),
              )!;

              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _PricingCard(plan: pricingPlans[0]),
                      SizedBox(width: gap),
                      _PricingCard(plan: pricingPlans[1]),
                    ],
                  ),
                  const SizedBox(height: 34),
                  // const Center(child: _ContactSalesButton()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ContactSalesButton extends StatelessWidget {
  const _ContactSalesButton();

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () => appNav.changePage(AppRoutes.login),
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        fixedSize: const Size(317, 64),
        backgroundColor: const Color(0xFF08042A),
        padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
        side: const BorderSide(color: Color(0xFF4F46E5), width: 1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
      child: const Text('Contact sales for more information'),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.plan});

  final _PricingPlan plan;

  /// Matches design spec: 484×569, 1px border, 30px radius.
  static const double _kWidth = 484;
  static const double _kHeight = 569;

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 40.0;

    return SizedBox(
      width: _kWidth,
      height: _kHeight,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          horizontalPadding,
          0,
          horizontalPadding,
          32,
        ),
        decoration: BoxDecoration(
          color: const Color(0xFF08042A),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: const Color(0xFF4F46E5), width: 1),
          boxShadow: const [
            BoxShadow(
              color: Color(0x443C2DD8),
              blurRadius: 32,
              offset: Offset(0, 12),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: -32,
              left: 0,
              right: 0,
              child: _PricingPlanBadge(label: plan.name),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 74),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: plan.price,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 32,
                            ),
                          ),
                          const TextSpan(
                            text: '/month',
                            style: TextStyle(
                              color: Color(0xFF5F688E),
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  ...plan.items.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF8B8DA7),
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PricingPlanBadge extends StatelessWidget {
  const _PricingPlanBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        width: 156,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Color(0xFF4F46E5), Color(0xFF2C277F)],
          ),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF4F46E5)),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}

class _ContactSection extends StatelessWidget {
  const _ContactSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 6, padding, 120),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final gap = lerpDouble(
            18,
            28,
            ((constraints.maxWidth - 980) / 220).clamp(0.0, 1.0),
          )!;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 44,
                child: Padding(
                  padding: EdgeInsets.only(right: gap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                height: 1.15,
                                color: Colors.white,
                              ),
                          children: [
                            const TextSpan(text: 'Start Automating\nYour '),
                            TextSpan(
                              text: 'Renewals Today',
                              style: Get.theme.textTheme.bodyLarge?.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Join hundreds of businesses that are recovering lost revenue every single day. No credit card required to start.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 22),
                      ...contactHighlights.map(
                        (item) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: Row(
                            children: [
                              Container(
                                width: 32,
                                height: 32,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF4F46E5),
                                  shape: BoxShape.circle,
                                ),
                                alignment: Alignment.center,
                                child: SvgPicture.asset(
                                  'assets/icons/circle-check.svg',
                                  width: 20,
                                  height: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item,
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(
                                        color: const Color(0xFF475569),
                                        fontWeight: FontWeight.w600,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: gap),
              const Expanded(flex: 56, child: _LeadCard()),
            ],
          );
        },
      ),
    );
  }
}

class _LeadCard extends StatefulWidget {
  const _LeadCard();

  @override
  State<_LeadCard> createState() => _LeadCardState();
}

class _LeadCardState extends State<_LeadCard> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _businessNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isSending = false;

  static final _emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static final _phoneRegex = RegExp(r'^\+?[0-9 ]{7,15}$');

  @override
  void dispose() {
    _fullNameController.dispose();
    _businessNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final form = _formKey.currentState;
    if (form == null || !form.validate()) return;

    setState(() => _isSending = true);
    try {
      final endpoint = Uri.parse('https://formsubmit.co/ajax/admin@recrip.com');
      final response = await http.post(
        endpoint,
        headers: const {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': _fullNameController.text.trim(),
          'business_name': _businessNameController.text.trim(),
          'email': _emailController.text.trim(),
          'phone': _phoneController.text.trim(),
          'subject': 'New enquiry from Recrip landing page',
          '_captcha': 'false',
          '_template': 'table',
        }),
      );

      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw Exception('Submission failed with ${response.statusCode}');
      }
      final decoded = jsonDecode(response.body);
      final successValue = decoded is Map<String, dynamic>
          ? decoded['success']?.toString().toLowerCase()
          : null;
      if (successValue != 'true') {
        final message = decoded is Map<String, dynamic>
            ? decoded['message']?.toString()
            : null;
        throw Exception(message ?? 'Submission rejected by provider.');
      }

      if (mounted) {
        form.reset();
        _fullNameController.clear();
        _businessNameController.clear();
        _emailController.clear();
        _phoneController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Enquiry sent successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Could not send enquiry. ${e.toString().replaceFirst('Exception: ', '')}',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final horizontalPadding = lerpDouble(
          28,
          48,
          ((constraints.maxWidth - 520) / 260).clamp(0.0, 1.0),
        )!;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.only(
            top: 32,
            left: horizontalPadding,
            right: horizontalPadding,
            bottom: 51,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFF08042A),
            borderRadius: BorderRadius.circular(50),
            border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _DarkField(
                        label: 'Full Name',
                        hint: 'Enter Full Name',
                        controller: _fullNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Full name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _DarkField(
                        label: 'Business Name',
                        hint: 'Enter Business Name',
                        controller: _businessNameController,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Business name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: _DarkField(
                        label: 'Email Address',
                        hint: 'Enter Email Address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          final v = value?.trim() ?? '';
                          if (v.isEmpty) return 'Email is required';
                          if (!_emailRegex.hasMatch(v)) {
                            return 'Enter valid email';
                          }
                          return null;
                        },
                      ),
                    ),
                    const SizedBox(width: 32),
                    Expanded(
                      child: _DarkField(
                        label: 'Phone Number',
                        hint: 'Enter Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          final v = value?.trim() ?? '';
                          if (v.isEmpty) return 'Phone number is required';
                          if (!_phoneRegex.hasMatch(v)) {
                            return 'Enter valid phone';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: FilledButton(
                    onPressed: _isSending ? null : _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: const Color(0xFF5C5BFF),
                      disabledBackgroundColor: const Color(0xFF5C5BFF),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: _isSending
                        ? const SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Request Enquiry',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'Request enquiry and we will get back to you.\nThank you!',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF475569),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DarkField extends StatelessWidget {
  const _DarkField({
    required this.label,
    required this.hint,
    required this.controller,
    required this.validator,
    this.keyboardType,
  });

  final String label;
  final String hint;
  final TextEditingController controller;
  final FormFieldValidator<String> validator;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFFE8E2FF),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 44,
          child: TextFormField(
            controller: controller,
            validator: validator,
            keyboardType: keyboardType,
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            style: Get.theme.textTheme.labelMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: hint,
              errorStyle: const TextStyle(
                color: Color(0xFFFCA5A5),
                fontSize: 11,
              ),
              hintStyle: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF8E9AC7)),
              isDense: false,
              filled: true,
              fillColor: const Color(0xFF0F172A),
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
                  color: Color(0xFFE2E8F0),
                  width: 1,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFFCA5A5)),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFFFCA5A5)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 120),
      child: Column(
        children: [
          const FaqSectionHeading(
            leadColor: Color(0xFF4F46E5),
            restColor: Colors.white,
            fontSize: 40,
          ),
          const SizedBox(height: 48),
          LayoutBuilder(
            builder: (context, constraints) {
              final gap = lerpDouble(
                20,
                35,
                ((constraints.maxWidth - 980) / 220).clamp(0.0, 1.0),
              )!;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 46,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: faqs
                          .map(
                            (faq) => Padding(
                              padding: const EdgeInsets.only(bottom: 24),
                              child: _FaqCard(faq: faq),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  SizedBox(width: gap),
                  const Expanded(flex: 54, child: _QuestionCard()),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FaqCard extends StatelessWidget {
  const _FaqCard({required this.faq});

  static const double _kBorderRadius = 20;

  final _Faq faq;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(_kBorderRadius),
        border: Border.all(color: const Color(0xFFDCE3F3), width: 1),
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            faq.question,
            style: Get.theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            faq.answer,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  const _QuestionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 413,
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Got anything to ask us?',
            style: Get.theme.textTheme.bodyLarge?.copyWith(
              fontSize: 20,
              color: const Color(0xFF4F46E5),
            ),
          ),
          const SizedBox(height: 32),
          TextField(
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Your Email Address Here',
              hintStyle: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF)),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              contentPadding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFCBD5E1),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFF4F46E5),
                  width: 1,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 155,
            child: TextField(
              expands: true,
              maxLines: null,
              minLines: null,
              style: const TextStyle(color: Colors.white),
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Type your message here...',
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF)),
                filled: true,
                fillColor: const Color(0xFF0F172A),
                contentPadding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFCBD5E1),
                    width: 1,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFF4F46E5),
                    width: 1,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                elevation: 0,
                minimumSize: const Size(0, 46),
                backgroundColor: const Color(0xFF312E91),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Send',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomCtaSection extends StatelessWidget {
  const _BottomCtaSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 12, padding, 120),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Get.theme.textTheme.bodyLarge?.copyWith(
                fontSize: 40,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
              children: [
                TextSpan(text: 'Ready to transform your\n'),
                TextSpan(
                  text: 'Renewal Process?',
                  style: Get.theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Join thousands of teams who have reduced churn and increased retention with Recrip.\nStart your free trial today.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFE2DDF7),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 60),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _HeroButton(
                label: 'Book a Free Trial',
                filled: true,
                onTap: () => appNav.changePage(AppRoutes.login),
              ),
              const SizedBox(width: 14),
              _HeroButton(
                label: 'Schedule a Demo',
                filled: false,
                onTap: () {},
              ),
            ],
          ),
          const SizedBox(height: 32),
          Text(
            'No credit card required • 14-day free trial • Cancel anytime',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

/// Desktop / laptop landing footer: five columns (brand, Product, Company, Legal, Social).
class _FooterSection extends StatelessWidget {
  const _FooterSection({required this.padding});

  final double padding;

  static const Color _kBackground = Color(0xFF0B0B2A);
  static const Color _kMutedText = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 64, padding, 40),
      decoration: const BoxDecoration(color: _kBackground),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(flex: 32, child: _FooterBrandColumn()),
              Expanded(
                flex: 14,
                child: _FooterColumn(
                  title: 'Product',
                  items: const ['Features', 'Pricing'],
                  linkColor: _kMutedText,
                ),
              ),
              Expanded(
                flex: 14,
                child: _FooterColumn(
                  title: 'Company',
                  items: const ['About', 'Contact'],
                  linkColor: _kMutedText,
                ),
              ),
              Expanded(
                flex: 14,
                child: _FooterColumn(
                  title: 'Legal',
                  items: const ['Privacy Policy', 'Terms of Service'],
                  linkColor: _kMutedText,
                ),
              ),
              const Expanded(flex: 14, child: _FooterSocialColumn()),
            ],
          ),
          const SizedBox(height: 48),
          Divider(
            color: Colors.white.withValues(alpha: 0.14),
            thickness: 1,
            height: 1,
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: Text(
              '© 2026 Recrip. All rights reserved.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: _kMutedText,
                fontWeight: FontWeight.w500,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterBrandColumn extends StatelessWidget {
  const _FooterBrandColumn();

  static const Color _kTagline = Color(0xFF94A3B8);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(
          AppIcons.recripLogo,
          height: 44,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.high,
        ),
        const SizedBox(height: 22),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            'Most powerful subscription renewal management platform. Built for business that want to scale without losing revenue.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: _kTagline,
              fontWeight: FontWeight.w400,
              height: 1.55,
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({
    required this.title,
    required this.items,
    required this.linkColor,
  });

  final String title;
  final List<String> items;
  final Color linkColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Get.theme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 20),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Text(
              item,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: linkColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _FooterSocialColumn extends StatelessWidget {
  const _FooterSocialColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Social',
          style: Get.theme.textTheme.titleSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.15,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          children: const [
            _FooterSocialIcon('assets/images/linkedin-new.png'),
            SizedBox(width: 12),
            _FooterSocialIcon('assets/images/instagram.png'),
            SizedBox(width: 12),
            _FooterSocialIcon('assets/images/twitter.png'),
            SizedBox(width: 12),
            _FooterSocialIcon('assets/images/facebook-new.png'),
          ],
        ),
      ],
    );
  }
}

class _FooterSocialIcon extends StatelessWidget {
  const _FooterSocialIcon(this.assetPath);

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(assetPath, width: 32, height: 32, fit: BoxFit.contain);
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.accent,
    required this.description,
    this.accentOnNewLine = true,
  });

  final String title;
  final String accent;
  final String? description;
  final bool accentOnNewLine;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Get.theme.textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 40,
            ),
            children: [
              TextSpan(text: title),
              TextSpan(text: accentOnNewLine ? '\n' : ' '),
              TextSpan(
                text: accent,
                style: const TextStyle(color: Color(0xFF4F46E5)),
              ),
            ],
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 24),
          Text(
            description!,
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ],
    );
  }
}

String _previewImageFor(_PreviewTab tab) {
  switch (tab) {
    case _PreviewTab.dashboard:
      return 'assets/images/dashboard-new.png';
    case _PreviewTab.members:
      return 'assets/images/members-new.png';
    case _PreviewTab.subscriptions:
      return 'assets/images/subscriptions-new.png';
    case _PreviewTab.renewals:
      return 'assets/images/renewals-new.png';
  }
}

String _previewIcon(_PreviewTab tab) {
  switch (tab) {
    case _PreviewTab.dashboard:
      return AppIcons.dashboard;
    case _PreviewTab.members:
      return AppIcons.usersRound;
    case _PreviewTab.subscriptions:
      return AppIcons.calendarDays;
    case _PreviewTab.renewals:
      return AppIcons.calendarSync;
  }
}

String _previewLabel(_PreviewTab tab) {
  switch (tab) {
    case _PreviewTab.dashboard:
      return 'Dashboard';
    case _PreviewTab.members:
      return 'Members';
    case _PreviewTab.subscriptions:
      return 'Subscriptions';
    case _PreviewTab.renewals:
      return 'Renewals';
  }
}

const features = [
  _Feature(
    'Smart Renewal Alerts',
    'Automatically remind customers via WhatsApp, SMS, and email before they expire.',
    AppIcons.bell,
    Color(0xFF41A3FF),
  ),
  _Feature(
    'Analytics Dashboard',
    'Track revenue, renewals, and customer behavior with customer behavior insights.',
    AppIcons.chartPie,
    Color(0xFF8C58FF),
  ),
  _Feature(
    'Auto Renewals',
    'Set it once and let Recrip handle the rest. Seamless recurring billing.',
    AppIcons.renew,
    Color(0xFF14C98D),
  ),
  _Feature(
    'Customer Management',
    'All your subscription data in one place. Search, filter, and manage with ease.',
    AppIcons.usersRound,
    Color(0xFFF54BFF),
  ),
  _Feature(
    'Payment Recovery',
    'Recover missed payments and reduce churn effortlessly with automated retries.',
    AppIcons.creditCard,
    Color(0xFF6ED0FF),
  ),
  _Feature(
    'Analytics Dashboard',
    'Track revenue, renewals, and customer behavior with deep visual insights.',
    AppIcons.globe,
    Color(0xFFFFA31A),
  ),
];

const steps = [
  _Step(
    'Add your customers',
    'Import your existing customer list or sync with your current CRM in seconds.',
    AppIcons.addCustomer,
  ),
  _Step(
    'Set renewal schedules',
    'Define when and how you want to notify customers about their upcoming renewals.',
    AppIcons.clock,
  ),
  _Step(
    'Automate & track revenue',
    'Sit back while Recrip handles the follow-ups and provides real-time growth data.',
    AppIcons.trendingUp,
  ),
];

const pricingPlans = [
  _PricingPlan(
    name: 'Starter',
    price: '₹1499',
    items: [
      '300 Members',
      'WhatsApp Reminders',
      'Renewal Alerts',
      'Default Reminders',
      'Export Report (Current Month)',
    ],
  ),
  _PricingPlan(
    name: 'Growth',
    price: '₹2499',
    items: [
      'Unlimited Members',
      'WhatsApp/Email Reminders',
      'Advanced Insights',
      'Renewal Alerts',
      'Custom Reminders',
      'Custom Ad Template',
      'Priority Support',
      'Export Report (Custom Preference)',
    ],
  ),
];

const contactHighlights = [
  'Free 14-day trial',
  'No Setup fees',
  'Cancel Anytime',
  '24/7 Priority Support',
];

const faqs = [
  _Faq(
    'Can I customize the notification messages?',
    'Absolutely! You can fully customize the content, timing, and channel (WhatsApp, Email) for every notification sent.',
  ),
  _Faq(
    'Is my customer data secure?',
    'Yes, we use bank-grade encryption and are fully GDPR and SOC2 compliant. Your data is isolated and protected at all times.',
  ),
  _Faq(
    'What businesses is Recrip best for?',
    'Recrip is designed for any business with recurring subscriptions, including gyms, salons, clinics, SaaS, and service providers.',
  ),
];

class _Feature {
  const _Feature(this.title, this.description, this.iconAsset, this.color);

  final String title;
  final String description;
  final String iconAsset;
  final Color color;
}

class _Step {
  const _Step(this.title, this.description, this.iconAsset);

  final String title;
  final String description;
  final String iconAsset;
}

class _PricingPlan {
  const _PricingPlan({
    required this.name,
    required this.price,
    required this.items,
  });

  final String name;
  final String price;
  final List<String> items;
}

class _Faq {
  const _Faq(this.question, this.answer);

  final String question;
  final String answer;
}
