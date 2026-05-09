part of 'landing_page.dart';

/// Tablet layout (760–1100px): same structure and scroll-staged hero as desktop
/// [LandingPage]; padding and scale use the same formulas as desktop so only
/// the smaller viewport changes apparent sizing.
class LandingPageTabletView extends StatefulWidget {
  const LandingPageTabletView({super.key});

  @override
  State<LandingPageTabletView> createState() => _LandingPageTabletViewState();
}

class _LandingPageTabletViewState extends State<LandingPageTabletView>
    with SingleTickerProviderStateMixin {
  static const double _heroTransitionScrollExtent = 760;
  static const double _stageMenuTarget = 540;
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
  bool _suppressScrollSpy = false;

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
    _scrollController.addListener(_syncNavHighlightFromScroll);
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncNavHighlightFromScroll();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_syncNavHighlightFromScroll);
    _dashboardTapController.dispose();
    _scrollController.dispose();
    LoginController.deleteHeroIfRegistered();
    super.dispose();
  }

  ScrollPhysics get _scrollPhysics => const ClampingScrollPhysics();

  bool _handleScrollNotification(ScrollNotification notification) {
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

  void _syncNavHighlightFromScroll() {
    if (!mounted || _suppressScrollSpy || !_scrollController.hasClients) {
      return;
    }
    final next = _activeTabFromScrollPhysics(context);
    if (next != _activeNavTab) {
      setState(() => _activeNavTab = next);
    }
  }

  _TopNavTab? _activeTabFromScrollPhysics(BuildContext context) {
    final anchorY =
        MediaQuery.paddingOf(context).top + _kLandingNavSpyAnchorBelowSafeTop;

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
      if (dy <= anchorY) {
        chosen = tab;
      }
    }
    return chosen;
  }

  Future<void> _onNavTap(_TopNavTab tab, GlobalKey key) async {
    if (!mounted) return;
    setState(() {
      _suppressScrollSpy = true;
      _activeNavTab = tab;
    });
    await _scrollTo(key, alignment: 0.04);
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 460));
    if (!mounted) return;
    setState(() => _suppressScrollSpy = false);
    _syncNavHighlightFromScroll();
  }

  Future<void> _scrollToFeaturesFromArrow() async {
    if (!_renderDeferredSections) {
      if (mounted) setState(() => _renderDeferredSections = true);
      await Future<void>.delayed(const Duration(milliseconds: 16));
      if (!mounted) return;
    }

    final sectionContext = _featuresKey.currentContext;
    if (sectionContext != null &&
        sectionContext.mounted &&
        _scrollController.hasClients) {
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

  Future<void> _onDashboardCardTap() async {
    if (_isSnappingHeroTransition) return;
    if (!_scrollController.hasClients) return;

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
    final height = MediaQuery.sizeOf(context).height;

    // Match desktop [LandingPage] rhythm; apparent size follows viewport.
    final horizontalPadding = (width * 0.055).clamp(40.0, 96.0);
    final layoutScale = math.min(width / 1440, height / 900).clamp(0.72, 1.0);

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
        child: Align(
          alignment: Alignment.topCenter,
          child: Transform.scale(
            scale: layoutScale,
            alignment: Alignment.topCenter,
            child: SizedBox(
              width: width / layoutScale,
              height: height / layoutScale,
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
                        onSteps: () =>
                            _onNavTap(_TopNavTab.howItWorks, _stepsKey),
                        onPricing: () =>
                            _onNavTap(_TopNavTab.pricing, _pricingKey),
                        onContact: () =>
                            _onNavTap(_TopNavTab.contact, _contactKey),
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
                                final currentOffset =
                                    _scrollController.hasClients
                                    ? _scrollController.offset
                                    : 0.0;
                                final fullUnlockProgress =
                                    (currentOffset / _fullScrollUnlockTarget)
                                        .clamp(0.0, 1.0);
                                final releaseProgress = Curves.easeInOutCubic
                                    .transform(
                                      ((fullUnlockProgress - 0.58) / 0.42)
                                          .clamp(0.0, 1.0),
                                    );
                                final heroCompensation =
                                    currentOffset * (1 - releaseProgress);
                                final featureRevealProgress = Curves
                                    .easeOutCubic
                                    .transform(
                                      ((fullUnlockProgress - 0.72) / 0.28)
                                          .clamp(0.0, 1.0),
                                    );
                                final heroCardShiftProgress =
                                    (currentOffset /
                                            _heroTransitionScrollExtent)
                                        .clamp(0.0, 1.0);

                                return Transform.translate(
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
                                          onPrimaryTap: () => appNav.changePage(
                                            AppRoutes.login,
                                          ),
                                          onSecondaryTap: () => _onNavTap(
                                            _TopNavTab.contact,
                                            _contactKey,
                                          ),
                                          onDashboardTap: _onDashboardCardTap,
                                          onArrowTap:
                                              _scrollToFeaturesFromArrow,
                                        ),
                                      ),
                                      if (_renderDeferredSections)
                                        SizedBox(
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
                              RepaintBoundary(
                                child: _ContactSection(
                                  key: _contactKey,
                                  padding: horizontalPadding,
                                ),
                              ),
                              RepaintBoundary(
                                child: _FaqSection(padding: horizontalPadding),
                              ),
                              RepaintBoundary(
                                child: _BottomCtaSection(
                                  padding: horizontalPadding,
                                ),
                              ),
                              RepaintBoundary(
                                child: _FooterSection(
                                  padding: horizontalPadding,
                                ),
                              ),
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
          ),
        ),
      ),
    );
  }
}
