import 'package:flutter_web_plugins/flutter_web_plugins.dart';

/// Uses path-based URLs on web (e.g. /forgot-password) so the address bar
/// reflects the current route when navigating with Get.toNamed().
void setUpUrlStrategy() {
  setUrlStrategy(PathUrlStrategy());
}
