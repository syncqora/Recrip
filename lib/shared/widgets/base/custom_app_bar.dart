import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/di/get_injector.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String appBarTitle;
  final Color appBarColor;
  final RxBool isConnected;
  final VoidCallback onNotificationPressed;
  final RxBool isUserLoggedIn;
  final RxInt unreadNotificationCount;

  const CustomAppBar({
    super.key,
    required this.appBarTitle,
    required this.appBarColor,
    required this.isConnected,
    required this.onNotificationPressed,
    required this.isUserLoggedIn,
    required this.unreadNotificationCount,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        appBarTitle,
        style: Get.theme.textTheme.bodyMedium?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      // Dynamically update title using Obx
      centerTitle: true,
      backgroundColor: appBarColor,
      titleTextStyle: Get.theme.textTheme.bodyMedium?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      // Dynamically update background color
      leading:
          appBarTitle == "All Categories" ||
              appBarTitle == "Rewards" ||
              appBarTitle == "Profile"
          ? SizedBox()
          : IconButton(
              onPressed: () => appNav.popPage(), // Drawer toggle action
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: Get.theme.colorScheme.primary,
                size: 24,
              ),
            ),
      actions: [
        appBarTitle == 'Buzz & Updates'
            ? Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Image.asset(
                  'assets/icons/settings.png',
                  width: 24,
                  height: 24,
                ),
              )
            : const SizedBox(),
      ],
      // actions: [
      //   Obx(
      //     () => isUserLoggedIn.value
      //         ? Semantics(
      //             label: 'Notifications',
      //             child: IconButton(
      //               onPressed: () {
      //                 if (!isConnected.value) {
      //                   appUi.showNoInternetSnackbar();
      //                   return;
      //                 }
      //                 onNotificationPressed();
      //               },
      //               icon: Stack(
      //                 children: [
      //                   Icon(
      //                     Icons.notifications,
      //                     color: Get.theme.colorScheme.primary,
      //                     size: 28,
      //                   ),
      //                   Obx(
      //                     () => (unreadNotificationCount.value > 0)
      //                         ? Positioned(
      //                             left: 8,
      //                             child: Container(
      //                               padding: const EdgeInsets.all(3),
      //                               decoration: const BoxDecoration(
      //                                 color: Colors.red,
      //                                 shape: BoxShape.circle,
      //                               ),
      //                               child: Center(
      //                                 child: Text(
      //                                   "${unreadNotificationCount.value}",
      //                                   style: Get.theme.textTheme.labelSmall!
      //                                       .copyWith(
      //                                         color: Colors.white,
      //                                         fontSize: 8,
      //                                       ),
      //                                 ),
      //                               ),
      //                             ),
      //                           )
      //                         : const SizedBox(),
      //                   ),
      //                 ],
      //               ),
      //             ),
      //           )
      //         : const SizedBox(),
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
