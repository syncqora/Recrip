import 'dart:ui';
import 'package:get/get.dart';
import '../../shared/constants/box_constants.dart';
import '../di/get_injector.dart';
import 'en_US.dart';

/// A service that manages the localization of the application,
/// providing support for changing and retrieving the current locale.
class LocalizationServices extends Translations {
  /// The default language code, fetched from stored preferences or set to 'en'.
  static final _defaultLanguageCode =
      boxDb.readStringValue(key: BoxConstants.selectedLanguage).isEmpty
      ? 'en'
      : boxDb.readStringValue(key: BoxConstants.selectedLanguage);

  /// The default country code, fetched from stored preferences or set to 'US'.
  static final _defaultCountryCode =
      boxDb.readStringValue(key: BoxConstants.selectedCountryCode).isEmpty
      ? 'US'
      : boxDb.readStringValue(key: BoxConstants.selectedCountryCode);

  /// The default locale based on stored preferences or set to 'en_US'.
  static final locale = Locale(_defaultLanguageCode, _defaultCountryCode);

  /// List of supported languages.
  static final langs = ['en', 'hi', 'kn', 'es'];

  /// List of supported locales corresponding to the languages.
  static final locales = [
    const Locale('en', 'US'),
    const Locale('hi'),
    const Locale('kn'),
    const Locale('es', 'BR'),
  ];

  /// A map of locale keys to localized values.
  @override
  Map<String, Map<String, String>> get keys => {
    "en": LocaleEn.values,
    // "hi": LocaleHi.values,
    // "kn": LocaleKa.values,
    // "es": LocaleEs.values,
  };

  /// Changes the current locale of the application.
  ///
  /// [lang] - The language code to change to.
  void changeLocale(String lang) {
    print("changelang: $lang");
    final locale = _getLocaleFromLanguage(lang);
    if (locale != null) {
      print("locale not null");
      print(
        "locale details:: ${locale.languageCode.toString()}  ${locale.countryCode.toString()}",
      );
      Get.updateLocale(locale);
      // Save selected language and country code for persistence
      boxDb.writeStringValue(
        key: BoxConstants.selectedLanguage,
        value: locale.languageCode,
      );
      boxDb.writeStringValue(
        key: BoxConstants.selectedCountryCode,
        value: locale.countryCode.toString(),
      );
    } else {
      print("locale null");
    }
  }

  /// Finds and returns the corresponding locale for a given language.
  ///
  /// [lang] - The language code to find the locale for.
  ///
  /// Returns the corresponding [Locale] if found, otherwise the current locale.
  Locale? _getLocaleFromLanguage(String lang) {
    final index = langs.indexOf(lang);
    return index != -1 ? locales[index] : Get.locale;
  }
}
