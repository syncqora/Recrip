import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../core/controllers/app_settings_controller.dart';
import '../routes/app_pages.dart';
import '../shared/constants/app.dart';
import 'navigation_rule.dart';

mixin NavigationMixin on GetxService {
  final basePageStack = <String>[].obs;
  final RxString currentPage = AppRoutes.home.obs;

  final pageStack = <String>[AppRoutes.home].obs;

  final args = <dynamic>[null].obs;

  Function(String, Widget, dynamic)?
  onPageChangeCallback; // Callback for page changes

  dynamic appArgs;

  DateTime lastBackPressTime = DateTime.now();

  RxString appBarTitle = PageTitles.home.obs;

  String lastVisitedPageBeforeLogin = AppRoutes.home;

  final AppSettingsController appSettings = Get.find<AppSettingsController>();

  final List<NavigationRule> navigationRules = [
    NavigationRule(
      page: AppRoutes.login,
      condition: () =>
          /// modify this condition based on your app's logic
          false,
      //!Get.find<AppSettingsController>().isUserLoggedIn.value,
      redirectPage: AppRoutes.login,
      arguments: {RouteArgumentKeys.isLogin: true},
    ),
    // Add more rules as needed.
  ];

  /// Sets the callback function for page changes and app bar title updates.
  void setNavigationCallback(Function(String, Widget, dynamic) onPageChange) {
    onPageChangeCallback = onPageChange;
  }

  /// Checks if there are pages in the stack to pop.
  bool canPop() => pageStack.length > 1;

  /// Returns the arguments for the current page.
  dynamic getCurrentArguments() => args.isNotEmpty ? args.last : null;

  /// Handles back press action.
  bool handleBackPress() {
    final now = DateTime.now();
    if (now.difference(lastBackPressTime) > const Duration(seconds: 2)) {
      lastBackPressTime = now;
      print("Back Pressed: ${lastBackPressTime.toIso8601String()}");
      // showSnackBar(
      //   title: 'Close App',
      //   message: 'Press back again to exit',
      //   duration: const Duration(seconds: 2),
      // );
      /// add a custom toast or snackbar here if needed
      return false;
    }

    ///call the mixpanel, when app got closed.
    //fbServices.logEvent(eventName: TrackData.sessionEnds);
    // fbServices.flushAllAnalyticsData();
    SystemNavigator.pop(animated: true);
    return true;
  }

  /// Updates the app bar title based on the current page.
  void updateAppBarTitle(String path) {
    appBarTitle.value =
        {
          AppRoutes.home: PageTitles.home,
          AppRoutes.dashboard: PageTitles.dashboard,
          AppRoutes.categories: PageTitles.categories,
          AppRoutes.profile: PageTitles.profile,
          AppRoutes.onBoarding: PageTitles.onboarding,
          AppRoutes.login: PageTitles.login,
          AppRoutes.otp: PageTitles.otp,
          AppRoutes.explore: PageTitles.explore,
          AppRoutes.rewards: PageTitles.rewards,
          AppRoutes.qrView: PageTitles.qrView,
          AppRoutes.notifications: PageTitles.notifications,
          AppRoutes.categoryDetail: PageTitles.categoryDetail,
          AppRoutes.location: PageTitles.location,
          AppRoutes.personalInfo: PageTitles.personalInfo,
        }[path] ??
        'DashBoard';
  }

  /// Move to landing page.
  void moveToLandingPage() {
    pageStack.clear();
    args.clear();
    pageStack.add(lastVisitedPageBeforeLogin);
    args.add(null);
    currentPage.value = lastVisitedPageBeforeLogin;
    updateAppBarTitle(lastVisitedPageBeforeLogin);
  }

  /// Resets the BasePage stack to its initial state.
  void resetBasePageStack() {
    log("resetBasePageStack");
    pageStack.clear();
    args.clear();
    pageStack.add(AppRoutes.home); // Default landing page for guest
    args.add(null);
    currentPage.value = AppRoutes.home;
    updateAppBarTitle(AppRoutes.home);
  }
}

class PageTitles {
  static const String basePage = 'Base Page';
  static const String home = 'Home';
  static const String forgotPassword = 'Forgot Password';
  static const String resetPassword = 'Reset Password';
  static const String dashboard = 'Dashboard';
  static const String onboarding = 'Onboarding';
  static const String login = 'login';
  static const String otp = 'otp';
  static const String profile = 'Profile';
  static const String categories = 'All Categories';
  static const String support = 'Support';
  static const String explore = 'Explore';
  static const String rewards = 'Rewards';
  static const String qrView = 'Perk Zone';
  static const String notifications = 'Buzz & Updates';
  static String categoryDetail = 'Category Detail';
  static const String location = 'Location';
  static const String personalInfo = 'Personal Info';
  // static const String globalCoffeePrices = 'Global Coffee Prices';
  // static const String userGuide = 'CoffeeWeb User Guide';
  // static const String billionaireGuide = 'Billionaires Brew';
}
