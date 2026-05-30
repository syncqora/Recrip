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

  void setCurrentCommunityId(String? communityId, {String? route}) {
    _currentCommunityId = communityId;
    log("Set current community ID: $communityId, route: $route");
  }

  void clearCurrentCommunityId() {
    _currentCommunityId = null;
    log("Cleared current community ID");
  }

  String? getCurrentCommunityId() => _currentCommunityId;

  String? _extractCommunityId(Map<String, dynamic> map) {
    return map['communityId'] ??
        map['community_id'] ??
        map['chatId'] ??
        map['chat_id'] ??
        map['community'] ??
        map['channelId'] ??
        map['channel_id'] ??
        map['groupId'] ??
        map['group_id'];
  }

  String? _getCommunityIdFromCurrentPage() {
    try {
      final appNav = Get.find<NavigationService>();
      final navCurrentPage = appNav.currentPage.value;
      final appArgs = appNav.appArgs;
      final currentArgs = Get.arguments;

      final isOnChatPage =
          navCurrentPage.toLowerCase().contains('chat') ||
          navCurrentPage.toLowerCase().contains('community');

      if (!isOnChatPage) return null;

      String? communityId;

      if (appArgs != null && appArgs is Map) {
        communityId = _extractCommunityId(appArgs as Map<String, dynamic>);
      }

      if (communityId == null && currentArgs != null && currentArgs is Map) {
        communityId = _extractCommunityId(currentArgs as Map<String, dynamic>);
      }

      if (communityId == null) {
        final navArgs = appNav.getCurrentArguments();
        if (navArgs != null && navArgs is Map) {
          communityId = _extractCommunityId(navArgs as Map<String, dynamic>);
        }
      }

      if (communityId != null) {
        setCurrentCommunityId(communityId, route: navCurrentPage);
      }

      return communityId;
    } catch (e) {
      log("Error getting community ID from current page: $e");
      return null;
    }
  }

  bool _shouldShowNotification(Map<String, dynamic> messageData) {
    try {
      final communityId = _extractCommunityId(messageData);
      if (communityId == null) return true;

      if (_currentCommunityId != null &&
          _currentCommunityId.toString() == communityId.toString()) {
        log("Suppressing notification for active community: $communityId");
        return false;
      }

      return true;
    } catch (e) {
      log("Error in shouldShowNotification: $e");
      return true;
    }
  }

  RxBool foregroundNotification = false.obs;

  Future<void> showPushNotificationEnablePermission() async {
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

  Future<void> _processNotificationPayload(
    Map<String, dynamic> payload,
  ) async {}

  Future<void> onReceivePushNotification(RemoteMessage? remoteMessage) async {
    print("onReceivePushNotification called");
    if (remoteMessage == null) return;
    await _processNotificationPayload(remoteMessage.data);
  }

  Future<void> handlePushNotificationTap(RemoteMessage? remoteMessage) async {
    if (remoteMessage == null) return;
    await _processNotificationPayload(remoteMessage.data);
  }

  Future<void> onSelectForegroundNotification(
    NotificationResponse notificationResponse,
  ) async {
    log(
      "onSelectForegroundNotification - payload: ${notificationResponse.payload}",
    );
    final payloadData = json.decode(notificationResponse.payload.toString());
    foregroundNotification.value = true;
    await _processNotificationPayload(payloadData);
  }

  void _setupNavigationListener() {
    try {
      final appNav = Get.find<NavigationService>();
      appNav.currentPage.listen((_) {
        _getCommunityIdFromCurrentPage();
      });
    } catch (e) {
      log("Could not set up navigation listener: $e");
    }
  }

  void _handleForegroundMessage(RemoteMessage event) async {
    log(
      "=== Notification Received (Platform: ${Platform.isIOS ? 'iOS' : 'Android'}) ===",
    );
    log("Message: ${event.notification?.title} - ${event.notification?.body}");

    if (event.notification == null) return;

    final message = event.data;
    _getCommunityIdFromCurrentPage();

    if (!_shouldShowNotification(message)) {
      log("Notification suppressed - user is on the same community page");
      return;
    }

    if (displayedMessages.contains(event.messageId)) return;

    log("Showing notification");
    displayedMessages.add(event.messageId ?? event.hashCode.toString());

    if (message["subscriptionStaus"] == "Success") {
      boxDb.writeStringValue(key: BoxConstants.idOrder, value: '');
    }

    final notificationPlugin = FlutterLocalNotificationsPlugin();

    if (Platform.isAndroid) {
      await notificationPlugin.show(
        event.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
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
      final communityId = _extractCommunityId(message);
      if (communityId != null &&
          _currentCommunityId != null &&
          _currentCommunityId.toString() == communityId.toString()) {
        displayedMessages.remove(event.messageId ?? event.hashCode.toString());
        return;
      }

      await notificationPlugin.show(
        event.messageId?.hashCode ?? DateTime.now().millisecondsSinceEpoch,
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
      log("iOS notification displayed");
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

      if (Platform.isIOS) {
        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );
        log("iOS: Disabled automatic notification display");

        final settings = await firebaseMessaging.getNotificationSettings();
        log(
          "iOS: Settings - alert: ${settings.alert}, badge: ${settings.badge}, sound: ${settings.sound}",
        );

        await showPushNotificationEnablePermission();

        await firebaseMessaging.setForegroundNotificationPresentationOptions(
          alert: false,
          badge: false,
          sound: false,
        );
      }

      final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
      await flutterLocalNotificationsPlugin.initialize(
        InitializationSettings(
          android: const AndroidInitializationSettings("@drawable/app_logo"),
          iOS: const DarwinInitializationSettings(),
        ),
        onDidReceiveNotificationResponse: onSelectForegroundNotification,
      );

      if (initialMessage != null) {
        handlePushNotificationTap(initialMessage);
      }

      FirebaseMessaging.onBackgroundMessage(onReceivePushNotification);

      _setupNavigationListener();

      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(handlePushNotificationTap);

      return fcmToken != null;
    } catch (e, trace) {
      print("error $e");
      print("trace $trace");
      return false;
    }
  }
}
