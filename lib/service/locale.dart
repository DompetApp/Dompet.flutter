import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LocaleController extends GetxService {
  late final enUs = const Locale('en', 'US');
  late final locale = (Get.locale ?? enUs).obs;

  void update(Locale? locale) {
    this.locale.value = locale ?? enUs;
  }
}
