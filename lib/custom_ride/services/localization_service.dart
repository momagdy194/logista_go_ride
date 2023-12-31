import 'package:customer/custom_ride/lang/app_ar.dart';
import 'package:customer/custom_ride/lang/app_en.dart';
import 'package:customer/custom_ride/lang/app_fr.dart';
import 'package:customer/custom_ride/lang/app_hi.dart';
import 'package:customer/custom_ride/lang/app_ja.dart';
import 'package:customer/custom_ride/lang/app_pt.dart';
import 'package:customer/custom_ride/lang/app_ru.dart';
import 'package:customer/custom_ride/lang/app_zh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationService extends Translations {
  // Default locale
  static const locale = Locale('ar', 'de');
  // app_ar.dart
  static final locales = [
    const Locale('en'),
    const Locale('ar'),

    const Locale('fr'),
    const Locale('zh'),
    const Locale('ja'),
    const Locale('hi'),
    const Locale('pt'),
    const Locale('ru'),
  ];

  // Keys and their translations
  // Translations are separated maps in `lang` file
  @override
  Map<String, Map<String, String>> get keys => {
        'en': enUS,
        'ar': deGR,

          'fr': trFR,
        'zh': zhCH,
        'ja': jaJP,
        'hi': hiIN,
        'pt': ptPO,
        'ru': ruRU,
      };

  // Gets locale from language, and updates the locale
  void changeLocale(String lang) {
    Get.updateLocale(Locale(lang));
  }
}
