import 'package:get/get.dart';

extension SizeExtension on num {
  static const double preset = 375.0;

  double get scale {
    return Get.width / preset;
  }

  double get dp {
    return this * scale;
  }
}
