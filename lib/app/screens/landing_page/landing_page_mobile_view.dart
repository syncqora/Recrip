import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';
// import 'package:saas/app/screens/landing_page/landing_hero_login_form.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/constants/app_icons.dart';

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
  _MobilePreviewTab _selectedPreviewTab = _MobilePreviewTab.dashboard;

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
      backgroundColor: const Color(0xFFF5F7FF),
      body: Column(
        children: [
          _MobileTopBar(onMenuTap: _openNavSheet),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _MobileHeroSection(padding: padding),
                  _MobileFeatureSection(key: _featuresKey, padding: padding),
                  _MobilePreviewSection(
                    key: _previewKey,
                    padding: padding,
                    selectedTab: _selectedPreviewTab,
                    onPreviewSelected: (tab) =>
                        setState(() => _selectedPreviewTab = tab),
                  ),
                  _MobileStepSection(padding: padding),
                  _MobileCtaSection(key: _pricingKey, padding: padding),
                  _MobileFaqSection(key: _contactKey, padding: padding),
                  _MobileFooterSection(padding: padding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _MobileNavTab { features, preview, pricing, contact }

enum _MobilePreviewTab { dashboard, members, subscriptions, renewals }

class _MobileTopBar extends StatelessWidget {
  const _MobileTopBar({required this.onMenuTap});

  final VoidCallback onMenuTap;

  static const Color _barBg = Color(0xFFFDFDFE);
  static const Color _menuIcon = Color(0xFF1E293B);

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
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Color(0xFFE7EBF3))),
          ),
          child: SizedBox(
            height: 52,
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
                Center(
                  child: Image.asset(
                    AppIcons.recripLogo,
                    height: 28,
                    fit: BoxFit.contain,
                    filterQuality: FilterQuality.high,
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
    final headingStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: 38,
      fontWeight: FontWeight.w900,
      color: const Color(0xFF0F172A),
      height: 1.05,
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
            top: 460,
            right: -90,
            child: Container(
              width: 580,
              height: 460,
              decoration: const BoxDecoration(
                color: Color(0xFF111C3B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(90),
                  bottomLeft: Radius.circular(90),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, 24, padding, 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Never Lose\nRevenue from ',
                        style: headingStyle,
                      ),
                      TextSpan(
                        text: 'Expired\nSubscriptions',
                        style: headingStyle?.copyWith(
                          color: const Color(0xFF4F46E5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Recrip helps businesses automate renewals, track customers, and recover missed payments from one powerful dashboard.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: const Color(0xFF475569),
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: () => appNav.changePage(AppRoutes.login),
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFF5C5BFF),
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: const Text(
                          'Start Free Trial',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                // const SizedBox(height: 24),
                // const _MobileHeroLoginCard(),
              ],
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
      color: const Color(0xFFF5F4FF),
      padding: EdgeInsets.fromLTRB(padding, 36, padding, 40),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Everything you need\nto ',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                    height: 1.12,
                  ),
                ),
                TextSpan(
                  text: 'scale faster',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Stop manually tracking spreadsheets. Recrip automates the boring stuff so you can focus on growth.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          for (final feature in _mobileFeatures) ...[
            _MobileFeatureCard(feature: feature),
            if (feature != _mobileFeatures.last) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _MobileFeatureCard extends StatelessWidget {
  const _MobileFeatureCard({required this.feature});

  final _MobileFeature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6EAF6)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x060F172A),
            blurRadius: 20,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: feature.color,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x29383737),
                  offset: Offset(0, 12),
                  blurRadius: 18,
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
          const SizedBox(height: 18),
          Text(
            feature.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B),
              height: 1.55,
            ),
          ),
        ],
      ),
    );
  }
}

class _MobilePreviewSection extends StatelessWidget {
  const _MobilePreviewSection({
    super.key,
    required this.padding,
    required this.selectedTab,
    required this.onPreviewSelected,
  });

  final double padding;
  final _MobilePreviewTab selectedTab;
  final ValueChanged<_MobilePreviewTab> onPreviewSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 32, padding, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Built for ',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                TextSpan(
                  text: 'Modern Teams',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'A focused renewal workflow for fast-moving teams, now simplified for mobile browsing.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Wrap(
              spacing: 6,
              runSpacing: 6,
              children: _MobilePreviewTab.values.map((tab) {
                final selected = tab == selectedTab;
                return SizedBox(
                  width:
                      ((MediaQuery.sizeOf(context).width - (padding * 2) - 24) /
                              2)
                          .clamp(120.0, 220.0),
                  child: InkWell(
                    onTap: () => onPreviewSelected(tab),
                    borderRadius: BorderRadius.circular(12),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 220),
                      curve: Curves.easeOutCubic,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF4F46E5)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            _mobilePreviewIcon(tab),
                            width: 15,
                            height: 15,
                            colorFilter: ColorFilter.mode(
                              selected ? Colors.white : const Color(0xFF64748B),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 7),
                          Flexible(
                            child: Text(
                              _mobilePreviewLabel(tab),
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: selected
                                        ? Colors.white
                                        : const Color(0xFF334155),
                                    fontWeight: FontWeight.w700,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),
          GestureDetector(
            onHorizontalDragEnd: (details) {
              const minSwipeVelocity = 140.0;
              final velocity = details.primaryVelocity ?? 0;
              if (velocity.abs() < minSwipeVelocity) return;
              if (velocity < 0) {
                onPreviewSelected(_nextMobilePreviewTab(selectedTab));
              } else {
                onPreviewSelected(_previousMobilePreviewTab(selectedTab));
              }
            },
            child: _MobileDashboardMock(selectedTab: selectedTab),
          ),
        ],
      ),
    );
  }
}

_MobilePreviewTab _nextMobilePreviewTab(_MobilePreviewTab tab) {
  final tabs = _MobilePreviewTab.values;
  final current = tabs.indexOf(tab);
  final next = (current + 1) % tabs.length;
  return tabs[next];
}

_MobilePreviewTab _previousMobilePreviewTab(_MobilePreviewTab tab) {
  final tabs = _MobilePreviewTab.values;
  final current = tabs.indexOf(tab);
  final previous = (current - 1 + tabs.length) % tabs.length;
  return tabs[previous];
}

class _MobileDashboardMock extends StatelessWidget {
  const _MobileDashboardMock({required this.selectedTab});

  final _MobilePreviewTab selectedTab;
  static const double _aspect = 392 / 792;
  static const double _innerPadding = 8;

  @override
  Widget build(BuildContext context) {
    // Keep all 4 tabs in the stack; selected tab stays on top/front.
    final orderedCards = [
      for (final tab in _MobilePreviewTab.values)
        if (tab != selectedTab) tab,
      selectedTab,
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final w = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : 360.0;
        final h = w * _aspect;

        return SizedBox(
          width: w,
          height: h,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
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
                            _MobilePreviewCard(
                              key: ValueKey<_MobilePreviewTab>(
                                orderedCards[index],
                              ),
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

class _MobilePreviewCard extends StatelessWidget {
  const _MobilePreviewCard({
    super.key,
    required this.tab,
    required this.layerIndex,
    required this.layerCount,
    required this.isFront,
    required this.stackW,
    required this.stackH,
  });

  final _MobilePreviewTab tab;
  final int layerIndex;
  final int layerCount;
  final bool isFront;
  final double stackW;
  final double stackH;

  @override
  Widget build(BuildContext context) {
    final w = stackW;
    final h = stackH;

    final cardW = (w * 0.60).clamp(0.0, 220.0);
    final cardH = h * 0.88;
    final top = (h - cardH) / 2;
    final baseLeft = w * 0.04;
    // Half-overlap rule: each next/lower card starts from half of the card above.
    final stepOffset = cardW * 0.20;
    final stepsFromFront = (layerCount - 1) - layerIndex;
    final left = baseLeft + (stepOffset * stepsFromFront);
    final depthScale = (1.0 - (0.04 * stepsFromFront)).clamp(0.84, 1.0);

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
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 320),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: isFront ? const Color(0x150F172A) : Colors.transparent,
              ),
              boxShadow: [
                BoxShadow(
                  color: isFront
                      ? const Color(0x300F172A)
                      : const Color(0x1A0F172A),
                  blurRadius: isFront ? 24 : 16,
                  offset: Offset(0, isFront ? 10 : 7),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: _mobileStackPreviewImage(tab: tab, isFront: isFront),
          ),
        ),
      ),
    );
  }
}

Widget _mobileStackPreviewImage({
  required _MobilePreviewTab tab,
  required bool isFront,
}) {
  final path = _mobilePreviewImage(tab);
  Widget img = Image.asset(
    path,
    fit: BoxFit.contain,
    alignment: Alignment.center,
    cacheWidth: isFront ? 720 : 520,
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

class _MobileStepSection extends StatelessWidget {
  const _MobileStepSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F4FF),
      padding: EdgeInsets.fromLTRB(padding, 32, padding, 42),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Get started in ',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                TextSpan(
                  text: 'three simple steps',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 30,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            'Move from manual follow-ups to automated renewals without changing how your team already works.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          for (var i = 0; i < _mobileSteps.length; i++) ...[
            _MobileStepCard(index: i + 1, step: _mobileSteps[i]),
            if (i != _mobileSteps.length - 1) const SizedBox(height: 14),
          ],
        ],
      ),
    );
  }
}

class _MobileStepCard extends StatelessWidget {
  const _MobileStepCard({required this.index, required this.step});

  final int index;
  final _MobileStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFF4F46E5),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  step.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF64748B),
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              step.iconAsset,
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                Color(0xFF4F46E5),
                BlendMode.srcIn,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileCtaSection extends StatelessWidget {
  const _MobileCtaSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF101934),
      padding: EdgeInsets.fromLTRB(padding, 34, padding, 34),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Start Automating\n',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
                TextSpan(
                  text: 'Your Renewals Today',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Join hundreds of businesses recovering lost revenue every day. No credit card required to start.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFFCBD5E1),
              height: 1.45,
            ),
          ),
          const SizedBox(height: 18),
          for (final item in const [
            'Free 14-day trial',
            'No Setup Fee',
            'Cancel Anytime',
            '24/7 Priority Support',
          ])
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Color(0xFF4F46E5),
                      shape: BoxShape.circle,
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      AppIcons.circleCheck,
                      width: 14,
                      height: 14,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    item,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: const Color(0xFFE2E8F0),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),
          const _MobileLeadCard(),
        ],
      ),
    );
  }
}

class _MobileLeadCard extends StatelessWidget {
  const _MobileLeadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16224A),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        children: const [
          _MobileDarkField('Full Name'),
          SizedBox(height: 14),
          _MobileDarkField('Business Name'),
          SizedBox(height: 14),
          _MobileDarkField('Email Address'),
          SizedBox(height: 14),
          _MobileDarkField('Phone Number'),
          SizedBox(height: 18),
          _MobileEnquiryButton(),
          SizedBox(height: 18),
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
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFFC6D1F7),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFF16224A),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
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

class _MobileEnquiryButton extends StatelessWidget {
  const _MobileEnquiryButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF5C5BFF),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: const Text(
          'Request Enquiry',
          style: TextStyle(fontWeight: FontWeight.w700),
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
        color: const Color(0xFFCBD5E1),
        height: 1.4,
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
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(padding, 36, padding, 28),
      child: Column(
        children: [
          Text(
            'Frequently Asked Questions',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 30,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFCBD5E1)),
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
          const _MobileInputField(hint: 'Email Address', height: 48),
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
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF5C5BFF),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(48),
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
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF)),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.fromLTRB(
            12,
            expands ? 11 : 13,
            12,
            expands ? 11 : 13,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(expands ? 10 : 12),
            borderSide: const BorderSide(color: Color(0xFFDCE3F3)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(expands ? 10 : 12),
            borderSide: const BorderSide(color: Color(0xFF4F46E5)),
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
        color: const Color(0xFFF8FAFC),
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
                        color: const Color(0xFF0F172A),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    _open
                        ? Icons.expand_less_rounded
                        : Icons.expand_more_rounded,
                    color: const Color(0xFF64748B),
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
                  color: const Color(0xFF64748B),
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

class _MobileFooterSection extends StatelessWidget {
  const _MobileFooterSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F4FF),
      padding: EdgeInsets.fromLTRB(padding, 24, padding, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppIcons.recripLogo, height: 32, fit: BoxFit.contain),
          const SizedBox(height: 10),
          Text(
            'Most powerful subscription renewal management platform. Built for business that want to scale without losing revenue.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 24),
          const Divider(thickness: 1, color: Color(0xFFCBD5E1)),
          const SizedBox(height: 18),
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

String _mobilePreviewImage(_MobilePreviewTab tab) {
  switch (tab) {
    case _MobilePreviewTab.dashboard:
      return 'assets/images/Dashboard.webp';
    case _MobilePreviewTab.members:
      return 'assets/images/Members.webp';
    case _MobilePreviewTab.subscriptions:
      return 'assets/images/Members.webp';
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
    'Payment Recovery',
    'Recover missed payments and reduce churn effortlessly with automated retries.',
    AppIcons.creditCard,
    Color(0xFF5FC7FF),
  ),
  _MobileFeature(
    'Analytics Dashboard',
    'Track revenue, renewals, and customer behavior with deep visual insights.',
    AppIcons.chartPie,
    Color(0xFF8E51FF),
  ),
  _MobileFeature(
    'Customer Management',
    'All your subscription data in one place. Search, filter, and manage with ease.',
    AppIcons.usersRound,
    Color(0xFFE12AFB),
  ),
  _MobileFeature(
    'Auto Renewals',
    'Set it once and let Recrip handle the rest. Seamless recurring billing.',
    AppIcons.renew,
    Color(0xFF00BC7D),
  ),
  _MobileFeature(
    'Business Insights',
    'Track revenue, renewals, and customer behavior with deep visual insights.',
    AppIcons.globe,
    Color(0xFFFE9A00),
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
    'Automate and track revenue',
    'Sit back while Recrip handles the follow-ups and gives your team real-time growth visibility.',
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
