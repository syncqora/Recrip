import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:get/get.dart';

import '../di/get_injector.dart';
import 'network_checker.dart';

mixin RemoteConfigService {
  late FirebaseRemoteConfig _remoteConfig;
  final Duration _fetchTimeOut = const Duration(minutes: 2);
  final Duration _minimumFetchInterval = const Duration(seconds: 2);

  Future<void> _setConfigSettings() async => _remoteConfig.setConfigSettings(
    RemoteConfigSettings(
      fetchTimeout: _fetchTimeOut,
      minimumFetchInterval: _minimumFetchInterval,
    ),
  );

  /// initialize the remote config
  Future<bool> initRemoteConfig() async {
    _remoteConfig = FirebaseRemoteConfig.instance;
    var updated;
    await _setConfigSettings();
    if (Get.find<NetworkChecker>().isConnected.value) {
      updated = await _remoteConfig.fetchAndActivate();
      if (updated) {
        appLog.info("REMOTE CONFIG GETS LATEST DATA");
      } else {
        appLog.info("REMOTE CONFIG NO DATA UPDATE");
      }
    } else {
      updated = await _remoteConfig.activate();
    }
    return updated != null;
  }
}
