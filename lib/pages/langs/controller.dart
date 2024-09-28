import 'dart:math';
import 'package:get/get.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/service/bind.dart';
import 'package:flutter/widgets.dart';

class PageLangsController extends GetxController {
  late final scrollController = ScrollController();
  late final storeController = Get.find<StoreController>();
  late final localeController = Get.find<LocaleController>();
  late final mediaQueryController = Get.find<MediaQueryController>();

  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaTopBar = mediaQueryController.topBar;
  late final localer = storeController.storeLocale;
  late final locale = storeController.locale;
  late final zhCn = localeController.zhCn;
  late final enUs = localeController.enUs;
  late final isShadow = false.obs;

  bool get isZhCn => locale.value == zhCn;
  bool get isEnUs => locale.value == enUs;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      final expanded = 640.wmax * 152.sr;
      final collapsed = max(640.wmax * 40.sr, mediaTopBar.value);
      isShadow.value = scrollController.position.pixels >= expanded - collapsed;
    });
  }
}
