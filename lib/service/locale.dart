import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocaleController extends GetxService {
  late final enUs = const Locale('en', 'US');
  late final zhCn = const Locale('zh', 'CN');
  late final locale = (Get.locale ?? enUs).obs;

  String get languageCode => locale.value.languageCode;
  String? get countryCode => locale.value.countryCode;

  void update(Locale? locale) {
    if (locale == null) {
      this.locale.value = enUs;
      Get.updateLocale(enUs);
      return;
    }

    if (locale.languageCode == zhCn.languageCode) {
      this.locale.value = zhCn;
      Get.updateLocale(zhCn);
      return;
    }

    this.locale.value = enUs;
    Get.updateLocale(enUs);
  }
}
