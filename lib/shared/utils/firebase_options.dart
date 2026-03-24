import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  // Allow manual override of platform detection (useful for testing or when platform detection fails)
  static TargetPlatform? _overridePlatform;

  /// Manually set the platform to use for Firebase options.
  /// This is useful when platform detection fails or for desktop platforms.
  static void setPlatformOverride(TargetPlatform? platform) {
    _overridePlatform = platform;
  }

  /// Safely detects the platform, falling back to multiple methods
  /// Note: This should never be called on web (kIsWeb is checked in currentPlatform)
  static TargetPlatform _detectPlatform() {
    // Use override if set
    if (_overridePlatform != null) {
      return _overridePlatform!;
    }

    // Safety check: if somehow we're on web, return a default (should never happen)
    if (kIsWeb) {
      if (kDebugMode) {
        print(
          'Warning: _detectPlatform called on web platform. This should not happen.',
        );
      }
      // Return Android as fallback, but web should be handled in currentPlatform
      return TargetPlatform.android;
    }

    // Try using Flutter's defaultTargetPlatform
    // This is the most reliable cross-platform method
    try {
      final platform = defaultTargetPlatform;

      // Map the detected platform
      switch (platform) {
        case TargetPlatform.android:
        case TargetPlatform.iOS:
        case TargetPlatform.macOS:
        case TargetPlatform.windows:
        case TargetPlatform.linux:
        case TargetPlatform.fuchsia:
          return platform;
        default:
          // Unknown platform, default to Android
          if (kDebugMode) {
            print(
              'Unknown platform detected: $platform. Defaulting to Android.',
            );
          }
          return TargetPlatform.android;
      }
    } catch (e) {
      // If platform detection fails completely, default to Android
      // This can happen in test environments or when Platform._operatingSystem is unavailable
      if (kDebugMode) {
        print(
          'Platform detection via defaultTargetPlatform failed: $e. Defaulting to Android.',
        );
      }
      return TargetPlatform.android;
    }
  }

  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }

    // Wrap everything in try-catch to handle any platform detection errors
    try {
      // Use safe platform detection
      final platform = _detectPlatform();

      // TODO find a way to get production or developmenrt
      switch (platform) {
        case TargetPlatform.android:
          return
          //AppConstants.appEnvironment == "prod"
          // ?
          android;
        //  : AppConstants.appEnvironment == "preprod"
        //  ? android_preprod
        //  : android_dev;

        case TargetPlatform.iOS:
          return
          //AppConstants.appEnvironment == "prod"
          //    ?
          ios;
        //   : AppConstants.appEnvironment == "preprod"
        //   ? ios_preprod
        //  : ios_dev;
        case TargetPlatform.macOS:
        case TargetPlatform.windows:
        case TargetPlatform.linux:
          // For desktop platforms (Windows, Linux, macOS), fall back to Android options
          // This is common for development/testing purposes
          // You can configure proper desktop options later if needed
          if (kDebugMode) {
            print(
              'Using Android Firebase options for desktop platform: $platform',
            );
          }
          return android;
        default:
          // For any other platform, default to Android
          if (kDebugMode) {
            print(
              'Unknown platform detected: $platform. Defaulting to Android.',
            );
          }
          return android;
      }
    } catch (e) {
      // If anything goes wrong with platform detection, default to Android
      if (kDebugMode) {
        print(
          'Error in currentPlatform getter: $e. Defaulting to Android Firebase options.',
        );
      }
      return android;
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: "AIzaSyCeNuwx1IjRg4rexs7XJ28XQr8uIDccow4",
    authDomain: "splitapp-527a0.firebaseapp.com",
    projectId: "splitapp-527a0",
    storageBucket: "splitapp-527a0.firebasestorage.app",
    messagingSenderId: "971653692386",
    appId: "1:971653692386:web:a0bd48f425e142846597bb",
    measurementId: "G-YZFGN2CBZ1",
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAFFk0k1-EiGheNJ0mic8-3cXvQIgjQl1Q',
    appId: '1:971653692386:android:b3fe10858a0750b86597bb',
    messagingSenderId: '971653692386',
    projectId: 'splitapp-527a0',
    // databaseURL:
    //     'https://coffeeweb-354711-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'splitapp-527a0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDLzNlGX2yYocWXGKANVVTnpaMPu3TsCro',
    appId: '1:971653692386:ios:18230d09a27d53e36597bb',
    messagingSenderId: '971653692386',
    projectId: 'splitapp-527a0',
    // databaseURL:
    //     'https://coffeeweb-354711-default-rtdb.asia-southeast1.firebasedatabase.app',
    storageBucket: 'splitapp-527a0.firebasestorage.app',
    androidClientId:
        '233601607029-aoplm413tur116u6unhv01bofd6c6i9o.apps.googleusercontent.com',
    iosClientId:
        '233601607029-ll5qspcrva6rd176chjpvbad759s55fn.apps.googleusercontent.com',
    iosBundleId: 'com.hoft.app',
  );

  // static const FirebaseOptions macos = FirebaseOptions(
  //   apiKey: 'AIzaSyAorp4fwVCOcDixUKdEsuSwIv4V-7YbxzY',
  //   appId: '1:138705464334:ios:84f50f2bf6a4449e62e05f',
  //   messagingSenderId: '138705464334',
  //   projectId: 'coffeeweb-354711',
  //   databaseURL:
  //       'https://coffeeweb-354711-default-rtdb.asia-southeast1.firebasedatabase.app',
  //   storageBucket: 'coffeeweb-354711.appspot.com',
  //   androidClientId:
  //       '138705464334-85e8q35mpmh0rt397r6d7sa2b1suio69.apps.googleusercontent.com',
  //   iosClientId:
  //       '138705464334-he8rblq83c9hltmbmpdfiehg3bfasuqn.apps.googleusercontent.com',
  //   iosBundleId: 'com.coffeeweb.app',
  // );
}
