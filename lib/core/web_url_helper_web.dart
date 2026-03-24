import 'dart:html' as html;

/// Updates the browser address bar to [path] so the URL reflects the current route.
void updateBrowserUrl(String path) {
  html.window.history.pushState(null, '', path);
}

/// Replaces the current history entry with [path] (used when going back).
void replaceBrowserUrl(String path) {
  html.window.history.replaceState(null, '', path);
}

/// Listens for the browser back button and invokes [onBack].
void setupBrowserBackListener(void Function() onBack) {
  html.window.addEventListener('popstate', (_) {
    onBack();
  });
}
