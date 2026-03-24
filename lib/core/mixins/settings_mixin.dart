import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import '../../models/others/getAllCountriesResponse.dart';
import '../../shared/constants/box_constants.dart';
import '../di/get_injector.dart';
import '../services/network_checker.dart';

mixin SettingsMixin {
  /// Indicates whether the app is already installed
  ValueNotifier<bool?> isAlreadyInstalled = ValueNotifier<bool?>(null);

  /// Network checker to monitor internet connectivity
  NetworkChecker networkChecker = Get.find<NetworkChecker>();

  /// Current placeMark information
  Placemark? placeMark;

  /// Stream subscription for handling deep links
  StreamSubscription? streamLinks;

  /// Latest and initial deep links
  String? latestLink;
  String? initialLink;

  /// Flag to indicate if the initial URI link has been handled
  bool initialURILinkHandled = false;

  /// Flag to indicate whether the app came from terminate state
  bool fromTerminateState = false;

  /// Observable profile card data model
  // Rx<ProfileCardDataModel> profileCardDataModel = ProfileCardDataModel().obs;

  /// Observable location details
  //Rx<LocationDetails> locationDetails = LocationDetails().obs;

  /// Guest and user menu models (New)
  // List<MenuListResponse> guestMenu = [];
  // List<MenuListResponse> userMenu = [];

  // List<PushNotificationResponse> pushNotificationList = [];

  RxBool isUserLoggedIn = boxDb
      .readBoolValue(key: BoxConstants.isUserLoggedIn)
      .obs;

  /// Country Model
  List<GetAllCountriesResponse> countriesList = [];
  // List<GetAllForexCurrencies> forexCurrenciesList = [];
  // List<GetAllCountriesResponse> exportCountriesList = [];
  RxList<String> clock = ["date", "time"].obs;
  //ClockController clockController = Get.find<ClockController>();

  RxString userSubscriptionLevel = "Regular".obs;

  RxBool deleteSuccess = false.obs;

  final RxBool backgroundState = false.obs;

  //RouteArgsModel? deepArgs;

  RxBool isAppUpdated = false.obs;

  RxBool isUserLogout = false.obs;

  RxBool terminateState = false.obs;

  // RxBool isFromDeepLink = false.obs;
  //
  // RxString deepLinkingId = "".obs;
  // RxString deepLinkPath = "".obs;
  //
  // Rx<DeepLinkState> currentDeepLinkState = DeepLinkState.idle.obs;

  /// list for stacking news in newsfeeds detail
  // News stack list from deepLinking
  //RxList<NewsFeed> detailNewsHistory = <NewsFeed>[].obs;

  /// Loads guest and user menus concurrently.
  // Future<void> loadMenus() async {
  //  await loadGuestMenus();
  //   if (isUserLoggedIn.value) {
  //     await loadUserMenus();
  //   }
  //   // await Future.wait([loadGuestMenus(), loadUserMenus()]);
  // }

  /// Loads the guest menus from local storage or remote config services.
  // Future<void> loadGuestMenus() async {
  //   final guestMenus = boxDb.readStringValue(key: BoxConstants.guestMenu);
  //   if (guestMenus.isEmpty) {
  //     guestMenu = await fbServices.getGuestMenus();
  //   } else {
  //     guestMenu = menuListFromJson(guestMenus);
  //   }
  // }

  /// Loads the user menus from local storage or remote config services.
  // Future<void> loadUserMenus({
  //   bool isLogin = false,
  //   int? subscriptionType,
  //   int? countryId,
  // }) async {
  //   print("loadUserMenus");
  //   if (isLogin) {
  //     userMenu = fbServices.getUserMenus(subscriptionType!, countryId!);
  //   } else {
  //     final userMenus = boxDb.readStringValue(key: BoxConstants.userMenu);
  //     if (userMenus.isEmpty) {
  //       final UserData? userData = await Get.find<AppDataController>()
  //           .getCurrentUserData();
  //       if (userData != null) {
  //         print("user data not null");
  //         userMenu = fbServices.getUserMenus(
  //           int.parse(userData.subscriptionType!),
  //           userData.countryId!,
  //         );
  //       } else {
  //         print("user data null");
  //       }
  //     } else {
  //       userMenu = menuListFromJson(userMenus);
  //     }
  //   }
  // }

  /// Load countries list from assets
  Future<void> loadCountries() async {
    final getAllCountries = boxDb.readStringValue(
      key: BoxConstants.getAllCountries,
    );
    if (getAllCountries.isEmpty) {
      final countries = await rootBundle.loadString(
        'assets/jsons/countries_list.json',
      );
      boxDb.writeStringValue(
        key: BoxConstants.getAllCountries,
        value: countries,
      );
      countriesList = allCountriesListResponseFromJson(countries);
    } else {
      countriesList = allCountriesListResponseFromJson(getAllCountries);
    }
  }

  // Future<void> loadForexCurrencies() async {
  //   final getAllCurencies = boxDb.readStringValue(
  //     key: BoxConstants.getAllForexCurrencies,
  //   );
  //   if (getAllCurencies.isEmpty) {
  //     final currencies = await rootBundle.loadString(
  //       'assets/jsons/forex_currency_list.json',
  //     );
  //     boxDb.writeStringValue(
  //       key: BoxConstants.getAllForexCurrencies,
  //       value: currencies,
  //     );
  //     forexCurrenciesList = allForexCurrencyListFromJson(currencies);
  //   } else {
  //     forexCurrenciesList = allForexCurrencyListFromJson(getAllCurencies);
  //   }
  // }
}
