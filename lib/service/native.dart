import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class NativeChannelController extends GetxService {
  late final eventChannel = const EventChannel('app.native/eventChannel');
  late final methodChannel = const MethodChannel('app.native/methodChannel');

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
      // final arguments = call.arguments;
      // final method = call.method;
    });
  }
}
