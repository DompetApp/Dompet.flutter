import Flutter
import Foundation

class AppStreamHandler: NSObject, FlutterStreamHandler {
  private var onInnerListen: ((Any?, @escaping FlutterEventSink) -> FlutterError?)?
  private var onInnerCancel: ((Any?) -> FlutterError?)?

  init(
    onListen: @escaping (Any?, @escaping FlutterEventSink) -> FlutterError?,
    onCancel: @escaping (Any?) -> FlutterError?
  ) {
    super.init()
    self.onInnerListen = onListen
    self.onInnerCancel = onCancel
  }

  func onListen(withArguments args: Any?, eventSink sink: @escaping FlutterEventSink) -> FlutterError? {
    return onInnerListen?(args, sink)
  }

  func onCancel(withArguments args: Any?) -> FlutterError? {
    return onInnerCancel?(args)
  }
}
