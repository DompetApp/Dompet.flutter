import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/mixins/watcher.dart';

typedef TickerProvider = GetSingleTickerProviderStateMixin;

class PageCardController extends GetxController with RxWatcher, TickerProvider {
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final storeController = Get.find<StoreController>();

  late final duration = const Duration(milliseconds: 480);
  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaTopBar = mediaQueryController.topBar;
  late final bankCard = storeController.card;

  late AnimationController animationController;
  late Animation<double> animationValue;

  Rx<bool> isAnimating = false.obs;
  Rx<bool> isExpand = false.obs;

  @override
  void onInit() {
    super.onInit();

    animationController = AnimationController(duration: duration, vsync: this);

    animationValue = Tween<double>(begin: 0, end: 3.1415926 / 2).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );

    rw.ever(isExpand, (state) {
      if (!state) animationController.reverse();
      if (state) animationController.forward();
    });
  }

  @override
  void onClose() {
    super.onClose();
    rw.close();
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
