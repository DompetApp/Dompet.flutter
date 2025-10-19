import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:dompet/service/linker.dart';
import 'package:dompet/routes/navigator.dart';

class NativeChannelController extends GetxService {
  late final eventChannel = const EventChannel('app.native/eventChannel');
  late final methodChannel = const MethodChannel('app.native/methodChannel');
  late final appLinkController = Get.find<AppLinkController>();

  @override
  void onInit() async {
    super.onInit();
    invokerNativeMethodChannel();
    registerNativeMethodChannel();
  }

  Future<void> invokerNativeMethodChannel() async {
    return methodChannel.invokeMethod('invokeNativeMethodChannel');
  }

  Future<void> registerNativeMethodChannel() async {
    return methodChannel.setMethodCallHandler((call) async {
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
