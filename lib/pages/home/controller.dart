import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/extension/size.dart';

class PageHomeController extends GetxController {
  late final scrollController = ScrollController();
  late final storeController = Get.find<StoreController>();
  late final mediaQueryController = Get.find<MediaQueryController>();

  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaTopBar = mediaQueryController.topBar;
  late final mediaHeight = mediaQueryController.height;
  late final mediaWidth = mediaQueryController.width;
  late final bankOrders = storeController.orders;
  late final loginUser = storeController.user;
  late final bankCard = storeController.card;

  Rx<bool> showShadow = false.obs;
  Rx<bool> showActions = false.obs;
  Rx<bool> isAnimating = false.obs;

  @override
  void onInit() async {
    super.onInit();

    scrollController.addListener(() {
      final scrollTop = scrollController.position.pixels;
      final isShowShadow = scrollTop >= 640.wmax * 42.sr;
      final isShowActions = scrollTop >= 640.wmax * 296.sr;
      isAnimating.value = showActions.value != isShowActions;
      showActions.value = isShowActions;
      showShadow.value = isShowShadow;
    });
  }
}
