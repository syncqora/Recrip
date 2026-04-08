import 'dart:async';
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/shared/themes/design.dart';
import 'app.dart';
import 'core/controllers/app_settings_controller.dart';
import 'core/di/get_injector.dart';
import 'core/services/network_checker.dart';
import 'core/url_strategy_stub.dart'
    if (dart.library.html) 'core/url_strategy_web.dart'
    as url_strategy;
import 'network/services/api_end_points.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const legacyBase = String.fromEnvironment('API_BASE_URL');
  const authBase = String.fromEnvironment('API_AUTH_BASE_URL');
  const dataBase = String.fromEnvironment('API_DATA_BASE_URL');
  if (legacyBase.isNotEmpty) {
    ApiEndPoints.authBaseUrl = legacyBase;
    ApiEndPoints.dataManagementBaseUrl = legacyBase;
  }
  if (authBase.isNotEmpty) {
    ApiEndPoints.authBaseUrl = authBase;
  }
  if (dataBase.isNotEmpty) {
    ApiEndPoints.dataManagementBaseUrl = dataBase;
  }
  url_strategy.setUpUrlStrategy();
  setupBaseAppServices();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ValueNotifier<AsyncSnapshot<bool>> _appLoadState = ValueNotifier(
    const AsyncSnapshot.waiting(),
  );

  @override
  initState() {
    super.initState();
    _retryLoadApp();
  }

  void _retryLoadApp() async {
    _appLoadState.value = const AsyncSnapshot.waiting(); // Set to loading state
    try {
      final bool result = await checkNetworkAndServices();
      _appLoadState.value = AsyncSnapshot.withData(
        ConnectionState.done,
        result,
      );
    } catch (error) {
      log('Error during initialization: $error');
      _appLoadState.value = AsyncSnapshot.withError(
        ConnectionState.done,
        error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AsyncSnapshot<bool>>(
      valueListenable: _appLoadState,
      builder: (context, snapshot, child) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.white,
              // themeServices.isDarkMode()
              //     ? Colors.black
              //     : Colors.white,
              body: const Center(
                child: CircularProgressIndicator(),
              ), // Loading indicator
            ),
          );
        } else if (snapshot.hasError || snapshot.data == false) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              backgroundColor: Colors.black,
              // themeServices.isDarkMode()
              //     ? Colors.black
              //     : Colors.white,
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 24,
                      ),
                      child: Image.asset('assets/images/logo.webp'),
                    ),
                    const SizedBox(height: 16),
                    const Icon(
                      Icons.signal_wifi_statusbar_connected_no_internet_4,
                      size: 40,
                      color: AppColors.appPrimaryColorLight,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        "Oops! We can't seem to reach our services right now. "
                        "Check your internet connection and tap 'Retry' to try again.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Get.theme.dividerColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // AppButton(
                    //   text: "Retry",
                    //   appButtonType: AppButtonType.regular,
                    //   isEnabled: true,
                    //   onTap: _retryLoadApp,
                    //   icon: Icons.autorenew,
                    // ),
                    ElevatedButton(
                      onPressed: _retryLoadApp,
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return GestureDetector(
            onLongPress: () {
              // AppSettingsController().checkMiniSwaggerAvailability(
              //   MiniSwaggerProtocolGestures.longPress,
              // );
            },
            child: RecripApp(title: "Recrip"),
          );
        }
      },
    );
  }
}

/// Custom function to check network and ensure all services are ready before rendering the app.
Future<bool> checkNetworkAndServices() async {
  try {
    await initializeApp().timeout(const Duration(seconds: 8));

    final networkChecker = Get.find<NetworkChecker>();
    try {
      await networkChecker.getConnectionStatus().timeout(
        const Duration(seconds: 2),
      );
    } on TimeoutException {
      if (kIsWeb) {
        networkChecker.isConnected.value = true;
      }
    }

    if (!kIsWeb && !networkChecker.isConnected.value) {
      print("No internet connection");
      return false;
    }

    final appSettingsController = Get.find<AppSettingsController>();
    await appSettingsController.initializeSettings().timeout(
      const Duration(seconds: 5),
      onTimeout: () async {},
    );

    if (kIsWeb) {
      return true;
    }
    return networkChecker.isConnected.value;
  } catch (e, st) {
    log('Error during initialization: $e', stackTrace: st);
    if (kIsWeb) {
      return true;
    }
    return false;
  }
}

/// Initializes the application by setting up necessary services and configurations.
Future<void> initializeApp() async {
  // Lazy put NetworkChecker service for later use.
  Get.lazyPut(() => NetworkChecker(), fenix: true);
  // Initialize core services and app configuration concurrently.
  await _initializeCoreServices();
  //await _initializeAppConfig();
}

/// Initializes core services required by the application.
Future<void> _initializeCoreServices() async {
  //await registerBaseServices();
  await setupGlobalServices();
  await initAppControllers();
}
