import 'landing_page_desktop_host_stub.dart'
    if (dart.library.html) 'landing_page_desktop_host_web.dart'
    as impl;

/// True on Windows desktop browsers (web) — [defaultTargetPlatform] is not
/// reliable for Flutter web.
bool isLikelyWindowsDesktopHost() => impl.isLikelyWindowsDesktopHost();
