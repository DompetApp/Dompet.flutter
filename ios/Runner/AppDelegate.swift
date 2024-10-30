import app_links
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let controller = self.window.rootViewController as! FlutterBinaryMessenger

        if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
          AppLinks.shared.handleLink(url: url)
          return true
        }
        
        initAppShortcuts()
        setMessenger(controller: controller)
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        initActiveShortcut(shortcutItem)
    }
}
