import 'web_url_helper_stub.dart'
    if (dart.library.html) 'web_url_helper_web.dart'
    as impl;

/// On web: updates the browser URL to [path]. On other platforms: no-op.
void updateBrowserUrl(String path) => impl.updateBrowserUrl(path);

/// On web: replaces current history entry with [path]. On other platforms: no-op.
void replaceBrowserUrl(String path) => impl.replaceBrowserUrl(path);

/// On web: listens for browser back button and calls [onBack]. On other platforms: no-op.
void setupBrowserBackListener(void Function() onBack) =>
    impl.setupBrowserBackListener(onBack);
