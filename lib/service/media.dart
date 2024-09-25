import 'package:get/get.dart';
import 'package:flutter/material.dart';

class MediaQueryController extends GetxService {
  late Rx<TextScaler> textScaler = const TextScaler.linear(1.0).obs;
  late Rx<Orientation> orientation = Orientation.portrait.obs;
  late Rx<EdgeInsets> viewPadding = EdgeInsets.zero.obs;
  late Rx<EdgeInsets> viewInsets = EdgeInsets.zero.obs;
  late Rx<EdgeInsets> padding = EdgeInsets.zero.obs;
  late Rx<double> height = Size.zero.height.obs;
  late Rx<double> width = Size.zero.width.obs;
  late Rx<double> bottomBar = 56.0.obs;
  late Rx<double> topBar = 56.0.obs;

  final double minScale = 0.85;
  final double maxScale = 1.05;

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
      padding.value = mediaQuery.padding;
      width.value = mediaQuery.size.width;
      height.value = mediaQuery.size.height;
      viewInsets.value = mediaQuery.viewInsets;
      orientation.value = mediaQuery.orientation;
      viewPadding.value = mediaQuery.viewPadding;

      textScaler.value = mediaQuery.textScaler.clamp(
        minScaleFactor: minScale,
        maxScaleFactor: maxScale,
      );
    }
  }
}
