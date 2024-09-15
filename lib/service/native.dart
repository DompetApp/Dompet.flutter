import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class NativeChannelController extends GetxService {
  late final nativeMessenger = const MethodChannel('app.native/methodChannel');

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
    return nativeMessenger.setMethodCallHandler((call) async {});
  }
}
