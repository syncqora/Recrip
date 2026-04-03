import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';
import 'package:saas/app/screens/landing_page/landing_page_controller.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/constants/app_strings.dart';

class LandingPageTabletView extends StatefulWidget {
  const LandingPageTabletView({super.key});

  static const String heroControllerTag = 'landingPageHero';

  @override
  State<LandingPageTabletView> createState() => _LandingPageTabletViewState();
}

class _LandingPageTabletViewState extends State<LandingPageTabletView> {
  final _featuresKey = GlobalKey();
  final _previewKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();
  _TabletNavTab _activeNavTab = _TabletNavTab.features;
  _TabletPreviewTab _selectedPreviewTab = _TabletPreviewTab.dashboard;

  Future<void> _scrollTo(GlobalKey key) async {
    final context = key.currentContext;
    if (context == null) return;
    await Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
      alignment: 0.06,
    );
  }

  Future<void> _onNavTap(_TabletNavTab tab, GlobalKey key) async {
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
          required _TabletNavTab tab,
          required GlobalKey key,
        }) {
          final selected = _activeNavTab == tab;
          return ListTile(
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
                  tab: _TabletNavTab.features,
                  key: _featuresKey,
                ),
                navTile(
                  label: 'How it works',
                  tab: _TabletNavTab.preview,
                  key: _previewKey,
                ),
                navTile(
                  label: 'Pricing',
                  tab: _TabletNavTab.pricing,
                  key: _pricingKey,
                ),
                navTile(
                  label: 'Contact',
                  tab: _TabletNavTab.contact,
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
    final width = MediaQuery.sizeOf(context).width;
    final padding = width < 900 ? 28.0 : 40.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: Column(
        children: [
          _TabletTopBar(
            padding: padding,
            onMenuTap: _openNavSheet,
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _TabletHeroSection(padding: padding),
                  _TabletFeatureSection(
                    key: _featuresKey,
                    padding: padding,
                  ),
                  _TabletPreviewSection(
                    key: _previewKey,
                    padding: padding,
                    selectedTab: _selectedPreviewTab,
                    onPreviewSelected: (tab) =>
                        setState(() => _selectedPreviewTab = tab),
                  ),
                  _TabletStepSection(padding: padding),
                  _TabletCtaSection(key: _pricingKey, padding: padding),
                  _TabletFaqSection(key: _contactKey, padding: padding),
                  _TabletFooterSection(padding: padding),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum _TabletNavTab { features, preview, pricing, contact }

enum _TabletPreviewTab { dashboard, members, subscriptions, renewals }

class _TabletTopBar extends StatelessWidget {
  const _TabletTopBar({required this.padding, required this.onMenuTap});

  final double padding;
  final VoidCallback onMenuTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 18, padding, 14),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE7EBF3))),
      ),
      child: Row(
        children: [
          Image.asset(AppIcons.recripLogo, height: 34, fit: BoxFit.contain),
          const Spacer(),
          FilledButton(
            onPressed: () => appNav.changePage(AppRoutes.login),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF5C5BFF),
              foregroundColor: Colors.white,
              minimumSize: const Size(132, 46),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            child: const Text(
              'Get Started',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onMenuTap,
            icon: const Icon(Icons.menu_rounded),
            color: const Color(0xFF334155),
          ),
        ],
      ),
    );
  }
}

class _TabletHeroSection extends StatelessWidget {
  const _TabletHeroSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.headlineMedium?.copyWith(
      fontSize: 52,
      fontWeight: FontWeight.w900,
      color: const Color(0xFF0F172A),
      height: 1.04,
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
            top: 406,
            right: -80,
            child: Container(
              width: 750,
              height: 320,
              decoration: const BoxDecoration(
                color: Color(0xFF111C3B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(120),
                  bottomLeft: Radius.circular(120),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, 34, padding, 56),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Never Lose Revenue\nfrom ',
                        style: titleStyle,
                      ),
                      TextSpan(
                        text: 'Expired\nSubscriptions',
                        style: titleStyle?.copyWith(
                          color: const Color(0xFF4F46E5),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 700),
                  child: Text(
                    'Recrip helps businesses automate renewals, track customers, and recover missed payments all from one powerful dashboard.',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF475569),
                      height: 1.55,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Row(
                  children: [
                    FilledButton(
                      onPressed: () => appNav.changePage(AppRoutes.login),
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF5C5BFF),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(160, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Start Free Trial',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 14),
                    OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF334155),
                        side: const BorderSide(color: Color(0xFFD6DAF4)),
                        minimumSize: const Size(144, 52),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'See Overview',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 34),
                const _TabletHeroLoginCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletHeroLoginCard extends StatelessWidget {
  const _TabletHeroLoginCard();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LandingPageController>(
      tag: LandingPageTabletView.heroControllerTag,
    );

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 520),
        child: AuthFormCard(
          compact: true,
          showLogo: false,
          title: '',
          cornerRadius: 40,
          cardColor: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x240F172A),
              offset: Offset(0, 18),
              blurRadius: 32,
            ),
          ],
          customHeader: Column(
            children: [
              Text(
                'Already with Us?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Login',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF5C5BFF),
                ),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: AppStrings.userNameLabel,
                child: Obx(
                  () => AuthTextField(
                    controller: controller.emailController,
                    focusNode: controller.emailFocusNode,
                    hint: AppStrings.enterUsernameHint,
                    isHovered: controller.isUsernameHovered.value,
                    errorText: controller.emailError.value,
                    keyboardType: TextInputType.emailAddress,
                    autocorrect: false,
                    textInputAction: TextInputAction.next,
                    onSubmitted: (_) =>
                        controller.passwordFocusNode.requestFocus(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              AuthFormFieldSection(
                label: AppStrings.passwordLabel,
                child: Obx(
                  () => AuthPasswordField(
                    controller: controller.passwordController,
                    focusNode: controller.passwordFocusNode,
                    obscureText: !controller.isPasswordVisible.value,
                    onToggleVisibility: controller.togglePasswordVisibility,
                    hint: AppStrings.enterPasswordHint,
                    isHovered: controller.isPasswordHovered.value,
                    errorText: controller.passwordError.value,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => controller.onLogin(),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: controller.onForgotPassword,
                  child: Text(
                    AppStrings.forgotPasswordTitle,
                    style: Get.theme.textTheme.labelMedium?.copyWith(
                      color: const Color(0xFF64748B),
                      decoration: TextDecoration.underline,
                      decorationColor: const Color(0xFF64748B),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Obx(
                () => AuthPrimaryButton(
                  text: AppStrings.loginTitle,
                  onPressed: controller.onLogin,
                  isEnabled: controller.isFormValid.value,
                  isLoading: controller.isSubmitting.value,
                  enabledBackgroundColor: const Color(0xFFC8CEFF),
                ),
              ),
            ],
          ),
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
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F4FF),
      padding: EdgeInsets.fromLTRB(padding, 48, padding, 54),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Everything you need to\n',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                    height: 1.12,
                  ),
                ),
                TextSpan(
                  text: 'scale faster',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 36,
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
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          LayoutBuilder(
            builder: (context, constraints) {
              final cardWidth = (constraints.maxWidth - 18) / 2;
              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: _tabletFeatures
                    .map(
                      (feature) => SizedBox(
                        width: cardWidth.clamp(280.0, 420.0).toDouble(),
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

  final _TabletFeature feature;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 232),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
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
            width: 62,
            height: 62,
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
              width: 28,
              height: 28,
              colorFilter: const ColorFilter.mode(
                Colors.white,
                BlendMode.srcIn,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            feature.title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 10),
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

class _TabletPreviewSection extends StatelessWidget {
  const _TabletPreviewSection({
    super.key,
    required this.padding,
    required this.selectedTab,
    required this.onPreviewSelected,
  });

  final double padding;
  final _TabletPreviewTab selectedTab;
  final ValueChanged<_TabletPreviewTab> onPreviewSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 28, padding, 54),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Built for ',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                TextSpan(
                  text: 'Modern Teams',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Explore the key workflows your team uses every day, optimized for renewals, customer management, and fast follow-ups.',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 22),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _TabletPreviewTab.values.map((tab) {
                final selected = selectedTab == tab;
                return Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: InkWell(
                    onTap: () => onPreviewSelected(tab),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: selected
                              ? const Color(0xFF4F46E5)
                              : const Color(0xFFCBD5E1),
                        ),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            _previewIconFor(tab),
                            width: 18,
                            height: 18,
                            colorFilter: ColorFilter.mode(
                              selected ? Colors.white : const Color(0xFF64748B),
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _previewLabelFor(tab),
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: selected
                                  ? Colors.white
                                  : const Color(0xFF334155),
                              fontWeight: FontWeight.w700,
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
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4FF),
              borderRadius: BorderRadius.circular(28),
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x190F172A),
                    blurRadius: 28,
                    offset: Offset(0, 14),
                  ),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 1.28,
                child: Image.asset(
                  _previewImageFor(selectedTab),
                  fit: BoxFit.cover,
                  alignment: Alignment.topLeft,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabletStepSection extends StatelessWidget {
  const _TabletStepSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F4FF),
      padding: EdgeInsets.fromLTRB(padding, 34, padding, 56),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'Get started in ',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                TextSpan(
                  text: 'three simple steps',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 36,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFF4F46E5),
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Text(
            'Move from manual follow-ups to an automated renewal engine without changing how your team already works.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 28),
          for (var i = 0; i < _tabletSteps.length; i++) ...[
            _TabletStepCard(index: i + 1, step: _tabletSteps[i]),
            if (i != _tabletSteps.length - 1) const SizedBox(height: 16),
          ],
        ],
      ),
    );
  }
}

class _TabletStepCard extends StatelessWidget {
  const _TabletStepCard({required this.index, required this.step});

  final int index;
  final _TabletStep step;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: const BoxDecoration(
              color: Color(0xFF4F46E5),
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
            alignment: Alignment.center,
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          const SizedBox(width: 16),
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
                const SizedBox(height: 10),
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
          const SizedBox(width: 12),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              step.iconAsset,
              width: 22,
              height: 22,
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

class _TabletCtaSection extends StatelessWidget {
  const _TabletCtaSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFF101934),
      child: Padding(
        padding: EdgeInsets.fromLTRB(padding, 52, padding, 52),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Start Automating\n',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                      height: 0.98,
                    ),
                  ),
                  TextSpan(
                    text: 'Your Renewals Today',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
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
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: const Color(0xFFCBD5E1),
                fontWeight: FontWeight.w500,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 24),
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
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4F46E5),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: SvgPicture.asset(
                        AppIcons.circleCheck,
                        width: 16,
                        height: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      item,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: const Color(0xFFE2E8F0),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 28),
            const _TabletLeadCard(),
          ],
        ),
      ),
    );
  }
}

class _TabletLeadCard extends StatelessWidget {
  const _TabletLeadCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: const Color(0xFF16224A),
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: const Color(0xFFCBD5E1)),
      ),
      child: Column(
        children: const [
          Row(
            children: [
              Expanded(child: _TabletDarkField('Full Name')),
              SizedBox(width: 14),
              Expanded(child: _TabletDarkField('Business Name')),
            ],
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _TabletDarkField('Email Address')),
              SizedBox(width: 14),
              Expanded(child: _TabletDarkField('Phone Number')),
            ],
          ),
          SizedBox(height: 24),
          _TabletEnquiryButton(),
          SizedBox(height: 24),
          _TabletLeadCopy(),
        ],
      ),
    );
  }
}

class _TabletDarkField extends StatelessWidget {
  const _TabletDarkField(this.label);

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

class _TabletEnquiryButton extends StatelessWidget {
  const _TabletEnquiryButton();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        onPressed: () {},
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF5C5BFF),
          foregroundColor: Colors.white,
          minimumSize: const Size.fromHeight(50),
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

class _TabletLeadCopy extends StatelessWidget {
  const _TabletLeadCopy();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Request a demo and we will get back to you. Thank you!',
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: const Color(0xFFCBD5E1),
        height: 1.3,
      ),
    );
  }
}

class _TabletFaqSection extends StatelessWidget {
  const _TabletFaqSection({super.key, required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(padding, 48, padding, 32),
      child: Column(
        children: [
          Text(
            'Frequently Asked Questions',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 36,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 28),
          for (final faq in _tabletFaqs) ...[
            _TabletExpandableFaqCard(faq: faq),
            const SizedBox(height: 12),
          ],
          const SizedBox(height: 20),
          const _TabletQuestionCard(),
        ],
      ),
    );
  }
}

class _TabletQuestionCard extends StatelessWidget {
  const _TabletQuestionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
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
          const SizedBox(height: 28),
          const _TabletInputField(hint: 'Email Address', minHeight: 48),
          const SizedBox(height: 18),
          const _TabletInputField(
            hint: 'Type your message here....',
            minHeight: 155,
            maxLines: null,
            expands: true,
          ),
          const SizedBox(height: 24),
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

class _TabletInputField extends StatelessWidget {
  const _TabletInputField({
    required this.hint,
    required this.minHeight,
    this.maxLines = 1,
    this.expands = false,
  });

  final String hint;
  final double minHeight;
  final int? maxLines;
  final bool expands;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: minHeight,
      child: TextField(
        maxLines: expands ? null : maxLines,
        minLines: expands ? null : 1,
        expands: expands,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF9CA3AF),
          ),
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

class _TabletExpandableFaqCard extends StatefulWidget {
  const _TabletExpandableFaqCard({required this.faq});

  final _TabletFaq faq;

  @override
  State<_TabletExpandableFaqCard> createState() =>
      _TabletExpandableFaqCardState();
}

class _TabletExpandableFaqCardState extends State<_TabletExpandableFaqCard> {
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
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.faq.question,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
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
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 18),
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

class _TabletFooterSection extends StatelessWidget {
  const _TabletFooterSection({required this.padding});

  final double padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFF5F4FF),
      padding: EdgeInsets.fromLTRB(padding, 28, padding, 36),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(AppIcons.recripLogo, height: 36, fit: BoxFit.contain),
          const SizedBox(height: 10),
          Text(
            'Most powerful subscription renewal management platform. Built for business that want to scale without losing revenue.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF64748B),
              fontWeight: FontWeight.w600,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFCBD5E1), thickness: 1),
          const SizedBox(height: 20),
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

String _previewImageFor(_TabletPreviewTab tab) {
  switch (tab) {
    case _TabletPreviewTab.dashboard:
      return 'assets/images/Dashboard.png';
    case _TabletPreviewTab.members:
      return 'assets/images/Members.png';
    case _TabletPreviewTab.subscriptions:
      return 'assets/images/Members.png';
    case _TabletPreviewTab.renewals:
      return 'assets/images/Renewals.png';
  }
}

String _previewIconFor(_TabletPreviewTab tab) {
  switch (tab) {
    case _TabletPreviewTab.dashboard:
      return AppIcons.dashboard;
    case _TabletPreviewTab.members:
      return AppIcons.usersRound;
    case _TabletPreviewTab.subscriptions:
      return AppIcons.calendarDays;
    case _TabletPreviewTab.renewals:
      return AppIcons.calendarSync;
  }
}

String _previewLabelFor(_TabletPreviewTab tab) {
  switch (tab) {
    case _TabletPreviewTab.dashboard:
      return 'Dashboard';
    case _TabletPreviewTab.members:
      return 'Members';
    case _TabletPreviewTab.subscriptions:
      return 'Subscriptions';
    case _TabletPreviewTab.renewals:
      return 'Renewals';
  }
}

const _tabletFeatures = [
  _TabletFeature(
    'Smart Renewal Alerts',
    'Automatically remind customers via WhatsApp, SMS, and email before they expire.',
    AppIcons.bell,
    Color(0xFF2B7FFF),
  ),
  _TabletFeature(
    'Payment Recovery',
    'Recover missed payments and reduce churn effortlessly with automated retries.',
    AppIcons.creditCard,
    Color(0xFF5FC7FF),
  ),
  _TabletFeature(
    'Analytics Dashboard',
    'Track revenue, renewals, and customer behavior with deep visual insights.',
    AppIcons.chartPie,
    Color(0xFF8E51FF),
  ),
  _TabletFeature(
    'Customer Management',
    'All your subscription data in one place. Search, filter, and manage with ease.',
    AppIcons.usersRound,
    Color(0xFFE12AFB),
  ),
  _TabletFeature(
    'Auto Renewals',
    'Set it once and let Recrip handle the rest. Seamless recurring billing.',
    AppIcons.renew,
    Color(0xFF00BC7D),
  ),
  _TabletFeature(
    'Business Insights',
    'Track revenue, renewals, and customer behavior with deep visual insights.',
    AppIcons.globe,
    Color(0xFFFE9A00),
  ),
];

const _tabletSteps = [
  _TabletStep(
    'Add your customers',
    'Import your existing customer list or sync with your current CRM in seconds.',
    AppIcons.addCustomer,
  ),
  _TabletStep(
    'Set renewal schedules',
    'Define when and how you want to notify customers about their upcoming renewals.',
    AppIcons.clock,
  ),
  _TabletStep(
    'Automate and track revenue',
    'Sit back while Recrip handles the follow-ups and gives your team real-time growth visibility.',
    AppIcons.trendingUp,
  ),
];

const _tabletFaqs = [
  _TabletFaq(
    'Can I customize the notification messages?',
    'Absolutely! You can fully customize the content, timing, and channel for every notification sent.',
  ),
  _TabletFaq(
    'Is my customer data secure?',
    'Yes, we use bank-grade encryption and are fully GDPR and SOC2 compliant. Your data is isolated and protected at all times.',
  ),
  _TabletFaq(
    'What businesses is Recrip best for?',
    'Recrip is designed for any business with recurring subscriptions, including gyms, salons, clinics, SaaS, and service providers.',
  ),
];

class _TabletFeature {
  const _TabletFeature(
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

class _TabletStep {
  const _TabletStep(this.title, this.description, this.iconAsset);

  final String title;
  final String description;
  final String iconAsset;
}

class _TabletFaq {
  const _TabletFaq(this.question, this.answer);

  final String question;
  final String answer;
}
