import 'dart:math';
import 'package:get/get.dart';
import 'package:dompet/configure/fluttertoast.dart';
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

  void localer(Locale? locale) {
    storeController.storeLocale(locale);

    Future.delayed(Duration(milliseconds: 200), () {
      if (locale == enUs) {
        Toaster.success(
          message: 'You switched to English (en-US)!'.tr,
          duration: Duration(seconds: 1),
        );
        return;
      }

      if (locale == zhCn) {
        Toaster.success(
          message: 'You switched to Chinese (zh-CN)!'.tr,
          duration: Duration(seconds: 1),
        );
        return;
      }

      Toaster.success(
        message: 'You switched to device system language!'.tr,
        duration: Duration(seconds: 1),
      );
    });
  }
}
