import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/di/get_injector.dart';
import '../../constants/box_constants.dart';

class LocationAppBar extends StatelessWidget implements PreferredSizeWidget {
  final RxBool isConnected;
  final VoidCallback onNotificationPressed;
  final RxInt unreadNotificationCount;
  final VoidCallback? onLocationTap;

  const LocationAppBar({
    super.key,
    required this.isConnected,
    required this.onNotificationPressed,
    required this.unreadNotificationCount,
    this.onLocationTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      titleSpacing: 16.0,
      title: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onLocationTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Showing Deals at',
                    style: Get.theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          _getLocationText(),
                          style: Get.theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(
                        Icons.keyboard_arrow_down,
                        color: Get.theme.colorScheme.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        Semantics(
          label: 'Notifications',
          child: IconButton(
            padding: EdgeInsets.only(right: 16.0),
            onPressed: () {
              if (!isConnected.value) {
                appUi.showNoInternetSnackbar();
                return;
              }
              onNotificationPressed();
            },
            icon: Stack(
              children: [
                Container(
                  width: 68,
                  height: 48,
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: Color(0xFF121212)),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Image.asset(
                    'assets/icons/bell.png',
                    width: 24,
                    height: 24,
                  ),
                ),
                Obx(
                  () => (unreadNotificationCount.value > 0)
                      ? Positioned(
                          right: 14,
                          bottom: 20,
                          child: Container(
                            width: 8,
                            height: 8,
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                "${unreadNotificationCount.value}",
                                style: Get.theme.textTheme.labelSmall!.copyWith(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  String _getLocationText() {
    // Get values from BoxDB with null safety
    final thoroughFare = boxDb.readStringValue(key: BoxConstants.thoroughFare);
    final subLocality =
        boxDb.readStringValue(key: BoxConstants.subLocality) ?? '';
    final currentLocality =
        boxDb.readStringValue(key: BoxConstants.currentLocality) ?? '';

    // Build location string with proper fallbacks
    String locationText = '';

    if (thoroughFare.isNotEmpty) {
      locationText += thoroughFare;
    }

    if (subLocality.isNotEmpty) {
      if (locationText.isNotEmpty) {
        locationText += ', ';
      }
      locationText += subLocality;
    } else if (currentLocality.isNotEmpty) {
      if (locationText.isNotEmpty) {
        locationText += ', ';
      }
      locationText += currentLocality;
    }

    // Return a default message if no location data is available
    return locationText.isEmpty ? 'Current Location' : locationText;
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
