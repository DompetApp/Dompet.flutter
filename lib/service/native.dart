import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:dompet/service/linker.dart';
import 'package:dompet/routes/router.dart';

class NativeChannelController extends GetxService {
  late final nativeMessenger = const MethodChannel('app.native/methodChannel');
  late final appLinkController = Get.find<AppLinkController>();

  @override
  void onInit() async {
    super.onInit();
    invokerNativeMethodChannel();
    registerNativeMethodChannel();
  }

  Future<void> invokerNativeMethodChannel() async {
    return nativeMessenger.invokeMethod('invokerNativeMethodChannel');
  }

  Future<void> registerNativeMethodChannel() async {
    return nativeMessenger.setMethodCallHandler((call) async {
      final method = call.method;
      final arguments = call.arguments;
      final shortcutType = arguments is Map ? arguments['shortcut'] : null;

      if (method == 'com.example.dompet.shortcut') {
        switch (shortcutType) {
          case 'com.example.dompet.shortcut.bill':
            appLinkController.forward(GetRoutes.stats);
            break;
        }
      }
    });
  }
}
