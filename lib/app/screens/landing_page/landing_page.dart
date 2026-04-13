import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/login/views/login_controller.dart';
import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';
import 'package:saas/app/screens/landing_page/landing_hero_login_form.dart';
import 'package:saas/app/screens/landing_page/landing_page_mobile_view.dart';
import 'package:saas/app/screens/landing_page/landing_page_tablet_view.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/widgets/landing_section_skeleton.dart';
import 'package:saas/shared/widgets/hover_elevated_card.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  static const double tabletBreakpoint = 1100.0;
  static const double mobileBreakpoint = 760.0;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _featuresKey = GlobalKey();
  final _stepsKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();
  _TopNavTab _activeNavTab = _TopNavTab.features;
  bool _renderDeferredSections = false;

  @override
  void initState() {
    super.initState();
    LoginController.registerHeroIfNeeded();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _renderDeferredSections = true);
      for (final path in const [
        AppIcons.recripLogo,
        'assets/images/logo.webp',
      ]) {
        precacheImage(AssetImage(path), context);
      }
    });
  }

  @override
  void dispose() {
    LoginController.deleteHeroIfRegistered();
    super.dispose();
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0.08,
    );
  }

  Future<void> _onNavTap(_TopNavTab tab, GlobalKey key) async {
    setState(() => _activeNavTab = tab);
    await _scrollTo(key);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 760;

    if (width < LandingPage.mobileBreakpoint) {
      return const LandingPageMobileView();
    }

    if (width >= LandingPage.mobileBreakpoint &&
        width < LandingPage.tabletBreakpoint) {
      return const LandingPageTabletView();
    }

    final pad = width < 600
        ? 20.0
        : width < 1100
        ? 40.0
        : 72.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(pad, 18, pad, 14),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFE7EBF3))),
            ),
            child: _TopNav(
              compact: mobile,
              selectedTab: _activeNavTab,
              onFeatures: () => _onNavTap(_TopNavTab.features, _featuresKey),
              onSteps: () => _onNavTap(_TopNavTab.howItWorks, _stepsKey),
              onPricing: () => _onNavTap(_TopNavTab.pricing, _pricingKey),
              onContact: () => _onNavTap(_TopNavTab.contact, _contactKey),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _HeroSection(padding: pad),
                  if (_renderDeferredSections) ...[
                    _FeatureSection(
                      key: _featuresKey,
                      padding: pad,
                      mobile: mobile,
                    ),
                    _TeamSection(padding: pad, mobile: mobile),
                    _StepSection(key: _stepsKey, padding: pad, mobile: mobile),
                    _CtaSection(key: _pricingKey, padding: pad),
                    _FaqSection(
                      key: _contactKey,
                      padding: pad,
                      mobile: mobile,
                    ),
                    _FooterSection(padding: pad),
                  ] else ...[
                    LandingSectionSkeleton(
                      padding: pad,
                      blockCount: 4,
                      includeWideBlock: true,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    const line1Size = 50.0;
    const line2Size = 64.0;
    final descriptionStyle = Get.theme.textTheme.bodyLarge?.copyWith(
      fontWeight: FontWeight.w600,
      color: const Color(0xFF475569),
      height: 1.4,
    );

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Color(0xFFF6F7FF)],
        ),
      ),
      child: Stack(
        children: [
          Positioned(
            top: 40,
            right: 0,
            child: Container(
              width: 950,
              height: 290,
              decoration: const BoxDecoration(
                color: Color(0xFF111C3B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(160),
                  bottomLeft: Radius.circular(160),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, 26, padding, 54),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 5,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _HeroTextBlock(
                            line1Size: line1Size,
                            line2Size: line2Size,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Recrip helps businesses automate renewals, track customers, and recover missed payments — all from one powerful dashboard.',
                            textAlign: TextAlign.left,
                            style: descriptionStyle,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),
                    const Expanded(
                      flex: 7,
                      child: SizedBox(
                        height: 470,
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            Positioned(
                              top: 44,
                              right: 0,
                              child: _LandingHeroLoginCard(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroTextBlock extends StatelessWidget {
  const _HeroTextBlock({required this.line1Size, required this.line2Size});

  final double line1Size;
  final double line2Size;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Never Lose\nRevenue from',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 60,
            fontWeight: FontWeight.w900,
            color: AppConstants.textColor,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Expired\nSubscriptions',
          textAlign: TextAlign.left,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontSize: 60,
            fontWeight: FontWeight.w900,
            color: const Color(0xFF4F46E5),
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

enum _TopNavTab { features, howItWorks, pricing, contact }

class _TopNav extends StatefulWidget {
  const _TopNav({
    required this.compact,
    required this.selectedTab,
    required this.onFeatures,
    required this.onSteps,
    required this.onPricing,
    required this.onContact,
  });

  final bool compact;
  final _TopNavTab selectedTab;
  final VoidCallback onFeatures;
  final VoidCallback onSteps;
  final VoidCallback onPricing;
  final VoidCallback onContact;

  @override
  State<_TopNav> createState() => _TopNavState();
}

class _TopNavState extends State<_TopNav> {
  _TopNavTab? _hoveredTab;

  void _openMobileNav(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 0, 8, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: const Text('Features'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onFeatures();
                },
              ),
              ListTile(
                title: const Text('How it works'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onSteps();
                },
              ),
              ListTile(
                title: const Text('Pricing'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onPricing();
                },
              ),
              ListTile(
                title: const Text('Contact'),
                onTap: () {
                  Navigator.pop(ctx);
                  widget.onContact();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget link({
      required _TopNavTab tab,
      required String text,
      required VoidCallback onTap,
    }) {
      final isActive = widget.selectedTab == tab;
      final isHovered = _hoveredTab == tab;
      final color = (isActive || isHovered)
          ? const Color(0xFF4F46E5)
          : const Color(0xFF4B5563);

      return MouseRegion(
        onEnter: (_) => setState(() => _hoveredTab = tab),
        onExit: (_) => setState(() => _hoveredTab = null),
        child: TextButton(
          onPressed: onTap,
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 14,
            ),
          ),
        ),
      );
    }

    final cta = FilledButton(
      onPressed: () => appNav.changePage(AppRoutes.login),
      style: FilledButton.styleFrom(
        backgroundColor: const Color(0xFF5C5BFF),
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(132, 44),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      child: const Text(
        'Get Started',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );

    if (widget.compact) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(AppIcons.recripLogo, height: 32, fit: BoxFit.contain),
          const Spacer(),
          cta,
          const SizedBox(width: 4),
          IconButton(
            onPressed: () => _openMobileNav(context),
            icon: const Icon(Icons.menu_rounded),
            color: const Color(0xFF374151),
          ),
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AppIcons.recripLogo, height: 36, fit: BoxFit.contain),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              link(
                tab: _TopNavTab.features,
                text: 'Features',
                onTap: widget.onFeatures,
              ),
              const SizedBox(width: 36),
              link(
                tab: _TopNavTab.howItWorks,
                text: 'How it works',
                onTap: widget.onSteps,
              ),
              const SizedBox(width: 36),
              link(
                tab: _TopNavTab.pricing,
                text: 'Pricing',
                onTap: widget.onPricing,
              ),
              const SizedBox(width: 36),
              link(
                tab: _TopNavTab.contact,
                text: 'Contact',
                onTap: widget.onContact,
              ),
            ],
          ),
        ),
        cta,
      ],
    );
  }
}

/// Hero login panel: [LoginController] + same form UX as [Login] desktop.
class _LandingHeroLoginCard extends StatelessWidget {
  const _LandingHeroLoginCard();

  @override
  Widget build(BuildContext context) {
    return Align(
      child: ConstrainedBox(
        constraints: const BoxConstraints.tightFor(width: 379, height: 430),
        child: AuthFormCard(
          compact: true,
          showLogo: false,
          title: '',
          cornerRadius: 50,
          cardColor: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x40000000),
              offset: Offset(0, 20),
              blurRadius: 19.5,
              spreadRadius: 0,
            ),
          ],
          customHeader: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Already with Us?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Login',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF5C5BFF),
                  fontSize: 20,
                ),
              ),
            ],
          ),
          child: const LandingHeroLoginForm(),
        ),
      ),
    );
  }
}

class _MockField extends StatelessWidget {
  const _MockField({required this.hint});

  final String hint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      width: double.infinity,
      child: TextField(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFD6DAF4)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFF4F46E5)),
          ),
        ),
      ),
    );
  }
}

class _FeatureSection extends StatelessWidget {
  const _FeatureSection({
    super.key,
    required this.padding,
    required this.mobile,
  });

  final double padding;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F4FF),
      padding: EdgeInsets.fromLTRB(padding, 42, padding, 48),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Everything you need to\n',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppConstants.textColor,
                    height: 1.15,
                  ),
                ),
                TextSpan(
                  text: 'scale faster',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                    height: 1.15,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            'Stop manually tracking spreadsheets. Recrip automates the boring stuff so you\ncan focus on growth.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppConstants.supportTextColor,
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              final count = constraints.maxWidth > 980
                  ? 3
                  : constraints.maxWidth > 640
                  ? 2
                  : 1;
              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: features
                    .map(
                      (feature) => SizedBox(
                        width: 384,
                        height: 240,
                        child: _FeatureCard(feature),
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
  const _FeatureCard(this.feature);

  final _Feature feature;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 384,
      height: 240,
      child: HoverElevatedCard(
        accentColor: feature.color,
        borderRadius: 20,
        idleBorderColor: const Color(0xFFE6EAF6),
        idleBorderWidth: 1,
        useSolidAccentBorderOnHover: true,
        hoverBorderWidth: 1.2,
        child: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 66,
                  height: 66,
                  decoration: BoxDecoration(
                    color: feature.color,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x40383737),
                        offset: Offset(0, 13),
                        blurRadius: 11.1,
                        spreadRadius: 0,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: SvgPicture.asset(
                      feature.iconAsset,
                      colorFilter: const ColorFilter.mode(
                        Colors.white,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  feature.title,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: AppConstants.textColor),
                ),
                const SizedBox(height: 8),
                Text(
                  feature.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.supportTextColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TeamSection extends StatefulWidget {
  const _TeamSection({required this.padding, required this.mobile});

  final double padding;
  final bool mobile;

  @override
  State<_TeamSection> createState() => _TeamSectionState();
}

class _TeamSectionState extends State<_TeamSection> {
  _PreviewTab _selectedTab = _PreviewTab.dashboard;

  _PreviewTab _previewTabForStack(_PreviewTab tab) {
    if (tab == _PreviewTab.subscriptions) {
      return _PreviewTab.members;
    }
    return tab;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(widget.padding, 22, widget.padding, 46),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 980;
          Widget leftChild = Padding(
            padding: EdgeInsets.only(
              right: stacked ? 0 : 28,
              bottom: stacked ? 22 : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    style:
                        (Theme.of(context).textTheme.headlineMedium ??
                                const TextStyle())
                            .copyWith(
                              fontSize: widget.mobile ? 30 : 40,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                              height: 1.12,
                            ),
                    children: [
                      TextSpan(
                        text: 'Built for ',
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: AppConstants.textColor,
                        ),
                      ),
                      TextSpan(
                        text: 'Modern\nTeams',
                        style: Get.textTheme.bodyLarge?.copyWith(
                          fontSize: 40,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF4F46E5),
                          height: 0.95,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: stacked ? double.infinity : 260,
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _SideNavItem(
                        label: 'Dashboard',
                        iconAsset: AppIcons.dashboard,
                        selected: _selectedTab == _PreviewTab.dashboard,
                        onTap: () => setState(
                          () => _selectedTab = _PreviewTab.dashboard,
                        ),
                      ),
                      _SideNavItem(
                        label: 'Members',
                        iconAsset: AppIcons.usersRound,
                        selected: _selectedTab == _PreviewTab.members,
                        onTap: () =>
                            setState(() => _selectedTab = _PreviewTab.members),
                      ),
                      _SideNavItem(
                        label: 'Subscriptions',
                        iconAsset: AppIcons.calendarDays,
                        selected: _selectedTab == _PreviewTab.subscriptions,
                        onTap: () => setState(
                          () => _selectedTab = _PreviewTab.subscriptions,
                        ),
                      ),
                      _SideNavItem(
                        label: 'Renewals',
                        iconAsset: AppIcons.calendarSync,
                        selected: _selectedTab == _PreviewTab.renewals,
                        onTap: () =>
                            setState(() => _selectedTab = _PreviewTab.renewals),
                        isLast: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'One workspace for members, renewals, and revenue — with statuses and reminders that keep your team aligned.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF6B7280),
                    height: 1.55,
                  ),
                ),
              ],
            ),
          );
          final rightChild = _DashboardMock(
            selectedTab: _previewTabForStack(_selectedTab),
          );
          // Do not use CrossAxisAlignment.stretch here: this Row lives in a
          // scrollable Column with unbounded height; stretch + Expanded yields
          // infinite cross-axis constraints and breaks layout / hit testing.
          return Flex(
            direction: stacked ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: stacked
                ? CrossAxisAlignment.center
                : CrossAxisAlignment.start,
            children: [
              if (stacked) leftChild else Expanded(flex: 4, child: leftChild),
              if (stacked)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: rightChild,
                )
              else
                Expanded(flex: 7, child: rightChild),
            ],
          );
        },
      ),
    );
  }
}

class _SideNavItem extends StatelessWidget {
  const _SideNavItem({
    required this.label,
    required this.iconAsset,
    required this.selected,
    this.isLast = false,
    this.onTap,
  });

  final String label;
  final String iconAsset;
  final bool selected;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 14),
      child: Material(
        color: selected ? const Color(0xFFE9ECFA) : Colors.transparent,
        borderRadius: BorderRadius.circular(999),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(999),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            child: Row(
              children: [
                SvgPicture.asset(
                  iconAsset,
                  width: 24,
                  height: 24,
                  colorFilter: ColorFilter.mode(
                    selected
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF64748B),
                    BlendMode.srcIn,
                  ),
                ),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: selected
                        ? const Color(0xFF4F46E5)
                        : const Color(0xFF475569),
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

enum _PreviewTab { dashboard, members, subscriptions, renewals }

class _DashboardMock extends StatelessWidget {
  const _DashboardMock({required this.selectedTab});

  final _PreviewTab selectedTab;

  /// Fallback aspect when the row does not give a finite max height.
  static const double _aspect = 392 / 792;

  /// Inset between the navy frame and the stacked previews (all sides).
  static const double _innerPadding = 10;

  @override
  Widget build(BuildContext context) {
    final orderedCards = [
      for (final tab in _PreviewTab.values)
        if (tab != selectedTab) tab,
      selectedTab,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : 792.0;
        final aspectH = w * _aspect;
        final maxH = constraints.maxHeight;
        // With unbounded height (scroll), maxHeight is infinity — only aspect
        // height is valid. If a finite max is ever passed, stay within it.
        final h = maxH.isFinite && maxH > 0
            ? aspectH.clamp(0.0, maxH)
            : aspectH;

        return SizedBox(
          width: w,
          height: h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(26),
            child: ColoredBox(
              color: const Color(0xFF0F1835),
              child: Padding(
                padding: const EdgeInsets.all(_innerPadding),
                child: LayoutBuilder(
                  builder: (context, inner) {
                    final iw = inner.maxWidth;
                    final ih = inner.maxHeight;
                    return RepaintBoundary(
                      child: Stack(
                        clipBehavior: Clip.hardEdge,
                        fit: StackFit.expand,
                        children: [
                          for (
                            var index = 0;
                            index < orderedCards.length;
                            index++
                          )
                            _PreviewCard(
                              key: ValueKey<_PreviewTab>(orderedCards[index]),
                              tab: orderedCards[index],
                              layerIndex: index,
                              layerCount: orderedCards.length,
                              isFront: orderedCards[index] == selectedTab,
                              stackW: iw,
                              stackH: ih,
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PreviewCard extends StatelessWidget {
  const _PreviewCard({
    super.key,
    required this.tab,
    required this.layerIndex,
    required this.layerCount,
    required this.isFront,
    required this.stackW,
    required this.stackH,
  });

  final _PreviewTab tab;
  final int layerIndex;
  /// Total cards in the stack ([_PreviewTab] count — always > 0).
  final int layerCount;
  final bool isFront;
  final double stackW;
  final double stackH;

  @override
  Widget build(BuildContext context) {
    final w = stackW;
    final h = stackH;

    // Same-size cards, stacked like physical paper: front is leftmost & on top;
    // cards behind shift right so their right edges peek out (reference UI).
    final cardW = (w - (w * 0.012) - 8).clamp(0.0, 766.0);
    final cardH = h * 0.91;
    final top = (h - cardH) / 2;
    final baseLeft = w * 0.012;
    final staggerBack = w * 0.24;

    // Support any layer count (4 tabs → 4 cards). Previously only 0..2 were
    // handled, so layer 3 (the selected screen) vanished and a blurred card
    // was drawn on top instead.
    final double left;
    final double depthScale;
    if (layerCount <= 1) {
      left = baseLeft;
      depthScale = 1.0;
    } else {
      final t = layerIndex / (layerCount - 1); // 0 = farthest back, 1 = front
      left = baseLeft + staggerBack * (1 - t);
      depthScale = 0.87 + 0.13 * t;
    }

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOutCubic,
      left: left,
      top: top,
      width: cardW,
      height: cardH,
      child: AnimatedScale(
        duration: const Duration(milliseconds: 420),
        curve: Curves.easeInOutCubic,
        scale: depthScale,
        alignment: Alignment.center,
        child: AnimatedOpacity(
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOutCubic,
          opacity: isFront ? 1.0 : 0.92,
          child: _previewCardBody(context),
        ),
      ),
    );
  }

  Widget _previewCardBody(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isFront ? const Color(0x150F172A) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: isFront ? const Color(0x300F172A) : const Color(0x1A0F172A),
            blurRadius: isFront ? 28 : 18,
            offset: Offset(0, isFront ? 12 : 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: _stackPreviewImage(tab: tab, isFront: isFront),
    );
  }
}

/// Foreground card stays sharp; cards behind use a light blur (depth is from [Transform.scale] on the card).
Widget _stackPreviewImage({required _PreviewTab tab, required bool isFront}) {
  final path = _previewImageFor(tab);
  Widget img = Image.asset(
    path,
    fit: BoxFit.cover,
    alignment: Alignment.topLeft,
    cacheWidth: isFront ? 1500 : 1100,
    filterQuality: isFront ? FilterQuality.high : FilterQuality.medium,
    isAntiAlias: true,
  );
  if (!isFront) {
    img = ImageFiltered(
      imageFilter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
      child: img,
    );
  }
  return img;
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

class _StatChip extends StatelessWidget {
  const _StatChip(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
            ),
          ),
        ],
      ),
    );
  }
}

class _StepSection extends StatelessWidget {
  const _StepSection({super.key, required this.padding, required this.mobile});

  final double padding;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F4FF),
      padding: EdgeInsets.fromLTRB(padding, 30, padding, 58),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Get started in ',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: AppConstants.textColor,
                  ),
                ),
                TextSpan(
                  text: '3 simple steps',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 60),
          if (mobile)
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: steps
                  .map((step) => SizedBox(width: 280, child: _StepCard(step)))
                  .toList(),
            )
          else
            SizedBox(
              width: 1060,
              child: Stack(
                children: [
                  Positioned(
                    left: 120,
                    right: 120,
                    top: 25,
                    child: Container(height: 1, color: const Color(0xFFE1E5EE)),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _StepCard(steps[0])),
                      const SizedBox(width: 40),
                      Expanded(child: _StepCard(steps[1])),
                      const SizedBox(width: 40),
                      Expanded(child: _StepCard(steps[2])),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  const _StepCard(this.step);

  final _Step step;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: Color(0xFF5C5BFF),
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Color(0x40383737),
                offset: Offset(0, 13),
                blurRadius: 11.1,
                spreadRadius: 0,
              ),
            ],
          ),
          child: Center(
            child: SvgPicture.asset(
              step.iconAsset,
              width: 22,
              height: 22,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
        ),
        const SizedBox(height: 22),
        Text(
          step.title,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppConstants.textColor),
        ),
        const SizedBox(height: 8),
        Text(
          step.description,
          textAlign: TextAlign.center,
          maxLines: 3,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w500,
            color: AppConstants.supportTextColor,
          ),
        ),
      ],
    );
  }
}

class _CtaSection extends StatelessWidget {
  const _CtaSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF101934),
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 1440,
            minHeight: MediaQuery.sizeOf(context).width < 600 ? 420 : 560,
          ),
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, 54, padding, 54),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final stacked = constraints.maxWidth < 900;
                Widget leftChild = Padding(
                  padding: EdgeInsets.only(
                    right: stacked ? 0 : 36,
                    bottom: stacked ? 28 : 0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: 'Start Automating\n',
                              style: Get.textTheme.bodyLarge?.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                height: 0.95,
                              ),
                            ),
                            TextSpan(
                              text: 'Your Renewals Today',
                              style: Get.textTheme.bodyLarge?.copyWith(
                                fontSize: 40,
                                fontWeight: FontWeight.w900,
                                color: const Color(0xFF4F46E5),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Join hundreds of businesses that are recovering lost revenue every single day. No credit card required to start.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppConstants.supportTextColor,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 26),
                      for (final item in const [
                        'Free 14-day trial',
                        'No Setup Fee',
                        'Cancel Anytime',
                        '24/7 Priority Support',
                      ])
                        Padding(
                          padding: const EdgeInsets.only(bottom: 12),
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
                                  AppIcons.circleCheck,
                                  width: 18,
                                  height: 18,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                item,
                                style: Get.textTheme.bodyLarge?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppConstants.supportTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
                const rightChild = _LeadCard();
                return Flex(
                  direction: stacked ? Axis.vertical : Axis.horizontal,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (stacked)
                      leftChild
                    else
                      Expanded(flex: 5, child: leftChild),
                    if (stacked)
                      const Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: rightChild,
                      )
                    else
                      const Expanded(flex: 6, child: rightChild),
                  ],
                );
              },
            ),
          ),
        ),
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
              Expanded(child: _DarkField('Full Name')),
              SizedBox(width: 14),
              Expanded(child: _DarkField('Business Name')),
            ],
          ),
          const SizedBox(height: 32),
          const Row(
            children: [
              Expanded(child: _DarkField('Email Address')),
              SizedBox(width: 14),
              Expanded(child: _DarkField('Phone Number')),
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
              style: Get.textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Request a demo and we will get back to you. Thank you!',
            textAlign: TextAlign.center,
            style: Get.textTheme.bodyLarge?.copyWith(
              color: AppConstants.supportTextColor,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _DarkField extends StatelessWidget {
  const _DarkField(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFFC6D1F7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFF31457D)),
          ),
        ),
      ],
    );
  }
}

class _FaqSection extends StatelessWidget {
  const _FaqSection({super.key, required this.padding, required this.mobile});

  final double padding;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(padding, 46, padding, 32),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 900;
          Widget leftChild = Column(
            children: faqs.map((faq) => _ExpandableFaqCard(faq)).toList(),
          );
          const rightChild = _QuestionCard();
          return Column(
            children: [
              Text(
                'Frequently Asked Questions',
                style: Get.textTheme.bodyLarge?.copyWith(
                  fontSize: 40,
                  fontWeight: FontWeight.w900,
                  color: AppConstants.textColor,
                ),
              ),
              const SizedBox(height: 28),
              Flex(
                direction: stacked ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (stacked)
                    leftChild
                  else
                    Expanded(flex: 5, child: leftChild),
                  SizedBox(width: stacked ? 0 : 18, height: stacked ? 18 : 0),
                  if (stacked)
                    rightChild
                  else
                    const Expanded(flex: 6, child: rightChild),
                ],
              ),
              const SizedBox(height: 38),
            ],
          );
        },
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
      color: const Color(0xFFF5F4FF),
      padding: EdgeInsets.fromLTRB(padding, 24, padding, 32),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AppIcons.recripLogo, height: 36, fit: BoxFit.contain),
            const SizedBox(height: 8),
            Text(
              'Most powerful subscription renewal management platform. Built for business that want to scale without losing revenue.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppConstants.supportTextColor,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 48),
            const Divider(thickness: 1, color: Color(0xFFCBD5E1)),
            const SizedBox(height: 24),
            Text(
              '\u00A9 2026 Recrip. All rights reserved.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpandableFaqCard extends StatefulWidget {
  const _ExpandableFaqCard(this.faq);

  final _Faq faq;

  @override
  State<_ExpandableFaqCard> createState() => _ExpandableFaqCardState();
}

class _ExpandableFaqCardState extends State<_ExpandableFaqCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A),
            blurRadius: 16,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                      style: Get.textTheme.bodyMedium?.copyWith(
                        fontSize: 20,
                        color: AppConstants.textColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Icon(
                    _open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: const Color(0xFF6B7280),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 16),
              child: Text(
                widget.faq.answer,
                style: Get.textTheme.bodySmall?.copyWith(
                  color: AppConstants.supportTextColor,
                  height: 1.55,
                ),
              ),
            ),
            crossFadeState: _open
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
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
        color: Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Got anything to ask us?',
            style: Get.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF4F46E5),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 32),
          const _MockField(hint: 'Email Address'),
          const SizedBox(height: 24),
          SizedBox(
            width: Get.width,
            height: 155,
            child: TextField(
              expands: true,
              maxLines: null,
              minLines: null,
              textAlignVertical: TextAlignVertical.top,
              decoration: InputDecoration(
                hintText: 'Type your message here....',
                hintStyle: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF)),
                filled: true,
                fillColor: Colors.white,
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
          FilledButton(
            onPressed: () {},
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF5C5BFF),
              foregroundColor: Colors.white,
              elevation: 0,
              minimumSize: const Size(double.infinity, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Send',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

const features = [
  _Feature(
    'Smart Renewal Alerts',
    'Automatically remind customers via WhatsApp, SMS, and email before they expire.',
    AppIcons.bell,
    Color(0xFF2B7FFF),
  ),
  _Feature(
    'Payment Recovery',
    'Recover missed payments and reduce churn effortlessly with automated retries.',
    AppIcons.creditCard,
    Color(0xFF5FC7FF),
  ),
  _Feature(
    'Analytics Dashboard',
    'Track revenue, renewals, and customer behavior with deep visual insights.',
    AppIcons.chartPie,
    Color(0xFF8E51FF),
  ),
  _Feature(
    'Customer Management',
    'All your subscription data in one place. Search, filter, and manage with ease.',
    AppIcons.usersRound,
    Color(0xFFE12AFB),
  ),
  _Feature(
    'Auto Renewals',
    'Set it once and let Recrip handle the rest. Seamless recurring billing.',
    AppIcons.renew,
    Color(0xFF00BC7D),
  ),
  _Feature(
    'Business Insights',
    'Track revenue, renewals, and customer behavior with deep visual insights.',
    AppIcons.globe,
    Color(0xFFFE9A00),
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

const faqs = [
  _Faq(
    'Can I customize the notification messages?',
    'Absolutely! You can fully customize the content, timing, and channel (WhatsApp, Email) for every notification sent.',
  ),
  _Faq(
    'Is my customer data secure?',
    'Yes, we use bank-grade encryption and are fully GDPR/SOC2 compliant. Your data is isolated and protected at all times.',
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

class _Faq {
  const _Faq(this.question, this.answer);

  final String question;
  final String answer;
}
