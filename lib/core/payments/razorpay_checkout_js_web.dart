import 'dart:js_interop';

/// Minimal `window` binding for `_rzpCheckoutOpen` (see [web/index.html]).
@JS()
extension type _WindowRzp._(JSObject _) implements JSObject {
  external JSPromise<JSString> _rzpCheckoutOpen(JSString optionsJson);
}

@JS('window')
external _WindowRzp get _window;

/// Opens Checkout via [window._rzpCheckoutOpen].
Future<String> openRazorpayCheckoutJson(String optionsJson) async {
  try {
    final promise = _window._rzpCheckoutOpen(optionsJson.toJS);
    final jsOut = await promise.toDart;
    return jsOut.toDart;
  } catch (_) {
    throw StateError(
      'Razorpay web bridge is not loaded. Do a full app restart '
      '(not hot reload) so web/index.html scripts are reloaded.',
    );
  }
}
