import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import '../../navigation/navigation_service.dart';
import '../../shared/themes/theme_service.dart';
import '../../shared/utils/app_functions.dart';
import '../../shared/utils/app_logger.dart';
import '../../shared/utils/logx.dart';
import '../controllers/app_settings_controller.dart';
import '../controllers/ui_controller.dart';
import '../services/auth_service.dart';
import '../services/box_db.dart';
import '../../network/api/api.dart';
import '../../network/repo/repo.dart';
import '../../network/services/services.dart';
import '../services/supabase_services.dart';

GetIt di = GetIt.instance;

Future<void> setupBaseAppServices() async {
  Get.lazyPut<BoxDb>(() => BoxDb(), fenix: true);
  // if (!di.isRegistered<ThemeService>()) {
  //   di.registerLazySingleton<ThemeService>(() => ThemeService());
  // }
}

Future<void> setupGlobalServices() async {
  await GetStorage.init();
  if (!di.isRegistered<LogX>()) {
    di.registerLazySingleton<LogX>(
      () => LogX(
        appTitle: 'Split App',
        is24HourFormat: true,
        useBoxyFormat: true,
        includeTimestamps: true,
        currentLogLevel: LogLevel.debug,
      ),
    );
  }
  if (!di.isRegistered<AppLogger>()) {
    di.registerSingleton<AppLogger>(AppLogger());
  }

  // if (!di.isRegistered<SupaBaseServices>()) {
  //   di.registerLazySingleton<SupaBaseServices>(() => SupaBaseServices());
  // }

  // if (!di.isRegistered<FirebaseServices>()) {
  //   di.registerLazySingleton<FirebaseServices>(() => FirebaseServices());
  // }

  if (!di.isRegistered<AppFunctions>()) {
    di.registerLazySingleton<AppFunctions>(() => AppFunctions());
  }

  if (!di.isRegistered<ThemeService>()) {
    di.registerLazySingleton<ThemeService>(() => ThemeService());
  }

  if (!Get.isRegistered<ApiServices>(tag: ApiServicesTag.auth)) {
    Get.put<ApiServices>(
      ApiServices(ApiEndPoints.authBaseUrl),
      tag: ApiServicesTag.auth,
      permanent: true,
    );
  }
  if (!Get.isRegistered<ApiServices>(tag: ApiServicesTag.dataManagement)) {
    Get.put<ApiServices>(
      ApiServices(ApiEndPoints.dataManagementBaseUrl),
      tag: ApiServicesTag.dataManagement,
      permanent: true,
    );
  }
  if (!Get.isRegistered<AuthRepository>()) {
    Get.put<AuthRepository>(
      AuthRepo(services: AuthServices()),
      permanent: true,
    );
  }
  if (!Get.isRegistered<SubscriptionRepository>()) {
    Get.put<SubscriptionRepository>(
      SubscriptionRepo(services: SubscriptionServices()),
      permanent: true,
    );
  }
  if (!Get.isRegistered<MemberRepository>()) {
    Get.put<MemberRepository>(
      MemberRepo(services: MemberServices()),
      permanent: true,
    );
  }
  if (!Get.isRegistered<AuthService>()) {
    Get.put<AuthService>(
      AuthService(Get.find<AuthRepository>()),
      permanent: true,
    );
  }
}

/// Registers the application controllers required at the start of the application.
/// This method initializes and registers the AppSettingsController as a permanent instance.
Future<void> initAppControllers() async {
  Get.put<UiController>(UiController(), permanent: true);
  Get.put<AppSettingsController>(AppSettingsController(), permanent: true);
  Get.put<NavigationService>(NavigationService(), permanent: true);
  //Get.put<AppDataController>(AppDataController(), permanent: true);
}

/// Provides a globally accessible instance of the supabase.
SupaBaseServices get sbServices => di<SupaBaseServices>();

/// Provides a globally accessible instance of the AppLogger.
AppLogger get appLog => di<AppLogger>();

LogX get logger => di<LogX>();

/// Provides a globally accessible instance of the BoxDb.
BoxDb get boxDb => Get.find<BoxDb>();

/// Provides a globally accessible instance of the Firebase.
// FirebaseServices get fbServices => di<FirebaseServices>();

/// Provides a globally accessible instance of the AppFunctions
AppFunctions get appFunctions => di<AppFunctions>();

/// Provides a globally accessible instance of ThemeService
// ThemeService get themeServices => di<ThemeService>();

///App navigation will be available through this.
NavigationService get appNav => Get.find<NavigationService>();

///Show the ui controller from here
UiController get appUi => Get.find<UiController>();
