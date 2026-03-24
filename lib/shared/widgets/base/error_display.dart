import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ErrorDataDisplay extends StatelessWidget {
  final Function() onRetry;

  const ErrorDataDisplay({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4.0),
      width: Get.width,
      height: Get.height - 50,
      color: Colors.grey.shade100,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              Text(
                "Oops!!! Something went wrong. Please click Refresh button to try again...",
                style: Get.theme.textTheme.bodyMedium!.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 4,
                overflow: TextOverflow.clip,
              ),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// need to make a custom app button
              // AppButton(
              //   isEnabled: true,
              //   text: "refresh",
              //   appButtonType: AppButtonType.compact,
              //   icon: Icons.refresh,
              //   onTap: () => onRetry(),
              // ),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text("refresh"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
