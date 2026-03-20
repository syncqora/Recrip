import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:saas/app/screens/authentication/forgot_password/forgot_password.dart';
import 'package:saas/core/web_url_helper.dart';
import '../app/screens/authentication/login/login.dart';
import '../app/screens/authentication/otp_authentication/otp_authentication.dart';
import '../app/screens/authentication/reset_password/reset_password.dart';
import '../app/screens/dashboard/views/dashboard/dashboard.dart';
import '../app/screens/admin/dashboard/admin_dashboard.dart';
import '../core/di/get_injector.dart';
import '../routes/app_pages.dart';
import '../shared/constants/app.dart';
import '../shared/constants/box_constants.dart';
import 'navigation_mixins.dart';

class NavigationService extends GetxService with NavigationMixin {
  @override
  void onInit() {
    super.onInit();
    setupBrowserBackListener(popPage);
  }

  /// Returns the current widget based on the current page path.
  Widget getCurrentPage() {
    final redirectRule = navigationRules.firstWhereOrNull(
      (rule) => currentPage.value == rule.page && rule.condition(),
    );

    if (redirectRule != null) {
      appArgs = redirectRule.arguments;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        navigateTo(
          redirectRule.redirectPage,
          arguments: redirectRule.arguments,
          shouldReplace: true,
        );
      });
      return const SizedBox();
    }

    updateAppBarTitle(currentPage.value);
    return getViewForPath(currentPage.value);
  }

  ///Return the title of the getPath
  String getTitleOfPath(String path) {
    switch (path) {
      case AppRoutes.home:
        return PageTitles.home;
      case AppRoutes.forgotPassword:
        return PageTitles.forgotPassword;
      case AppRoutes.otp:
        return PageTitles.otp;
      case AppRoutes.resetPassword:
        return PageTitles.resetPassword;
      case AppRoutes.dashboard:
        return PageTitles.dashboard;
      case AppRoutes.adminDashboard:
        return 'Admin Dashboard';
      // case AppRoutes.home:
      //   return PageTitles.home;
      // case AppRoutes.onBoarding:
      //   return PageTitles.onboarding;
      // case AppRoutes.otp:
      //   return PageTitles.otp;
      // case AppRoutes.profile:
      //   return PageTitles.profile;
      // case AppRoutes.support:
      //   return PageTitles.support;
      // case AppRoutes.categories:
      //   return PageTitles.categories;
      // case AppRoutes.explore:
      //   return PageTitles.explore;
      // case AppRoutes.rewards:
      //   return PageTitles.rewards;
      // case AppRoutes.qrView:
      //   return PageTitles.qrView;
      // case AppRoutes.notifications:
      //   return PageTitles.notifications;
      // case AppRoutes.categoryDetail:
      //   return PageTitles.categoryDetail;
      // case AppRoutes.location:
      //   return PageTitles.location;
      // case AppRoutes.personalInfo:
      //   return PageTitles.personalInfo;
      // case AppRoutes.userGuides:
      //   return PageTitles.userGuide;
      // case AppRoutes.billionaireBrew
      //   return PageTitles.billionaireGuide;
      default:
        return '';
    }
  }

  /// Returns the corresponding widget for the given path.
  Widget getViewForPath(String path) {
    switch (path) {
      case AppRoutes.home:
        return Login();
      case AppRoutes.forgotPassword:
        return ForgotPassword();
      case AppRoutes.otp:
        return OtpAuthentication();
      case AppRoutes.resetPassword:
        return ResetPassword();
      case AppRoutes.dashboard:
        return Dashboard();
      case AppRoutes.adminDashboard:
        return const AdminDashboard();
      // case AppRoutes.onBoarding:
      //   return OnboardingScreen();
      // case AppRoutes.login:
      //   return LoginScreen();
      // case AppRoutes.otp:
      //   return OtpVerificationScreen();
      // case AppRoutes.profile:
      //   return ProfileScreen();
      // case AppRoutes.categories:
      //   return AllCategory();
      // case AppRoutes.explore:
      //   return ExploreScreen();
      // case AppRoutes.rewards:
      //   return Rewards();
      // case AppRoutes.support:
      // case AppRoutes.qrView:
      //   return QrView();
      // case AppRoutes.notifications:
      //   return Notifications();
      // case AppRoutes.categoryDetail:
      //   return CategoryDetailScreen();
      // case AppRoutes.location:
      //   return LocationScreen();
      // case AppRoutes.personalInfo:
      //   return const PersonalInfoScreen();
      //return SupportScreen();
      default:
        return const Center(child: CircularProgressIndicator());
    }
  }

  /// Changes the current page to the specified path and adds it to the stack.
  /// Changes the current page to the specified path and adds it to the stack.
  void changePage(
    String path, {
    dynamic arguments,
    bool shouldReplace = false,
    //MenuListResponse? menuResult,
  }) {
    final redirectRule = navigationRules.firstWhereOrNull(
      (rule) => path == rule.page && rule.condition(),
    );

    if (redirectRule != null) {
      basePageStack.value = pageStack.toList();
      appArgs = redirectRule.arguments;
      //Logs.routeLogger(pageStack, arguments);
      Get.toNamed(redirectRule.redirectPage, arguments: redirectRule.arguments);
      return;
    }

    // Update last visited page if the user is logged in and it's not the login/logout page
    if (!appSettings.isUserLoggedIn.value && path != AppRoutes.login) {
      lastVisitedPageBeforeLogin = path;
    }

    if (shouldReplace) {
      pageStack.clear();
      args.clear();
    }

    currentPage.value = path;
    pageStack.add(path);
    args.add(arguments);
    appArgs = arguments;

    log("Stack length: ${pageStack.length}");
    log("pages:: $pageStack");
    updateAppBarTitle(path);

    final newPage = getViewForPath(path); // Get the corresponding page widget
    // Trigger the callback with the new page and title
    if (onPageChangeCallback != null) {
      onPageChangeCallback!(appBarTitle.value, newPage, arguments);
    }

    updateBrowserUrl(path);

    ///for access the subscriptions dynamically
    // if (menuResult != null && appSettings.isUserLoggedIn.value) {
    //   currentMenuSubscriptions.value = menuResult.subscriptionIds!.join(',');
    //
    //   appNav.pageMenuSubscriptionStack.add({
    //     'ids': menuResult.subscriptionIds!.toSet(), // Convert list to a set
    //     'name': menuResult.menuName,
    //   });
    // }
  }

  /// Pops the last page from the stack and updates the current page.
  void popPage() {
    if (pageStack.length > 1) {
      pageStack.removeLast();
      args.clear();
      currentPage.value = pageStack.last;
      updateAppBarTitle(currentPage.value);
      appArgs = null;

      // Handle dynamic subscription updates safely.
      // if (appSettings.isUserLoggedIn.value &&
      //     pageMenuSubscriptionStack.isNotEmpty) {
      //   pageMenuSubscriptionStack.removeLast();
      //
      //   if (pageMenuSubscriptionStack.isNotEmpty) {
      //     currentMenuSubscriptions.value =
      //         (pageMenuSubscriptionStack.last['ids'] as Set).join(',');
      //   } else {
      //     currentMenuSubscriptions.value = '';
      //   }
      // }

      final newPage = getViewForPath(currentPage.value);

      // Trigger the callback with the new page and title
      onPageChangeCallback?.call(appBarTitle.value, newPage, null);

      /// logs the route change
      //Logs.routeLogger(pageStack);
    } else if (handleBackPress()) {
      //Logs.routeLogger(pageStack);
      SystemNavigator.pop(animated: true);
    }
  }

  /// Navigates to the specified route and saves the current BasePage stack state.
  Future<dynamic> navigateTo(
    String route, {
    dynamic arguments,
    bool shouldReplace = false,
  }) async {
    if (route != '/' && pageStack.isNotEmpty) {
      basePageStack.value = pageStack.toList();
    }
    appArgs = arguments;

    /// finish this don't forget to add the logs
    //Logs.routeLogger(pageStack, arguments);
    return await Get.toNamed(
      route,
      arguments: arguments,
      preventDuplicates: false,
    );
  }

  ///Replace navigation
  Future<dynamic> replaceNavigateTo(
    String route, {
    dynamic arguments,
    bool shouldReplace = false,
  }) async {
    if (route != '/' && pageStack.isNotEmpty) {
      basePageStack.value = pageStack.toList();
    }

    appArgs = arguments;
    //Logs.routeLogger(pageStack, arguments);
    return await Get.offNamed(
      route,
      arguments: arguments,
      preventDuplicates: false,
    );
  }

  /// Navigates back to the previous page and restores the BasePage stack state if needed.
  void navigateBack({dynamic result}) {
    Get.back(result: result);
    if (basePageStack.isNotEmpty) {
      // Logs.stringLogger("base page stack is noty empty!!!!!");
      // Logs.stringLogger("base page stack ${basePageStack.first}");
      pageStack.value = basePageStack.toList();
      //Logs.stringLogger("page stack ${pageStack.first}");
      currentPage.value = pageStack.last;
      //Logs.stringLogger("page stack ${currentPage.value}");
      basePageStack.clear();
      appArgs = null;
    } else {
      //Logs.stringLogger("base page stack is empty!!!!!");
      Get.offAllNamed(AppRoutes.home);
    }
    //Logs.routeLogger(pageStack);
    //notifyControllersToResume();
  }

  /// Redirect to authentication page and pass the arguments
  void redirectToAuth({dynamic loginArguments, bool redirectLogin = true}) {
    navigateTo(
      AppRoutes.login,
      arguments: [
        {RouteArgumentKeys.isLogin: redirectLogin},
        loginArguments,
      ],
    );
  }

  ///Navigate to auth page [isLoginRequired] default as false
  void navigateToAuth({bool isLogin = false}) {
    //fbServices.logEvent(eventName: TrackData.login);
    navigateTo(
      AppRoutes.login,
      arguments: {RouteArgumentKeys.isLogin: isLogin},
    );
  }

  /// Disposes initialized controllers.
  Future<void> _disposeInitializedControllers() async {
    // TODO: Implement controller disposal if necessary.
    // if (Get.isRegistered<DashBoardController>()) {
    // Get.delete<DashBoardController>(force: true);
    //  }
    // if (Get.isRegistered<AddNewsController>()) {
    //   Get.delete<AddNewsController>(force: true);
    // }
    // if (Get.isRegistered<NewsPreviewController>()) {
    //  Get.delete<NewsPreviewController>(force: true);
    // }
  }

  /// Handles successful authentication navigation with login result as arguments.
  Future<void> handleAuthSuccess() async {
    _disposeInitializedControllers();
    moveToLandingPage();
    // Get.lazyPut<AppDataController>(() => AppDataController());
    appSettings.isUserLoggedIn.value = true;
    // boxDb.writeBoolValue(key: BoxConstants.isUserLoggedIn, value: true);
    // await Get.find<AppDataController>()
    //     .streamCoffeeWebFirebase(
    //     userFBDocumentId:
    //     boxDb.readStringValue(key: BoxConstants.fireBaseUserDocumentId))
    //     .then((r) async => await appSettings.loadUserMenus(
    //     isLogin: true,
    //     subscriptionType: authResponse!.sub!.subType!.toInt(),
    //     countryId: authResponse.countryId!.toInt()));
    //appArgs = loginResult;
    Get.offAllNamed(AppRoutes.basePage, arguments: {});
    // appNav.navigateTo(AppRoutes.basePage, arguments: loginResult);
    // changePage(lastVisitedPageBeforeLogin,
    //     arguments: loginResult, shouldReplace: true);
  }

  /// Handles user logout and navigates to guest landing page.
  Future<void> handleLogout() async {
    try {
      // Log the action (using your appLog or logger from history)
      log("handleLogout initiated"); // Or logger.log(...) if using LogX

      // Save last visited page if logged in
      if (boxDb.readBoolValue(key: BoxConstants.isUserLoggedIn)) {
        lastVisitedPageBeforeLogin =
            currentPage.value; // Ensure these vars are defined
      }

      // Clear ObjectBox or other data
      // await _disposeInitializedControllers(); // Uncomment and implement if needed

      // Reset navigation stack
      resetBasePageStack(); // Ensure this function is defined

      // Update login state
      boxDb.writeBoolValue(key: BoxConstants.isUserLoggedIn, value: false);
      // appSettings.isUserLoggedIn.value = false; // Uncomment if appSettings controller exists

      // Clear user data (uncomment and adapt from your code)
      // if (Get.isRegistered<AppDataController>()) {
      //   await Get.find<AppDataController>().clearUserData();
      // }

      // Analytics and tracking (uncomment if using Firebase or similar)
      // fbServices.logEvent(eventName: TrackData.loggedOut);
      // fbServices.resetAnalytics();
      // appFunctions.setGuestDataToAnalytics();

      // Optional: Reset theme to system default on logout (ties into your theme queries)
      // if (Get.isRegistered<ThemeController>()) {
      //   Get.find<ThemeController>().switchTheme(ThemeMode.system);
      // }

      // Clear globals if needed
      // appArgs = null;
      // appSettings.isUserLogout.value = true;

      // Navigate to login, clearing all previous routes
      Get.offAllNamed(
        AppRoutes.login, // Ensure this route is defined in your GetMaterialApp
        arguments: [], // Pass any needed args (e.g., for guest mode)
      );

      // Reinitialize controllers if necessary
      // _reinitControllers();
    } catch (e) {
      // Handle errors gracefully
      log(
        "Logout error: $e",
      ); // Or show a snackbar: Get.snackbar('Error', 'Logout failed: $e');
      // Optional: Revert any partial changes or notify user
    }
  }

  ///Restart the app
  void restartApp() {
    _disposeInitializedControllers(); // Dispose the previous controllers
    resetBasePageStack();
    Get.offAllNamed(
      AppRoutes.home, // Navigate to the landing page
      arguments: [],
    );
  }
}
