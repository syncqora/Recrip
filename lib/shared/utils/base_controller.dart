import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/mixins/base_mixin.dart';
import '../widgets/base/ui_state.dart';

/// A base controller class that manages the UI state using the GetX package.
/// It provides methods to set different UI states such as loading, error, internet disconnected, default, and none.
class BaseController extends GetxController
    with WidgetsBindingObserver, BaseMixin {
  /// UI state to manage different states like loading, error, etc.
  Rx<UiState> state = UiState.defaultView.obs;

  /// Flag to control if the overlay dialog is shown.
  RxBool showOverlay = false.obs;

  /// Sets the UI state to loading and triggers a UI update.
  void setLoading() {
    state.value = UiState.loading;
  }

  /// Sets the UI state to error and triggers a UI update.
  void setError() {
    state.value = UiState.errorView;
  }

  /// Sets the UI state to internet disconnected and triggers a UI update.
  void setInternetDisconnected() {
    state.value = UiState.internetDisconnected;
  }

  /// Sets the UI state to default and triggers a UI update.
  void setDefault() {
    state.value = UiState.defaultView;
  }

  /// Shows or hides the custom overlay dialog and triggers a UI update.
  void toggleOverlay(bool show) {
    showOverlay.value = show;
  }

  /// Called when the controller is initialized.
  @override
  void onInit() {
    log("base controller init");
    super.onInit();
    // Initialize network checker from the mixin
    initializeNetworkChecker();
    WidgetsBinding.instance.addObserver(this);
  }

  /// Handles network status change.
  @override
  void onNetworkStatusChanged(bool isConnected) {
    if (isConnected) {
      setDefault(); // If connected, set the default UI state
    } else {
      setInternetDisconnected(); // If not connected, set the internet disconnected UI state
    }
  }

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
      print("Error during network checker initialization: o$e");
      print("Stack trace: $trace");
    }
  }

  /// Called when the app lifecycle state changes.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        onResume();
        break;
      case AppLifecycleState.paused:
        onPause();
        break;
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.detached:
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  /// Called to resume the controller's state.
  void onResume() {
    log("controller resumed");
  }

  /// Called to pause the controller's state.
  void onPause() {
    log("controller paused");
  }

  void onInActiveState() {
    log("controller inactive");
  }

  void onHidden() {
    log("controller hidden");
  }

  /// Called when the controller is being disposed.
  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
}
