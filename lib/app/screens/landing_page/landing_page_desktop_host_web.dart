import 'dart:html' as html;

/// True when the browser reports Windows on a non-mobile user agent.
bool isLikelyWindowsDesktopHost() {
  final ua = html.window.navigator.userAgent.toLowerCase();
  if (ua.contains('iphone') ||
      ua.contains('ipad') ||
      ua.contains('android') ||
      ua.contains('mobile')) {
    return false;
  }
  return ua.contains('windows') || ua.contains('win64') || ua.contains('win32');
}
