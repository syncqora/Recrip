import 'dart:developer';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart' as ph;
import '../../shared/constants/app.dart';
import '../../shared/constants/box_constants.dart';
import '../controllers/app_settings_controller.dart';
import '../di/get_injector.dart';
import 'box_db.dart';
import 'package:geocoding/geocoding.dart' as geo_code;
import 'package:location/location.dart';
import 'network_checker.dart';

class PermissionManager {
  /// Gets the current country of the user based on location
  Future<geo_code.Placemark?> getCurrentCountry() async {
    final Location location = Location();

    if (!await _ensureServiceEnabled(location)) return null;
    if (!await _ensurePermissionGranted(location)) return null;
    if (!Get.find<NetworkChecker>().isConnected.value) return null;

    return await _getLocationAndSave(location);
  }

  /// Ensures the location service is enabled
  Future<bool> _ensureServiceEnabled(Location location) async {
    if (!await location.serviceEnabled()) {
      if (!await location.requestService()) return false;
    }
    return true;
  }

  /// Ensures location permission is granted
  Future<bool> _ensurePermissionGranted(Location location) async {
    PermissionStatus permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) return false;
    }
    return true;
  }

  /// Gets the location and saves the country data to the database
  Future<geo_code.Placemark?> _getLocationAndSave(Location location) async {
    final LocationData locationData = await location.getLocation();
    if (locationData.latitude == null || locationData.longitude == null) {
      return null;
    }

    // Save latitude and longitude to BoxDB
    final boxDb = Get.find<BoxDb>();
    boxDb.writeStringValue(
      key: BoxConstants.currentLatitude,
      value: locationData.latitude!.toString(),
    );
    boxDb.writeStringValue(
      key: BoxConstants.currentLongitude,
      value: locationData.longitude!.toString(),
    );

    geo_code.Placemark? placeMark;
    try {
      placeMark = await _getPlaceMark(
        locationData.latitude!,
        locationData.longitude!,
      );
      _savePlaceMark(placeMark);
    } catch (error) {
      log('Error retrieving place mark: $error');
    }

    return placeMark;
  }

  /// Saves the place mark data to the database
  void _savePlaceMark(geo_code.Placemark? placeMark) {
    final boxDb = Get.find<BoxDb>();
    boxDb.writeStringValue(
      key: BoxConstants.currentCountryISO,
      value: placeMark?.isoCountryCode ?? "",
    );
    boxDb.writeStringValue(
      key: BoxConstants.currentLocality,
      value: placeMark?.locality ?? "",
    );
    boxDb.writeStringValue(
      key: BoxConstants.currentCountry,
      value: placeMark?.country ?? "",
    );
    boxDb.writeStringValue(
      key: BoxConstants.thoroughFare,
      value: placeMark?.thoroughfare ?? "",
    );

    boxDb.writeStringValue(
      key: BoxConstants.subLocality,
      value: placeMark?.subLocality ?? "",
    );

    boxDb.writeStringValue(
      key: BoxConstants.postalCode,
      value: placeMark?.postalCode ?? "",
    );
    final userCountryFlag = Get.find<AppSettingsController>().countriesList
        .where(
          (element) =>
              element.iso.toString() ==
              boxDb.readStringValue(key: BoxConstants.currentCountryISO),
        )
        .first
        .flagsUrl
        .toString();
    boxDb.writeStringValue(key: BoxConstants.flagUrl, value: userCountryFlag);
    print("userCountryFlag $userCountryFlag");
    print(
      "country code:: ${boxDb.readStringValue(key: BoxConstants.currentCountryISO)}",
    );
    print(
      "country:: ${boxDb.readStringValue(key: BoxConstants.currentCountry)}",
    );
  }

  /// Gets the place mark based on latitude and longitude
  Future<geo_code.Placemark?> _getPlaceMark(
    double latitude,
    double longitude,
  ) async {
    try {
      final List<geo_code.Placemark> placeMarks = await geo_code
          .placemarkFromCoordinates(latitude, longitude);
      return placeMarks.isNotEmpty ? placeMarks[0] : null;
    } catch (error, stackTrace) {
      log('Error in _getPlaceMark: $error\n$stackTrace');
      throw Exception('Error retrieving place mark');
    }
  }

  /// Requests SMS permission
  Future<void> getSMSPermission() async {
    await ph.Permission.sms.request();
  }

  /// Requests notification permission
  Future<bool> requestNotificationPermission(
    FirebaseMessaging firebaseMessaging, {
    bool? getValue,
    required bool showNotificationDialogBox,
  }) async {
    final NotificationSettings notificationSettings = await firebaseMessaging
        .getNotificationSettings();
    final BoxDb boxDb = Get.find<BoxDb>();

    if (getValue != null) {
      return notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized;
    }

    log(
      "notificationStatus:: ${notificationSettings.authorizationStatus.toString()}",
    );

    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized) {
      //Logs.stringLogger("enable permission");
      return true;
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      /// TODO:: Handle denied permission case with a dialog box if needed
      //Logs.stringLogger("denied permission");
      // showDialog(
      //   context: Get.context!,
      //   builder: (BuildContext context) {
      //     return AppDialog.getDialog(
      //       DialogBoxType.notification,
      //       title: "CoffeeWeb Notifications",
      //       content:
      //       "Get the latest updates of CoffeeWeb Application as Push Notifications on your mobile screen",
      //       subContent:
      //       "You can always disable this from Master Settings in Profile",
      //       onResponse: (DialogBoxResponse response) async {
      //         boxDb.writeBoolValue(
      //           key: BoxConstants.pushNotificationPermissionChecked,
      //           value: true,
      //         );
      //         await AppSettings.openAppSettings(
      //           type: AppSettingsType.notification,
      //         );
      //       },
      //     );
      //   },
      // );
      return true;
    } else {
      return await _handleNotificationPermission(
        firebaseMessaging,
        boxDb,
        showNotificationDialogBox,
      );
    }
  }

  /// Handles notification permission for different platforms
  Future<bool> _handleNotificationPermission(
    FirebaseMessaging firebaseMessaging,
    BoxDb boxDb,
    bool showNotificationDialogBox,
  ) async {
    //Logs.stringLogger("_handleNotificationPermission");
    final deviceInfo = await appFunctions.getDeviceInfo(
      infoName: DeviceInfoName.sdkInt,
    );

    if (Platform.isAndroid) {
      return await _handleAndroidNotificationPermission(
        firebaseMessaging,
        boxDb,
        showNotificationDialogBox,
        deviceInfo,
      );
    } else if (Platform.isIOS) {
      return await _handleIOSNotificationPermission(firebaseMessaging);
    }

    return false;
  }

  /// Requests notification permission for Android
  Future<bool> _requestAndroidNotificationPermission(
    FirebaseMessaging firebaseMessaging,
  ) async {
    //Logs.stringLogger("_requestAndroidNotificationPermission");
    final NotificationSettings notificationSettings = await firebaseMessaging
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

    return notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized;
  }

  /// Handles notification permission for Android
  Future<bool> _handleAndroidNotificationPermission(
    FirebaseMessaging firebaseMessaging,
    BoxDb boxDb,
    bool showNotificationDialogBox,
    int deviceInfo,
  ) async {
    //Logs.stringLogger("_handleAndroidNotificationPermission $deviceInfo");
    if (deviceInfo > 32) {
      return await _requestAndroidNotificationPermission(firebaseMessaging);
    } else {
      if (showNotificationDialogBox &&
          !boxDb.readBoolValue(
            key: BoxConstants.pushNotificationPermissionChecked,
          )) {
        // showDialog(
        //   context: Get.context!,
        //   builder: (BuildContext context) {
        //     return AppDialog.getDialog(
        //       DialogBoxType.notification,
        //       title: "CoffeeWeb Notifications",
        //       content:
        //       "Get the latest updates of CoffeeWeb Application as Push Notifications on your mobile screen",
        //       subContent:
        //       "You can always disable this from Master Settings in Profile",
        //       onResponse: (DialogBoxResponse response) async {
        //         boxDb.writeBoolValue(
        //           key: BoxConstants.pushNotificationPermissionChecked,
        //           value: true,
        //         );
        //         await AppSettings.openAppSettings(
        //           type: AppSettingsType.notification,
        //         );
        //       },
        //     );
        //   },
        // );
      } else {
        await AppSettings.openAppSettings(type: AppSettingsType.notification);
      }
    }

    return false;
  }

  /// Handles notification permission for iOS
  Future<bool> _handleIOSNotificationPermission(
    FirebaseMessaging firebaseMessaging,
  ) async {
    final NotificationSettings notificationSettings = await firebaseMessaging
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );
    return notificationSettings.authorizationStatus ==
        AuthorizationStatus.authorized;
  }
}
