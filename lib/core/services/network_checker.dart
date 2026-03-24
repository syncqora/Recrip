import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

/// A service class that monitors network connectivity status using the Connectivity package.
/// It updates and provides the current connectivity status throughout the app.
class NetworkChecker extends GetxService {
  /// Notifies listeners about the connectivity status.
  final RxBool isConnected = false.obs;

  /// Reactive variable to indicate the type of network connection (e.g., Wifi, Mobile).
  final connectionType = "".obs;

  /// Reactive variable to control the visibility of network connectivity messages.
  final isShowNetworkConnectivityMessage = true.obs;

  /// Instance of the Connectivity class to monitor network changes.
  final Connectivity connectivity;

  /// Subscription to listen for connectivity changes.
  late StreamSubscription<List<ConnectivityResult>>
  _connectivityStreamSubscription;

  /// Constructor for NetworkChecker with optional dependency injection for testing.
  NetworkChecker({Connectivity? connectivity})
    : connectivity = connectivity ?? Connectivity();

  /// Initializes the service and starts listening for connectivity changes.
  @override
  void onInit() {
    _connectivityStreamSubscription = connectivity.onConnectivityChanged.listen(
      _updateConnectionStatus,
    );
    getConnectionStatus();
    super.onInit();
  }

  /// Checks the current connectivity status and updates the corresponding variables.
  Future<List<ConnectivityResult>> getConnectionStatus() async {
    List<ConnectivityResult> connectivityResult = [ConnectivityResult.none];
    try {
      connectivityResult = await connectivity.checkConnectivity();
    } catch (error, stackTrace) {
      /*Logs.appErrorLogger(
          swaggerDataCategory: SwaggerDataCategory.platformDispatcher,
          error: error,
          stackTrace: stackTrace);*/
    }
    _updateConnectionStatus(connectivityResult);
    return connectivityResult;
  }

  /// Updates the connectivity status and displays appropriate messages.
  ///
  /// [connectivityResult] The current connectivity result (Wifi, Mobile, None).
  Future<void> _updateConnectionStatus(
    List<ConnectivityResult> connectivityResult,
  ) async {
    /*isShowNetworkConnectivityMessage.value = true;
    switch (connectivityResult) {
      case ConnectivityResult.wifi:
        _setConnectedStatus(true, LocaleKeys.wifi.tr);
        break;
      case ConnectivityResult.mobile:
        _setConnectedStatus(true, LocaleKeys.mobile.tr);
        break;
      case ConnectivityResult.none:
        _setConnectedStatus(false, LocaleKeys.noInternet.tr);
        break;
      default:
        Get.snackbar(
            LocaleKeys.errorNetwork.tr, LocaleKeys.networkFailedMessage.tr);
        break;
    }*/
    if (connectivityResult.contains(ConnectivityResult.none)) {
      isConnected.value = false;
      connectionType.value = "No Internet";
    } else {
      if (connectivityResult.contains(ConnectivityResult.mobile)) {
        isConnected.value = true;
        connectionType.value = "mobile";
      } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
        isConnected.value = true;
        connectionType.value = "wifi";
      } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
        isConnected.value = true;
        connectionType.value = "connectedEthernet";
      } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
        isConnected.value = true;
        connectionType.value = "connectedVPN";
      } else if (connectivityResult.contains(ConnectivityResult.other)) {
        isConnected.value = true;
        connectionType.value = "connectedUnknown";
      }
    }
    /*if (isShowNetworkConnectivityMessage.value) {
      Future.delayed(const Duration(seconds: 3), () {
        isShowNetworkConnectivityMessage.value = false;
      });
    }*/
  }

  /// Sets the connectivity status and type.
  ///
  /// [status] The connectivity status (true if connected, false if not).
  /// [type] The type of network connection.
  // ignore: unused_element
  void _setConnectedStatus(bool status, String type) {
    isConnected.value = status;
    connectionType.value = type;
    print("NetworkChecker:: status::  $status");
  }

  /// Cancels the connectivity stream subscription when the service is closed.
  @override
  void onClose() {
    _connectivityStreamSubscription.cancel();
    super.onClose();
  }

  /// Checks if the current connection is via Wifi.
  ///
  /// Returns true if connected to Wifi, false otherwise.
  bool isConnectedToWifi() {
    return connectionType.value.toLowerCase().contains("wifi");
  }

  /// Gets the current connectivity type as a String.
  ///
  /// Returns 'mobile' if connected via mobile data, 'wifi' if connected via Wifi, and 'none' if not connected.
  Future<String> getConnectivityType() async {
    final connectivityResult = await connectivity.checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return "mobile";
    } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return "wifi";
    } else if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return "connectedEthernet";
    } else if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return "connectedVPN";
    } else if (connectivityResult.contains(ConnectivityResult.other)) {
      return "connectedUnknown";
    } else {
      return "None";
    }
  }
}
