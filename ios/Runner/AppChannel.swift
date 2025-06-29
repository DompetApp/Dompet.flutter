import Flutter
import Foundation
import UIKit

private var initialized: Bool = false
private var eventChannel: FlutterEventChannel?
private var methodChannel: FlutterMethodChannel?

func isInitialized() -> Bool {
  return initialized
}

func getEventChannel() -> FlutterEventChannel? {
  return eventChannel
}

func getMethodChannel() -> FlutterMethodChannel? {
  return methodChannel
}

func setEventChannel(controller: FlutterBinaryMessenger) {
  eventChannel = FlutterEventChannel(
    name: "app.native/eventChannel",
    binaryMessenger: controller
  )

  setEventChannelHandler(eventChannel: eventChannel!)
}

func setMethodChannel(controller: FlutterBinaryMessenger) {
  methodChannel = FlutterMethodChannel(
    name: "app.native/methodChannel",
    binaryMessenger: controller
  )
  setMethodChannelHandler(methodChannel: methodChannel!)
}

func setEventChannelHandler(eventChannel: FlutterEventChannel) {
  eventChannel.setStreamHandler(
    AppStreamHandler(
      onListen: { (args, sink) in
        return nil
      },
      onCancel: { (args) in
        return nil
      }
    )
  )
}

func setMethodChannelHandler(methodChannel: FlutterMethodChannel) {
  methodChannel.setMethodCallHandler {
    (call, result) in
    if "invokeNativeMethodChannel" == call.method {
      openActiveShortcut(getActiveShortcut())
      initialized = true
      result(true)
      return
    }
    result(FlutterMethodNotImplemented)
  }
}
