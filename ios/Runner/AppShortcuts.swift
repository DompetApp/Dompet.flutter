import UIKit
import Foundation

fileprivate var activeShortcut: UIApplicationShortcutItem?

func initActiveShortcut (_ shortcutItem: UIApplicationShortcutItem) {
    isInitialized() ? openActiveShortcut(shortcutItem) : setActiveShortcut(shortcutItem)
}

func openActiveShortcut (_ shortcutItem: UIApplicationShortcutItem? = nil) {
    if (shortcutItem == nil) {
      return
    }
    
    let type = "com.example.dompet.shortcut"
    let maps = ["shortcut": shortcutItem!.type]
    
    getMessenger().invokeMethod(type, arguments: maps)
    
    setActiveShortcut()
}

func setActiveShortcut (_ shortcutItem: UIApplicationShortcutItem? = nil) {
    activeShortcut = shortcutItem
}

func getActiveShortcut () -> UIApplicationShortcutItem? {
    return activeShortcut
}

func initAppShortcuts () {
    UIApplication.shared.shortcutItems = [
        UIApplicationShortcutItem(
            type: "com.example.dompet.shortcut.bill",
            localizedTitle: NSLocalizedString("MyBill", comment: ""),
            localizedSubtitle: nil,
            icon: UIApplicationShortcutIcon(templateImageName: "BillIcon")
        )
    ]
}
