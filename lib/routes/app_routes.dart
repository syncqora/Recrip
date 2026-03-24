part of 'app_pages.dart';

abstract class AppRoutes {
  static const basePage = _Paths.basePage;
  static const home = _Paths.home;
  static const onBoarding = _Paths.onBoarding;
  static const login = _Paths.login;
  static const otp = _Paths.otp;
  static const profile = _Paths.profile;
  static const categories = _Paths.categories;
  static const support = _Paths.support;
  static const explore = _Paths.explore;
  static const rewards = _Paths.rewards;
  static const qrView = _Paths.qrView;
  static const notifications = _Paths.notifications;
  static const categoryDetail = _Paths.categoryDetail;
  static const themeSettings = _Paths.themeSettings;
  static const location = _Paths.location;
  static const personalInfo = _Paths.personalInfo;
  static const forgotPassword = _Paths.forgotPassword;
  static const resetPassword = _Paths.resetPassword;
  static const dashboard = _Paths.dashboard;
  static const adminDashboard = _Paths.adminDashboard;
  AppRoutes._();
}

abstract class _Paths {
  static const basePage = '/';
  static const home = '/home';
  static const onBoarding = '/onBoarding';
  static const login = '/login';
  static const otp = '/otp';
  static const profile = '/profile';
  static const categories = '/categories';
  static const support = '/support';
  static const explore = '/explore';
  static const rewards = '/rewards';
  static const qrView = '/qrView';
  static const notifications = '/notifications';
  static const categoryDetail = '/categoryDetail';
  static const themeSettings = '/themeSettings';
  static const location = '/location';
  static const personalInfo = '/personal-info';
  static const forgotPassword = '/forgot-password';
  static const resetPassword = '/reset-password';
  static const dashboard = '/dashboard';
  static const adminDashboard = '/admin-dashboard';
  _Paths._();
}
