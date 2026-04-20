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

  _TopNavTab _activeNavTab = _TopNavTab.features;
  _PreviewTab _selectedPreviewTab = _PreviewTab.dashboard;
  bool _renderDeferredSections = false;
  bool _isSnappingHeroTransition = false;
  double _heroCardShiftProgress = 0;
  late final AnimationController _dashboardTapController;
  late final Animation<double> _dashboardTapAnimation;

  @override
  void initState() {
    super.initState();
    _dashboardTapController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    _dashboardTapAnimation = CurvedAnimation(
      parent: _dashboardTapController,
      curve: const Cubic(0.78, 0.01, 0.5, 1),
    );
    _dashboardTapController.addListener(() {
      if (mounted) setState(() {});
    });
    LoginController.registerHeroIfNeeded();
    _scrollController.addListener(_handleScroll);
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
      _handleScroll();
    });
  }

  @override
  void dispose() {
    _dashboardTapController.dispose();
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    LoginController.deleteHeroIfRegistered();
    super.dispose();
  }

  void _handleScroll() {
    if (!mounted) return;

    final nextHeroProgress =
        (_scrollController.hasClients
                ? (_scrollController.offset / _heroTransitionScrollExtent)
                : 0.0)
            .clamp(0.0, 1.0);
    if (nextHeroProgress != _heroCardShiftProgress) {
      setState(() {
        _heroCardShiftProgress = nextHeroProgress;
      });
    }
  }

  ScrollPhysics get _scrollPhysics => _isSnappingHeroTransition
      ? const NeverScrollableScrollPhysics()
      : const ClampingScrollPhysics();

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
        _handleScroll();
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
    if (!_renderDeferredSections ||
        _isSnappingHeroTransition ||
        !_scrollController.hasClients) {
      return false;
    }

    final offset = _scrollController.offset;
    bool? goingDown;

    if (notification is UserScrollNotification) {
      if (notification.direction == ScrollDirection.idle) return false;
      goingDown = notification.direction == ScrollDirection.reverse;
    } else if (notification is ScrollUpdateNotification &&
        notification.dragDetails != null) {
      final dy = notification.scrollDelta ?? 0;
      if (dy.abs() < 0.001) return false;
      goingDown = dy > 0;
    } else {
      return false;
    }

    // Fully unlock normal scroll once stage-3 is complete.
    if (goingDown && offset >= _fullScrollUnlockTarget - 0.5) {
      return false;
    }
    // While above the transition zone, allow normal upward scrolling.
    if (!goingDown && offset > _fullScrollUnlockTarget + 0.5) {
      return false;
    }

    if (_shouldSnapForDirection(goingDown: goingDown, offset: offset)) {
      _snapHeroTransition(forward: goingDown);
      return true;
    }
    return false;
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final sectionContext = key.currentContext;
    if (sectionContext == null) return;
    await Scrollable.ensureVisible(
      sectionContext,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,
      alignment: 0.05,
    );
  }

  Future<void> _onNavTap(_TopNavTab tab, GlobalKey key) async {
    setState(() => _activeNavTab = tab);
    await _scrollTo(key);
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
          340,
          760,
          (remaining / _stageMenuTarget).clamp(0.0, 1.0),
        )!.round();
        await _scrollController.animateTo(
          _stageMenuTarget,
          duration: Duration(milliseconds: durationMs),
          curve: Curves.easeInOutCubicEmphasized,
        );
      } finally {
        if (mounted) {
          setState(() => _isSnappingHeroTransition = false);
          _handleScroll();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final currentOffset = _scrollController.hasClients
        ? _scrollController.offset
        : 0.0;
    final fullUnlockProgress = (currentOffset / _fullScrollUnlockTarget).clamp(
      0.0,
      1.0,
    );
    final releaseProgress = Curves.easeInOutCubic.transform(
      ((fullUnlockProgress - 0.58) / 0.42).clamp(0.0, 1.0),
    );
    final heroCompensation = currentOffset * (1 - releaseProgress);
    final featureRevealProgress = Curves.easeOutCubic.transform(
      ((fullUnlockProgress - 0.72) / 0.28).clamp(0.0, 1.0),
    );

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
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  18,
                  horizontalPadding,
                  12,
                ),
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
                      Transform.translate(
                        // Keep staged hero transition visually locked so finished
                        // content and incoming content stay aligned.
                        offset: Offset(0, heroCompensation),
                        child: Column(
                          children: [
                            _HeroSection(
                              padding: horizontalPadding,
                              scrollProgress: _heroCardShiftProgress,
                              dashboardTapProgress:
                                  _dashboardTapAnimation.value,
                              selectedTab: _selectedPreviewTab,
                              onTabSelected: (tab) =>
                                  setState(() => _selectedPreviewTab = tab),
                              onPrimaryTap: () =>
                                  appNav.changePage(AppRoutes.login),
                              onSecondaryTap: () =>
                                  _onNavTap(_TopNavTab.contact, _contactKey),
                              onDashboardTap: _onDashboardCardTap,
                            ),
                            if (_renderDeferredSections)
                              SizedBox(
                                // Keep next section parked below until the full
                                // staged transition is released progressively.
                                height: lerpDouble(
                                  540,
                                  0,
                                  featureRevealProgress,
                                )!,
                              ),
                          ],
                        ),
                      ),
                      if (_renderDeferredSections) ...[
                        _FeatureSection(
                          key: _featuresKey,
                          padding: horizontalPadding,
                        ),
                        _StepSection(
                          key: _stepsKey,
                          padding: horizontalPadding,
                        ),
                        _PricingSection(
                          key: _pricingKey,
                          padding: horizontalPadding,
                        ),
                        _ContactSection(padding: horizontalPadding),
                        _FaqSection(
                          key: _contactKey,
                          padding: horizontalPadding,
                        ),
                        _BottomCtaSection(padding: horizontalPadding),
                        _FooterSection(padding: horizontalPadding),
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

  final _TopNavTab selectedTab;
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
          padding: const EdgeInsets.symmetric(horizontal: 26, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: selected ? const Color(0xFF3F37D8) : Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    return Row(
      children: [
        Image.asset(AppIcons.recripLogo, height: 42, fit: BoxFit.contain),
        const Spacer(),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: const Color(0xFF5445D9)),
            color: const Color(0x14000000),
          ),
          child: Row(
            children: [
              navPill(
                tab: _TopNavTab.features,
                label: 'Features',
                onTap: onFeatures,
              ),
              navPill(
                tab: _TopNavTab.howItWorks,
                label: 'How it works',
                onTap: onSteps,
              ),
              navPill(
                tab: _TopNavTab.pricing,
                label: 'Pricing',
                onTap: onPricing,
              ),
              navPill(
                tab: _TopNavTab.contact,
                label: 'Contact',
                onTap: onContact,
              ),
            ],
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () => appNav.changePage(AppRoutes.login),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          child: const Text(
            'Log in',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
        ),
        const SizedBox(width: 12),
        FilledButton(
          onPressed: () => appNav.changePage(AppRoutes.login),
          style: FilledButton.styleFrom(
            backgroundColor: const Color(0xFF5C57F4),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(999),
            ),
          ),
          child: const Text(
            'Get Started',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
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
    required this.dashboardTapProgress,
    required this.selectedTab,
    required this.onTabSelected,
    required this.onPrimaryTap,
    required this.onSecondaryTap,
    required this.onDashboardTap,
  });

  final double padding;
  final double scrollProgress;
  final double dashboardTapProgress;
  final _PreviewTab selectedTab;
  final ValueChanged<_PreviewTab> onTabSelected;
  final VoidCallback onPrimaryTap;
  final VoidCallback onSecondaryTap;
  final VoidCallback onDashboardTap;

  @override
  Widget build(BuildContext context) {
    // Match reference: copy fades out earlier while card enters.
    final textFadeProgress = ((scrollProgress - 0.10) / 0.38).clamp(0.0, 1.0);
    final textOpacity = 1 - Curves.easeInOut.transform(textFadeProgress);
    final cardMoveProgress = Curves.easeOutCubic.transform(
      (scrollProgress / 0.45).clamp(0.0, 1.0),
    );
    final dashboardTapLift = lerpDouble(0, -40, dashboardTapProgress)!;
    final dashboardTapScale = lerpDouble(1, 1.06, dashboardTapProgress)!;
    final cardVisualHeight = lerpDouble(420, 487.2, cardMoveProgress)!;
    final menuProgress = Curves.easeOutCubic.transform(
      ((scrollProgress - 0.45) / 0.35).clamp(0.0, 1.0),
    );
    // Keep transformed visuals within Stack bounds so hit-testing aligns with
    // what the user sees.
    const rightPanelTopInset = 240.0;

    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 56, padding, 54),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 6,
            child: Opacity(
              opacity: textOpacity,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    Text(
                      'Never Lose Revenue\nfrom ',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                        height: 1.12,
                        fontSize: 60,
                      ),
                    ),
                    Text(
                      'Expired Subscriptions',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: const Color(0xFF5F57F8),
                        fontWeight: FontWeight.w800,
                        height: 1.0,
                        fontSize: 62,
                      ),
                    ),
                    const SizedBox(height: 30),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 800),
                      child: Text(
                        'Recrip helps businesses automate renewals, track customers, and recover missed payments — all from one powerful dashboard.',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
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
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFF7B73A7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),
          Expanded(
            flex: 5,
            child: Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: rightPanelTopInset),
                    child: Transform.translate(
                      offset: Offset(
                        // Single image moves into center/text area.
                        lerpDouble(0, -690, cardMoveProgress)!,
                        lerpDouble(0, -240, cardMoveProgress)! +
                            dashboardTapLift,
                      ),
                      child: Transform.scale(
                        scale:
                            lerpDouble(1, 1.16, cardMoveProgress)! *
                            dashboardTapScale,
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: onDashboardTap,
                          child: _HeroDashboardCard(
                            imagePath: _previewImageFor(selectedTab),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    right: -6,
                    top: rightPanelTopInset,
                    child: Opacity(
                      opacity: menuProgress,
                      child: Transform.translate(
                        offset: Offset(
                          lerpDouble(90, 0, menuProgress)!,
                          lerpDouble(0, -240, cardMoveProgress)!,
                        ),
                        child: SizedBox(
                          width: 270,
                          height: cardVisualHeight,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontSize: 46,
                                        fontWeight: FontWeight.w900,
                                        height: 1.02,
                                        color: Colors.white,
                                      ),
                                  children: const [
                                    TextSpan(text: 'Built for '),
                                    TextSpan(
                                      text: 'Modern\nTeams',
                                      style: TextStyle(
                                        color: Color(0xFF5F57F8),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),
                              const Spacer(),
                              ..._PreviewTab.values.indexed.map((entry) {
                                final itemProgress =
                                    ((menuProgress - (entry.$1 * 0.12)) / 0.6)
                                        .clamp(0.0, 1.0);
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: Opacity(
                                    opacity: itemProgress,
                                    child: Transform.translate(
                                      offset: Offset(
                                        lerpDouble(60, 0, itemProgress)!,
                                        0,
                                      ),
                                      child: _PreviewNavItem(
                                        label: _previewLabel(entry.$2),
                                        iconAsset: _previewIcon(entry.$2),
                                        selected: entry.$2 == selectedTab,
                                        onTap: () => onTabSelected(entry.$2),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
    final style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w700,
      fontSize: 16,
    );

    if (filled) {
      return FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF5C57F4),
          foregroundColor: Colors.white,
          minimumSize: const Size(208, 60),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: Text(label, style: style),
      );
    }

    return OutlinedButton(
      onPressed: onTap,
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        minimumSize: const Size(208, 60),
        side: const BorderSide(color: Color(0xFF5C57F4)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      child: Text(label, style: style),
    );
  }
}

class _HeroDashboardCard extends StatelessWidget {
  const _HeroDashboardCard({required this.imagePath});

  final String imagePath;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: Color(0x44130A25),
            blurRadius: 36,
            offset: Offset(0, 24),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          alignment: Alignment.topLeft,
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
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAEFFC) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
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
            const SizedBox(width: 14),
            Text(
              label,
              style: TextStyle(
                color: selected
                    ? const Color(0xFF5C57F4)
                    : const Color(0xFF66739B),
                fontWeight: FontWeight.w600,
                fontSize: 17,
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
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SectionTitle(
            title: 'Everything you need to',
            accent: 'scale faster',
            description:
                'Stop manually tracking spreadsheets. Recrip automates the boring stuff so you can focus on growth.',
          ),
          const SizedBox(height: 34),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = constraints.maxWidth / 3;
              return Wrap(
                children: features
                    .map(
                      (feature) => SizedBox(
                        width: cardWidth,
                        child: _FeatureCard(feature: feature),
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 192,
      //  padding: const EdgeInsets.fromLTRB(26, 24, 26, 20),
      padding: EdgeInsets.symmetric(vertical: 27, horizontal: 87),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF3B2F84)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
          const SizedBox(height: 18),
          Text(
            feature.title,
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
          ),
          const SizedBox(height: 28),
          Text(
            'Identify, Support & Retain',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontWeight: FontWeight.w800,
              fontSize: 62,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 1
                ..color = const Color(0xFF30255C),
            ),
          ),
          const SizedBox(height: 30),
          Stack(
            children: [
              Positioned(
                left: 140,
                right: 140,
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
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF5C57F4),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            step.iconAsset,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          step.title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 22,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          step.description,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFFC9C1EC),
            height: 1.55,
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
          ),
          const SizedBox(height: 42),
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
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 24),
                              child: _PricingCard(plan: pricingPlans[0]),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24),
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
                            padding: const EdgeInsets.symmetric(
                              horizontal: 34,
                              vertical: 18,
                            ),
                            side: const BorderSide(color: Color(0xFF554AD8)),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
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
      height: 700,
      padding: const EdgeInsets.fromLTRB(58, 74, 54, 56),
      decoration: BoxDecoration(
        color: const Color(0xFF0E0825),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF4E42D1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x443C2DD8),
            blurRadius: 32,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Transform.translate(
            offset: const Offset(0, -106),
            child: Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 156,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: const Color(0xFFFF9900)),
                ),
                child: Text(
                  plan.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          ),
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
          const SizedBox(height: 40),
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
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontSize: 34,
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                            color: Colors.white,
                          ),
                      children: const [
                        TextSpan(text: 'Start Automating\nYour '),
                        TextSpan(
                          text: 'Renewals Today',
                          style: TextStyle(color: Color(0xFF5F57F8)),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Join hundreds of businesses that are recovering lost revenue every single day. No credit card required to start.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: const Color(0xFFC9C1EC),
                      height: 1.55,
                    ),
                  ),
                  const SizedBox(height: 22),
                  ...contactHighlights.map(
                    (item) => Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFF7167FF),
                                width: 1.5,
                              ),
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFF7167FF),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            item,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: const Color(0xFFC9C1EC)),
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
        color: const Color(0xFF16224A),
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
            'Request a demo and we will get back to you. Thank you!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFC9D1F0),
              height: 1.2,
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
            fillColor: const Color(0xFF16224A),
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
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: faqs
                      .map(
                        (faq) => Padding(
                          padding: const EdgeInsets.only(bottom: 14),
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

class _ExpandableFaqCard extends StatefulWidget {
  const _ExpandableFaqCard({required this.faq});

  final _Faq faq;

  @override
  State<_ExpandableFaqCard> createState() => _ExpandableFaqCardState();
}

class _ExpandableFaqCardState extends State<_ExpandableFaqCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF110A29),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFB8AFF0)),
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Icon(
                    _open ? Icons.remove_rounded : Icons.add_rounded,
                    color: const Color(0xFFC9C1EC),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
              child: Text(
                widget.faq.answer,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFFC9C1EC),
                  height: 1.55,
                ),
              ),
            ),
            crossFadeState: _open
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 180),
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
      constraints: const BoxConstraints(minHeight: 413),
      padding: const EdgeInsets.only(left: 24, right: 24, top: 24, bottom: 32),
      decoration: BoxDecoration(
        color: const Color(0xFF110A29),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB8AFF0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Got anything to ask us?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF7066FF),
              fontWeight: FontWeight.w700,
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
              fillColor: const Color(0xFF151B2F),
              contentPadding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xFFDCE3F3),
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
          const SizedBox(height: 24),
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
                fillColor: const Color(0xFF151B2F),
                contentPadding: const EdgeInsets.fromLTRB(12, 11, 12, 11),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(
                    color: Color(0xFFDCE3F3),
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
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                elevation: 0,
                minimumSize: const Size(0, 48),
                backgroundColor: const Color(0xFF5C5BFF),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Send',
                style: TextStyle(fontWeight: FontWeight.w700),
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
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontSize: 50,
                fontWeight: FontWeight.w800,
                height: 1.1,
                color: Colors.white,
              ),
              children: const [
                TextSpan(text: 'Ready to transform your\n'),
                TextSpan(
                  text: 'Renewal Process?',
                  style: TextStyle(color: Color(0xFF5F57F8)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Join thousands of teams who have reduced churn and increased retention with Recrip.\nStart your free trial today.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFE2DDF7),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 28),
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
          const SizedBox(height: 14),
          Text(
            'No credit card required • 14-day free trial • Cancel anytime',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF7B73A7)),
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
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: const Color(0xFF5D678A),
                          fontSize: 20,
                          height: 1.18,
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
              color: const Color(0xFF697394),
              fontSize: 22,
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
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 22),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFF5D678A),
                fontSize: 18,
                height: 1.1,
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
  });

  final String title;
  final String accent;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Colors.white,
              fontSize: 46,
              fontWeight: FontWeight.w800,
              height: 1.15,
            ),
            children: [
              TextSpan(text: title),
              const TextSpan(text: '\n'),
              TextSpan(
                text: accent,
                style: const TextStyle(color: Color(0xFF5F57F8)),
              ),
            ],
          ),
        ),
        if (description != null) ...[
          const SizedBox(height: 14),
          Text(
            description!,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFE2DDF7),
              height: 1.55,
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
      return 'assets/images/Members.webp';
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
