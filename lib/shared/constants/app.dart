class RouteArgumentKeys {
  static const String isLogin = 'isLogin';
  static const String newsId = 'newsId';
  static const String author = 'author';
  static const String description = 'description';
  static const String newsPlain = 'newsPlain';
  static const String date = 'date';
  static const String categoryName = 'categoryName';
  static const String phoneNumber = 'phoneNumber';
}

enum DeviceDetailResultType {
  setDeviceDetail,
  getDeviceId,
  checkBuildNumber,
  appVersion,
}

enum DeviceInfoName { sdkInt, deviceId }

class AppConstants {
  static const String splitPushNotificationAndroidChannelId =
      "splitPushNotificationAndroidChannelId";
  static const String splitPushNotificationAndroidChannelName =
      "splitPushNotificationAndroidChannelName";
  static const String splitPushNotificationIOSChannelId =
      "splitPushNotificationIOSChannelId";
  static const String splitPushNotificationIOSChannelName =
      "splitPushNotificationIOSChannelName";
  static const String splitPushNotificationIOSChannelDescription =
      "This channel is used for default Push Notifications for Split Application";

  static const String appCacheDatabaseName = 'coffeeWebAppCache';
  static const String appCacheKey = 'appCacheKey';

  static String categoryDetailName = 'Category Detail';
}
