import 'dart:math';
import 'package:get/get.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/service/bind.dart';
import 'package:flutter/widgets.dart';

class PageSettingsController extends GetxController {
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final eventController = Get.find<EventController>();
  late final scrollController = ScrollController();

  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaTopBar = mediaQueryController.topBar;
  late final logout = eventController.logout;
  late final isShadow = false.obs;

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
