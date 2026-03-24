import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:saas/shared/widgets/base/ui_state.dart';
import 'error_display.dart';
import 'no_internet.dart';

/// A [BaseBody] widget that handles various UI states and displays the appropriate
/// content based on the current state. It can show loading indicators, error messages,
/// internet disconnected state, and supports displaying a custom overlay with an option
/// to dismiss the overlay by tapping outside of it.
class BaseBody extends StatelessWidget {
  /// The main content to be displayed within the [BaseBody].
  final Widget body;

  /// A callback function that refreshes the view when triggered. It is mainly used
  /// with pull-to-refresh functionality.
  final Future<void> Function()? refreshView;

  /// Determines whether the body should be displayed in full view.
  final bool fullView;

  /// Controls whether the pull-to-refresh functionality should be enabled.
  final bool enablePullToRefresh;

  /// A callback to toggle the visibility of the overlay. If provided, this function
  /// will be called when the overlay is dismissed by tapping outside.
  final VoidCallback? toggleOverlay;

  /// A reactive [Rx] variable that represents the current UI state (e.g., loading, error).
  /// It defaults to [UiState.defaultView] if not provided.
  final Rx<UiState> uiState;

  /// A reactive [RxBool] that determines if the custom overlay should be shown.
  /// It defaults to `false` if not provided.
  final RxBool showOverlay;

  /// An optional widget that represents the custom overlay content.
  /// This widget is displayed when [showOverlay] is `true`.
  final Widget? customOverlay;

  /// A flag that controls whether the overlay should be dismissed when tapping outside of it.
  /// Defaults to `true`, meaning the overlay will be dismissed by tapping outside.
  final bool dismissOnTapOutside;

  ///Make a overlay loading true or false, that makes no effect on loading view.
  final bool overlayLoading;

  ///Make a undefined height and width
  final bool selfContainer;

  ///Make a self refresh body
  final bool selfRefreshBody;

  ///Show the try again button from internet disconnected view
  final bool showTryAgain;

  /// Constructor for the [BaseBody] widget.
  ///
  /// [body] is the required widget that represents the main content.
  ///
  /// [refreshView] is a callback function used for refreshing the view, primarily
  /// for pull-to-refresh functionality.
  ///
  /// [uiState] is an optional reactive state that controls what UI is displayed.
  /// Defaults to [UiState.defaultView].
  ///
  /// [showOverlay] is an optional reactive flag that determines if the custom overlay
  /// should be shown. Defaults to `false`.
  ///
  /// [customOverlay] is an optional widget that defines the content of the overlay.
  ///
  /// [dismissOnTapOutside] controls whether the overlay should be dismissed when
  /// tapping outside. Defaults to `true`.
  BaseBody({
    super.key,
    required this.body,
    required this.refreshView,
    this.fullView = false,
    this.enablePullToRefresh = true,
    Rx<UiState>? uiState, // Optional, default to UiState.defaultView
    RxBool? showOverlay, // Optional, default to false
    this.customOverlay,
    this.toggleOverlay, // Nullable custom overlay widget
    this.dismissOnTapOutside = true,
    this.overlayLoading = true,
    this.selfContainer = false,
    this.selfRefreshBody = false,
    this.showTryAgain = true,
  }) : uiState = uiState ?? UiState.none.obs,
       showOverlay = showOverlay ?? false.obs;

  /// Builds the widget tree of the [BaseBody].
  ///
  /// It listens to the reactive variables [uiState] and [showOverlay] and updates
  /// the UI accordingly. The [Stack] widget allows displaying multiple layers,
  /// such as the body content, a loading overlay, and a custom overlay.
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Listen to uiState changes using Obx and update the body accordingly
        Obx(
          () => Platform.isAndroid
              ? _buildBodyByState(uiState.value)
              : _buildBodyByState(uiState.value),
        ),
        // Show custom overlay if showOverlay is true
        Obx(
          () => (showOverlay.value && customOverlay != null)
              ? _buildCustomDialogOverlay()
              : const SizedBox.shrink(),
        ),
        // Show loading overlay if the current state is loading
        Obx(
          () => uiState.value == UiState.loading
              ? _buildLoadingOverlay()
              : const SizedBox.shrink(),
        ),
      ],
    );
  }

  /// Builds the content of the body based on the current [uiState].
  ///
  /// If the [uiState] is [UiState.errorView], it displays an error message
  /// with a retry option. If it's [UiState.internetDisconnected], it shows a
  /// no internet connection view with a refresh option. If it's in any other
  /// state, the main body content is displayed.
  Widget _buildBodyByState(UiState uiState) {
    switch (uiState) {
      case UiState.errorView:
        return ErrorDataDisplay(onRetry: refreshView!);
      case UiState.internetDisconnected:
        return NoInternet(refresh: refreshView!, showTryAgain: showTryAgain);
      case UiState.defaultView:
      case UiState.loading:
        return enablePullToRefresh
            ? RefreshIndicator(
                color: Get.theme.progressIndicatorTheme.color,
                backgroundColor:
                    Get.theme.progressIndicatorTheme.refreshBackgroundColor,
                onRefresh: refreshView!,
                child: selfRefreshBody
                    ? body
                    : SafeArea(
                        child: SingleChildScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          child: selfContainer
                              ? body
                              : SafeArea(
                                  child: SizedBox(
                                    width: Get.width,
                                    height: fullView
                                        ? Get.height
                                        : (Get.height -
                                              Get.mediaQuery.viewPadding.top),
                                    child: body,
                                  ),
                                ),
                        ),
                      ),
              )
            : SafeArea(child: body);
      case UiState.none:
        return const SizedBox();
    }
  }

  /// Builds the loading overlay which is displayed when the [uiState] is set to loading.
  ///
  /// The overlay is semi-transparent and displays a loading indicator (e.g., [ElasticLoader]).
  Widget _buildLoadingOverlay() {
    return Positioned.fill(
      child: overlayLoading
          ? AbsorbPointer(
              absorbing: true,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
                child: const Center(child: CircularProgressIndicator()),
              ),
            )
          : Container(
              width: Get.width,
              height: Get.height - 50,
              color: Get.theme.primaryColor,
              child: const Center(child: CircularProgressIndicator()),
            ),
    );
  }

  /// Builds the custom overlay that is displayed when [showOverlay] is `true`.
  ///
  /// If [dismissOnTapOutside] is `true`, tapping outside of the overlay will call
  /// the [toggleOverlay] callback to dismiss the overlay. Otherwise, tapping outside
  /// will not dismiss the overlay.
  Widget _buildCustomDialogOverlay() {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () {
          if (dismissOnTapOutside && toggleOverlay != null) {
            toggleOverlay!(); // Dismiss the overlay only if allowed
          }
        },
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
          child: Center(child: customOverlay),
        ),
      ),
    );
  }
}
