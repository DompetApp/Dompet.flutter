import UIKit
import Flutter
import Foundation

fileprivate var initialized: Bool = false
fileprivate var messenger: FlutterMethodChannel?

func isInitialized () -> Bool {
    return initialized
}

func getMessenger () -> FlutterMethodChannel {
    return messenger!
}

func setMessenger (controller: FlutterBinaryMessenger) {
    messenger = FlutterMethodChannel(
        name: "app.native/methodChannel",
        binaryMessenger: controller
    )
    setMessengerHandler(messenger: messenger!)
}

func setMessengerHandler (messenger: FlutterMethodChannel) {
    messenger.setMethodCallHandler {
    (call, result) in
        if "invokerNativeMethodChannel" == call.method {
            openActiveShortcut(getActiveShortcut())
            initialized = true
            result(true)
            return
        }
        result(FlutterMethodNotImplemented)
    }
}
