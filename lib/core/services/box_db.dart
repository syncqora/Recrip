import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import '../../shared/constants/box_constants.dart';

/// A class that manages persistent storage using the GetStorage package.
/// Provides methods to read and write String, int, bool, and JSON values.
class BoxDb {
  final box = GetStorage();

  /// Writes a String value into storage.
  ///
  /// [key] The key under which the value is stored.
  /// [value] The String value to store.
  void writeStringValue({required String key, required String value}) {
    box.write(key, value);
    //enableLog(key: key, value: value);
    // final String log = '(updated) PreferenceKey "$key" = ${box.read(key)}';
    // dev.log(log);
    // addToMiniSwagger(log);
  }

  /// Reads a String value from storage.
  ///
  /// [key] The key under which the value is stored.
  /// Returns the stored String value. If the value is null, returns an empty String.
  /// If the key is `BoxConstants.userId` and the value is empty, returns '0'.
  String readStringValue({required String key}) {
    String retrievedValue = box.read(key) ?? '';
    if (key == BoxConstants.userId && retrievedValue.isEmpty) {
      retrievedValue = '0';
    }
    //enableLog(key: key);
    // final String log = '(retrieved) PreferenceKey "$key" = $retrievedValue';
    // dev.log(log);
    // addToMiniSwagger(log);
    return retrievedValue;
  }

  /// Writes an int value into storage.
  ///
  /// [key] The key under which the value is stored.
  /// [value] The int value to store.
  void writeIntValue({required String key, required int value}) {
    box.write(key, value);
    //enableLog(key: key, value: value.toString());
    // final String log = '(updated) PreferenceKey "$key" = ${box.read(key)}';
    // dev.log(log);
    // addToMiniSwagger(log);
  }

  /// Reads an int value from storage.
  ///
  /// [key] The key under which the value is stored.
  /// Returns the stored int value. If the value is null, returns 0.
  int readIntValue({required String key}) {
    final int retrievedValue = box.read(key) ?? 0;
    //enableLog(key: key);
    // final String log = '(retrieved) PreferenceKey "$key" = $retrievedValue';
    // dev.log(log);
    // addToMiniSwagger(log);
    return retrievedValue;
  }

  /// Writes a bool value into storage.
  ///
  /// [key] The key under which the value is stored.
  /// [value] The bool value to store.
  void writeBoolValue({required String key, required bool value}) {
    box.write(key, value);
    //enableLog(key: key, value: value.toString());
    // final String log = '(updated) PreferenceKey "$key" = ${box.read(key)}';
    // dev.log(log);
    // addToMiniSwagger(log);
  }

  /// Reads a bool value from storage.
  ///
  /// [key] The key under which the value is stored.
  /// Returns the stored bool value. If the value is null, returns false.
  bool readBoolValue({required String key}) {
    final bool retrievedValue = box.read(key) ?? false;
    //enableLog(key: key);
    // final String log = '(retrieved) PreferenceKey "$key" = $retrievedValue';
    // dev.log(log);
    // addToMiniSwagger(log);
    return retrievedValue;
  }

  /// Writes a JSON object into storage.
  ///
  /// [key] The key under which the value is stored.
  /// [jsonData] The JSON data to store.
  void writeJsonValue({required String key, required dynamic jsonData}) {
    box.write(key, jsonEncode(jsonData));
    //enableLog(key: key, value: jsonData.toString());
    // final String log = '(updated) PreferenceKey "$key" = ${box.read(key)}';
    // dev.log(log);
    // addToMiniSwagger(log);
  }

  /// Reads a JSON object from storage.
  ///
  /// [key] The key under which the value is stored.
  /// Returns the stored JSON object. If the value is null or empty, returns an empty String.
  dynamic readJsonValue({required String key}) {
    final String retrievedValue = box.read(key) ?? '';
    //enableLog(key: key);
    // final String log = '(retrieved) PreferenceKey "$key" = $retrievedValue';
    // dev.log(log);
    // addToMiniSwagger(log);
    return retrievedValue.isEmpty ? '' : jsonDecode(retrievedValue);
  }

  /// Logs storage actions if the app is in debug mode.
  ///
  /// [key] The key of the value being stored or read.
  /// [value] The value being stored or read (optional).
  // void enableLog({required String key, String value = ''}) {
  //   if (AppConstants.appReleaseMode == AppReleaseMode.test) {
  //     appLog.info("Key $key ${value.isNotEmpty ? 'value: $value' : ''}");
  //   }
  // }

  /// Adds a log entry to the Mini Swagger records after the current frame.
  /// Uses [MiniSwaggerController] to add a [MiniSwaggerLogsModel] with the provided log string.
  /// Ensure the controller is initialized before calling this method.
  // void addToMiniSwagger(String log) =>
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       final miniSwaggerController = Get.find<MiniSwaggerController>();
  //       if (miniSwaggerController.initialized) {
  //         miniSwaggerController.addDataToRecords(
  //           MiniSwaggerLogsModel(log: log),
  //         );
  //       }
  //     });
}
