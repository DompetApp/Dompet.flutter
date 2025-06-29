package com.example.dompet

import android.content.Intent
import android.content.Context
import android.content.ComponentName
import android.graphics.drawable.Icon
import android.content.pm.ShortcutInfo
import android.content.pm.ShortcutManager

private var activeShortcut: Intent? = null

fun initAppShortcuts (mainActivity: MainActivity?) {
  if (android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.O) {
    val activity = mainActivity ?: getMainActivity()
    val activityService = activity.getSystemService(Context.SHORTCUT_SERVICE)
    val shortcutManager = activityService as ShortcutManager

    if (shortcutManager.isRequestPinShortcutSupported) {
      val shortcutIntent = Intent(Intent.ACTION_VIEW)

      shortcutIntent.setComponent(
        ComponentName(
          "com.example.dompet",
          "com.example.dompet.MainActivity"
        )
      )

      shortcutIntent.putExtra("intentKey", "com.example.dompet.shortcut")
      shortcutIntent.putExtra("shortcutKey", "com.example.dompet.shortcut.bill")

      shortcutManager.addDynamicShortcuts(mutableListOf(
        ShortcutInfo.Builder(activity, "bill")
          .setIcon(Icon.createWithResource(activity, R.drawable.shortcut_bill))
          .setShortLabel(activity.getString(R.string.shortcut_short_bill))
          .setLongLabel(activity.getString(R.string.shortcut_long_bill))
          .setIntent(shortcutIntent)
          .build()
      ));
    }
  }
}

fun initActiveShortcut (shortcutItem: Intent? = null) {
  if (isInitialized()) openActiveShortcut(shortcutItem)
  else setActiveShortcut(shortcutItem)
}

fun openActiveShortcut (shortcutItem: Intent? = null) {
  if (shortcutItem == null) {
    return
  }

  val method = shortcutItem.getStringExtra("intentKey")
  val shortcut = shortcutItem.getStringExtra("shortcutKey")

  if (method != null) {
    getMethodChannel()?.invokeMethod(method, mapOf("shortcut" to shortcut))
  }

  setActiveShortcut(null)
}

fun setActiveShortcut (shortcutItem: Intent? = null) {
  activeShortcut = shortcutItem
}

fun getActiveShortcut () : Intent? {
  return activeShortcut
}
