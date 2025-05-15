import app_links
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
    override func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        
        if let url = AppLinks.shared.getLink(launchOptions: launchOptions) {
          AppLinks.shared.handleLink(url: url)
          return true
        }
        
        initAppShortcuts()
        setMessenger(controller: self.window.rootViewController as! FlutterBinaryMessenger)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    override func application(_ application: UIApplication, performActionFor shortcutItem: UIApplicationShortcutItem, completionHandler: @escaping (Bool) -> Void) {
        initActiveShortcut(shortcutItem)
    }
}
