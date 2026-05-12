import 'auth_validators.dart';

/// Validators for the super-admin tenant & user onboarding form.
abstract final class AdminTenantFormValidators {
  AdminTenantFormValidators._();

  static final _slugPattern = RegExp(r'^[a-z0-9]+(?:-[a-z0-9]+)*$');
  static final _usernamePattern = RegExp(r'^[a-zA-Z0-9_]{3,32}$');
  static final _personNamePattern = RegExp(r"^[a-zA-Z\s'.-]{1,64}$");

  /// Non-empty after trim.
  static String? requiredTrimmed(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  /// Tenant display name.
  static String? tenantName(String? value) {
    final req = requiredTrimmed(value);
    if (req != null) return req;
    if (value!.trim().length > 200) {
      return 'Name must be at most 200 characters';
    }
    return null;
  }

  /// URL slug: lowercase letters, digits, single hyphens between segments.
  static String? tenantSlug(String? value) {
    final req = requiredTrimmed(value);
    if (req != null) return req;
    final s = value!.trim().toLowerCase();
    if (!_slugPattern.hasMatch(s)) {
      return 'Use lowercase letters, numbers, and hyphens (e.g. acme-corp)';
    }
    return null;
  }

  /// Hostname-style domain.
  static String? tenantDomain(String? value) {
    final req = requiredTrimmed(value);
    if (req != null) return req;
    final s = value!.trim();
    if (s.contains(' ') || s.contains('://')) {
      return 'Enter a domain without scheme (e.g. acme.example.com)';
    }
    final uri = Uri.tryParse('https://$s');
    if (uri == null || uri.host.isEmpty) {
      return 'Enter a valid domain';
    }
    final authority = uri.hasPort ? '${uri.host}:${uri.port}' : uri.host;
    if (authority != s) {
      return 'Enter a valid domain';
    }
    return null;
  }

  /// `http` or `https` URL.
  static String? logoUrl(String? value) {
    final req = requiredTrimmed(value);
    if (req != null) return req;
    final s = value!.trim();
    final uri = Uri.tryParse(s);
    if (uri == null ||
        !uri.hasScheme ||
        (uri.scheme != 'http' && uri.scheme != 'https') ||
        uri.host.isEmpty) {
      return 'Enter a valid http(s) URL';
    }
    return null;
  }

  /// Short description for the tenant.
  static String? tenantDescription(String? value) {
    final req = requiredTrimmed(value);
    if (req != null) return req;
    if (value!.trim().length < 4) {
      return 'Description must be at least 4 characters';
    }
    if (value.trim().length > 2000) {
      return 'Description must be at most 2000 characters';
    }
    return null;
  }

  /// Login username for the new user.
  static String? username(String? value) {
    final req = requiredTrimmed(value);
    if (req != null) return req;
    if (!_usernamePattern.hasMatch(value!.trim())) {
      return 'Use 3–32 characters: letters, numbers, or underscore';
    }
    return null;
  }

  /// Same rules as login email.
  static String? email(String? value) {
    return AuthValidators.emailErrorForSubmit(value ?? '');
  }

  /// Same rules as login password.
  static String? password(String? value) {
    return AuthValidators.passwordErrorForSubmit(value ?? '');
  }

  /// Given / family name.
  static String? firstName(String? value) => _personName(value, 'First name');

  /// Given / family name.
  static String? lastName(String? value) => _personName(value, 'Last name');

  static String? _personName(String? value, String fieldLabel) {
    final req = requiredTrimmed(value);
    if (req != null) return req;
    if (!_personNamePattern.hasMatch(value!.trim())) {
      return '$fieldLabel may only include letters, spaces, hyphen, apostrophe, or period';
    }
    return null;
  }
}
