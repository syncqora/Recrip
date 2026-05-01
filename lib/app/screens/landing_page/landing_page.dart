import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/login/views/login_controller.dart';
import 'package:saas/app/screens/landing_page/landing_page_mobile_view.dart';
import 'package:saas/app/screens/landing_page/landing_page_tablet_view.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/widgets/landing_section_skeleton.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  static const double tabletBreakpoint = 1100.0;
  static const double mobileBreakpoint = 760.0;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage>
    with SingleTickerProviderStateMixin {
  static const double _heroTransitionScrollExtent = 760;
  static const double _stageCardTarget = 280;
  static const double _stageMenuTarget = 540;
  static const double _stageUnlockTarget = _heroTransitionScrollExtent;
  static const double _fullScrollUnlockTarget = 1080;
  final _featuresKey = GlobalKey();
  final _stepsKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _scrollController = ScrollController();

  _TopNavTab? _activeNavTab;
  _PreviewTab _selectedPreviewTab = _PreviewTab.dashboard;
  bool _renderDeferredSections = false;
  bool _isSnappingHeroTransition = false;
  late final AnimationController _dashboardTapController;
  late final Animation<double> _dashboardTapAnimation;

  @override
  void initState() {
    super.initState();
    _dashboardTapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 480),
    );
    _dashboardTapAnimation = CurvedAnimation(
      parent: _dashboardTapController,
      curve: Curves.easeOutCubic,
    );
    LoginController.registerHeroIfNeeded();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _renderDeferredSections = true);
      for (final path in const [
        AppIcons.recripLogo,
        'assets/images/Dashboard.webp',
        'assets/images/Members.webp',
        'assets/images/Renewals.webp',
      ]) {
        precacheImage(AssetImage(path), context);
      }
    });
  }

  @override
  void dispose() {
    _dashboardTapController.dispose();
    _scrollController.dispose();
    LoginController.deleteHeroIfRegistered();
    super.dispose();
  }

  ScrollPhysics get _scrollPhysics => const ClampingScrollPhysics();

  double _nextSnapTarget({required bool forward, required double offset}) {
    const points = <double>[
      0,
      _stageCardTarget,
      _stageMenuTarget,
      _stageUnlockTarget,
      _fullScrollUnlockTarget,
    ];
    if (forward) {
      for (final p in points) {
        if (p > offset + 1) return p;
      }
      return _fullScrollUnlockTarget;
    }
    for (final p in points.reversed) {
      if (p < offset - 1) return p;
    }
    return 0;
  }

  Future<void> _snapHeroTransition({required bool forward}) async {
    if (!_scrollController.hasClients || _isSnappingHeroTransition) return;
    final target = _nextSnapTarget(
      forward: forward,
      offset: _scrollController.offset,
    );
    final current = _scrollController.offset;
    if ((current - target).abs() < 1) return;

    setState(() => _isSnappingHeroTransition = true);
    try {
      final distance = (target - current).abs();
      final durationMs = lerpDouble(
        240,
        760,
        (distance / 540).clamp(0.0, 1.0),
      )!.round();
      await _scrollController.animateTo(
        target,
        duration: Duration(milliseconds: durationMs),
        curve: Curves.easeInOutCubic,
      );
    } finally {
      if (mounted) {
        setState(() => _isSnappingHeroTransition = false);
      }
    }
  }

  bool _shouldSnapForDirection({
    required bool goingDown,
    required double offset,
  }) {
    if (goingDown) {
      return offset < _fullScrollUnlockTarget - 0.5;
    }
    return offset > 0.5 && offset <= _fullScrollUnlockTarget + 0.5;
  }

  bool _handleScrollNotification(ScrollNotification notification) {
    // Disable scroll-snapping interception to keep native scrolling buttery.
    return false;
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

  Future<void> _onNavTap(_TopNavTab tab, GlobalKey key) async {
    setState(() => _activeNavTab = tab);
    if (tab == _TopNavTab.features && _scrollController.hasClients) {
      final target = (_fullScrollUnlockTarget - 90).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      await _scrollController.animateTo(
        target,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
      return;
    }
    final targetAlignment = tab == _TopNavTab.features ? 0.0 : 0.05;
    await _scrollTo(key, alignment: targetAlignment);
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
            ?.getOffsetToReveal(renderObject, 0.05)
            .offset;
        if (revealOffset != null) {
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

  Future<void> _onDashboardCardTap() async {
    if (_isSnappingHeroTransition) return;
    if (!_scrollController.hasClients) return;

    // Give the dashboard card a small tactile pulse on tap.
    if (!_dashboardTapController.isAnimating) {
      _dashboardTapController.forward(from: 0);
    }

    final offset = _scrollController.offset;
    if (offset < _stageMenuTarget - 0.5) {
      final remaining = (_stageMenuTarget - offset).clamp(
        0.0,
        _stageMenuTarget,
      );

      setState(() => _isSnappingHeroTransition = true);
      try {
        final durationMs = lerpDouble(
          220,
          460,
          (remaining / _stageMenuTarget).clamp(0.0, 1.0),
        )!.round();
        await _scrollController.animateTo(
          _stageMenuTarget,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeOutCubic,
        );
      } finally {
        if (mounted) {
          setState(() => _isSnappingHeroTransition = false);
        }
      }
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

    final horizontalPadding = width > 1440 ? 88.0 : 72.0;

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
                padding: EdgeInsets.fromLTRB(120, 18, 120, 12),
                child: _TopNav(
                  selectedTab: _activeNavTab,
                  onFeatures: () =>
                      _onNavTap(_TopNavTab.features, _featuresKey),
                  onSteps: () => _onNavTap(_TopNavTab.howItWorks, _stepsKey),
                  onPricing: () => _onNavTap(_TopNavTab.pricing, _pricingKey),
                  onContact: () => _onNavTap(_TopNavTab.contact, _contactKey),
                ),
              ),
            ),
            Expanded(
              child: NotificationListener<ScrollNotification>(
                onNotification: _handleScrollNotification,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  physics: _scrollPhysics,
                  child: Column(
                    children: [
                      AnimatedBuilder(
                        animation: _scrollController,
                        builder: (context, child) {
                          final currentOffset = _scrollController.hasClients
                              ? _scrollController.offset
                              : 0.0;
                          final fullUnlockProgress =
                              (currentOffset / _fullScrollUnlockTarget).clamp(
                                0.0,
                                1.0,
                              );
                          final releaseProgress = Curves.easeInOutCubic
                              .transform(
                                ((fullUnlockProgress - 0.58) / 0.42).clamp(
                                  0.0,
                                  1.0,
                                ),
                              );
                          final heroCompensation =
                              currentOffset * (1 - releaseProgress);
                          final featureRevealProgress = Curves.easeOutCubic
                              .transform(
                                ((fullUnlockProgress - 0.72) / 0.28).clamp(
                                  0.0,
                                  1.0,
                                ),
                              );
                          final heroCardShiftProgress =
                              (currentOffset / _heroTransitionScrollExtent)
                                  .clamp(0.0, 1.0);

                          return Transform.translate(
                            // Keep staged hero transition visually locked so
                            // finished content and incoming content stay aligned.
                            offset: Offset(0, heroCompensation),
                            child: Column(
                              children: [
                                RepaintBoundary(
                                  child: _HeroSection(
                                    padding: horizontalPadding,
                                    scrollProgress: heroCardShiftProgress,
                                    dashboardTapAnimation:
                                        _dashboardTapAnimation,
                                    selectedTab: _selectedPreviewTab,
                                    onTabSelected: (tab) => setState(
                                      () => _selectedPreviewTab = tab,
                                    ),
                                    onPrimaryTap: () =>
                                        appNav.changePage(AppRoutes.login),
                                    onSecondaryTap: () => _onNavTap(
                                      _TopNavTab.contact,
                                      _contactKey,
                                    ),
                                    onDashboardTap: _onDashboardCardTap,
                                    onArrowTap: _scrollToFeaturesFromArrow,
                                  ),
                                ),
                                if (_renderDeferredSections)
                                  SizedBox(
                                    // Keep next section parked below until the full
                                    // staged transition is released progressively.
                                    height: lerpDouble(
                                      620,
                                      90,
                                      featureRevealProgress,
                                    )!,
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                      if (_renderDeferredSections) ...[
                        RepaintBoundary(
                          child: _FeatureSection(
                            key: _featuresKey,
                            padding: horizontalPadding,
                          ),
                        ),
                        RepaintBoundary(
                          child: _StepSection(
                            key: _stepsKey,
                            padding: horizontalPadding,
                          ),
                        ),
                        RepaintBoundary(
                          child: _PricingSection(
                            key: _pricingKey,
                            padding: horizontalPadding,
                          ),
                        ),
                        RepaintBoundary(child: _ContactSection(padding: 120)),
                        RepaintBoundary(
                          child: _FaqSection(key: _contactKey, padding: 120),
                        ),
                        RepaintBoundary(
                          child: _BottomCtaSection(padding: horizontalPadding),
                        ),
                        RepaintBoundary(child: _FooterSection(padding: 120)),
                      ] else ...[
                        LandingSectionSkeleton(
                          padding: horizontalPadding,
                          blockCount: 5,
                          includeWideBlock: true,
                        ),
                      ],
                    ],
                  ),
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
    }) {
      final selected = selectedTab == tab;
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          height: 35,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
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

    return Row(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/brand-logo.png',
              height: 42,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 10),
            Image.asset(
              'assets/images/recrip.png',
              height: 42,
              fit: BoxFit.contain,
            ),
          ],
        ),
        const Spacer(),
        SizedBox(
          height: 48,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: const Color(0xFF4F46E5), width: 1),
              color: const Color(0x14000000),
            ),
            child: Row(
              children: [
                navPill(
                  tab: _TopNavTab.features,
                  label: 'Features',
                  onTap: onFeatures,
                ),
                const SizedBox(width: 24),
                navPill(
                  tab: _TopNavTab.howItWorks,
                  label: 'How it works',
                  onTap: onSteps,
                ),
                const SizedBox(width: 24),
                navPill(
                  tab: _TopNavTab.pricing,
                  label: 'Pricing',
                  onTap: onPricing,
                ),
                const SizedBox(width: 24),
                navPill(
                  tab: _TopNavTab.contact,
                  label: 'Contact',
                  onTap: onContact,
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => appNav.changePage(AppRoutes.login),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          child: Text(
            'Log in',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        SizedBox(
          width: 142,
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
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
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
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.padding,
    required this.scrollProgress,
    required this.dashboardTapAnimation,
    required this.selectedTab,
    required this.onTabSelected,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
    required this.onDashboardTap,
    required this.onArrowTap,
  });

  final double padding;
  final double scrollProgress;
  final Animation<double> dashboardTapAnimation;
  final _PreviewTab selectedTab;
  final ValueChanged<_PreviewTab> onTabSelected;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;
  final VoidCallback onDashboardTap;
  final VoidCallback onArrowTap;

  @override
  Widget build(BuildContext context) {
    final heroContentLeftInset = (120 - padding).clamp(0.0, 120.0);
    final viewportWidth = MediaQuery.sizeOf(context).width;
    final viewportHeight = MediaQuery.sizeOf(context).height;
    final widthAdaptiveScale = (viewportWidth / 1512).clamp(0.94, 1.0);
    final heightAdaptiveScale = (viewportHeight / 900).clamp(0.92, 1.0);
    final dashboardDesktopScale = (widthAdaptiveScale * heightAdaptiveScale)
        .clamp(0.90, 1.0);
    final endScaleByWidth = lerpDouble(
      1.0,
      1.06,
      ((viewportWidth - 1280) / 320).clamp(0.0, 1.0),
    )!;
    final endScaleByHeight = lerpDouble(
      0.96,
      1.0,
      ((viewportHeight - 820) / 180).clamp(0.0, 1.0),
    )!;
    final dashboardEndVisualScale = endScaleByWidth * endScaleByHeight;
    final animationAreaScale = lerpDouble(
      0.90,
      1.0,
      ((viewportWidth - 1280) / 232).clamp(0.0, 1.0),
    )!;
    // Match reference: copy fades out earlier while card enters.
    final textFadeProgress = ((scrollProgress - 0.10) / 0.38).clamp(0.0, 1.0);
    final textOpacity = 1 - Curves.easeInOut.transform(textFadeProgress);
    final cardMoveProgress = Curves.easeOutCubic.transform(
      (scrollProgress / 0.45).clamp(0.0, 1.0),
    );
    final dashboardInitialOpacity = lerpDouble(0.42, 1.0, cardMoveProgress)!;
    final dashboardDullOverlayOpacity = lerpDouble(
      0.42,
      0.0,
      cardMoveProgress,
    )!;
    final cardVisualHeight = lerpDouble(470, 540, cardMoveProgress)!;
    // Keep transformed visuals within Stack bounds so hit-testing aligns with
    // what the user sees.
    const rightPanelTopInset = 240.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 56, padding, 54),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 6,
                child: Padding(
                  padding: EdgeInsets.only(left: heroContentLeftInset),
                  child: Opacity(
                    opacity: textOpacity,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 760),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 28),
                          RichText(
                            text: TextSpan(
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
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
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
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
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(color: const Color(0xFF475569)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 30),
              Expanded(
                flex: 5,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final laneWidth = constraints.maxWidth;
                    final dashboardStartX = (laneWidth * 0.26).clamp(
                      120.0,
                      180.0,
                    );
                    final dashboardEndXBase = -(laneWidth * 1.05).clamp(
                      520.0,
                      680.0,
                    );
                    final panelStartX = (laneWidth * 1.30).clamp(560.0, 820.0);
                    final panelRightInsetBase = (laneWidth * 0.36).clamp(
                      150.0,
                      230.0,
                    );
                    final rowWidth = (laneWidth * 11 / 5) + 30;
                    final laneStartX = (laneWidth * 6 / 5) + 30;
                    final dashboardLeftBase = laneStartX + dashboardEndXBase;
                    final panelLeftBase =
                        laneStartX + (laneWidth - panelRightInsetBase - 340);
                    final groupLeftBase = dashboardLeftBase < panelLeftBase
                        ? dashboardLeftBase
                        : panelLeftBase;
                    final dashboardRightBase = dashboardLeftBase + 725;
                    final panelRightBase = panelLeftBase + 340;
                    final groupRightBase = dashboardRightBase > panelRightBase
                        ? dashboardRightBase
                        : panelRightBase;
                    const additionalRightShift = 72.0;
                    final centerShift =
                        (rowWidth / 2) - ((groupLeftBase + groupRightBase) / 2);
                    final totalShift = centerShift + additionalRightShift;
                    final dashboardEndX = dashboardEndXBase + totalShift;
                    final panelRightInset = (panelRightInsetBase - totalShift)
                        .clamp(40.0, 280.0);

                    return AnimatedBuilder(
                      animation: dashboardTapAnimation,
                      builder: (context, child) {
                        final dashboardTapLift = lerpDouble(
                          0,
                          -22,
                          dashboardTapAnimation.value,
                        )!;
                        final dashboardTapScale = lerpDouble(
                          1,
                          1.02,
                          dashboardTapAnimation.value,
                        )!;

                        return Transform.scale(
                          scale: animationAreaScale,
                          alignment: Alignment.topCenter,
                          child: Padding(
                            padding: const EdgeInsets.only(top: 80),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                    top: rightPanelTopInset,
                                  ),
                                  child: Transform.translate(
                                    offset: Offset(
                                      // Keep same motion feel, but tie travel
                                      // distance to available lane width.
                                      lerpDouble(
                                        dashboardStartX,
                                        dashboardEndX,
                                        cardMoveProgress,
                                      )!,
                                      lerpDouble(20, -220, cardMoveProgress)! +
                                          dashboardTapLift,
                                    ),
                                    child: Transform.scale(
                                      scale:
                                          lerpDouble(
                                            0.96,
                                            dashboardEndVisualScale,
                                            cardMoveProgress,
                                          )! *
                                          dashboardTapScale,
                                      alignment: Alignment.topRight,
                                      child: GestureDetector(
                                        onTap: onDashboardTap,
                                        child: Opacity(
                                          opacity: dashboardInitialOpacity,
                                          child: _HeroDashboardCard(
                                            imagePath: _previewImageFor(
                                              selectedTab,
                                            ),
                                            dullOverlayOpacity:
                                                dashboardDullOverlayOpacity,
                                            sizeScale: dashboardDesktopScale,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: panelRightInset,
                                  top: rightPanelTopInset,
                                  child: Transform.translate(
                                    offset: Offset(
                                      lerpDouble(
                                        panelStartX,
                                        0,
                                        cardMoveProgress,
                                      )!,
                                      // Start fully off-screen and enter with hero motion.
                                      lerpDouble(0, -220, cardMoveProgress)!,
                                    ),
                                    child: SizedBox(
                                      width: 340,
                                      height: cardVisualHeight,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          RichText(
                                            text: TextSpan(
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headlineMedium
                                                  ?.copyWith(
                                                    fontSize: 46,
                                                    fontWeight: FontWeight.w900,
                                                    height: 0.93,
                                                    color: Colors.white,
                                                  ),
                                              children: const [
                                                TextSpan(
                                                  text: 'Built for Modern',
                                                ),
                                                TextSpan(
                                                  text: '\nTeams',
                                                  style: TextStyle(
                                                    color: Color(0xFF5F57F8),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          const SizedBox(height: 48),
                                          ..._PreviewTab.values.map((tab) {
                                            return Padding(
                                              padding: const EdgeInsets.only(
                                                bottom: 16,
                                              ),
                                              child: _PreviewNavItem(
                                                label: _previewLabel(tab),
                                                iconAsset: _previewIcon(tab),
                                                selected: tab == selectedTab,
                                                onTap: () => onTabSelected(tab),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -140,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onArrowTap,
              child: SizedBox(
                width: 72,
                height: 72,
                child: Center(
                  child: Transform.translate(
                    offset: Offset(0, lerpDouble(0, -220, cardMoveProgress)!),
                    child: Opacity(
                      opacity: lerpDouble(0.92, 0.82, cardMoveProgress)!,
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
  const _HeroDashboardCard({
    required this.imagePath,
    this.dullOverlayOpacity = 0,
    this.sizeScale = 1,
  });

  final String imagePath;
  final double dullOverlayOpacity;
  final double sizeScale;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 725 * sizeScale,
      height: 453 * sizeScale,
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
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              filterQuality: FilterQuality.low,
            ),
            if (dullOverlayOpacity > 0)
              ColoredBox(
                color: const Color(0xFF2A1E63).withOpacity(dullOverlayOpacity),
              ),
          ],
        ),
      ),
    );
  }
}

enum _PreviewTab { dashboard, members, subscriptions, renewals }

class _PreviewNavItem extends StatelessWidget {
  const _PreviewNavItem({
    required this.label,
    required this.iconAsset,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String iconAsset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 255,
        height: 56,
        padding: const EdgeInsets.only(left: 24, right: 96),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAEFFC) : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 22,
              height: 22,
              colorFilter: ColorFilter.mode(
                selected ? const Color(0xFF5C57F4) : const Color(0xFF66739B),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OverflowBox(
                alignment: Alignment.centerLeft,
                minWidth: 0,
                maxWidth: double.infinity,
                child: Text(
                  label,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF5C57F4)
                        : const Color(0xFF66739B),
                    fontWeight: FontWeight.w600,
                    fontSize: 17,
                  ),
                ),
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
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF3B2F84)),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: features.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: columns,
                    childAspectRatio: 1.95,
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
  });

  final _Feature feature;
  final bool showRightBorder;
  final bool showBottomBorder;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 192,
      //  padding: const EdgeInsets.fromLTRB(26, 24, 26, 20),
      padding: EdgeInsets.symmetric(vertical: 27, horizontal: 87),
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
            style: Get.theme.textTheme.bodyMedium!.copyWith(
              color: const Color(0xFFD7D7D7),
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
              fontSize: 85,
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
                left: 225,
                right: 225,
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
                  fontSize: 24,
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
          Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1018),
              child: SizedBox(
                height: 700,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned.fill(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 24),
                            child: SizedBox(
                              width: 484,
                              child: _PricingCard(plan: pricingPlans[0]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 24),
                            child: SizedBox(
                              width: 484,
                              child: _PricingCard(plan: pricingPlans[1]),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 34,
                      child: Center(
                        child: OutlinedButton(
                          onPressed: () => appNav.changePage(AppRoutes.login),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            fixedSize: const Size(317, 64),
                            backgroundColor: const Color(0xFF08042A),
                            padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                            side: const BorderSide(
                              color: Color(0xFF4F46E5),
                              width: 1,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Contact sales for more information',
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PricingCard extends StatelessWidget {
  const _PricingCard({required this.plan});

  final _PricingPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 484,
      height: 674,
      padding: const EdgeInsets.fromLTRB(58, 0, 54, 56),
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
                const SizedBox(height: 48),
                ...plan.items.map(
                  (item) => Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF8B8DA7),
                        fontWeight: FontWeight.w700,
                        height: 1.4,
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
          border: Border.all(color: const Color(0xFFFF9900)),
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
  const _ContactSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 6, padding, 120),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(right: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 40,
                        fontWeight: FontWeight.w900,
                        height: 1.15,
                        color: Colors.white,
                      ),
                      children: [
                        TextSpan(text: 'Start Automating\nYour '),
                        TextSpan(
                          text: 'Renewals Today',
                          style: Get.theme.textTheme.bodyLarge?.copyWith(
                            fontSize: 40,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF4F46E5),
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
                            decoration: BoxDecoration(
                              color: Color(0xFF4F46E5),
                              shape: BoxShape.circle,
                              // border: Border.all(
                              //   color: const Color(0xFF7167FF),
                              //   width: 1.5,
                              // ),
                            ),
                            alignment: Alignment.center,
                            child: SvgPicture.asset(
                              'assets/icons/circle-check.svg',
                              width: 20,
                              height: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: const Color(0xFF475569),
                                  fontWeight: FontWeight.w600,
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
          const Expanded(flex: 6, child: _LeadCard()),
        ],
      ),
    );
  }
}

class _LeadCard extends StatelessWidget {
  const _LeadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 689,
      height: 431,
      padding: const EdgeInsets.only(top: 32, left: 48, right: 48, bottom: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Expanded(
                child: _DarkField(label: 'Full Name', hint: 'Enter Full Name'),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _DarkField(
                  label: 'Business Name',
                  hint: 'Enter Business Name',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Expanded(
                child: _DarkField(
                  label: 'Email Address',
                  hint: 'Enter Email Address',
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _DarkField(
                  label: 'Phone Number',
                  hint: 'Enter Phone Number',
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF5C5BFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Request Enquiry',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Request enquiry and we will get back to you.Thank you!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF475569),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkField extends StatelessWidget {
  const _DarkField({required this.label, required this.hint});

  final String label;
  final String hint;

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
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: const Color(0xFF8E9AC7)),
            isDense: true,
            filled: true,
            fillColor: const Color(0xFF0F172A),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 12,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF31457D)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFF5C5BFF)),
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
          _SectionTitle(
            title: 'Frequently',
            accent: 'Asked Questions',
            description: null,
            accentOnNewLine: false,
          ),
          const SizedBox(height: 48),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: faqs
                      .map(
                        (faq) => Padding(
                          padding: const EdgeInsets.only(bottom: 18),
                          child: _ExpandableFaqCard(faq: faq),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(width: 22),
              const Expanded(flex: 6, child: _QuestionCard()),
            ],
          ),
        ],
      ),
    );
  }
}

class _ExpandableFaqCard extends StatelessWidget {
  const _ExpandableFaqCard({required this.faq});

  final _Faq faq;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFDCE3F3), width: 1),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq.question,
                  style: Get.theme.textTheme.titleSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  faq.answer,
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                    height: 1.45,
                  ),
                ),
              ],
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
      width: 652,
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

class _FooterSection extends StatelessWidget {
  const _FooterSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 56, padding, 54),
      decoration: const BoxDecoration(color: Color(0xFF0D0820)),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(AppIcons.recripLogo, height: 50),
                    const SizedBox(height: 24),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 340),
                      child: Text(
                        'Most powerful subscription renewal management platform. Built for business that want to scale without losing revenue.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF475569),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 96),
              Expanded(
                flex: 6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _FooterColumn(
                      title: 'Product',
                      items: ['Features', 'Pricing'],
                    ),
                    _FooterColumn(
                      title: 'Company',
                      items: ['About', 'Contact'],
                    ),
                    _FooterColumn(
                      title: 'Legal',
                      items: ['Privacy Policy', 'Terms of Service'],
                    ),
                    _FooterSocialColumn(),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 56),
          const Divider(color: Color(0xFFB4BDD4), thickness: 0.8),
          const SizedBox(height: 50),
          Text(
            '© 2026 Recrip. All rights reserved.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF64748B),
              fontSize: 20,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _FooterColumn extends StatelessWidget {
  const _FooterColumn({required this.title, required this.items});

  final String title;
  final List<String> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Get.theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 24),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              item,
              style: Get.theme.textTheme.bodyMedium?.copyWith(
                color: Color(0xFF475569),
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
        const Text(
          'Social',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 22),
        Row(
          children: const [
            _FooterSocialIcon('assets/images/linkedin.png'),
            SizedBox(width: 14),
            _FooterSocialIcon('assets/images/insta.png'),
            SizedBox(width: 14),
            _FooterSocialIcon('assets/images/twitter-x.png'),
            SizedBox(width: 14),
            _FooterSocialIcon('assets/images/facebook.png'),
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
      return 'assets/images/Dashboard.webp';
    case _PreviewTab.members:
      return 'assets/images/Members.webp';
    case _PreviewTab.subscriptions:
      return 'assets/images/subscriptions.webp';
    case _PreviewTab.renewals:
      return 'assets/images/Renewals.webp';
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
