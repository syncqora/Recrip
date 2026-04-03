import '../constants/app_strings.dart';

/// Validation helpers for the login form (aligned with typical password policy).
abstract final class AuthValidators {
  AuthValidators._();

  static final _email = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static bool isValidEmail(String value) {
    final v = value.trim();
    return v.isNotEmpty && _email.hasMatch(v);
  }

  /// Returns `null` if valid, otherwise a localized error string.
  static String? emailFieldError(String value) {
    final v = value.trim();
    if (v.isEmpty) return null;
    if (!isValidEmail(v)) return AppStrings.loginEmailInvalid;
    return null;
  }

  static bool isStrongPassword(String password) {
    if (password.length < 8) return false;
    final hasLower = RegExp(r'[a-z]').hasMatch(password);
    final hasUpper = RegExp(r'[A-Z]').hasMatch(password);
    final hasDigit = RegExp(r'[0-9]').hasMatch(password);
    final hasSpecial = RegExp(r'[^a-zA-Z0-9]').hasMatch(password);
    return hasLower && hasUpper && hasDigit && hasSpecial;
  }

  static String? passwordFieldError(String password) {
    if (password.isEmpty) return null;
    if (password.length < 8) return AppStrings.loginPasswordTooShort;
    if (!isStrongPassword(password)) return AppStrings.loginPasswordWeak;
    return null;
  }

  /// Used when the user taps Login (includes required checks).
  static String? emailErrorForSubmit(String value) {
    final v = value.trim();
    if (v.isEmpty) return AppStrings.loginEmailRequired;
    if (!isValidEmail(v)) return AppStrings.loginEmailInvalid;
    return null;
  }

  /// Used when the user taps Login (includes required checks).
  static String? passwordErrorForSubmit(String password) {
    if (password.isEmpty) return AppStrings.loginPasswordRequired;
    return passwordFieldError(password);
  }
}
