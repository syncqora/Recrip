import '../../core/models/auth/introspect_response.dart';
import '../../routes/app_pages.dart';

/// Chooses member vs admin shell after login or session restore.
abstract final class AuthLanding {
  AuthLanding._();

  static const _adminEmail = 'admin@gmail.com';
  static const _adminUsername = 'admin';

  /// Prefer [intro] when available (e.g. after `/auth/introspect`); fall back to [persistedEmail].
  static String path({IntrospectResponse? intro, String? persistedEmail}) {
    final username = intro?.username?.trim().toLowerCase();
    if (username == _adminUsername) {
      return AppRoutes.adminDashboard;
    }
    final email = persistedEmail?.trim().toLowerCase();
    if (email == _adminEmail) {
      return AppRoutes.adminDashboard;
    }
    return AppRoutes.dashboard;
  }
}
