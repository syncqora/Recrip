import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart' show ValueListenable, ValueNotifier;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/widgets/faq_section_heading.dart';
import 'package:saas/shared/widgets/landing_section_skeleton.dart';

/// Decode size aligned to device DPI (cap avoids huge bitmaps / slow decode).
int _landingRasterDecodePx(BuildContext context, double logical) {
  final dpr = MediaQuery.devicePixelRatioOf(context);
  return (logical * dpr).round().clamp(1, 4096);
}

/// All PNG/WebP raster assets referenced on mobile landing — warmed on first frame.
const _landingMobileRasterWarmupPaths = <String>{
  AppIcons.recripLogo,
  'assets/images/brand-logo.png',
  'assets/images/recrip.png',
  'assets/images/dashboard-new.png',
  'assets/images/members-new.png',
  'assets/images/subscriptions-new.png',
  'assets/images/renewals-new.png',
  'assets/images/linkedin.png',
  'assets/images/insta.png',
  'assets/images/twitter-x.png',
  'assets/images/facebook.png',
};

class LandingPageMobileView extends StatefulWidget {
  const LandingPageMobileView({super.key});

  @override
  State<LandingPageMobileView> createState() => _LandingPageMobileViewState();
}

class _LandingPageMobileViewState extends State<LandingPageMobileView> {
  final _featuresKey = GlobalKey();
  final _previewKey = GlobalKey();
  final _stepsKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();

  final _scrollController = ScrollController();

  /// Nav highlight isolated so scroll-spy updates don’t rebuild the whole page.
  final ValueNotifier<_MobileNavTab?> _navHighlight =
      ValueNotifier<_MobileNavTab?>(null);

  bool _renderDeferredSections = false;
  bool _lockPageScroll = false;

  /// Tracks active swiper pointers ([Listener] down/up/cancel) so deferred
  /// [setState] matches nested swipers without losing unlock order on web.
  int _swiperActivePointers = 0;

  bool _pageScrollLockMicrotaskScheduled = false;

  /// Avoid fighting [ScrollController] listener during [Scrollable.ensureVisible].
  bool _suppressScrollSpy = false;

  /// Scroll-spy runs at most once per frame (listeners fire every drag tick).
  bool _navSpyFramePending = false;

  /// Approx sticky header offset for scroll-spy anchor (below safe area chip row).
  static const double _navSpyHeaderBelowSafeArea = 118;

  /// Slack for scroll-spy (same intent as desktop `_kLandingNavSpySectionTopSlackPx`).
  static const double _navSpySectionTopSlackPx = 72;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scheduleNavSpyIfNeeded);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(_precacheLandingRasters());
      setState(() => _renderDeferredSections = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _syncNavHighlightFromScroll();
      });
    });
  }

  @override
  void dispose() {
    _swiperActivePointers = 0;
    _scrollController.removeListener(_scheduleNavSpyIfNeeded);
    _scrollController.dispose();
    _navHighlight.dispose();
    super.dispose();
  }

  /// Fills [ImageCache] for mobile landing rasters in parallel (Decode is still
  /// capped via [cacheWidth]/[ResizeImage] where used).
  Future<void> _precacheLandingRasters() async {
    if (!mounted) return;
    await Future.wait<void>(
      _landingMobileRasterWarmupPaths.map(
        (path) => precacheImage(AssetImage(path), context),
      ),
    );
  }

  Future<void> _scrollTo(GlobalKey key) async {
    final targetContext = key.currentContext;
    if (targetContext == null) return;
    await Scrollable.ensureVisible(
      targetContext,
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeInOut,
      alignment: 0.0,
    );
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

  Future<void> _onNavTap(_MobileNavTab tab, GlobalKey key) async {
    if (!mounted) return;
    _suppressScrollSpy = true;
    _navHighlight.value = tab;
    await _scrollTo(key);
    if (!mounted) return;
    await Future<void>.delayed(const Duration(milliseconds: 460));
    if (!mounted) return;
    _suppressScrollSpy = false;
    _syncNavHighlightFromScroll();
  }

  /// Swiper wrappers call this on pointer down/up/cancel.
  ///
  /// **Do not call [setState] synchronously** from those pointers: swapping
  /// [ScrollPhysics] rebuilds [SingleChildScrollView] while hit-testing still
  /// walks swiper descendants → "Cannot hit test ... NEEDS-LAYOUT" on web.
  void _onSwiperInteractionStart() {
    if (!mounted) return;
    _swiperActivePointers++;
    _schedulePageScrollLockedToSwipers();
  }

  void _onSwiperInteractionEnd() {
    if (_swiperActivePointers > 0) {
      _swiperActivePointers--;
    }
    _schedulePageScrollLockedToSwipers();
  }

  void _schedulePageScrollLockedToSwipers() {
    if (_pageScrollLockMicrotaskScheduled) return;
    _pageScrollLockMicrotaskScheduled = true;
    Future.microtask(() {
      _pageScrollLockMicrotaskScheduled = false;
      if (!mounted) return;
      final lock = _swiperActivePointers > 0;
      if (lock != _lockPageScroll) setState(() => _lockPageScroll = lock);
    });
  }

  void _syncNavHighlightFromScroll() {
    if (!mounted || _suppressScrollSpy || !_scrollController.hasClients) {
      return;
    }
    // Never call [localToGlobal] + ValueNotifier mutations synchronously off a
    // scroll/layout path — that can rebuild the sibling header subtree and hit
    // layout re-entry while this page's Column (scroll child) still lays out
    // (!_debugDoingThisLayout assertion on web).
    Future.microtask(() {
      if (!mounted || _suppressScrollSpy || !_scrollController.hasClients) {
        return;
      }
      final next = _activeTabFromScrollPhysics(context);
      if (next != _navHighlight.value) {
        _navHighlight.value = next;
      }
    });
  }

  /// Picks the last section (in scroll order) whose top has crossed the anchor
  /// band — matches “current section while reading”; above features → none.
  _MobileNavTab? _activeTabFromScrollPhysics(BuildContext context) {
    final anchorY =
        MediaQuery.paddingOf(context).top + _navSpyHeaderBelowSafeArea;
    final effectiveAnchor = anchorY + _navSpySectionTopSlackPx;

    final tabs = <({_MobileNavTab tab, GlobalKey key})>[
      (tab: _MobileNavTab.features, key: _featuresKey),
      (tab: _MobileNavTab.preview, key: _stepsKey),
      (tab: _MobileNavTab.pricing, key: _pricingKey),
      (tab: _MobileNavTab.contact, key: _contactKey),
    ];

    _MobileNavTab? chosen;
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

  void _onLandingNavSelect(_MobileNavTab tab) {
    switch (tab) {
      case _MobileNavTab.features:
        _onNavTap(tab, _featuresKey);
      case _MobileNavTab.preview:
        _onNavTap(tab, _stepsKey);
      case _MobileNavTab.pricing:
        _onNavTap(tab, _pricingKey);
      case _MobileNavTab.contact:
        _onNavTap(tab, _contactKey);
    }
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
            _MobileLandingHeader(
              navHighlight: _navHighlight,
              onNavSelect: _onLandingNavSelect,
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: _lockPageScroll
                    ? const NeverScrollableScrollPhysics()
                    : const BouncingScrollPhysics(
                        parent: AlwaysScrollableScrollPhysics(),
                      ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 32),
                    _MobileHeroSection(padding: padding),
                    const SizedBox(height: 80),
                    KeyedSubtree(
                      key: _previewKey,
                      child: _MobileHeroDashboardCarousel(
                        onInteractionStart: _onSwiperInteractionStart,
                        onInteractionEnd: _onSwiperInteractionEnd,
                      ),
                    ),
                    if (_renderDeferredSections) ...[
                      _MobileFeatureSection(
                        key: _featuresKey,
                        padding: padding,
                      ),
                      _MobileStepSection(key: _stepsKey, padding: padding),
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

/// Logo + log-in row and a horizontally scrollable in-page nav — matches landing
/// colors (no white bottom sheet interrupting the gradient).
class _MobileLandingHeader extends StatelessWidget {
  const _MobileLandingHeader({
    required this.navHighlight,
    required this.onNavSelect,
  });

  final ValueListenable<_MobileNavTab?> navHighlight;
  final ValueChanged<_MobileNavTab> onNavSelect;

  static const Color _inactiveBorder = Color(0xFF4F46E5);
  static const Color _inactiveFill = Color(0x2608042A);

  @override
  Widget build(BuildContext context) {
    final chips = <({_MobileNavTab tab, String label})>[
      (tab: _MobileNavTab.features, label: 'Features'),
      (tab: _MobileNavTab.preview, label: 'How it works'),
      (tab: _MobileNavTab.pricing, label: 'Pricing'),
      (tab: _MobileNavTab.contact, label: 'Contact'),
    ];

    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () => appNav.changePage(AppRoutes.login),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.only(right: 26, left: 16),
                      ),
                      child: Text(
                        'Log in',
                        style: Get.theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
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
                          gaplessPlayback: true,
                          cacheWidth: _landingRasterDecodePx(context, 32),
                          cacheHeight: _landingRasterDecodePx(context, 32),
                          filterQuality: FilterQuality.medium,
                        ),
                        const SizedBox(width: 10),
                        Image.asset(
                          'assets/images/recrip.png',
                          height: 32,
                          fit: BoxFit.contain,
                          gaplessPlayback: true,
                          cacheHeight: _landingRasterDecodePx(context, 32),
                          filterQuality: FilterQuality.medium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
              // Rebuild only the chip row — rebuilding the scroll view itself
              // recreated the subtree every scroll-spy tick and broke hit-testing.
              child: ValueListenableBuilder<_MobileNavTab?>(
                valueListenable: navHighlight,
                builder: (context, activeNavTab, _) {
                  return Row(
                    children: [
                      for (var i = 0; i < chips.length; i++) ...[
                        if (i > 0) const SizedBox(width: 8),
                        _MobileLandingNavChip(
                          label: chips[i].label,
                          selected: activeNavTab == chips[i].tab,
                          borderColorSelected: const Color(0xFF4F46E5),
                          gradientSelected: const LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            colors: [Color(0xFF5C5BFF), Color(0xFF3A2F9D)],
                          ),
                          inactiveFill: _inactiveFill,
                          inactiveBorder: _inactiveBorder,
                          onTap: () => onNavSelect(chips[i].tab),
                        ),
                      ],
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileLandingNavChip extends StatelessWidget {
  const _MobileLandingNavChip({
    required this.label,
    required this.selected,
    required this.onTap,
    required this.borderColorSelected,
    required this.gradientSelected,
    required this.inactiveFill,
    required this.inactiveBorder,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color borderColorSelected;
  final Gradient gradientSelected;
  final Color inactiveFill;
  final Color inactiveBorder;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        splashColor: const Color(0x334F46E5),
        highlightColor: const Color(0x224F46E5),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: selected ? borderColorSelected : inactiveBorder,
              width: 1,
            ),
            gradient: selected ? gradientSelected : null,
            color: selected ? null : inactiveFill,
          ),
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
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
  const _MobileHeroDashboardCarousel({
    required this.onInteractionStart,
    required this.onInteractionEnd,
  });

  final VoidCallback onInteractionStart;
  final VoidCallback onInteractionEnd;

  @override
  State<_MobileHeroDashboardCarousel> createState() =>
      _MobileHeroDashboardCarouselState();
}

class _MobileHeroDashboardCarouselState
    extends State<_MobileHeroDashboardCarousel> {
  static const _previewTabs = <_MobilePreviewTab>[
    _MobilePreviewTab.dashboard,
    _MobilePreviewTab.members,
    _MobilePreviewTab.subscriptions,
    _MobilePreviewTab.renewals,
  ];

  final SwiperController _swiperController = SwiperController();
  int _activeIndex = 0;

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentTab = _previewTabs[_activeIndex % _previewTabs.length];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 8),
        _MobileSwiperBuilder(
          controller: _swiperController,
          onIndexChanged: (index) =>
              setState(() => _activeIndex = index % _previewTabs.length),
          onInteractionStart: widget.onInteractionStart,
          onInteractionEnd: widget.onInteractionEnd,
        ),
        const SizedBox(height: 10),
        Center(child: _MobilePreviewPill(tab: currentTab)),
      ],
    );
  }
}

class _MobileSwiperBuilder extends StatelessWidget {
  const _MobileSwiperBuilder({
    required this.controller,
    required this.onIndexChanged,
    this.onInteractionStart,
    this.onInteractionEnd,
  });

  final SwiperController controller;
  final ValueChanged<int> onIndexChanged;

  final VoidCallback? onInteractionStart;
  final VoidCallback? onInteractionEnd;
  static const double _cardWidth = 370;
  static const double _cardHeight = 232;
  static const double _cardRadius = 10;

  /// Tight viewport for vertical STACK so decks aren’t vertically centered in a
  /// tall [Expanded], which left a huge gap above the pill row.
  static const double kDeckViewportHeight = _cardHeight + 40;

  @override
  Widget build(BuildContext context) {
    const imagePath = <String>[
      'assets/images/dashboard-new.png',
      'assets/images/members-new.png',
      'assets/images/subscriptions-new.png',
      'assets/images/renewals-new.png',
    ];

    // Tight [SizedBox] avoids unbounded layout; no RepaintBoundary (web hit-test).
    return Listener(
      // Opaque: deferToChild walks into swiper’s first-frame placeholder and
      // STACK children that can briefly lack layout during gestures.
      behavior: HitTestBehavior.opaque,
      onPointerDown: (_) => onInteractionStart?.call(),
      onPointerUp: (_) => onInteractionEnd?.call(),
      onPointerCancel: (_) => onInteractionEnd?.call(),
      child: SizedBox(
        width: double.infinity,
        height: kDeckViewportHeight,
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Swiper(
              controller: controller,
              itemWidth: _cardWidth,
              itemHeight: _cardHeight,
              loop: true,
              duration: 1200,
              scrollDirection: Axis.vertical,
              onIndexChanged: onIndexChanged,
              itemBuilder: (context, index) {
                final wPx = _landingRasterDecodePx(context, _cardWidth);
                final hPx = _landingRasterDecodePx(context, _cardHeight);
                return Container(
                  width: _cardWidth,
                  height: _cardHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: ResizeImage(
                        AssetImage(imagePath[index]),
                        width: wPx,
                        height: hPx,
                        allowUpscaling: false,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(_cardRadius),
                  ),
                );
              },
              itemCount: imagePath.length,
              layout: SwiperLayout.STACK,
            ),
          ),
        ),
      ),
    );
  }
}

/// Horizontal stack deck ([SwiperLayout.STACK]). User swipe is disabled: STACK ignores
/// [ScrollPhysics]; we absorb horizontal drags above the CTA strip so pills still drive
/// [SwiperController.move] with the same stack animation.
class _MobilePricingStackSwiper extends StatelessWidget {
  const _MobilePricingStackSwiper({
    required this.controller,
    required this.cardWidth,
    required this.cardHeight,
    required this.cardRadius,
    required this.onIndexChanged,
  });

  /// Leave bottom area for "Contact sales" — must stay outside the drag shield.
  static const double _ctaStripBottomInset = 108;

  final SwiperController controller;
  final double cardWidth;
  final double cardHeight;
  final double cardRadius;
  final ValueChanged<int> onIndexChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: cardWidth,
      height: cardHeight,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(cardRadius),
              clipBehavior: Clip.antiAlias,
              child: Swiper(
                controller: controller,
                physics: const NeverScrollableScrollPhysics(),
                itemWidth: cardWidth,
                itemHeight: cardHeight,
                loop: false,
                duration: 1200,
                curve: Curves.easeOutCubic,
                scrollDirection: Axis.horizontal,
                axisDirection: AxisDirection.left,
                onIndexChanged: onIndexChanged,
                itemBuilder: (context, index) {
                  return _MobilePricingPlanCard(
                    plan: _mobilePricingPlans[index],
                  );
                },
                itemCount: _mobilePricingPlans.length,
                layout: SwiperLayout.STACK,
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: _ctaStripBottomInset,
            child: RawGestureDetector(
              behavior: HitTestBehavior.opaque,
              gestures: <Type, GestureRecognizerFactory>{
                HorizontalDragGestureRecognizer:
                    GestureRecognizerFactoryWithHandlers<
                      HorizontalDragGestureRecognizer
                    >(() => HorizontalDragGestureRecognizer(), (
                      HorizontalDragGestureRecognizer instance,
                    ) {
                      instance
                        ..onStart = (_) {}
                        ..onUpdate = (_) {}
                        ..onEnd = (_) {}
                        ..onCancel = () {};
                    }),
              },
              child: const SizedBox.expand(),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreviewImageCard extends StatelessWidget {
  const _PreviewImageCard({
    super.key,
    required this.imagePath,
    required this.radius,
    required this.borderColor,
  });

  final String imagePath;
  final double radius;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: borderColor),
        boxShadow: const [
          BoxShadow(
            color: Color(0x240F172A),
            blurRadius: 16,
            offset: Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          alignment: Alignment.topCenter,
          gaplessPlayback: true,
          cacheWidth: _landingRasterDecodePx(context, 360),
          filterQuality: FilterQuality.medium,
        ),
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
      constraints: const BoxConstraints(minWidth: 200),
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
            width: 24,
            height: 24,
            colorFilter: const ColorFilter.mode(
              Color(0xFF4F46E5),
              BlendMode.srcIn,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            _mobilePreviewLabel(tab),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF4F46E5),
              fontWeight: FontWeight.w600,
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
      padding: EdgeInsets.fromLTRB(padding + 12, 80, padding + 12, 34),
      child: Column(
        children: [
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 24,
              ),
              children: const [
                TextSpan(text: 'Everything you need to\n'),
                TextSpan(
                  text: 'scale faster',
                  style: TextStyle(color: Color(0xFF4F46E5)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Stop manually tracking spreadsheets. Recrip automates the boring stuff so you can\nfocus on growth.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 32),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: const Color(0xFF4042AC)),
              gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Color(0xFF120635),
                  Color(0xFF1A0D56),
                  Color(0xFF120635),
                ],
              ),
            ),
            child: Column(
              children: [
                for (
                  var index = 0;
                  index < _mobileFeatures.length;
                  index++
                ) ...[
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
        ],
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
  const _MobileStepSection({super.key, required this.padding});

  final double padding;

  /// Reused for stroked subtitle (avoids new [Paint] per frame).
  static final Paint _subtitleStrokePaint = Paint()
    ..style = PaintingStyle.stroke
    ..strokeWidth = 1
    ..color = const Color(0x33FFFFFF);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 80, padding, 34),
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
          LayoutBuilder(
            builder: (context, c) {
              final fz = (((c.maxWidth.clamp(0, 600)) / 380) * 28).clamp(
                17.5,
                28.0,
              );
              return Text(
                'Identify, Support & Retain',
                maxLines: 1,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontSize: fz,
                  fontWeight: FontWeight.w900,
                  foreground: _subtitleStrokePaint,
                ),
              );
            },
          ),
          const SizedBox(height: 49),
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
  static const double _connectorGap = 10;
  static const double _connectorTailHeight = 88;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 72,
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              if (!isLast) const SizedBox(height: _connectorGap),
              if (!isLast)
                Container(
                  width: 1,
                  height: _connectorTailHeight,
                  color: const Color(0x80E2E8F0),
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
  static const double _planCardWidth = 286;
  static const double _planCardHeight = 392;
  static const double _planCardRadius = 30;

  final SwiperController _planSwiperController = SwiperController();
  final ValueNotifier<int> _planIndexNotifier = ValueNotifier<int>(0);

  @override
  void dispose() {
    _planIndexNotifier.dispose();
    _planSwiperController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.transparent,
      padding: EdgeInsets.fromLTRB(widget.padding, 50, widget.padding, 34),
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
          const SizedBox(height: 32),
          ValueListenableBuilder<int>(
            valueListenable: _planIndexNotifier,
            builder: (context, planIdx, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _MobilePlanPill(
                    label: _mobilePricingPlans[0].name,
                    selected: planIdx == 0,
                    onTap: () {
                      if (planIdx == 0) return;
                      _planIndexNotifier.value = 0;
                      unawaited(_planSwiperController.move(0, animation: true));
                    },
                  ),
                  const SizedBox(width: 16),
                  _MobilePlanPill(
                    label: _mobilePricingPlans[1].name,
                    selected: planIdx == 1,
                    onTap: () {
                      if (planIdx == 1) return;
                      _planIndexNotifier.value = 1;
                      unawaited(_planSwiperController.move(1, animation: true));
                    },
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          // Fixed bounds so the Stack / Swiper subtree always has tight geometry.
          Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: _planCardWidth + 16,
              height: _planCardHeight + 12,
              child: Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    top: 10,
                    right: -8,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(_planCardRadius),
                      clipBehavior: Clip.antiAlias,
                      child: Container(
                        width: _planCardWidth,
                        height: _planCardHeight,
                        decoration: BoxDecoration(
                          color: const Color(0xFF1A1F60),
                          borderRadius: BorderRadius.circular(_planCardRadius),
                          border: Border.all(
                            color: const Color(0xFF2F33A8),
                            width: 0.8,
                          ),
                        ),
                      ),
                    ),
                  ),
                  _MobilePricingStackSwiper(
                    controller: _planSwiperController,
                    cardWidth: _planCardWidth,
                    cardHeight: _planCardHeight,
                    cardRadius: _planCardRadius,
                    onIndexChanged: (index) {
                      if (!mounted) return;
                      final i = index % _mobilePricingPlans.length;
                      if (_planIndexNotifier.value != i) {
                        _planIndexNotifier.value = i;
                      }
                    },
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

class _MobilePricingPlanCard extends StatelessWidget {
  const _MobilePricingPlanCard({required this.plan});

  /// Keeps pricing stack and [PageView] clip math in sync.
  static const double _kRadius = _MobileCtaSectionState._planCardRadius;

  final _MobilePricingPlan plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 26),
      decoration: BoxDecoration(
        color: const Color(0xFF08042A),
        borderRadius: BorderRadius.circular(_kRadius),
        border: Border.all(color: const Color(0xFF4F46E5), width: 1),
        // Contained glow (stays inside ClipRRect better than huge spread blurs).
        boxShadow: const [
          BoxShadow(
            color: Color(0x454F46E5),
            blurRadius: 20,
            spreadRadius: -2,
            offset: Offset(0, 10),
          ),
          BoxShadow(
            color: Color(0x284F46E5),
            blurRadius: 12,
            spreadRadius: 0,
            offset: Offset(0, 4),
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
                    style: Get.theme.textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 32,
                    ),
                  ),
                  TextSpan(
                    text: '/month',
                    style: Get.theme.textTheme.titleMedium?.copyWith(
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
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: const Color(0xFF9AA0B8),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),
          ],
          const Spacer(),
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
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
          border: Border.all(color: const Color(0xFF4F46E5)),
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
      padding: EdgeInsets.fromLTRB(padding, 60, padding, 34),
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
      width: 280,
      height: 44,
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
        child: Text(
          'Request Enquiry',
          style: Get.theme.textTheme.bodyMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
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
      padding: EdgeInsets.fromLTRB(padding, 60, padding, 28),
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
          Center(
            child: SizedBox(
              width: double.infinity,
              height: 44,
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
                child: Text(
                  'Send',
                  style: Get.theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
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
      padding: EdgeInsets.fromLTRB(padding, 60, padding, 36),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SizedBox(
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
                        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'Book a Free Trial',
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Get.theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(
                        color: Color(0xFF4F46E5),
                        width: 1,
                      ),
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Text(
                      'Schedule a Demo',
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Get.theme.textTheme.bodySmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
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
          Image.asset(
            AppIcons.recripLogo,
            height: 36,
            fit: BoxFit.contain,
            gaplessPlayback: true,
            cacheHeight: _landingRasterDecodePx(context, 36),
            filterQuality: FilterQuality.medium,
          ),
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
    return Image.asset(
      assetPath,
      width: 28,
      height: 28,
      fit: BoxFit.contain,
      gaplessPlayback: true,
      cacheWidth: _landingRasterDecodePx(context, 28),
      cacheHeight: _landingRasterDecodePx(context, 28),
      filterQuality: FilterQuality.medium,
    );
  }
}

String _mobilePreviewImage(_MobilePreviewTab tab) {
  switch (tab) {
    case _MobilePreviewTab.dashboard:
      return 'assets/images/card_1.png';
    case _MobilePreviewTab.members:
      return 'assets/images/card_2.png';
    case _MobilePreviewTab.subscriptions:
      return 'assets/images/card_3.png';
    case _MobilePreviewTab.renewals:
      return 'assets/images/card_1.png';
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
