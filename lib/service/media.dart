import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MediaQueryController extends GetxService {
  late Rx<EdgeInsets> viewPadding = EdgeInsets.zero.obs;
  late Rx<EdgeInsets> viewInsets = EdgeInsets.zero.obs;
  late Rx<EdgeInsets> padding = EdgeInsets.zero.obs;
  late Rx<double> bottomBar = 56.0.obs;
  late Rx<double> topBar = 56.0.obs;
  late Rx<Size> size = Size.zero.obs;

  void update({
    double? topBar = 56,
    double? bottomBar = 56,
    MediaQueryData? mediaQuery,
  }) {
    if (topBar != null) {
      this.topBar.value = topBar;
    }

    if (bottomBar != null) {
      this.bottomBar.value = bottomBar;
    }

    if (mediaQuery != null) {
      size.value = mediaQuery.size;
      padding.value = mediaQuery.padding;
      viewInsets.value = mediaQuery.viewInsets;
      viewPadding.value = mediaQuery.viewPadding;
    }
  }
}
