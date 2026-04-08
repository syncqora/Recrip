import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/di/get_injector.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../routes/app_pages.dart';
import '../../../../shared/constants/box_constants.dart';
import '../../../../shared/utils/app_exceptions.dart';
import '../../../../shared/utils/auth_landing.dart';
import '../../../../shared/utils/base_controller.dart';
import '../../admin/dashboard/admin_dashboard.dart';
import '../../landing_page/landing_page.dart';
import '../../dashboard/views/dashboard/dashboard.dart';

class BasePageController extends BaseController {
  BasePageController() {
    currentPage = const LandingPage();
    appBarTitle = ''.obs;
  }

  void _setShellAndNavForPath(String path) {
    currentPage = path == AppRoutes.adminDashboard
        ? const AdminDashboard()
        : const Dashboard();
    appBarTitle = appNav.getTitleOfPath(path).obs;
    appNav.currentPage.value = '';
    appNav.pageStack.clear();
    appNav.currentPage.value = path;
    appNav.pageStack.add(path);
    appNav.updateAppBarTitle(path);
  }

  GlobalKey<ScaffoldState>? _scaffoldKey;
  late RxString appBarTitle;
  late Widget currentPage;

  @override
  Future<void> onInit() async {
    await fetchArgs();
    super.onInit();
  }

  Future<void> fetchArgs() async {
    try {
      await setDefaultLanding();
    } catch (e) {
      log("Error fetching arguments: $e");
    }
  }

  /// Validates the session via `/auth/introspect` when a token exists, then lands on dashboard or login.
  Future<void> setDefaultLanding() async {
    try {
      log(
        "setDefaultLanding called isUserLoggedIn=${appSettingsController.isUserLoggedIn.value}",
      );
      final auth = Get.find<AuthService>();
      final token = auth.accessToken;

      final requestedPath = _requestedWebPath();

      if (token != null && token.isNotEmpty) {
        try {
          final intro = await auth.introspect();
          if (intro.active) {
            appSettingsController.isUserLoggedIn.value = true;
            boxDb.writeBoolValue(key: BoxConstants.isUserLoggedIn, value: true);
            if (requestedPath != null && _isSupportedPath(requestedPath)) {
              if (_isProtectedPath(requestedPath) || _isPublicPath(requestedPath)) {
                _applyLandingPath(_normalizePublicPath(requestedPath));
                return;
              }
            }
            _applyLandingPath(
              AuthLanding.path(intro: intro, persistedEmail: auth.loggedInEmail),
            );
            return;
          }
          await auth.clearLocalSessionOnly();
          appSettingsController.isUserLoggedIn.value = false;
        } on ApiException catch (e) {
          if (e.statusCode == 401) {
            await auth.clearLocalSessionOnly();
            appSettingsController.isUserLoggedIn.value = false;
          } else {
            appSettingsController.isUserLoggedIn.value = true;
            boxDb.writeBoolValue(key: BoxConstants.isUserLoggedIn, value: true);
            if (requestedPath != null && _isSupportedPath(requestedPath)) {
              if (_isProtectedPath(requestedPath) || _isPublicPath(requestedPath)) {
                _applyLandingPath(_normalizePublicPath(requestedPath));
                return;
              }
            }
            _applyLandingPath(
              AuthLanding.path(persistedEmail: auth.loggedInEmail),
            );
            return;
          }
        } catch (_) {
          appSettingsController.isUserLoggedIn.value = true;
          boxDb.writeBoolValue(key: BoxConstants.isUserLoggedIn, value: true);
          if (requestedPath != null && _isSupportedPath(requestedPath)) {
            if (_isProtectedPath(requestedPath) || _isPublicPath(requestedPath)) {
              _applyLandingPath(_normalizePublicPath(requestedPath));
              return;
            }
          }
          _applyLandingPath(
            AuthLanding.path(persistedEmail: auth.loggedInEmail),
          );
          return;
        }
      } else {
        await auth.clearLocalSessionOnly();
        appSettingsController.isUserLoggedIn.value = false;
      }

      if (appSettingsController.isUserLogout.value) {
        appSettingsController.isUserLogout.value = false;
      }

      if (requestedPath != null && _isSupportedPath(requestedPath)) {
        if (_isProtectedPath(requestedPath)) {
          _applyLandingPath(AppRoutes.home);
          return;
        }
        if (_isPublicPath(requestedPath)) {
          _applyLandingPath(_normalizePublicPath(requestedPath));
          return;
        }
      }
      _applyLandingPath(AppRoutes.home);
    } catch (e) {
      log("Error setDefaultLanding: $e");
      _applyLandingPath(AppRoutes.home);
    }
  }

  String? _requestedWebPath() {
    if (!GetPlatform.isWeb) return null;
    final raw = Uri.base.path;
    if (raw.isEmpty || raw == '/') return AppRoutes.basePage;
    return raw.replaceFirst(RegExp(r'/+$'), '');
  }

  bool _isSupportedPath(String path) {
    return _isProtectedPath(path) || _isPublicPath(path);
  }

  bool _isProtectedPath(String path) {
    return path == AppRoutes.dashboard || path == AppRoutes.adminDashboard;
  }

  bool _isPublicPath(String path) {
    return path == AppRoutes.basePage ||
        path == AppRoutes.home ||
        path == AppRoutes.login ||
        path == AppRoutes.forgotPassword ||
        path == AppRoutes.resetPassword ||
        path == AppRoutes.otp;
  }

  String _normalizePublicPath(String path) {
    if (path == AppRoutes.basePage) {
      return AppRoutes.home;
    }
    return path;
  }

  void _applyLandingPath(String path) {
    final title = appNav.getTitleOfPath(path);
    final newPage = appNav.getViewForPath(path);
    appNav.currentPage.value = '';
    appNav.pageStack.clear();
    appNav.currentPage.value = path;
    appNav.pageStack.add(path);
    log("path:: $path");
    updatePage(title, newPage, null);
  }

  void setScaffoldKey(GlobalKey<ScaffoldState> key) {
    _scaffoldKey = key;
  }

  void updatePage(String newPageTitle, Widget newPage, dynamic arguments) {
    log("updatePage:: $newPageTitle");
    appBarTitle.value = newPageTitle;
    currentPage = newPage;
    update();
  }
}
