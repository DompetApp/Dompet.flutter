import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:dompet/service/media.dart';

extension MoneyExtension on num {
  static const preset = 375.0;
  static final width = Get.find<MediaQueryController>().width;
  static final height = Get.find<MediaQueryController>().height;

  String get usd {
    return NumberFormat("#,##0.00").format(this);
  }
}
