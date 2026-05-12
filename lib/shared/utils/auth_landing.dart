import '../../routes/app_pages.dart';
import 'jwt_utils.dart';

/// Chooses member vs admin shell after login or session restore from JWT roles.
abstract final class AuthLanding {
  AuthLanding._();

  /// Uses [accessToken] payload: `roles` containing `super_admin` → admin shell.
  static String path({required String? accessToken}) {
    if (JwtUtils.hasSuperAdminRole(accessToken)) {
      return AppRoutes.adminDashboard;
    }
    return AppRoutes.dashboard;
  }
}
