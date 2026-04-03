import 'package:flutter/foundation.dart';

// Conditional import: dart:io on non-web, platform_stub on web
import 'dart:io' if (dart.library.html) 'platform_stub.dart' as io;

bool get isAndroid {
  // Always return false on web
  if (kIsWeb) return false;

  // Use override if set
  if (_isAndroid != null) return _isAndroid!;

  // On non-web platforms, try to access Platform from dart:io
  // The conditional import ensures io is dart:io on non-web
  try {
    // Check kIsWeb again to be extra safe
    if (!kIsWeb) {
      // Access Platform - this will work on non-web (dart:io)
      // On web, io is dart:html which doesn't have Platform, but we return early
      return io.Platform.isAndroid;
    }
  } catch (e) {
    // If Platform access fails for any reason, return false
    if (kDebugMode && !kIsWeb) {
      print('Error checking Android platform: $e');
    }
  }
  return false;
}

bool? _isAndroid;

bool get isIOS {
  // Always return false on web
  if (kIsWeb) return false;

  // Use override if set
  if (_isIOS != null) return _isIOS!;

  // On non-web platforms, try to access Platform from dart:io
  try {
    if (!kIsWeb) {
      return io.Platform.isIOS;
    }
  } catch (e) {
    if (kDebugMode && !kIsWeb) {
      print('Error checking iOS platform: $e');
    }
  }
  return false;
}

bool? _isIOS;

void setPlatformForTesting({bool? android, bool? ios}) {
  _isAndroid = android;
  _isIOS = ios;
}

void resetPlatform() {
  _isAndroid = null;
  _isIOS = null;
}
