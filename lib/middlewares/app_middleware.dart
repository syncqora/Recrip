import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../core/di/get_injector.dart';

class AppMiddleware extends GetMiddleware {
  /// Redirects to the specified route and logs the redirection event.
  @override
  RouteSettings? redirect(String? route) {
    // You can perform redirection here
    appLog.info("PAGE REDIRECT TO: $route");
    return super.redirect(route);
  }

  /// Logs the name of the page being called before returning the original page.
  @override
  GetPage? onPageCalled(GetPage? page) {
    // Called when the page is called
    //appLog.info('PAGE CALLED: ${page?.name}');
    return super.onPageCalled(page);
  }

  /// Logs the start of the binding process before returning the original bindings.
  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    // Called before bindings are initialized
    appLog.info('BINDING START');
    return super.onBindingsStart(bindings);
  }

  /// Logs when the page build process starts and returns the original page builder.
  @override
  GetPageBuilder? onPageBuildStart(GetPageBuilder? page) {
    // Called before the page is built
    appLog.info('PAGE START');
    return super.onPageBuildStart(page);
  }

  /// Called after the page is built
  @override
  Widget onPageBuilt(Widget page) {
    // Called after the page is built
    appLog.info('PAGE BUILT');
    return super.onPageBuilt(page);
  }

  /// Called when the page is disposed
  @override
  void onPageDispose() {
    // Called when the page is disposed
    appLog.info('PAGE DISPOSED');
    super.onPageDispose();
  }
}
