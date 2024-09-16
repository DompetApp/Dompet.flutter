import 'package:get/get.dart';
import 'package:dompet/service/media.dart';

extension SizeExtension on num {
  static const double preset = 375.0;

  double get vw {
    return this * Get.find<MediaQueryController>().width.value / 100;
  }

  double get vh {
    return this * Get.find<MediaQueryController>().height.value / 100;
  }

  double get dp {
    return this * Get.find<MediaQueryController>().width.value / preset;
  }
}
