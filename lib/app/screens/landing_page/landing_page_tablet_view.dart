part of 'landing_page.dart';

class LandingPageTabletView extends StatefulWidget {
  const LandingPageTabletView({super.key});

  @override
  State<LandingPageTabletView> createState() => _LandingPageTabletViewState();
}

class _LandingPageTabletViewState extends State<LandingPageTabletView> {
  final _featuresKey = GlobalKey();
  final _stepsKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();
  final _scrollController = ScrollController();

  final ValueNotifier<_TopNavTab?> _navTabHighlight = ValueNotifier(null);
  final ValueNotifier<_PreviewTab> _previewTabHighlight = ValueNotifier(
    _PreviewTab.dashboard,
  );

  bool _renderDeferredSections = false;
  bool _suppressScrollSpy = false;

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
        'assets/images/brand-logo.png',
        'assets/images/recrip.png',
        'assets/images/Dashboard.webp',
        'assets/images/Members.webp',
        'assets/images/Renewals.webp',
        'assets/images/subscriptions.webp',
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
    _suppressScrollSpy = true;
    _navTabHighlight.value = tab;
    await _scrollTo(key, alignment: 0.04);
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 460));
    if (!mounted) return;
    _suppressScrollSpy = false;
    _syncNavHighlightFromScroll();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = width < 900 ? 24.0 : 36.0;

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
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  16,
                  horizontalPadding,
                  8,
                ),
                child: ValueListenableBuilder<_TopNavTab?>(
                  valueListenable: _navTabHighlight,
                  builder: (context, activeNavTab, _) {
                    return _TabletTopNav(
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
              Expanded(
                child: ScrollConfiguration(
                  behavior: const _LandingScrollBehavior(),
                  child: CustomScrollView(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: ClampingScrollPhysics(),
                    ),
                    cacheExtent: 1000,
                    slivers: [
                      SliverToBoxAdapter(
                        child: ValueListenableBuilder<_PreviewTab>(
                          valueListenable: _previewTabHighlight,
                          builder: (context, selectedPreviewTab, _) {
                            return _TabletHeroSection(
                              padding: horizontalPadding,
                              selectedTab: selectedPreviewTab,
                              onTabSelected: (tab) =>
                                  _previewTabHighlight.value = tab,
                            );
                          },
                        ),
                      ),
                      if (_renderDeferredSections) ...[
                        SliverToBoxAdapter(
                          child: _TabletFeatureSection(
                            key: _featuresKey,
                            padding: horizontalPadding,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _TabletStepSection(
                            key: _stepsKey,
                            padding: horizontalPadding,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _TabletPricingSection(
                            key: _pricingKey,
                            padding: horizontalPadding,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _TabletContactSection(
                            key: _contactKey,
                            padding: horizontalPadding,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _TabletFaqSection(padding: horizontalPadding),
                        ),
                        SliverToBoxAdapter(
                          child: _TabletBottomCtaSection(
                            padding: horizontalPadding,
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: _TabletFooterSection(
                            padding: horizontalPadding,
                          ),
                        ),
                      ] else
                        SliverToBoxAdapter(
                          child: LandingSectionSkeleton(
                            padding: horizontalPadding,
                            blockCount: 4,
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
      ),
    );
  }
}

class _TabletTopNav extends StatelessWidget {
  const _TabletTopNav({
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
    final isCompact = MediaQuery.sizeOf(context).width < 920;
    final chips = <({String label, _TopNavTab tab, VoidCallback onTap})>[
      (label: 'Features', tab: _TopNavTab.features, onTap: onFeatures),
      (label: 'How it works', tab: _TopNavTab.howItWorks, onTap: onSteps),
      (label: 'Pricing', tab: _TopNavTab.pricing, onTap: onPricing),
      (label: 'Contact', tab: _TopNavTab.contact, onTap: onContact),
    ];

    return Column(
      children: [
        Row(
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/brand-logo.png',
                  width: 30,
                  height: 30,
                  fit: BoxFit.contain,
                ),
                const SizedBox(width: 10),
                Image.asset(
                  'assets/images/recrip.png',
                  height: 34,
                  fit: BoxFit.contain,
                ),
              ],
            ),
            const Spacer(),
            TextButton(
              onPressed: () => appNav.changePage(AppRoutes.login),
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(
                  horizontal: isCompact ? 10 : 14,
                  vertical: 12,
                ),
              ),
              child: Text(
                'Log in',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              height: 44,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(999),
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
                    padding: EdgeInsets.symmetric(
                      horizontal: isCompact ? 16 : 20,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            children: [
              for (var i = 0; i < chips.length; i++) ...[
                if (i > 0) const SizedBox(width: 10),
                _TabletNavPill(
                  label: chips[i].label,
                  selected: selectedTab == chips[i].tab,
                  onTap: chips[i].onTap,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _TabletNavPill extends StatelessWidget {
  const _TabletNavPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0x14000000),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFF4F46E5)),
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: selected ? const Color(0xFF3F37D8) : Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _TabletHeroSection extends StatelessWidget {
  const _TabletHeroSection({
    required this.padding,
    required this.selectedTab,
    required this.onTabSelected,
  });

  final double padding;
  final _PreviewTab selectedTab;
  final ValueChanged<_PreviewTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 900;
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 28, padding, 88),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 820),
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      height: 1.12,
                      fontSize: compact ? 44 : 52,
                    ),
                    children: const [
                      TextSpan(text: 'Never Lose Revenue\nfrom '),
                      TextSpan(
                        text: 'Expired Subscriptions',
                        style: TextStyle(
                          color: Color(0xFF5F57F8),
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  'Recrip helps businesses automate renewals, track customers, and recover missed payments from one clean, powerful dashboard.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFFE2DDF7),
                    height: 1.6,
                    fontSize: compact ? 18 : 20,
                  ),
                ),
                const SizedBox(height: 28),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 14,
                  runSpacing: 14,
                  children: [
                    _HeroButton(
                      label: 'Book a Free Trial',
                      filled: true,
                      onTap: () => appNav.changePage(AppRoutes.login),
                    ),
                    _HeroButton(
                      label: 'Schedule a Demo',
                      filled: false,
                      onTap: () => appNav.changePage(AppRoutes.login),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Text(
                  'No credit card required • 14-day free trial • Cancel anytime',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 44),
          _TabletPreviewShowcase(
            selectedTab: selectedTab,
            onTabSelected: onTabSelected,
          ),
        ],
      ),
    );
  }
}

class _TabletPreviewShowcase extends StatelessWidget {
  const _TabletPreviewShowcase({
    required this.selectedTab,
    required this.onTabSelected,
  });

  final _PreviewTab selectedTab;
  final ValueChanged<_PreviewTab> onTabSelected;

  @override
  Widget build(BuildContext context) {
    final isCompact = MediaQuery.sizeOf(context).width < 900;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isCompact ? 18 : 24),
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
        children: [
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
                sizeScale: 1,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Built for modern teams',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Switch between core product views to see how Recrip keeps your revenue operations organized.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFE2DDF7),
              height: 1.55,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 12,
            runSpacing: 12,
            children: _PreviewTab.values
                .map(
                  (tab) => _TabletPreviewTabChip(
                    label: _previewLabel(tab),
                    iconAsset: _previewIcon(tab),
                    selected: tab == selectedTab,
                    onTap: () => onTabSelected(tab),
                  ),
                )
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _TabletPreviewTabChip extends StatelessWidget {
  const _TabletPreviewTabChip({
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFEAEFFC) : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              iconAsset,
              width: 18,
              height: 18,
              colorFilter: ColorFilter.mode(
                selected ? const Color(0xFF5C57F4) : const Color(0xFF66739B),
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: selected
                    ? const Color(0xFF5C57F4)
                    : const Color(0xFF66739B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabletFeatureSection extends StatelessWidget {
  const _TabletFeatureSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 96),
      child: Column(
        children: [
          const _SectionTitle(
            title: 'Everything you need to',
            accent: 'scale faster',
            description:
                'Stop manually tracking spreadsheets. Recrip automates the boring stuff so you can focus on growth.',
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth < 860 ? 2 : 3;
              final gap = 18.0;
              final itemWidth =
                  (constraints.maxWidth - ((columns - 1) * gap)) / columns;
              return Wrap(
                spacing: gap,
                runSpacing: gap,
                children: features
                    .map(
                      (feature) => SizedBox(
                        width: itemWidth,
                        child: _TabletFeatureCard(feature: feature),
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

class _TabletFeatureCard extends StatelessWidget {
  const _TabletFeatureCard({required this.feature});

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 240,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF3B2F84)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: feature.color,
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              feature.iconAsset,
              width: 28,
              height: 28,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            feature.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: feature.color,
              fontWeight: FontWeight.w800,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFFD7D7D7),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletStepSection extends StatelessWidget {
  const _TabletStepSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 96),
      child: Column(
        children: [
          const _SectionTitle(
            title: 'Get started in',
            accent: '3 simple steps',
            description: 'Identify, support, and retain subscribers faster.',
            accentOnNewLine: false,
          ),
          const SizedBox(height: 34),
          LayoutBuilder(
            builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 900;
              if (isCompact) {
                return Column(
                  children: steps.asMap().entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key == steps.length - 1 ? 0 : 16,
                      ),
                      child: _TabletStepCard(
                        step: entry.value,
                        index: entry.key + 1,
                      ),
                    );
                  }).toList(),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: steps.asMap().entries.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: entry.key == steps.length - 1 ? 0 : 16,
                      ),
                      child: _TabletStepCard(
                        step: entry.value,
                        index: entry.key + 1,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TabletStepCard extends StatelessWidget {
  const _TabletStepCard({required this.step, required this.index});

  final _Step step;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF4F46E5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: const Color(0xFF4F46E5),
                  borderRadius: BorderRadius.circular(16),
                ),
                alignment: Alignment.center,
                child: SvgPicture.asset(
                  step.iconAsset,
                  width: 26,
                  height: 26,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '0$index',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: const Color(0x33FFFFFF),
                  fontWeight: FontWeight.w900,
                  fontSize: 44,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            step.title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            step.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF475569),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletPricingSection extends StatelessWidget {
  const _TabletPricingSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 96),
      child: Column(
        children: [
          const _SectionTitle(
            title: 'Simple plans for',
            accent: 'growing teams',
            description:
                'Choose a plan that fits your current member volume and upgrade when your renewal engine scales.',
            accentOnNewLine: false,
          ),
          const SizedBox(height: 40),
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth < 940) {
                return Column(
                  children: pricingPlans.asMap().entries.map((entry) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: entry.key == pricingPlans.length - 1 ? 0 : 18,
                      ),
                      child: _TabletPricingCard(
                        plan: entry.value,
                        highlighted: entry.value.name == 'Growth',
                      ),
                    );
                  }).toList(),
                );
              }

              return Row(
                children: pricingPlans.asMap().entries.map((entry) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: entry.key == pricingPlans.length - 1 ? 0 : 18,
                      ),
                      child: _TabletPricingCard(
                        plan: entry.value,
                        highlighted: entry.value.name == 'Growth',
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TabletPricingCard extends StatelessWidget {
  const _TabletPricingCard({required this.plan, required this.highlighted});

  final _PricingPlan plan;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(28, 26, 28, 28),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFF0D0830) : const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFF4F46E5)),
        boxShadow: highlighted
            ? const [
                BoxShadow(
                  color: Color(0x333C2DD8),
                  blurRadius: 28,
                  offset: Offset(0, 14),
                ),
              ]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
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
                  plan.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              if (highlighted)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF08042A),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFF4F46E5)),
                  ),
                  child: Text(
                    'Most Popular',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: plan.price,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 36,
                  ),
                ),
                TextSpan(
                  text: ' /month',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: const Color(0xFF5F688E),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ...plan.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 2),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 18,
                      color: Color(0xFF5F57F8),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      item,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFFD7D7D7),
                        fontWeight: FontWeight.w600,
                        height: 1.45,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: FilledButton(
              onPressed: () => appNav.changePage(AppRoutes.login),
              style: FilledButton.styleFrom(
                backgroundColor: highlighted
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFF08042A),
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF4F46E5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                highlighted ? 'Start Growth Plan' : 'Start ${plan.name}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletContactSection extends StatelessWidget {
  const _TabletContactSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 920;
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 96),
      child: Column(
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 780),
            child: Column(
              children: [
                Text.rich(
                  TextSpan(
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: compact ? 36 : 40,
                      height: 1.15,
                    ),
                    children: const [
                      TextSpan(text: 'Start Automating Your\n'),
                      TextSpan(
                        text: 'Renewals Today',
                        style: TextStyle(color: Color(0xFF4F46E5)),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Join hundreds of businesses recovering lost revenue every day. Set up your trial, book a demo, or ask for a walkthrough.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF475569),
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 14,
                  runSpacing: 14,
                  children: contactHighlights
                      .map((item) => _TabletHighlightPill(label: item))
                      .toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 820),
            child: _LeadCard(),
          ),
        ],
      ),
    );
  }
}

class _TabletHighlightPill extends StatelessWidget {
  const _TabletHighlightPill({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.check_circle_rounded,
            size: 16,
            color: Color(0xFF5F57F8),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF475569),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletFaqSection extends StatelessWidget {
  const _TabletFaqSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 96),
      child: Column(
        children: [
          const FaqSectionHeading(
            leadColor: Color(0xFF4F46E5),
            restColor: Colors.white,
            fontSize: 36,
          ),
          const SizedBox(height: 34),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 860),
            child: Column(
              children: [
                ...faqs.asMap().entries.map(
                  (entry) => Padding(
                    padding: EdgeInsets.only(
                      bottom: entry.key == faqs.length - 1 ? 0 : 18,
                    ),
                    child: _FaqCard(faq: entry.value),
                  ),
                ),
                const SizedBox(height: 22),
                const _QuestionCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletBottomCtaSection extends StatelessWidget {
  const _TabletBottomCtaSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(padding, 0, padding, 96),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 36),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFF4F46E5)),
        ),
        child: Column(
          children: [
            Text.rich(
              TextSpan(
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 36,
                ),
                children: const [
                  TextSpan(text: 'Ready to transform your\n'),
                  TextSpan(
                    text: 'Renewal Process?',
                    style: TextStyle(color: Color(0xFF4F46E5)),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            Text(
              'Join teams reducing churn and increasing retention with automated follow-ups and cleaner visibility.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: const Color(0xFFE2DDF7),
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 14,
              runSpacing: 14,
              children: [
                _HeroButton(
                  label: 'Book a Free Trial',
                  filled: true,
                  onTap: () => appNav.changePage(AppRoutes.login),
                ),
                _HeroButton(
                  label: 'Schedule a Demo',
                  filled: false,
                  onTap: () => appNav.changePage(AppRoutes.login),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Text(
              'No credit card required • 14-day free trial • Cancel anytime',
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: const Color(0xFF64748B)),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabletFooterSection extends StatelessWidget {
  const _TabletFooterSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 48, padding, 40),
      decoration: const BoxDecoration(color: Color(0xFF0D0820)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final stack = constraints.maxWidth < 920;
              if (stack) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _TabletFooterBrandBlock(maxWidth: constraints.maxWidth),
                    const SizedBox(height: 28),
                    const _TabletFooterLinks(),
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: _TabletFooterBrandBlock(
                      maxWidth: constraints.maxWidth * 0.42,
                    ),
                  ),
                  const SizedBox(width: 48),
                  const Expanded(flex: 6, child: _TabletFooterLinks()),
                ],
              );
            },
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFB4BDD4), thickness: 0.8),
          const SizedBox(height: 22),
          Text(
            '© 2026 Recrip. All rights reserved.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletFooterBrandBlock extends StatelessWidget {
  const _TabletFooterBrandBlock({required this.maxWidth});

  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(AppIcons.recripLogo, height: 44),
        const SizedBox(height: 18),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: maxWidth),
          child: Text(
            'Most powerful subscription renewal management platform. Built for businesses that want to scale without losing revenue.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF475569),
              height: 1.6,
            ),
          ),
        ),
      ],
    );
  }
}

class _TabletFooterLinks extends StatelessWidget {
  const _TabletFooterLinks();

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 36,
      runSpacing: 24,
      alignment: WrapAlignment.spaceBetween,
      children: [
        _FooterColumn(
          title: 'Product',
          items: const ['Features', 'Pricing'],
          linkColor: const Color(0xFF94A3B8),
        ),
        _FooterColumn(
          title: 'Company',
          items: const ['About', 'Contact'],
          linkColor: const Color(0xFF94A3B8),
        ),
        _FooterColumn(
          title: 'Legal',
          items: const ['Privacy Policy', 'Terms of Service'],
          linkColor: const Color(0xFF94A3B8),
        ),
        const _FooterSocialColumn(),
      ],
    );
  }
}
