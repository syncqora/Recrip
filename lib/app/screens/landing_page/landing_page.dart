import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/widgets/auth_widgets.dart';
import 'package:saas/app/screens/landing_page/landing_page_controller.dart';
import 'package:saas/core/di/get_injector.dart';
import 'package:saas/routes/app_pages.dart';
import 'package:saas/shared/constants/app_icons.dart';
import 'package:saas/shared/constants/app_strings.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  /// GetX tag for [LandingPageController] (hero login only).
  static const String heroControllerTag = 'landingPageHero';

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _featuresKey = GlobalKey();
  final _stepsKey = GlobalKey();
  final _pricingKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    if (!Get.isRegistered<LandingPageController>(
      tag: LandingPage.heroControllerTag,
    )) {
      Get.put(
        LandingPageController(),
        tag: LandingPage.heroControllerTag,
        permanent: false,
      );
    }
  }

  @override
  void dispose() {
    if (Get.isRegistered<LandingPageController>(
      tag: LandingPage.heroControllerTag,
    )) {
      Get.delete<LandingPageController>(tag: LandingPage.heroControllerTag);
    }
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

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final mobile = width < 760;
    final pad = width < 600
        ? 20.0
        : width < 1100
        ? 40.0
        : 72.0;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FF),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _HeroSection(
              padding: pad,
              mobile: mobile,
              onFeatures: () => _scrollTo(_featuresKey),
              onSteps: () => _scrollTo(_stepsKey),
              onPricing: () => _scrollTo(_pricingKey),
              onContact: () => _scrollTo(_contactKey),
            ),
            _FeatureSection(key: _featuresKey, padding: pad, mobile: mobile),
            _TeamSection(padding: pad, mobile: mobile),
            _StepSection(key: _stepsKey, padding: pad, mobile: mobile),
            _CtaSection(key: _pricingKey, padding: pad),
            _FaqSection(key: _contactKey, padding: pad, mobile: mobile),
          ],
        ),
      ),
    );
  }
}

class _HeroSection extends StatelessWidget {
  const _HeroSection({
    required this.padding,
    required this.mobile,
    required this.onFeatures,
    required this.onSteps,
    required this.onPricing,
    required this.onContact,
  });

  final double padding;
  final bool mobile;
  final VoidCallback onFeatures;
  final VoidCallback onSteps;
  final VoidCallback onPricing;
  final VoidCallback onContact;

  @override
  Widget build(BuildContext context) {
    final line1Size = mobile ? 34.0 : 50.0;
    final line2Size = mobile ? 40.0 : 64.0;

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
            top: 118,
            right: mobile ? -70 : 0,
            child: Container(
              width: mobile ? 260 : 1000,
              height: mobile ? 320 : 323,
              decoration: const BoxDecoration(
                color: Color(0xFF111C3B),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(176),
                  bottomLeft: Radius.circular(176),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(padding, 26, padding, 54),
            child: Column(
              children: [
                _TopNav(
                  compact: mobile,
                  onFeatures: onFeatures,
                  onSteps: onSteps,
                  onPricing: onPricing,
                  onContact: onContact,
                ),
                const SizedBox(height: 34),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final stacked = constraints.maxWidth < 980;
                    Widget leftChild = Padding(
                      padding: EdgeInsets.only(
                        right: stacked ? 0 : 32,
                        bottom: stacked ? 24 : 0,
                      ),
                      child: Column(
                        crossAxisAlignment: stacked
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Never Lose Revenue from',
                            textAlign: stacked
                                ? TextAlign.center
                                : TextAlign.left,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontSize: line1Size,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF111827),
                                  height: 1.08,
                                ),
                          ),
                          SizedBox(height: mobile ? 6 : 10),
                          Text(
                            'Expired Subscriptions',
                            textAlign: stacked
                                ? TextAlign.center
                                : TextAlign.left,
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  fontSize: line2Size,
                                  fontWeight: FontWeight.w900,
                                  color: const Color(0xFF5C5BFF),
                                  height: 1.05,
                                ),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            'Recrip helps businesses automate renewals, track customers, and recover missed payments — all from one powerful dashboard.',
                            textAlign: stacked
                                ? TextAlign.center
                                : TextAlign.left,
                            style: Get.theme.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF475569),
                            ),
                          ),
                        ],
                      ),
                    );
                    Widget rightChild = const Center(
                      child: _LandingHeroLoginCard(),
                    );
                    return Flex(
                      direction: stacked ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        if (stacked)
                          leftChild
                        else
                          Expanded(flex: 4, child: leftChild),
                        if (stacked)
                          rightChild
                        else
                          Expanded(flex: 8, child: rightChild),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TopNav extends StatelessWidget {
  const _TopNav({
    required this.compact,
    required this.onFeatures,
    required this.onSteps,
    required this.onPricing,
    required this.onContact,
  });

  final bool compact;
  final VoidCallback onFeatures;
  final VoidCallback onSteps;
  final VoidCallback onPricing;
  final VoidCallback onContact;

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
                  onFeatures();
                },
              ),
              ListTile(
                title: const Text('How it works'),
                onTap: () {
                  Navigator.pop(ctx);
                  onSteps();
                },
              ),
              ListTile(
                title: const Text('Pricing'),
                onTap: () {
                  Navigator.pop(ctx);
                  onPricing();
                },
              ),
              ListTile(
                title: const Text('Contact'),
                onTap: () {
                  Navigator.pop(ctx);
                  onContact();
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
    Widget link(String text, VoidCallback onTap) {
      return TextButton(
        onPressed: onTap,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF4B5563),
            fontWeight: FontWeight.w600,
            fontSize: 14,
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

    if (compact) {
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
              link('Features', onFeatures),
              const SizedBox(width: 36),
              link('How it works', onSteps),
              const SizedBox(width: 36),
              link('Pricing', onPricing),
              const SizedBox(width: 36),
              link('Contact', onContact),
            ],
          ),
        ),
        cta,
      ],
    );
  }
}

/// Hero login panel: same fields and actions as [Login] desktop form, compact [AuthFormCard].
class _LandingHeroLoginCard extends StatelessWidget {
  const _LandingHeroLoginCard();

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LandingPageController>(
      tag: LandingPage.heroControllerTag,
    );
    final narrow = MediaQuery.sizeOf(context).width < 760;

    return Align(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: narrow ? 340 : 400),
        child: AuthFormCard(
          compact: true,
          showLogo: false,
          title: '',
          cornerRadius: 50,
          cardColor: Colors.white,
          boxShadow: const [
            BoxShadow(
              color: Color(0x180F172A),
              offset: Offset(0, 12),
              blurRadius: 32,
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AuthFormFieldSection(
                label: AppStrings.userNameLabel,
                child: MouseRegion(
                  onEnter: (_) => controller.setUsernameHovered(true),
                  onExit: (_) => controller.setUsernameHovered(false),
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
              ),
              SizedBox(height: narrow ? 20 : AppConstants.spacingBetweenFields),
              AuthFormFieldSection(
                label: AppStrings.passwordLabel,
                child: MouseRegion(
                  onEnter: (_) => controller.setPasswordHovered(true),
                  onExit: (_) => controller.setPasswordHovered(false),
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
              ),
              const SizedBox(height: AppConstants.spacingAfterLabel),
              Align(
                alignment: Alignment.centerRight,
                child: MouseRegion(
                  onEnter: (_) => controller.setForgotPasswordHovered(true),
                  onExit: (_) => controller.setForgotPasswordHovered(false),
                  child: Obx(() {
                    final hovered = controller.isForgotPasswordHovered.value;
                    final color = hovered
                        ? AppConstants.titleColor
                        : AppConstants.hintColor;
                    return TextButton(
                      onPressed: controller.onForgotPassword,
                      child: Text(
                        AppStrings.forgotPasswordTitle,
                        style: Get.theme.textTheme.labelMedium!.copyWith(
                          color: color,
                          fontWeight: hovered ? FontWeight.w400 : null,
                          decoration: TextDecoration.underline,
                          decorationColor: color,
                          decorationThickness: 1.2,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              SizedBox(height: narrow ? 20 : AppConstants.spacingAfterLogo),
              Obx(
                () => AuthPrimaryButton(
                  text: AppStrings.loginTitle,
                  onPressed: controller.onLogin,
                  isEnabled: controller.isFormValid.value,
                  isLoading: controller.isSubmitting.value,
                  enabledBackgroundColor: const Color(0xFFC8CEFF),
                ),
              ),
              const SizedBox(height: 28),
              AuthSupportFooter(onReachOut: controller.onReachOutTap),
            ],
          ),
        ),
      ),
    );
  }
}

class _MockField extends StatelessWidget {
  const _MockField({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF6B7280),
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 6),
        Container(
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFF),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFD6DAF4)),
          ),
        ),
      ],
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
      color: const Color(0xFFF5F7FF),
      padding: EdgeInsets.fromLTRB(padding, 42, padding, 48),
      child: Column(
        children: [
          Text(
            'Everything you need to\nscale faster',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: mobile ? 28 : 36,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF111827),
              height: 1.15,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Stop manually tracking renewals. Recrip automates the boring stuff so you can focus on growth.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontSize: 15,
              color: const Color(0xFF6B7280),
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
              final width = (constraints.maxWidth - (18 * (count - 1))) / count;
              return Wrap(
                spacing: 18,
                runSpacing: 18,
                children: features
                    .map(
                      (feature) =>
                          SizedBox(width: width, child: _FeatureCard(feature)),
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
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
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
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: feature.color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(feature.icon, size: 20, color: Colors.white),
          ),
          const SizedBox(height: 14),
          Text(
            feature.title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            feature.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _TeamSection extends StatelessWidget {
  const _TeamSection({required this.padding, required this.mobile});

  final double padding;
  final bool mobile;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(padding, 22, padding, 46),
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
                              fontSize: mobile ? 30 : 40,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF111827),
                              height: 1.12,
                            ),
                    children: const [
                      TextSpan(text: 'Built for '),
                      TextSpan(
                        text: 'Modern Teams',
                        style: TextStyle(color: Color(0xFF5C5BFF)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Container(
                  width: stacked ? double.infinity : 260,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF0F2FF),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFE2E6F5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: const [
                      _SideNavItem(label: 'Dashboard', selected: true),
                      _SideNavItem(label: 'Members', selected: false),
                      _SideNavItem(label: 'Subscriptions', selected: false),
                      _SideNavItem(
                        label: 'Renewals',
                        selected: false,
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
          const rightChild = _DashboardMock();
          return Flex(
            direction: stacked ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (stacked) leftChild else Expanded(flex: 4, child: leftChild),
              if (stacked)
                const Padding(
                  padding: EdgeInsets.only(top: 12),
                  child: rightChild,
                )
              else
                const Expanded(flex: 7, child: rightChild),
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
    required this.selected,
    this.isLast = false,
  });

  final String label;
  final bool selected;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: isLast ? 0 : 4),
      child: Material(
        color: selected ? Colors.white : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Icon(
                Icons.circle,
                size: 8,
                color: selected
                    ? const Color(0xFF5C5BFF)
                    : const Color(0xFFD1D5DB),
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected
                      ? const Color(0xFF5C5BFF)
                      : const Color(0xFF6B7280),
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashboardMock extends StatelessWidget {
  const _DashboardMock();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1835),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          children: [
            Row(
              children: const [
                Expanded(
                  child: _StatChip('Revenue', '+18%', Color(0xFFDCFCE7)),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: _StatChip('Renewals', '124', Color(0xFFE0E7FF)),
                ),
                SizedBox(width: 12),
                Expanded(child: _StatChip('Alerts', '8', Color(0xFFFDE68A))),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFFE6EAF6)),
              ),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: List.generate(
                          6,
                          (index) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                _line(70, const Color(0xFFD7DDFF)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: _line(
                                    double.infinity,
                                    index.isEven
                                        ? const Color(0xFFE5E7EB)
                                        : const Color(0xFFEEF2FF),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 92,
                          height: 92,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: SweepGradient(
                              colors: [
                                Color(0xFF5C5BFF),
                                Color(0xFFB4BDFF),
                                Color(0xFFE5E7EB),
                                Color(0xFF5C5BFF),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Container(
                              width: 52,
                              height: 52,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        _line(88, const Color(0xFFD7DDFF)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _line(double width, Color color) {
    return Container(
      width: width,
      height: 10,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(99),
      ),
    );
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
      padding: EdgeInsets.fromLTRB(padding, 30, padding, 58),
      child: Column(
        children: [
          Text(
            'Get started in 3 simple steps',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: mobile ? 28 : 34,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF5C5BFF),
            ),
          ),
          const SizedBox(height: 28),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: steps
                .map((step) => SizedBox(width: 280, child: _StepCard(step)))
                .toList(),
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
    return Padding(
      padding: const EdgeInsets.all(6),
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: Color(0xFF5C5BFF),
              shape: BoxShape.circle,
            ),
            child: Icon(step.icon, color: Colors.white, size: 24),
          ),
          const SizedBox(height: 14),
          Text(
            step.title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF111827),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            step.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
        ],
      ),
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
                      Text(
                        'Start Automating\nYour Renewals Today',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              fontSize: stacked ? 28 : 38,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              height: 1.05,
                            ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Hundreds of businesses use this to recover lost payments and stay on top of subscription health.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFFB8C1E0),
                          height: 1.6,
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
                              const Icon(
                                Icons.check_circle,
                                size: 18,
                                color: Color(0xFF6C7BFF),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                item,
                                style: const TextStyle(
                                  color: Color(0xFFDCE3FF),
                                  fontWeight: FontWeight.w600,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF16224A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF2A3C73)),
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
          const SizedBox(height: 14),
          const Row(
            children: [
              Expanded(child: _DarkField('Email Address')),
              SizedBox(width: 14),
              Expanded(child: _DarkField('Phone Number')),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 15),
            decoration: BoxDecoration(
              color: const Color(0xFF5C5BFF),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              'Request enquiry',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Request a demo and we will get back to you. Thank you!',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF8FA1D2),
              height: 1.5,
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
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontSize: mobile ? 28 : 34,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF111827),
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
              const Divider(color: Color(0xFFD8DDEF)),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      AppIcons.recripLogo,
                      height: 36,
                      fit: BoxFit.contain,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Most powerful subscription renewal management platform — built for businesses that hate leaking revenue.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '© 2026 Recrip. All rights reserved.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF9CA3AF),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6EAF6)),
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
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: const Color(0xFF111827),
                        fontWeight: FontWeight.w800,
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
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF6B7280),
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
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6EAF6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Got anything to ask us?',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF5C5BFF),
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
          const _MockField(label: 'Email Address'),
          const SizedBox(height: 14),
          Text(
            'Message',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            height: 120,
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFF),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFDCE3F3)),
            ),
            alignment: Alignment.topLeft,
            child: Text(
              'Type your message here...',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: const Color(0xFF9CA3AF)),
            ),
          ),
          const SizedBox(height: 16),
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
    'Get reminded before plans expire.',
    Icons.notifications_active_rounded,
    Color(0xFF7293FF),
  ),
  _Feature(
    'Payment Recovery',
    'Spot overdue renewals and follow up fast.',
    Icons.payments_rounded,
    Color(0xFF7CC7FF),
  ),
  _Feature(
    'Analytics Dashboard',
    'Track trends, losses, and recovered revenue.',
    Icons.analytics_rounded,
    Color(0xFF9D7CFF),
  ),
  _Feature(
    'Customer Management',
    'Keep plans and member records organized.',
    Icons.people_alt_rounded,
    Color(0xFFE873FF),
  ),
  _Feature(
    'Auto Renewals',
    'Reduce manual work with scheduled reminders.',
    Icons.autorenew_rounded,
    Color(0xFF26C281),
  ),
  _Feature(
    'Business Insights',
    'Turn renewal data into actions your team can take.',
    Icons.bar_chart_rounded,
    Color(0xFFFFB547),
  ),
];

const steps = [
  _Step(
    'Add your customers',
    'Import your existing members and their plans in minutes.',
    Icons.person_add_alt_1_rounded,
  ),
  _Step(
    'Set renewal schedules',
    'Define when your team should follow up before expiries.',
    Icons.calendar_month_rounded,
  ),
  _Step(
    'Automate & track revenue',
    'Recover more income with reminders and insights.',
    Icons.sync_alt_rounded,
  ),
];

const faqs = [
  _Faq(
    'Can I customize the notification messages?',
    'Yes. Teams can tailor reminder content so follow-ups feel aligned with their business tone.',
  ),
  _Faq(
    'Is my customer data secure?',
    'The platform is designed around business account workflows, clear access control, and protected records.',
  ),
  _Faq(
    'What businesses is Recrip best for?',
    'It works well for gyms, agencies, service teams, and any business built on recurring renewals.',
  ),
];

class _Feature {
  const _Feature(this.title, this.description, this.icon, this.color);
  final String title;
  final String description;
  final IconData icon;
  final Color color;
}

class _Step {
  const _Step(this.title, this.description, this.icon);
  final String title;
  final String description;
  final IconData icon;
}

class _Faq {
  const _Faq(this.question, this.answer);
  final String question;
  final String answer;
}
