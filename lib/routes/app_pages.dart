import 'package:get/get.dart';
import '../app/screens/base_page/views/base_binding.dart';
import '../app/screens/base_page/views/base_page_view.dart';
import '../app/screens/authentication/forgot_password/forgot_password.dart';
import '../middlewares/app_middleware.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = _Paths.basePage;

  static GetPage get unknownPage => routes.first;

  static final routes = [
    GetPage(name: _Paths.basePage, page: () => BasePageView()),
    GetPage(name: _Paths.forgotPassword, page: () => const ForgotPassword()),
    // GetPage(
    //   name: AppRoutes.location,
    //   page: () => LocationScreen(),
    //   middlewares: [AppMiddleware()],
    //   children: const [],
    // ),
    // GetPage(
    //   name: AppRoutes.home,
    //   page: () => Home(),
    //   middlewares: [AppMiddleware()],
    //   children: const [],
    //   binding: BasePageBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.onBoarding,
    //   page: () => OnboardingScreen(),
    //   middlewares: [AppMiddleware()],
    //   children: const [],
    //   binding: BasePageBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.categories,
    //   page: () => AllCategory(),
    //   middlewares: [AppMiddleware()],
    //   children: const [],
    //   binding: BasePageBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.profile,
    //   page: () => ProfileScreen(),
    //   middlewares: [AppMiddleware()],
    //   children: const [],
    //   binding: BasePageBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.themeSettings,
    //   page: () => const ThemeSettingsScreen(), // Placeholder for auth page
    //   //middlewares: [AppMiddleware()],
    //   // children: const [],
    //   //binding: BasePageBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.login,
    //   page: () => LoginScreen(),
    //   middlewares: [AppMiddleware()],
    //   children: const [],
    // ),
    // GetPage(
    //   name: AppRoutes.otp,
    //   page: () => OtpVerificationScreen(),
    //   middlewares: [AppMiddleware()],
    //   children: const [],
    //   binding: BasePageBinding(),
    // ),
    // GetPage(
    //   name: AppRoutes.explore,
    //   page: () => ExploreScreen(),
    //   middlewares: [AppMiddleware()],
    //   children: const [],
    // ),
    // GetPage(
    //   name: AppRoutes.personalInfo,
    //   page: () => const PersonalInfoScreen(),
    //   middlewares: [AppMiddleware()],
    //   children: const [],
    // ),
  ];
}
