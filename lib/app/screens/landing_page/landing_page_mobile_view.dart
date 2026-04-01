import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';
import 'package:saas/app/screens/landing_page/landing_page_controller.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/constants/app_strings.dart';

class LandingPageMobileView extends StatefulWidget {
  const LandingPageMobileView({super.key});

  static const String heroControllerTag = 'landingPageHero';

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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFE7EBF3))),
      ),
      child: Row(
        children: [
          Expanded(
            child: Image.asset(
              AppIcons.recripLogo,
              height: 30,
              fit: BoxFit.contain,
              alignment: Alignment.centerLeft,
            ),
          ),
          FilledButton(
            onPressed: () => appNav.changePage(AppRoutes.login),
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF5C5BFF),
              foregroundColor: Colors.white,
              minimumSize: const Size(104, 40),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Start',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(width: 6),
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
            top: 42,
            right: -90,
            child: Container(
              width: 250,
              height: 160,
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
                Row(
                  children: const [
                    _HeroMetric(label: '14-day trial'),
                    SizedBox(width: 10),
                    _HeroMetric(label: 'No setup fee'),
                  ],
                ),
                const SizedBox(height: 24),
                const _MobileHeroLoginCard(),
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

class _MobileHeroLoginCard extends StatelessWidget {
  const _MobileHeroLoginCard();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LandingPageController>(
      tag: LandingPageMobileView.heroControllerTag,
    );

    return AuthFormCard(
      compact: true,
      showLogo: false,
      title: '',
      cornerRadius: 28,
      cardColor: Colors.white,
      boxShadow: const [
        BoxShadow(
          color: Color(0x190F172A),
          offset: Offset(0, 14),
          blurRadius: 28,
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
          const SizedBox(height: 4),
          Text(
            'Login',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
          const SizedBox(height: 18),
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
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: const Color(0xFF64748B),
                  decoration: TextDecoration.underline,
                  decorationColor: const Color(0xFF64748B),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
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
    );
  }
}

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
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _MobilePreviewTab.values.length,
              separatorBuilder: (_, _) => const SizedBox(width: 10),
              itemBuilder: (context, index) {
                final tab = _MobilePreviewTab.values[index];
                final selected = tab == selectedTab;
                return InkWell(
                  onTap: () => onPreviewSelected(tab),
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? const Color(0xFF4F46E5)
                          : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: selected
                            ? const Color(0xFF4F46E5)
                            : const Color(0xFFCBD5E1),
                      ),
                    ),
                    child: Row(
                      children: [
                        SvgPicture.asset(
                          _mobilePreviewIcon(tab),
                          width: 16,
                          height: 16,
                          colorFilter: ColorFilter.mode(
                            selected ? Colors.white : const Color(0xFF64748B),
                            BlendMode.srcIn,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _mobilePreviewLabel(tab),
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: selected
                                ? Colors.white
                                : const Color(0xFF334155),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 18),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF5F4FF),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x140F172A),
                    blurRadius: 22,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: AspectRatio(
                aspectRatio: 0.95,
                child: Image.asset(
                  _mobilePreviewImage(selectedTab),
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
      return 'assets/images/Dashboard.png';
    case _MobilePreviewTab.members:
      return 'assets/images/Members.png';
    case _MobilePreviewTab.subscriptions:
      return 'assets/images/Members.png';
    case _MobilePreviewTab.renewals:
      return 'assets/images/Renewals.png';
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
  const _MobileFeature(this.title, this.description, this.iconAsset, this.color);

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
