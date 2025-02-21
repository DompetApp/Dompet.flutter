import 'package:get/get.dart';
import 'package:dompet/service/media.dart';

extension DoubleExtension on double {
  int get ceil {
    return this.ceil();
  }

  int get round {
    return this.round();
  }

  int get floor {
    return this.floor();
  }

  int get integer {
    return toInt();
  }
}

extension IntegerExtension on int {
  double get float {
    return toDouble();
  }
}

extension SizeExtension on num {
  static const preset = 375.0;
  static final width = Get.find<MediaQueryController>().width;
  static final height = Get.find<MediaQueryController>().height;

  double get vw {
    return this * width.value / 100;
  }

  double get vh {
    return this * height.value / 100;
  }

  double get vmin {
    return width.value > height.value
        ? this * height.value / 100
        : this * width.value / 100;
  }

  double get vmax {
    return width.value > height.value
        ? this * width.value / 100
        : this * height.value / 100;
  }

  double get wmax {
    return this < width.value ? this / 1 : width.value;
  }

  double get wmin {
    return this > width.value ? this / 1 : width.value;
  }

  double get hmax {
    return this < height.value ? this / 1 : height.value;
  }

  double get hmin {
    return this > height.value ? this / 1 : height.value;
  }

  double get max {
    return this < 100.vmin ? this / 1 : 100.vmin;
  }

  double get min {
    return this > 100.vmax ? this / 1 : 100.vmax;
  }

  double get wdp {
    return this * width.value.sr;
  }

  double get hdp {
    return this * height.value.sr;
  }

  double get sr {
    return this / preset;
  }
}
