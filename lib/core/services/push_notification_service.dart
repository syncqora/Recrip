import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:saas/core/services/permission_manager.dart';
import '../../navigation/navigation_service.dart';
import '../../shared/constants/app.dart';
import '../../shared/constants/box_constants.dart';
import '../di/get_injector.dart';

mixin PushNotificationService {
  late FirebaseMessaging firebaseMessaging;
  final Set<String> displayedMessages = {};

  // Store current community/chat ID to track which page user is on
  String? _currentCommunityId;
  String? _currentChatRoute;

  /// Set the current community ID when user navigates to a community chat page
  void setCurrentCommunityId(String? communityId, {String? route}) {
    _currentCommunityId = communityId;
    _currentChatRoute = route;
    log("Set current community ID: $communityId, route: $route");
  }

  /// Clear the current community ID when user navigates away
  void clearCurrentCommunityId() {
    _currentCommunityId = null;
    _currentChatRoute = null;
    log("Cleared current community ID");
  }

  /// Get the current community ID
  String? getCurrentCommunityId() => _currentCommunityId;

  /// Automatically update community ID from current page arguments
  /// This is called when navigation changes to ensure we always have the current community ID
  void _updateCommunityIdFromCurrentPage() {
    try {
      final appNav = Get.find<NavigationService>();
      final navCurrentPage = appNav.currentPage.value;
      final appArgs = appNav.appArgs;
      final currentArgs = Get.arguments;

      // Check if we're on a community chat page
      final isOnChatPage =
          navCurrentPage.toLowerCase().contains('chat') ||
          navCurrentPage.toLowerCase().contains('community');

      if (isOnChatPage) {
        String? communityId;

        // Try to extract community ID from appArgs
        if (appArgs != null && appArgs is Map) {
          communityId =
              appArgs['communityId'] ??
              appArgs['community_id'] ??
              appArgs['chatId'] ??
              appArgs['chat_id'] ??
              appArgs['community'] ??
              appArgs['channelId'] ??
              appArgs['channel_id'] ??
              appArgs['groupId'] ??
              appArgs['group_id'];
        }

        // Try Get.arguments if not found
        if (communityId == null && currentArgs != null && currentArgs is Map) {
          communityId =
              currentArgs['communityId'] ??
              currentArgs['community_id'] ??
              currentArgs['chatId'] ??
              currentArgs['chat_id'] ??
              currentArgs['community'] ??
              currentArgs['channelId'] ??
              currentArgs['channel_id'] ??
              currentArgs['groupId'] ??
              currentArgs['group_id'];
        }

        if (communityId != null) {
          setCurrentCommunityId(communityId, route: navCurrentPage);
          log("✅ Auto-detected community ID from navigation: $communityId");
        } else {
          log(
            "⚠️ On chat page but could not extract community ID from arguments",
          );
        }
      } else {
        // Not on chat page, clear the community ID
        if (_currentCommunityId != null) {
          clearCurrentCommunityId();
          log("✅ Cleared community ID - not on chat page");
        }
      }
    } catch (e) {
      log("Error updating community ID from current page: $e");
    }
  }

  /// Checks if the notification should be shown based on current page and notification data
  /// Returns false if user is on the same community chat page as the notification
  bool _shouldShowNotification(Map<String, dynamic> messageData) {
    try {
      log("_shouldShowNotification: Checking notification data: $messageData");

      // Check if this is a community chat notification
      // Try multiple possible keys for community/chat ID
      final communityId =
          messageData['communityId'] ??
          messageData['community_id'] ??
          messageData['chatId'] ??
          messageData['chat_id'] ??
          messageData['community'] ??
          messageData['channelId'] ??
          messageData['channel_id'] ??
          messageData['groupId'] ??
          messageData['group_id'];

      log("Extracted communityId from notification: $communityId");

      if (communityId == null) {
        // If it's not a community chat notification, show it
        log("No communityId found, allowing notification");
        return true;
      }

      // FIRST: Check if we have a stored current community ID (most reliable)
      if (_currentCommunityId != null) {
        log("Current stored community ID: $_currentCommunityId");
        log("Notification community ID: $communityId");
        if (_currentCommunityId.toString() == communityId.toString()) {
          log(
            "❌ SUPPRESSING: User is on same community chat page (from stored ID: $communityId)",
          );
          log("Skipping notification for active community: $communityId");
          return false;
        } else {
          log(
            "✅ Different community IDs - stored: $_currentCommunityId, notification: $communityId",
          );
        }
      } else {
        log("No stored community ID found");
      }

      // SECOND: Get current route/page information using GetX routing
      final currentRoute = Get.currentRoute;
      final currentArgs = Get.arguments;

      log("Current route from Get.currentRoute: $currentRoute");
      log("Current args from Get.arguments: $currentArgs");

      // Also try to get navigation service if available
      try {
        final appNav = Get.find<NavigationService>();
        final navCurrentPage = appNav.currentPage.value;
        final navArgs = appNav.getCurrentArguments();
        final appArgs = appNav.appArgs;

        log("Navigation service current page: $navCurrentPage");
        log("Navigation service args: $navArgs");
        log("Navigation service appArgs: $appArgs");

        // Check if we're on a community chat page
        // Look for chat or community in route names
        final isOnChatPage =
            (currentRoute != null &&
                (currentRoute.toLowerCase().contains('chat') ||
                    currentRoute.toLowerCase().contains('community'))) ||
            (navCurrentPage.toLowerCase().contains('chat') ||
                navCurrentPage.toLowerCase().contains('community'));

        log("Is on chat page: $isOnChatPage");

        if (isOnChatPage) {
          // Extract community ID from current page arguments
          String? currentCommunityId;

          // Try appArgs first (most common in this app)
          if (appArgs != null) {
            if (appArgs is Map) {
              currentCommunityId =
                  appArgs['communityId'] ??
                  appArgs['community_id'] ??
                  appArgs['chatId'] ??
                  appArgs['chat_id'] ??
                  appArgs['community'] ??
                  appArgs['channelId'] ??
                  appArgs['channel_id'] ??
                  appArgs['groupId'] ??
                  appArgs['group_id'];
            } else if (appArgs is String) {
              currentCommunityId = appArgs;
            }
          }

          // Try Get.arguments if not found
          if (currentCommunityId == null && currentArgs != null) {
            if (currentArgs is Map) {
              currentCommunityId =
                  currentArgs['communityId'] ??
                  currentArgs['community_id'] ??
                  currentArgs['chatId'] ??
                  currentArgs['chat_id'] ??
                  currentArgs['community'] ??
                  currentArgs['channelId'] ??
                  currentArgs['channel_id'] ??
                  currentArgs['groupId'] ??
                  currentArgs['group_id'];
            } else if (currentArgs is String) {
              currentCommunityId = currentArgs;
            }
          }

          // Try navigation service arguments if not found
          if (currentCommunityId == null && navArgs != null) {
            if (navArgs is Map) {
              currentCommunityId =
                  navArgs['communityId'] ??
                  navArgs['community_id'] ??
                  navArgs['chatId'] ??
                  navArgs['chat_id'] ??
                  navArgs['community'] ??
                  navArgs['channelId'] ??
                  navArgs['channel_id'] ??
                  navArgs['groupId'] ??
                  navArgs['group_id'];
            } else if (navArgs is String) {
              currentCommunityId = navArgs;
            }
          }

          log("Current community ID from page: $currentCommunityId");
          log("Notification community ID: $communityId");

          // Update stored community ID for future checks
          if (currentCommunityId != null) {
            setCurrentCommunityId(currentCommunityId, route: navCurrentPage);
          }

          // If user is on the same community chat page, don't show notification
          if (currentCommunityId != null &&
              currentCommunityId.toString() == communityId.toString()) {
            log(
              "❌ SUPPRESSING: User is on same community chat page ($communityId)",
            );
            return false;
          } else {
            log("✅ Different community or no match, showing notification");
          }
        } else {
          // Not on a chat page, clear stored ID
          if (_currentCommunityId != null) {
            clearCurrentCommunityId();
          }
          log("✅ Not on chat page, showing notification");
        }
      } catch (e, stackTrace) {
        log("Error accessing navigation service: $e");
        log("Stack trace: $stackTrace");
        // Fallback to Get.currentRoute and Get.arguments
        final isOnChatPage =
            currentRoute != null &&
            (currentRoute.toLowerCase().contains('chat') ||
                currentRoute.toLowerCase().contains('community'));

        log("Fallback: Is on chat page: $isOnChatPage");

        if (isOnChatPage && currentArgs != null && currentArgs is Map) {
          final currentCommunityId =
              currentArgs['communityId'] ??
              currentArgs['community_id'] ??
              currentArgs['chatId'] ??
              currentArgs['chat_id'] ??
              currentArgs['community'] ??
              currentArgs['channelId'] ??
              currentArgs['channel_id'] ??
              currentArgs['groupId'] ??
              currentArgs['group_id'];

          log("Fallback: Current community ID: $currentCommunityId");

          if (currentCommunityId != null) {
            setCurrentCommunityId(currentCommunityId, route: currentRoute);
          }

          if (currentCommunityId != null &&
              currentCommunityId.toString() == communityId.toString()) {
            log(
              "❌ SUPPRESSING (fallback): User is on same community chat page",
            );
            return false;
          }
        } else if (!isOnChatPage && _currentCommunityId != null) {
          clearCurrentCommunityId();
        }
      }

      log("✅ Allowing notification to be shown");
      return true;
    } catch (e, stackTrace) {
      log("Error checking if should show notification: $e");
      log("Stack trace: $stackTrace");
      // On error, default to showing the notification
      return true;
    }
  }

  Future<bool> initPushNotifications() async {
    try {
      firebaseMessaging = FirebaseMessaging.instance;
      final String? apnsToken = await firebaseMessaging.getAPNSToken();
      if (apnsToken == null) {
        await Future<void>.delayed(const Duration(seconds: 3));
      }
      final dynamic fcmToken = await firebaseMessaging.getToken();
      boxDb.writeStringValue(key: BoxConstants.fbToken, value: fcmToken);
      log("fb tokens: ${boxDb.readStringValue(key: BoxConstants.fbToken)}");
      final RemoteMessage? initialMessage = await FirebaseMessaging.instance
          .getInitialMessage();
      // CRITICAL: Set iOS notification presentation options IMMEDIATELY
      // This MUST be set BEFORE any message listeners to prevent iOS from auto-showing notifications
      if (Platform.isIOS) {
        // Set this IMMEDIATELY and SYNCHRONOUSLY to prevent any automatic iOS notification display
        // This prevents iOS from showing notifications before our handler can check conditions
        // IMPORTANT: This must be called BEFORE onMessage.listen to take effect
        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert:
              false, // CRITICAL: NO automatic alerts - iOS will NOT show notifications automatically
          badge: false, // CRITICAL: NO automatic badge updates
          sound: false, // CRITICAL: NO automatic sound
        );
        log(
          "iOS: Disabled automatic notification display (alert: false, badge: false, sound: false)",
        );
        log(
          "iOS: All notifications will be manually controlled via flutterLocalNotificationsPlugin",
        );

        // Double-check that the setting was applied
        final settings = await firebaseMessaging.getNotificationSettings();
        log(
          "iOS: Current notification settings - alert: ${settings.alert}, badge: ${settings.badge}, sound: ${settings.sound}",
        );

        await showPushNotificationEnablePermission();

        // Set it again after permission request to ensure it's still applied
        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );
        log(
          "iOS: Re-applied notification presentation options after permission request",
        );
      }

      final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      final androidNotificationSettings = const AndroidInitializationSettings(
        "@drawable/app_logo",
      );
      final iOSNotificationSettings = const DarwinInitializationSettings();
      flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: androidNotificationSettings,
          iOS: iOSNotificationSettings,
        ),
        onDidReceiveNotificationResponse: onSelectForegroundNotification,
      );
      if (initialMessage != null) {
        handlePushNotificationTap(initialMessage);
      }

      /*firebaseMessaging.getInitialMessage().then((value) {
        if (value != null) {
          handlePushNotificationTap(value);
        }
      });*/
      /*      final AndroidNotificationDetails androidNotificationDetails =
          const AndroidNotificationDetails(
        AppConstants.coffeeWebPushNotificationAndroidChannelId,
        AppConstants.coffeeWebPushNotificationAndroidChannelName,
        importance: Importance.max,
        priority: Priority.high,
        playSound: true,
        icon: "@drawable/app_logo",
      );
      final NotificationDetails notificationDetails = NotificationDetails(
          android: androidNotificationDetails,
          iOS: const DarwinNotificationDetails());*/
      FirebaseMessaging.onBackgroundMessage(onReceivePushNotification);

      // CRITICAL: Monitor navigation changes to auto-detect and set community ID
      // This ensures we always have the current community ID set when user is on chat page
      try {
        final appNav = Get.find<NavigationService>();
        appNav.currentPage.listen((currentPage) {
          log("Navigation changed to: $currentPage");
          // When page changes, check if we're on a chat page and extract community ID
          _updateCommunityIdFromCurrentPage();
        });
      } catch (e) {
        log("Could not set up navigation listener: $e");
      }

      // CRITICAL: Set up message listener with early suppression check
      FirebaseMessaging.onMessage.listen((event) async {
        log(
          "=== Notification Received (Platform: ${Platform.isIOS ? 'iOS' : 'Android'}) ===",
        );
        log("Message ID: ${event.messageId}");
        log(
          "Notification: ${event.notification?.title} - ${event.notification?.body}",
        );
        log("Data: ${event.data}");

        // CRITICAL: Check FIRST before any other processing
        if (event.notification == null) {
          log("No notification payload, skipping");
          return;
        }

        final Map<String, dynamic> message = event.data;

        // CRITICAL: Update community ID from current page BEFORE checking
        // This ensures we have the latest community ID even if navigation just changed
        _updateCommunityIdFromCurrentPage();

        // CRITICAL: Check if we should show the notification IMMEDIATELY
        // This check MUST happen FIRST, before any other processing or delays
        // Extract community ID from notification data
        final communityId =
            message['communityId'] ??
            message['community_id'] ??
            message['chatId'] ??
            message['chat_id'] ??
            message['community'] ??
            message['channelId'] ??
            message['channel_id'] ??
            message['groupId'] ??
            message['group_id'];

        log(
          "🔍 Notification check - communityId: $communityId, _currentCommunityId: $_currentCommunityId",
        );

        // FAST CHECK: If we have a stored community ID and it matches, suppress IMMEDIATELY
        // This is the FIRST and FASTEST check to prevent any processing
        if (communityId != null && _currentCommunityId != null) {
          if (_currentCommunityId.toString() == communityId.toString()) {
            log(
              "❌ FAST CHECK: Suppressing notification for active community: $communityId",
            );
            log("Skipping notification for active community: $communityId");
            log("❌ Notification will NOT be displayed on iOS");
            log("❌ Returning immediately - no further processing");

            // CRITICAL: On iOS, even though we return early, iOS might have already
            // queued the notification. We need to ensure we don't process it at all.
            // Since we set alert: false, iOS should NOT show it automatically.
            // But if it's still showing, we need to prevent it at the source.

            // For iOS: Double-check that we're not going to show it
            if (Platform.isIOS) {
              log(
                "❌ iOS: Preventing notification display - community match detected",
              );
              // Make absolutely sure we don't add to displayedMessages
              // and return immediately without any further processing
            }

            return;
          } else {
            log(
              "✅ FAST CHECK: Different community - stored: $_currentCommunityId, notification: $communityId",
            );
          }
        } else {
          if (communityId == null) {
            log(
              "⚠️ FAST CHECK: No communityId in notification data - will show notification",
            );
          }
          if (_currentCommunityId == null) {
            log(
              "⚠️ FAST CHECK: No stored community ID - user may not be on chat page",
            );
            log(
              "⚠️ This might be why notifications are still showing - community ID not set!",
            );
          }
        }

        // Full check using _shouldShowNotification (includes route checking)
        final shouldShow = _shouldShowNotification(message);

        if (!shouldShow) {
          log(
            "❌ Notification SUPPRESSED - user is on same community chat page",
          );
          log("❌ SKIPPING notification display completely");
          log("Skipping notification for active community: $communityId");
          // IMPORTANT: Return immediately to prevent ANY notification processing
          // Do NOT add to displayedMessages - we want to show it if user navigates away
          return;
        }

        // Only check for duplicates AFTER we've confirmed we should show it
        if (displayedMessages.contains(event.messageId)) {
          log("Message already displayed, skipping");
          return;
        }

        log("✅ Notification will be shown");
        displayedMessages.add(event.messageId ?? event.hashCode.toString());

        if (message["subscriptionStaus"] == "Success") {
          ///need to do
          // appFunctions.clearUserPaymentDetailsFromPreferences();
          boxDb.writeStringValue(key: BoxConstants.idOrder, value: '');

          ///need to do, we don't use the app data controller from settings controller.
          // Get.find<AppDataController>().updateUserAfterSubscription();

          ///need to do
          // appFunctions.updateUserAfterPayment();
        }
        if (event.notification != null) {
          if (Platform.isAndroid) {
            await flutterLocalNotificationsPlugin.show(
              event.messageId?.hashCode ??
                  DateTime.now().millisecondsSinceEpoch,
              event.notification!.title,
              event.notification!.body,
              const NotificationDetails(
                android: AndroidNotificationDetails(
                  AppConstants.splitPushNotificationAndroidChannelId,
                  AppConstants.splitPushNotificationAndroidChannelName,
                  importance: Importance.max,
                  priority: Priority.high,
                  playSound: true,
                  icon: "@drawable/app_logo",
                ),
              ),
              payload: jsonEncode(event.toMap()),
            );
          } else if (Platform.isIOS) {
            // For iOS: We've already checked _shouldShowNotification at the top
            // If we reach here, it means we should show the notification
            // Since we disabled ALL automatic notifications (alert: false, badge: false, sound: false),
            // iOS will NOT show anything automatically
            // We ONLY manually show it here if _shouldShowNotification returned true

            // FINAL SAFETY CHECK: Verify one more time before showing
            final communityId =
                message['communityId'] ??
                message['community_id'] ??
                message['chatId'] ??
                message['chat_id'] ??
                message['community'] ??
                message['channelId'] ??
                message['channel_id'] ??
                message['groupId'] ??
                message['group_id'];

            if (communityId != null &&
                _currentCommunityId != null &&
                _currentCommunityId.toString() == communityId.toString()) {
              log(
                "❌ FINAL CHECK FAILED: Suppressing iOS notification for active community: $communityId",
              );
              // Remove from displayedMessages since we're not showing it
              displayedMessages.remove(
                event.messageId ?? event.hashCode.toString(),
              );
              return;
            }

            log("📱 Showing iOS notification manually (verified should show)");
            try {
              await flutterLocalNotificationsPlugin.show(
                event.messageId?.hashCode ??
                    DateTime.now().millisecondsSinceEpoch,
                event.notification!.title ?? 'Notification',
                event.notification!.body ?? '',
                const NotificationDetails(
                  iOS: DarwinNotificationDetails(
                    presentAlert: true,
                    presentBadge: true,
                    presentSound: true,
                  ),
                ),
                payload: jsonEncode(event.toMap()),
              );
              log("✅ iOS notification displayed successfully");
            } catch (e) {
              log("❌ Error showing iOS notification: $e");
            }
          }
        }
      });
      FirebaseMessaging.onMessageOpenedApp.listen(handlePushNotificationTap);
      return fcmToken != null;
    } catch (e, trace) {
      print("error $e");
      print("trace $trace");
      print("error init push notifications");
      return false;
    }
  }

  RxBool foregroundNotification = false.obs;

  Future<void> showPushNotificationEnablePermission() async {
    // if (Get.find<AppSettingsController>().isUserLoggedIn.value) {
    print("showPushNotificationEnablePermission");
    try {
      await PermissionManager().requestNotificationPermission(
        firebaseMessaging,
        showNotificationDialogBox: true,
      );
    } catch (e) {
      firebaseMessaging = FirebaseMessaging.instance;
      await PermissionManager().requestNotificationPermission(
        firebaseMessaging,
        showNotificationDialogBox: true,
      );
    }
  }

  // Unified function to process the payload and handle navigation
  Future<void> _processNotificationPayload(Map<String, dynamic> payload) async {
    final messageData = payload.containsKey("data") ? payload["data"] : payload;
    //await _handleNavigation(messageData);
  }

  // Streamlined push notification receivers
  Future<void> onReceivePushNotification(RemoteMessage? remoteMessage) async {
    print("onReceivePushNotification called");
    if (remoteMessage == null) return;
    await _processNotificationPayload(remoteMessage.data);
  }

  Future<void> handlePushNotificationTap(RemoteMessage? remoteMessage) async {
    if (remoteMessage == null) return;
    await _processNotificationPayload(remoteMessage.data);
  }

  // For handling foreground notification interactions
  Future<void> onSelectForegroundNotification(
    NotificationResponse notificationResponse,
  ) async {
    log(
      "onSelectForegroundNotification - Notification payload: ${notificationResponse.payload}",
    );
    final payloadData = json.decode(notificationResponse.payload.toString());
    foregroundNotification.value = true;
    await _processNotificationPayload(payloadData);
  }
}
