import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/service/bind.dart';

class PageCardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late final storeController = Get.find<StoreController>();
  late final mediaQueryController = Get.find<MediaQueryController>();

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

    animationController = AnimationController(
      duration: duration,
      vsync: this,
    );

    animationValue = Tween<double>(begin: 0, end: 3.1415926 / 2).animate(
      CurvedAnimation(
        parent: animationController,
        curve: Curves.linear,
      ),
    );

    ever(isExpand, (state) {
      state ? animationController.forward() : animationController.reverse();
    });
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }
}
