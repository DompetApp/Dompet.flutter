import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/extension/size.dart';

class PageHomeController extends GetxController {
  late final scrollController = ScrollController();
  late final storeController = Get.find<StoreController>();
  late final mediaQueryController = Get.find<MediaQueryController>();

  late final mediaPadding = mediaQueryController.viewPadding;
  late final bankOrders = storeController.orders;
  late final loginUser = storeController.user;
  late final bankCard = storeController.card;

  Rx<bool> showShadow = false.obs;
  Rx<bool> showActions = false.obs;
  Rx<bool> isRunAnimating = false.obs;
  Rx<bool> isTitleOffstage = false.obs;
  Rx<bool> isActionOffstage = true.obs;

  @override
  void onInit() async {
    super.onInit();

    scrollController.addListener(() {
      final scrollTop = scrollController.position.pixels;
      final isShowShadow = scrollTop >= 640.wmax * 42.sr;
      final isShowActions = scrollTop >= 640.wmax * 296.sr;

      if (showActions.value != isShowActions) {
        isRunAnimating.value = showActions.value != isShowActions;
      }

      isTitleOffstage.value = !isRunAnimating.value && isShowActions;
      isActionOffstage.value = !isRunAnimating.value && !isShowActions;

      WidgetsBinding.instance.addPostFrameCallback((_) async {
        showActions.value = isShowActions;
        showShadow.value = isShowShadow;
      });
    });
  }
}
