import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../shared/widgets/constants/widget_enums.dart';
import '../../shared/widgets/text_views/app_text.dart';
import '../controllers/app_settings_controller.dart';
import '../services/network_checker.dart';

mixin BaseMixin on GetxController {
  NetworkChecker networkChecker = Get.find<NetworkChecker>();
  AppSettingsController appSettingsController =
      Get.find<AppSettingsController>();
  //AppDataController appDataController = Get.find<AppDataController>();
  final ValueNotifier<bool> isConnected = ValueNotifier<bool>(false);

  void handleError({required Exception exception, StackTrace? trace}) {}

  /// Sends an event log with the specified message to the Firebase services.
  /// This method is used to track events for analytics purposes.
  void sendEventLog({required String message}) {
    //fbServices.logEvent(eventName: message);
  }

  /// Sends a screen log with the specified message and fragment status to the Firebase services.
  /// This method is used for tracking screen views in the application for analytics.
  void sendScreenLog({required String message, bool isFragment = false}) {
    //fbServices.setScreenLog(screenName: message, isFragment: isFragment);
  }

  /// Displays an error snack bar with the specified title and message to inform the user of an error.
  /// The snack bar is styled with a red background to indicate an error condition.
  void showErrorSnackBar({required String title, required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        titleText: AppText(
          text: title,
          category: TextCategory.title,
          color: Colors.white,
        ),
        messageText: AppText(
          text: title,
          category: TextCategory.normal,
          color: Colors.white,
        ),
        message: message,
        backgroundColor: Colors.redAccent,
      ),
    );
  }

  /// Displays an informational snack bar with the specified title and message to update the user.
  /// The snack bar is styled with a light background to convey an informational message.
  void showInfoSnackBar({required String title, required String message}) {
    Get.showSnackbar(
      GetSnackBar(
        titleText: AppText(text: title, category: TextCategory.title),
        messageText: AppText(text: title, category: TextCategory.normal),
        message: message,
        backgroundColor: Colors.white70,
      ),
    );
  }

  //RxBool get loginStatus => appSettingsController.isUserLoggedIn;

  RxBool get isNetworkConnected => networkChecker.isConnected;

  /// Initializes the network checker and listens for changes.
  Future<void> initializeNetworkChecker() async {
    print("initializeNetworkChecker");
    try {
      ever(networkChecker.isConnected, (bool isConnectedValue) {
        print("Listener triggered in BaseMixin: $isConnectedValue");
        isConnected.value = isConnectedValue;
        onNetworkStatusChanged(isConnectedValue);
      });

      // Await the initial network check if it's asynchronous
      await networkChecker.getConnectionStatus();
      isConnected.value = networkChecker.isConnected.value;
      onNetworkStatusChanged(isConnected.value);
    } catch (e, trace) {
      print("Error during network checker initialization: $e");
      print("Stack trace: $trace");
    }
  }

  /*  /// Updates the connectivity status when notified.
  void _updateConnectivityStatus() {
    print("_updateConnectivityStatus");
    isConnected.value = networkChecker.isConnected.value;
    onNetworkStatusChanged(isConnected.value);
  }*/

  /// Override this method to handle connectivity changes in derived classes.
  void onNetworkStatusChanged(bool isConnected) {
    print("Network status changed in BaseMixin: $isConnected");
  }
}
