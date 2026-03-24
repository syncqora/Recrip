import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';

class UiController extends GetxController {
  RxBool isSnackbarShowing = false.obs;

  /// Displays a snack bar when there is no internet connection or the connection is slow.
  /// The snack bar is shown only if it's not already being displayed.
  void showNoInternetSnackbar() {
    if (!isSnackbarShowing.value) {
      isSnackbarShowing.value = true;
      Get.showSnackbar(
        GetSnackBar(
          title: "Slow internet/No internet",
          message: "Please try again later",
          backgroundColor: Colors.white,

          /// TODO:: change later after setting themes
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
          // margin: const EdgeInsets.symmetric(
          //   vertical: 8.0,
          // ),
          isDismissible: true,
          duration: const Duration(seconds: 2),
          titleText: Stack(
            clipBehavior: Clip.none,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 60.0),
                child: Text(
                  "Slow Internet",
                  style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
                ),
              ),
              const Positioned(
                top: 0,
                left: 8,
                child: Icon(
                  Icons.wifi_off_outlined,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          messageText: Stack(
            clipBehavior: Clip.none,
            children: [
              Text(
                "Please Try Again Later",
                style: Get.textTheme.bodySmall!.copyWith(color: Colors.white),
              ).paddingOnly(left: 60),
            ],
          ),
          snackbarStatus: (status) {
            if (status == SnackbarStatus.CLOSED) {
              isSnackbarShowing.value = false;
            }
          },
        ),
      );
    }
  }

  ///snackbar for exports report
  void showSnackBarSingleVisible({
    required String? title,
    required String message,
    bool? isError,
    Duration? duration,
    Function(GetSnackBar)? onTap,
  }) {
    if (!isSnackbarShowing.value) {
      isSnackbarShowing.value = true;

      Get.snackbar(
        onTap: onTap,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: isError ?? false ? null : Colors.white,

        /// TODO:: change later after setting themes
        backgroundGradient: isError ?? false
            ? LinearGradient(colors: [Colors.red.shade900, Colors.red.shade400])
            : null,
        duration: duration ?? const Duration(seconds: 5),
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        '',
        '',
        titleText: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 80.0),
              child: Text(
                title!,
                style: Get.textTheme.bodyLarge!.copyWith(color: Colors.white),
              ),
            ),
            isError ?? false
                ? const SizedBox()
                : Positioned(
                    top: -48,
                    left: -0,
                    child: CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: SvgPicture.asset("", height: 56, width: 56),
                    ),
                  ),
          ],
        ),
        messageText: Stack(
          clipBehavior: Clip.none,
          children: [
            isError ?? false
                ? const SizedBox()
                : Positioned(
                    right: -16,
                    bottom: -16,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(16.0),
                      ),
                      child: SvgPicture.asset("", height: 64, width: 64),
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.only(left: 80.0),
              child: Text(
                message,
                style: const TextStyle(fontSize: 14.0, color: Colors.white),
              ),
            ),
          ],
        ),
        snackbarStatus: (status) {
          if (status == SnackbarStatus.CLOSED) {
            isSnackbarShowing.value = false;
          }
        },
      );
    }
  }
}
