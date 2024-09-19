import 'package:get/get.dart';
import 'package:dompet/service/media.dart';

extension SizeExtension on num {
  static const double preset = 375.0;
  static final Rx<double> width = Get.find<MediaQueryController>().width;
  static final Rx<double> height = Get.find<MediaQueryController>().height;

  double get vw {
    return this * width.value / 100;
  }

  double get vh {
    return this * height.value / 100;
  }

  double get vmin {
    return width.value > height.value ? height.value / 100 : width.value / 100;
  }

  double get vmax {
    return width.value > height.value ? width.value / 100 : height.value / 100;
  }

  double get max {
    return this < width.value ? this / 1 : width.value;
  }

  double get min {
    return this > width.value ? this / 1 : width.value;
  }

  double get sr {
    return this / preset;
  }

  double get dp {
    return width.value.sr;
  }
}
