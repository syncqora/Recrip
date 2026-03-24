/// No-op on non-web. Web implementation updates browser URL to match route.
void updateBrowserUrl(String path) {}

/// No-op on non-web. Web implementation replaces current history entry.
void replaceBrowserUrl(String path) {}

/// No-op on non-web. Web implementation listens for browser back button.
void setupBrowserBackListener(void Function() onBack) {}
