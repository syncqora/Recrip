import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';
// import 'package:saas/app/screens/landing_page/landing_hero_login_form.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/widgets/faq_section_heading.dart';
import 'package:saas/shared/widgets/landing_section_skeleton.dart';

class LandingPageMobileView extends StatefulWidget {
  const LandingPageMobileView({super.key});

  @override
  State<LandingPageMobileView> createState() => _LandingPageMobileViewState();
}

class _LandingPageMobileViewState extends State<LandingPageMobileView> {
  final _featuresKey = GlobalKey();
  final _previewKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();
  _MobileNavTab _activeNavTab = _MobileNavTab.features;
  bool _renderDeferredSections = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() => _renderDeferredSections = true);
    });
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final targetContext = key.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
      alignment: 0.04,
    );
  }

  Future<void> _onNavTap(_MobileNavTab tab, GlobalKey key) async {
    setState(() => _activeNavTab = tab);
    await _scrollTo(key);
  }

  void _openNavSheet() {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: Colors.white,
      builder: (sheetContext) {
        Widget navTile({
          required String label,
          required _MobileNavTab tab,
          required GlobalKey key,
        }) {
          final selected = _activeNavTab == tab;
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            title: Text(
              label,
              style: Theme.of(sheetContext).textTheme.titleMedium?.copyWith(
                color: selected
                    ? const Color(0xFF4F46E5)
                    : const Color(0xFF334155),
                fontWeight: FontWeight.w700,
              ),
            ),
            trailing: selected
                ? const Icon(Icons.check_rounded, color: Color(0xFF4F46E5))
                : null,
            onTap: () {
              Navigator.pop(sheetContext);
              _onNavTap(tab, key);
            },
          );
        }

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                navTile(
                  label: 'Features',
                  tab: _MobileNavTab.features,
                  key: _featuresKey,
                ),
                navTile(
                  label: 'How it works',
                  tab: _MobileNavTab.preview,
                  key: _previewKey,
                ),
                navTile(
                  label: 'Pricing',
                  tab: _MobileNavTab.pricing,
                  key: _pricingKey,
                ),
                navTile(
                  label: 'Contact',
                  tab: _MobileNavTab.contact,
                  key: _contactKey,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    const padding = 20.0;

    return Scaffold(
      backgroundColor: const Color(0xFF090611),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerRight,
            end: Alignment.centerLeft,
            stops: [0.0, 0.3413, 0.6202, 1.0],
            colors: [
              Color(0xFF120E3D),
              Color(0xFF210F5C),
              Color(0xFF1F0D41),
              Color(0xFF000000),
            ],
          ),
        ),
        child: Column(
          children: [
            _MobileTopBar(onMenuTap: _openNavSheet),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: 32),
                    _MobileHeroSection(padding: padding),
                    Padding(
                      padding: EdgeInsets.fromLTRB(padding, 28, padding, 8),
                      child: _MobileHeroDashboardCarousel(),
                    ),
                    if (_renderDeferredSections) ...[
                      _MobileFeatureSection(
                        key: _featuresKey,
                        padding: padding,
                      ),
                      _MobileStepSection(padding: padding),
                      _MobileCtaSection(key: _pricingKey, padding: padding),
                      _MobileContactSection(key: _contactKey, padding: padding),
                      _MobileFaqSection(padding: padding),
                      _MobileBottomCtaSection(padding: padding),
                      _MobileFooterSection(padding: padding),
                    ] else ...[
                      const LandingSectionSkeleton(
                        padding: padding,
                        blockCount: 3,
                        includeWideBlock: true,
                      ),
                    ],
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

enum _MobileNavTab { features, preview, pricing, contact }

enum _MobilePreviewTab { dashboard, members, subscriptions, renewals }

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar({required this.onMenuTap});

  final VoidCallback onMenuTap;

  static const Color _barBg = Colors.transparent;
  static const Color _menuIcon = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _barBg,
      elevation: 0,
      shadowColor: Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Container(
          width: double.infinity,
          child: SizedBox(
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    onPressed: onMenuTap,
                    padding: const EdgeInsets.only(left: 8, right: 16),
                    constraints: const BoxConstraints(
                      minWidth: 48,
                      minHeight: 48,
                    ),
                    icon: SvgPicture.asset(
                      AppIcons.menu,
                      width: 26,
                      height: 26,
                      colorFilter: const ColorFilter.mode(
                        _menuIcon,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => appNav.changePage(AppRoutes.login),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.only(right: 12, left: 16),
                    ),
                    child: Text(
                      'Log in',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/images/brand-logo.png',
                        width: 32,
                        height: 32,

                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 10),
                      Image.asset(
                        'assets/images/recrip.png',
                        height: 32,
                        fit: BoxFit.contain,
                      ),
                    ],
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

class _MobileHeroSection extends StatelessWidget {
  const _MobileHeroSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    final headingStyle = Theme.of(context).textTheme.bodyLarge?.copyWith(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Colors.white,
      height: 1.5,
    );

    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Never Lose Revenue\nfrom ',
                    style: headingStyle,
                  ),
                  TextSpan(
                    text: 'Expired Subscriptions',
                    style: headingStyle?.copyWith(
                      color: const Color(0xFF4F46E5),
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Recrip helps businesses automate renewals, track customers, and recover missed payments — all from one powerful dashboard.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFFCBD5E1),
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: 168,
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
                    'Book a Free Trial',
                    style: Get.theme.textTheme.bodySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'No credit card required • 14-day free trial • Cancel anytime',
              style: Get.theme.textTheme.labelMedium?.copyWith(
                color: const Color(0xFF475569),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileHeroDashboardCarousel extends StatefulWidget {
  const _MobileHeroDashboardCarousel();

  @override
  State<_MobileHeroDashboardCarousel> createState() =>
      _MobileHeroDashboardCarouselState();
}

class _MobileHeroDashboardCarouselState
    extends State<_MobileHeroDashboardCarousel> {
  /// Design: front card 370 × 232, radius 10; three deck “spines” below (mock).
  static const double _designCardW = 370;
  static const double _designCardH = 232;
  static const double _cardRadius = 10;

  /// Vertical offset per deck layer (~8–12px in mock).
  static const double _deckStepY = 10;

  /// Each deeper layer narrows by this amount on each side (~5px per step).
  static const double _deckSideInsetStep = 5.5;
  static const int _deckLayerCount = 3;

  static const Duration _imageSwitch = Duration(milliseconds: 380);
  static const Curve _imageSwitchIn = Curves.easeOutCubic;
  static const Curve _imageSwitchOut = Curves.easeInCubic;

  int _frontIndex = 0;
  int _slideSign = 1;

  void _go(int delta) {
    final len = _MobilePreviewTab.values.length;
    if (delta == 0) return;
    _slideSign = delta.sign;
    setState(() => _frontIndex = (_frontIndex + delta + len) % len);
  }

  @override
  Widget build(BuildContext context) {
    final tab = _MobilePreviewTab.values[_frontIndex];

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final cardW = maxW <= _designCardW ? maxW : _designCardW;
        final cardH = cardW * (_designCardH / _designCardW);
        final leftInset = (maxW - cardW) / 2;
        final stackFootprintH = cardH + _deckLayerCount * _deckStepY + 10;

        return Column(
          children: [
            SizedBox(
              width: maxW,
              height: stackFootprintH,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.topCenter,
                children: [
                  for (var d = _deckLayerCount; d >= 1; d--)
                    Positioned(
                      top: d * _deckStepY,
                      left: leftInset + d * _deckSideInsetStep,
                      width: cardW - 2 * d * _deckSideInsetStep,
                      height: cardH,
                      child: _MobileDeckSpineLayer(radius: _cardRadius),
                    ),
                  Positioned(
                    top: 0,
                    left: leftInset,
                    width: cardW,
                    height: cardH,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(_cardRadius),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x480F172A),
                            blurRadius: 26,
                            offset: Offset(0, 14),
                            spreadRadius: -3,
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(_cardRadius),
                        child: ColoredBox(
                          color: Colors.white,
                          child: AnimatedSwitcher(
                            duration: _imageSwitch,
                            switchInCurve: _imageSwitchIn,
                            switchOutCurve: _imageSwitchOut,
                            layoutBuilder: (currentChild, previousChildren) {
                              return Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  ...previousChildren,
                                  if (currentChild != null) currentChild,
                                ],
                              );
                            },
                            transitionBuilder: (child, animation) {
                              final curved = CurvedAnimation(
                                parent: animation,
                                curve: _imageSwitchIn,
                                reverseCurve: _imageSwitchOut,
                              );
                              return FadeTransition(
                                opacity: curved,
                                child: SlideTransition(
                                  position: Tween<Offset>(
                                    begin: Offset(0.07 * _slideSign, 0),
                                    end: Offset.zero,
                                  ).animate(curved),
                                  child: child,
                                ),
                              );
                            },
                            child: Image.asset(
                              _mobilePreviewImage(tab),
                              key: ValueKey<int>(_frontIndex),
                              fit: BoxFit.cover,
                              alignment: Alignment.topCenter,
                              width: cardW,
                              height: cardH,
                              cacheWidth: 720,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => _go(-1),
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    'assets/icons/circle-arrow-left.png',
                    width: 48,
                    height: 48,
                    filterQuality: FilterQuality.high,
                  ),
                ),
                const SizedBox(width: 14),
                _MobilePreviewPill(tab: tab),
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () => _go(1),
                  behavior: HitTestBehavior.opaque,
                  child: Image.asset(
                    'assets/icons/circle-arrow-right.png',
                    width: 48,
                    height: 48,
                    filterQuality: FilterQuality.high,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

/// Decorative layer under the main preview (muted purple-grey, inset).
class _MobileDeckSpineLayer extends StatelessWidget {
  const _MobileDeckSpineLayer({required this.radius});

  final double radius;

  static const Color _fill = Color(0xFF3B3B54);
  static const Color _border = Color(0xFF4A4A64);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: _fill,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: _border, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.22),
            blurRadius: 8,
            offset: const Offset(0, 3),
            spreadRadius: -1,
          ),
        ],
      ),
    );
  }
}

class _MobilePreviewPill extends StatelessWidget {
  const _MobilePreviewPill({required this.tab});

  final _MobilePreviewTab tab;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 160),
      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x140F172A),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            _mobilePreviewIcon(tab),
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(
              Color(0xFF4F46E5),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _mobilePreviewLabel(tab),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: const Color(0xFF1E1B4B),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: const Color(0xFFDCE3F3)),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: const Color(0xFF475569),
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// class _MobileHeroLoginCard extends StatelessWidget {
//   const _MobileHeroLoginCard();
//
//   @override
//   Widget build(BuildContext context) {
//     return AuthFormCard(
//       compact: true,
//       showLogo: false,
//       title: '',
//       cornerRadius: 28,
//       cardColor: Colors.white,
//       boxShadow: const [
//         BoxShadow(
//           color: Color(0x190F172A),
//           offset: Offset(0, 14),
//           blurRadius: 28,
//         ),
//       ],
//       customHeader: Column(
//         children: [
//           Text(
//             'Already with Us?',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w800,
//               color: const Color(0xFF0F172A),
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             'Login',
//             textAlign: TextAlign.center,
//             style: Theme.of(context).textTheme.titleMedium?.copyWith(
//               fontWeight: FontWeight.w800,
//               color: const Color(0xFF5C5BFF),
//             ),
//           ),
//         ],
//       ),
//       child: const LandingHeroLoginForm(),
//     );
//   }
// }

class _MobileFeatureSection extends StatelessWidget {
  const _MobileFeatureSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding + 12, 26, padding + 12, 34),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: const Color(0xFF4042AC)),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF120635), Color(0xFF1A0D56), Color(0xFF120635)],
          ),
        ),
        child: Column(
          children: [
            for (var index = 0; index < _mobileFeatures.length; index++) ...[
              _MobileFeatureListRow(feature: _mobileFeatures[index]),
              if (index < _mobileFeatures.length - 1)
                Container(
                  height: 1,
                  width: double.infinity,
                  color: const Color(0xFF3C3FA2),
                ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MobileFeatureListRow extends StatelessWidget {
  const _MobileFeatureListRow({required this.feature});

  final _MobileFeature feature;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 18, 22, 18),
        child: Column(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: feature.color,
                borderRadius: BorderRadius.circular(11),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x300F172A),
                    offset: Offset(0, 8),
                    blurRadius: 14,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                feature.iconAsset,
                width: 24,
                height: 24,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              feature.title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w900,
                color: feature.color,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              feature.description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: const Color(0xFFE2E8F0),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileStepSection extends StatelessWidget {
  const _MobileStepSection({required this.padding});

  final double padding;
  static const double _stepTextGap = 48;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 26, padding, 34),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Get started\n',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                  ),
                ),
                TextSpan(
                  text: 'in 3 simple steps',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              'Identify, Support & Retain',
              maxLines: 1,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                foreground: Paint()
                  ..style = PaintingStyle.stroke
                  ..strokeWidth = 1
                  ..color = const Color(0x33FFFFFF),
              ),
            ),
          ),
          const SizedBox(height: 22),
          for (var i = 0; i < _mobileSteps.length; i++) ...[
            _MobileStepCard(
              index: i + 1,
              step: _mobileSteps[i],
              isLast: i == _mobileSteps.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}

class _MobileStepCard extends StatelessWidget {
  const _MobileStepCard({
    required this.index,
    required this.step,
    required this.isLast,
  });

  final int index;
  final _MobileStep step;
  final bool isLast;
  static const double _itemBottomGap = 48;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 72,
            child: Column(
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF4F46E5),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x664F46E5),
                        blurRadius: 22,
                        spreadRadius: -4,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: SvgPicture.asset(
                    step.iconAsset,
                    width: 36,
                    height: 36,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(width: 1, color: const Color(0x80E2E8F0)),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: _itemBottomGap),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    step.title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    step.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF9AA0B8),
                      fontWeight: FontWeight.w500,
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

class _MobileCtaSection extends StatefulWidget {
  const _MobileCtaSection({super.key, required this.padding});

  final double padding;

  @override
  State<_MobileCtaSection> createState() => _MobileCtaSectionState();
}

class _MobileCtaSectionState extends State<_MobileCtaSection> {
  int _selectedPlanIndex = 0;

  @override
  Widget build(BuildContext context) {
    final plan = _mobilePricingPlans[_selectedPlanIndex];

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(widget.padding, 26, widget.padding, 34),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Simple &\n',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: 'transparent pricing',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4F46E5),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 22),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MobilePlanPill(
                label: _mobilePricingPlans[0].name,
                selected: _selectedPlanIndex == 0,
                onTap: () => setState(() => _selectedPlanIndex = 0),
              ),
              const SizedBox(width: 16),
              _MobilePlanPill(
                label: _mobilePricingPlans[1].name,
                selected: _selectedPlanIndex == 1,
                onTap: () => setState(() => _selectedPlanIndex = 1),
              ),
            ],
          ),
          const SizedBox(height: 22),
          Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 10,
                right: -8,
                child: Container(
                  width: 286,
                  height: 392,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1F60),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF2F33A8),
                      width: 0.8,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 286,
                height: 392,
                child: Container(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
                  decoration: BoxDecoration(
                    color: const Color(0xFF08042A),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: const Color(0xFF4F46E5),
                      width: 1,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x7A4F46E5),
                        blurRadius: 76,
                        spreadRadius: -14,
                        offset: Offset(0, 12),
                      ),
                      BoxShadow(
                        color: Color(0x3D4F46E5),
                        blurRadius: 24,
                        spreadRadius: -8,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: plan.price,
                                style: Get.theme.textTheme.headlineMedium
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 32,
                                    ),
                              ),
                              TextSpan(
                                text: '/month',
                                style: Get.theme.textTheme.titleMedium
                                    ?.copyWith(
                                      color: const Color(0xFF4B517C),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 20,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      for (final item in plan.items) ...[
                        Text(
                          item,
                          style: Get.theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF9AA0B8),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                      const SizedBox(height: 18),
                      Center(
                        child: OutlinedButton(
                          onPressed: () => appNav.changePage(AppRoutes.login),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFF4F46E5)),
                            minimumSize: const Size(0, 54),
                            padding: const EdgeInsets.symmetric(horizontal: 34),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(999),
                            ),
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            'Contact sales',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
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
        ],
      ),
    );
  }
}

class _MobilePlanPill extends StatelessWidget {
  const _MobilePlanPill({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 123,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: const Color(0xFFFE9A00)),
          gradient: selected
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [Color(0xFF5C5BFF), Color(0xFF3A2F9D)],
                )
              : null,
          color: selected ? null : const Color(0x1008042A),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MobileContactSection extends StatelessWidget {
  const _MobileContactSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(padding, 30, padding, 34),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Start Automating\n',
                  style: Get.theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: 'Your Renewals Today',
                  style: Get.theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4F46E5),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Join hundreds of businesses that are recovering\nlost revenue every single day. No credit card\nrequired to start.',
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFF475569),
            ),
          ),
          const SizedBox(height: 32),
          for (final item in _mobileContactPoints) ...[
            _MobileContactPoint(text: item),
            const SizedBox(height: 24),
          ],
          const SizedBox(height: 14),
          const _MobileLeadCard(),
        ],
      ),
    );
  }
}

class _MobileContactPoint extends StatelessWidget {
  const _MobileContactPoint({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF4F46E5),
            shape: BoxShape.circle,
            boxShadow: const [
              BoxShadow(
                color: Color(0x734F46E5),
                blurRadius: 20,
                spreadRadius: -5,
                offset: Offset(0, 8),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            AppIcons.circleCheck,
            width: 20,
            height: 20,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        const SizedBox(width: 18),
        Expanded(
          child: Text(
            text,
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF6D7598),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileLeadCard extends StatelessWidget {
  const _MobileLeadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 32, 18, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
      ),
      child: Column(
        children: const [
          _MobileDarkField('Full Name'),
          SizedBox(height: 24),
          _MobileDarkField('Business Name'),
          SizedBox(height: 24),
          _MobileDarkField('Email Address'),
          SizedBox(height: 24),
          _MobileDarkField('Phone Number'),
          SizedBox(height: 32),
          _MobileEnquiryButton(),
          SizedBox(height: 24),
          _MobileLeadCopy(),
        ],
      ),
    );
  }
}

class _MobileDarkField extends StatelessWidget {
  const _MobileDarkField(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: const Color(0xFFE2E8F0),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: 280,
          height: 44,
          child: TextField(
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'Enter $label',
              hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
                color: const Color(0xFF94A3B8),
                fontWeight: FontWeight.w500,
              ),
              filled: true,
              fillColor: const Color(0xFF0F172A),
              contentPadding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
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
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileEnquiryButton extends StatelessWidget {
  const _MobileEnquiryButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 58,
      child: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF3A2F9D),
          foregroundColor: const Color(0xFF8C8FAE),
          minimumSize: const Size.fromHeight(58),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        child: const Text(
          'Request Enquiry',
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
        ),
      ),
    );
  }
}

class _MobileLeadCopy extends StatelessWidget {
  const _MobileLeadCopy();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Request a demo and we will get back to you. Thank you!',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF475569),
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _MobileFaqSection extends StatelessWidget {
  const _MobileFaqSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(padding, 36, padding, 28),
      child: Column(
        children: [
          FaqSectionHeading(
            leadColor: const Color(0xFF4F46E5),
            restColor: Colors.white,
            fontSize: 24,
            breakAfterFirstWordOnMobile: true,
            baseStyle: Get.theme.textTheme.bodyLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 22),
          for (final faq in _mobileFaqs) ...[
            _MobileExpandableFaqCard(faq: faq),
            if (faq != _mobileFaqs.last) const SizedBox(height: 12),
          ],
          const SizedBox(height: 18),
          const _MobileQuestionCard(),
        ],
      ),
    );
  }
}

class _MobileQuestionCard extends StatelessWidget {
  const _MobileQuestionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 24),
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCBD5E1), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Got anything to ask us?',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF4F46E5),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 20),
          const _MobileInputField(hint: 'Email Address', height: 44),
          const SizedBox(height: 16),
          const _MobileInputField(
            hint: 'Type your message here....',
            height: 144,
            maxLines: null,
            expands: true,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 58,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF3A2F9D),
                foregroundColor: const Color(0xFF8C8FAE),
                minimumSize: const Size.fromHeight(58),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(999),
                ),
              ),
              child: const Text(
                'Send',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileInputField extends StatelessWidget {
  const _MobileInputField({
    required this.hint,
    required this.height,
    this.maxLines = 1,
    this.expands = false,
  });

  final String hint;
  final double height;
  final int? maxLines;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: height,
      child: TextField(
        maxLines: expands ? null : maxLines,
        minLines: expands ? null : 1,
        expands: expands,
        textAlign: TextAlign.start,
        textAlignVertical: expands
            ? TextAlignVertical.top
            : TextAlignVertical.center,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Get.theme.textTheme.labelMedium?.copyWith(
            color: const Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
          filled: true,
          fillColor: const Color(0xFF0F172A),
          contentPadding: EdgeInsets.fromLTRB(
            14,
            expands ? 11 : 11,
            14,
            expands ? 11 : 11,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
          ),
        ),
      ),
    );
  }
}

class _MobileExpandableFaqCard extends StatefulWidget {
  const _MobileExpandableFaqCard({required this.faq});

  final _MobileFaq faq;

  @override
  State<_MobileExpandableFaqCard> createState() =>
      _MobileExpandableFaqCardState();
}

class _MobileExpandableFaqCardState extends State<_MobileExpandableFaqCard> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () => setState(() => _open = !_open),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    _open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: const Color(0xFF94A3B8),
                  ),
                ],
              ),
            ),
          ),
          AnimatedCrossFade(
            firstChild: const SizedBox(width: double.infinity),
            secondChild: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Text(
                widget.faq.answer,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF94A3B8),
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

class _MobileBottomCtaSection extends StatelessWidget {
  const _MobileBottomCtaSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 28, padding, 36),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Ready to transform your\n',
                  style: Get.theme.textTheme.bodyLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                TextSpan(
                  text: 'Renewal Process?',
                  style: Get.theme.textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF4F46E5),
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            'Join thousands of teams who have reduced churn and increased retention with Recrip.\nStart your free trial today.',
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.bodySmall?.copyWith(
              color: const Color(0xFFE2DDF7),
              fontWeight: FontWeight.w600,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 168,
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
                  'Book a Free Trial',
                  style: Get.theme.textTheme.bodySmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: 174,
            height: 48,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: const BorderSide(color: Color(0xFF4F46E5), width: 1),
                padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: Text(
                'Schedule a Demo',
                style: Get.theme.textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'No credit card required • 14-day free trial • Cancel anytime',
            textAlign: TextAlign.center,
            style: Get.theme.textTheme.labelMedium?.copyWith(
              color: const Color(0xFF475569),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileFooterSection extends StatelessWidget {
  const _MobileFooterSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF0D0820),
      padding: EdgeInsets.fromLTRB(padding, 30, padding, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppIcons.recripLogo, height: 36, fit: BoxFit.contain),
          const SizedBox(height: 14),
          Text(
            'Most powerful subscription renewal management platform. Built for business that want to scale without losing revenue.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w500,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _MobileFooterColumn(
                  title: 'Product',
                  items: const ['Features', 'Pricing'],
                ),
              ),
              Expanded(
                child: _MobileFooterColumn(
                  title: 'Company',
                  items: const ['About', 'Contact'],
                ),
              ),
              Expanded(
                child: _MobileFooterColumn(
                  title: 'Legal',
                  items: const ['Privacy Policy', 'Terms of Service'],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            'Social',
            style: Get.theme.textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: const [
              _MobileFooterSocialIcon('assets/images/linkedin.png'),
              SizedBox(width: 12),
              _MobileFooterSocialIcon('assets/images/insta.png'),
              SizedBox(width: 12),
              _MobileFooterSocialIcon('assets/images/twitter-x.png'),
              SizedBox(width: 12),
              _MobileFooterSocialIcon('assets/images/facebook.png'),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 0.8, color: Color(0xFFB4BDD4)),
          const SizedBox(height: 16),
          Text(
            '\u00A9 2026 Recrip. All rights reserved.',
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

class _MobileFooterColumn extends StatelessWidget {
  const _MobileFooterColumn({required this.title, required this.items});

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
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              item,
              style: Get.theme.textTheme.bodySmall?.copyWith(
                color: const Color(0xFF64748B),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MobileFooterSocialIcon extends StatelessWidget {
  const _MobileFooterSocialIcon(this.assetPath);

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(assetPath, width: 28, height: 28, fit: BoxFit.contain);
  }
}

String _mobilePreviewImage(_MobilePreviewTab tab) {
  switch (tab) {
    case _MobilePreviewTab.dashboard:
      return 'assets/images/Dashboard.webp';
    case _MobilePreviewTab.members:
      return 'assets/images/Members.webp';
    case _MobilePreviewTab.subscriptions:
      return 'assets/images/subscriptions.webp';
    case _MobilePreviewTab.renewals:
      return 'assets/images/Renewals.webp';
  }
}

String _mobilePreviewIcon(_MobilePreviewTab tab) {
  switch (tab) {
    case _MobilePreviewTab.dashboard:
      return AppIcons.dashboard;
    case _MobilePreviewTab.members:
      return AppIcons.usersRound;
    case _MobilePreviewTab.subscriptions:
      return AppIcons.calendarDays;
    case _MobilePreviewTab.renewals:
      return AppIcons.calendarSync;
  }
}

String _mobilePreviewLabel(_MobilePreviewTab tab) {
  switch (tab) {
    case _MobilePreviewTab.dashboard:
      return 'Dashboard';
    case _MobilePreviewTab.members:
      return 'Members';
    case _MobilePreviewTab.subscriptions:
      return 'Subscriptions';
    case _MobilePreviewTab.renewals:
      return 'Renewals';
  }
}

const _mobileFeatures = [
  _MobileFeature(
    'Smart Renewal Alerts',
    'Automatically remind customers via WhatsApp, SMS, and email before they expire.',
    AppIcons.bell,
    Color(0xFF2B7FFF),
  ),
  _MobileFeature(
    'Analytics Dashboard',
    'Track revenue, renewals, and customer behavior with deep visual insights.',
    AppIcons.chartPie,
    Color(0xFF8E51FF),
  ),
  _MobileFeature(
    'Auto Renewals',
    'Set it once and let Recrip handle the rest. Seamless recurring billing.',
    AppIcons.renew,
    Color(0xFF00BC7D),
  ),
  _MobileFeature(
    'Customer Management',
    'All your subscription data in one place. Search, filter, and manage with ease.',
    AppIcons.usersRound,
    Color(0xFFE12AFB),
  ),
  _MobileFeature(
    'Payment Recovery',
    'Recover missed payments and reduce churn effortlessly with automated retries.',
    AppIcons.creditCard,
    Color(0xFF5FC7FF),
  ),
  _MobileFeature(
    'Integrations',
    'Work seamlessly with your existing tools like Stripe, Razorpay, and more.',
    AppIcons.globe,
    Color(0xFFFFB019),
  ),
];

const _mobileSteps = [
  _MobileStep(
    'Add your customers',
    'Import your existing customer list or sync with your current CRM in seconds.',
    AppIcons.addCustomer,
  ),
  _MobileStep(
    'Set renewal schedules',
    'Define when and how you want to notify customers about their upcoming renewals.',
    AppIcons.clock,
  ),
  _MobileStep(
    'Automate & track revenue',
    'Sit back while Recrip handles the follow-ups and provides real-time growth data.',
    AppIcons.trendingUp,
  ),
];

const _mobileFaqs = [
  _MobileFaq(
    'Can I customize the notification messages?',
    'Absolutely! You can fully customize the content, timing, and channel for every notification sent.',
  ),
  _MobileFaq(
    'Is my customer data secure?',
    'Yes, we use bank-grade encryption and are fully GDPR and SOC2 compliant. Your data is isolated and protected at all times.',
  ),
  _MobileFaq(
    'What businesses is Recrip best for?',
    'Recrip is designed for any business with recurring subscriptions, including gyms, salons, clinics, SaaS, and service providers.',
  ),
];

const _mobilePricingPlans = [
  _MobilePricingPlan(
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
  _MobilePricingPlan(
    name: 'Growth',
    price: '₹2499',
    items: [
      '700 Members',
      'WhatsApp Reminders',
      'Renewal Alerts',
      'Custom Reminders',
      'Export Report (Current Month)',
    ],
  ),
];

const _mobileContactPoints = [
  'Free 14-day trial',
  'No Setup fees',
  'Cancel Anytime',
  '24/7 Priority Support',
];

class _MobileFeature {
  const _MobileFeature(
    this.title,
    this.description,
    this.iconAsset,
    this.color,
  );

  final String title;
  final String description;
  final String iconAsset;
  final Color color;
}

class _MobileStep {
  const _MobileStep(this.title, this.description, this.iconAsset);

  final String title;
  final String description;
  final String iconAsset;
}

class _MobileFaq {
  const _MobileFaq(this.question, this.answer);

  final String question;
  final String answer;
}

class _MobilePricingPlan {
  const _MobilePricingPlan({
    required this.name,
    required this.price,
    required this.items,
  });

  final String name;
  final String price;
  final List<String> items;
}
