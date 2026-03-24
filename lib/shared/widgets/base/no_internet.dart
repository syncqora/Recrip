import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/locale/locale_keys.dart';

class NoInternet extends StatelessWidget {
  final Function() refresh;
  final bool showTryAgain;

  const NoInternet({
    super.key,
    this.showTryAgain = true,
    required this.refresh,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Get.theme.primaryColor,
      width: Get.width,
      height: Get.height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.signal_wifi_statusbar_connected_no_internet_4,
                        size: Get.width / 4,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          LocaleKeys.networkIssueHeader.tr,
                          style: Get.theme.textTheme.bodyLarge,
                        ),
                      ),
                      Text(
                        showTryAgain
                            ? LocaleKeys.networkIssueBody.tr
                            : LocaleKeys.networkIssueBody2.tr,
                        style: Get.theme.textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            showTryAgain
                ? Expanded(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // AppButton(
                            //   text: LocaleKeys.tryAgain.tr,
                            //   appButtonType: AppButtonType.regular,
                            //   isEnabled: true,
                            //   onTap: refresh,
                            // ),
                            ElevatedButton(
                              onPressed: refresh,
                              style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(LocaleKeys.tryAgain.tr),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                : const Expanded(child: SizedBox()),
          ],
        ),
      ),
    );
  }
}
