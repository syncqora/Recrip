import 'dart:async';
import 'package:get/get.dart';

import '../../shared/constants/app.dart';
import '../../shared/constants/box_constants.dart';
import '../di/get_injector.dart';
import '../mixins/settings_mixin.dart';
import '../services/firebase_services.dart';

/// AppSettingsController is responsible for managing app settings,
/// initializing services, and handling user and guest menus.
class AppSettingsController extends GetxController with SettingsMixin {
  @override
  Future<void> onInit() async {
    super.onInit();
  }

  ///Initialize the app settings
  Future<void> initializeSettings() async {
    //secureData();
    // await listenToInitialLink();
    //await listenToStreamLink();
    await checkFirstTimeInstall();
    await appFunctions.deviceDetailsSetup(
      DeviceDetailResultType.setDeviceDetail,
    );
    //await callSupa();
    //await loadCountries();
    //placeMark = await PermissionManager().getCurrentCountry();
    // clockController.startClock();
    //loadForexCurrencies();
    // await fetchRemoteConfigServices();
    //await startInitUserData();
    // await loadMenus();
  }

  Future<void> callSupa() async {
    // await sbServices.initSupabase();
  }

  /// Sets the flag indicating whether the app is installed for the first time.
  void _setFirstTimeInstall() {
    if (!boxDb.readBoolValue(key: BoxConstants.isAlreadyInstalled)) {
      isAlreadyInstalled.value = boxDb.readBoolValue(
        key: BoxConstants.isAlreadyInstalled,
      );
    }
  }

  /// Checks if the app is installed for the first time and handles it accordingly.
  Future<void> checkFirstTimeInstall() async {
    if (!networkChecker.isConnected.value) {
      appLog.info("Internet connection error");
      return;
    }
    _setFirstTimeInstall();
    //await initFireBaseService();
  }

  /// Initializes Firebase services and push notifications.
  Future<void> initFireBaseService() async {
    try {
      /// add firebase add fix this
      await di<FirebaseServices>().initializeFirebase();
    } catch (e, trace) {
      appLog.error("error init firebase :: ", e, trace);
      await di<FirebaseServices>().initializeFirebase();
    }
  }

  // Deep Link Navigation   [When App is in background state]
  // This function
  // will listen to stream of incoming links from Share news, and navigates to Read More news Screen
  // Future<void> listenToStreamLink() async {
  //   final appLinks = AppLinks();
  //   streamLinks = appLinks.uriLinkStream.listen(
  //     (link) async {
  //       Logs.stringLogger("background state ------");
  //       backgroundState.value = true;
  //       latestLink = await appLinks.getLatestLinkString();
  //       if (latestLink != null) {
  //         final uri = Uri.parse(latestLink!);
  //         _handleMyLink(uri);
  //         Logs.stringLogger("called listenToStreamLinks() function");
  //         latestLink = null;
  //       }
  //       // Parse the link and warn the user, if it is not correct
  //     },
  //     onError: (err) {
  //       print(err.message);
  //     },
  //   );
  // }

  /// This function will get the link through which app opened from terminated state [When App opens with link] and saves it.
  // Future<void> listenToInitialLink() async {
  //   final AppLinks appLinks = AppLinks();
  //   if (!initialURILinkHandled) {
  //     initialURILinkHandled = true;
  //     Logs.stringLogger("terminateState ------${terminateState.value}");
  //     try {
  //       initialLink = await appLinks.getInitialLinkString();
  //       if (initialLink != null) {
  //         terminateState.value = true;
  //         final uri = Uri.parse(initialLink!);
  //         _handleMyLink(uri);
  //         Logs.stringLogger("called listenToInitialLink() function");
  //         initialLink = null;
  //       }
  //     } on PlatformException {
  //       print("Error failed!!!!");
  //     }
  //   }
  // }

  /// Handles deep links for news feeds by extracting the news ID from the URI path.
  // void _handleMyLink(Uri uri) {
  //   Logs.stringLogger("_handle Function called!!");
  //   if (uri.path.contains("news")) {
  //     final List<String> separatedEndPoint = [];
  //     separatedEndPoint.addAll(uri.path.split('/'));
  //     //TODO handle news feeds deeplinks.
  //     if (!backgroundState.value) {
  //       Logs.stringLogger("backgroundstate ${!backgroundState.value}");
  //       deepArgs = RouteArgsModel(
  //         fromRoute: AppRoutes.newsFeeds,
  //         redirectTo: AppRoutes.newsFeedsDetail,
  //         arguments: {
  //           RouteArgumentKeys.newsId: separatedEndPoint.last,
  //           RouteArgumentKeys.isDeepLinking: true,
  //         },
  //       );
  //       Logs.stringLogger(
  //         "deepargs!!! value ----- ${deepArgs!.arguments[RouteArgumentKeys.newsId]}",
  //       );
  //       Logs.stringLogger("backgroundstate value is called!!!!");
  //       backgroundState.value = false;
  //     } else {
  //       Logs.stringLogger("terminate state ${!fromTerminateState}");
  //       appNav.navigateTo(
  //         AppRoutes.newsFeedsDetail,
  //         arguments: RouteArgsModel(
  //           fromRoute: backgroundState.value ? "" : AppRoutes.newsFeeds,
  //           redirectTo: AppRoutes.newsFeedsDetail,
  //           arguments: {
  //             RouteArgumentKeys.newsId: separatedEndPoint.last,
  //             RouteArgumentKeys.isDeepLinking: true,
  //           },
  //         ),
  //       );
  //
  //       if (Get.isRegistered<NewsFeedsDetailController>()) {
  //         Get.find<NewsFeedsDetailController>().fetchNewArgs();
  //       } else {
  //         Get.put<NewsFeedsDetailController>(
  //           NewsFeedsDetailController(),
  //         ).fetchNewArgs();
  //       }
  //       Logs.stringLogger("called fetchargs() function");
  //       fromTerminateState = false;
  //     }
  //   }
  //   backgroundState.value = false;
  //   return;
  // }

  // void _handleMyLink(Uri uri) {
  //   Logs.stringLogger("_handle Function called!!");
  //
  //   final String? newsId = uri.queryParameters['newsId'];
  //
  //   if (newsId != null && newsId.isNotEmpty) {
  //     // Deep link is valid
  //     if (!backgroundState.value) {
  //       Logs.stringLogger("backgroundstate ${!backgroundState.value}");
  //       deepArgs = RouteArgsModel(
  //         fromRoute: AppRoutes.newsFeeds,
  //         redirectTo: AppRoutes.newsFeedsDetail,
  //         arguments: {
  //           RouteArgumentKeys.newsId: newsId,
  //           RouteArgumentKeys.isDeepLinking: true,
  //         },
  //       );
  //       Logs.stringLogger("deepargs!!! value ----- $newsId");
  //     } else {
  //       appNav.navigateTo(
  //         AppRoutes.newsFeedsDetail,
  //         arguments: RouteArgsModel(
  //           fromRoute: backgroundState.value ? "" : AppRoutes.newsFeeds,
  //           redirectTo: AppRoutes.newsFeedsDetail,
  //           arguments: {
  //             RouteArgumentKeys.newsId: newsId,
  //             RouteArgumentKeys.isDeepLinking: true,
  //           },
  //         ),
  //       );
  //
  //       if (Get.isRegistered<NewsFeedsDetailController>()) {
  //         Get.find<NewsFeedsDetailController>().fetchNewArgs();
  //       } else {
  //         Get.put<NewsFeedsDetailController>(
  //           NewsFeedsDetailController(),
  //         ).fetchNewArgs();
  //       }
  //
  //       Logs.stringLogger("called fetchargs() function");
  //       fromTerminateState = false;
  //     }
  //   }
  //
  //   backgroundState.value = false;
  // }

  /// Fetches remote configuration services including state, occupation, share lists, and app settings.
  // Future<void> fetchRemoteConfigServices() async {
  //   fbServices.getCoffeeQuotesSettings();
  //   fbServices.getStateList();
  //   fbServices.getOccupationList();
  //   fbServices.getShareList();
  //   fbServices.getAppSettings();
  //   fbServices.getMenuList();
  //   fbServices.getExportCountriesList();
  // }

  /// Initializes user data by streaming Firebase data if the user is logged in.
  // Future<void> startInitUserData() async {
  //   log("called:: startInitUserData");
  //   if (isUserLoggedIn.value) {
  //     final String userDocId = boxDb.readStringValue(
  //       key: BoxConstants.fireBaseUserDocumentId,
  //     );
  //     if (isAppUpdated.value) {
  //       print("app is updated");
  //       Get.find<AppDataController>().migrateDbToNewVersion();
  //       //write the close the app when the app is updated
  //       isAppUpdated.value = false;
  //     }
  //     await Get.find<AppDataController>().streamCoffeeWebFirebase(
  //       userFBDocumentId: userDocId,
  //     );
  //     log("streaming on");
  //   }
  // }

  ///Future setup screen shots and video recording.
  // void secureData() async {
  //   if (AppConstants.appEnvironment == "dev" ||
  //       AppConstants.appEnvironment == "preprod" ||
  //       kDebugMode) {
  //     await ScreenProtector.preventScreenshotOff();
  //   } else {
  //     await ScreenProtector.preventScreenshotOff();
  //   }
  // }
}

// enum DeepLinkState { init, restarted, navigate, completed, idle }
