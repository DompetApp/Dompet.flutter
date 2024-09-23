import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocaleController extends GetxService {
  late final enUs = const Locale('en', 'US');
  late final zhCn = const Locale('zh', 'CN');
  late final locale = (Get.locale ?? enUs).obs;

  void update(Locale? locale) {
    if (locale == null) {
      this.locale.value = enUs;
      Get.updateLocale(enUs);
      return;
    }

    final countryCode = locale.countryCode;
    final languageCode = locale.languageCode;

    if (languageCode == enUs.languageCode && countryCode == enUs.countryCode) {
      this.locale.value = enUs;
      return;
    }

    if (languageCode == zhCn.languageCode && countryCode == zhCn.countryCode) {
      this.locale.value = zhCn;
      return;
    }

    if (languageCode == zhCn.languageCode) {
      this.locale.value = zhCn;
      Get.updateLocale(zhCn);
    }

    this.locale.value = enUs;
    Get.updateLocale(enUs);
  }
}
