import 'dart:async';
import 'package:get/get.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/logger/logger.dart';

class PageLoggerController extends GetxController {
  late final mediaQueryController = Get.find<MediaQueryController>();

  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaTopBar = mediaQueryController.topBar;

  late final isUpdating = false.obs;
  late final isShadow = true.obs;
  late final isFirst = true.obs;
  late final loading = true.obs;
  late final string = ''.obs;

  Timer? timer;

  @override
  onInit() async {
    super.onInit();
    logger.addListener(readAsString);
  }

  @override
  onClose() async {
    super.onClose();

    logger.removeListener(readAsString);

    if (timer?.isActive == true) {
      timer!.cancel();
    }
  }

  void readAsString() async {
    if (isFirst.value) {
      isFirst.value = false;
      isUpdating.value = true;
      string.value = await logger.readAsString() ?? '';
      isUpdating.value = false;
      loading.value = false;
      timer = null;
      return;
    }

    if (isUpdating.value) {
      return;
    }

    isUpdating.value = true;

    timer = Timer(Duration(seconds: 3), () async {
      string.value = await logger.readAsString() ?? '';
      isUpdating.value = false;
      loading.value = false;
    });
  }
}
