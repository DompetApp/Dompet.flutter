import 'package:permission_handler/permission_handler.dart';

class Permissioner {
  static Future<bool> openSettings() {
    return openAppSettings();
  }

  static Future<bool> mediaLibrary() async {
    // IOS 9.3+ only

    if (await Permission.mediaLibrary.status.isGranted) {
      return true;
    }

    if (await Permission.mediaLibrary.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> photosAddOnly() async {
    // IOS only

    if (await Permission.photosAddOnly.status.isGranted) {
      return true;
    }

    if (await Permission.photosAddOnly.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> sensorsAlways() async {
    if (await Permission.sensorsAlways.status.isGranted) {
      return true;
    }

    if (await Permission.sensorsAlways.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> bluetoothConnect() async {
    if (await Permission.bluetoothConnect.status.isGranted) {
      return true;
    }

    if (await Permission.bluetoothConnect.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> nearbyWifiDevices() async {
    if (await Permission.nearbyWifiDevices.status.isGranted) {
      return true;
    }

    if (await Permission.nearbyWifiDevices.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> systemAlertWindow() async {
    // Android only

    if (await Permission.systemAlertWindow.status.isGranted) {
      return true;
    }

    if (await Permission.systemAlertWindow.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> backgroundRefresh() async {
    // IOS only

    if (await Permission.backgroundRefresh.status.isGranted) {
      return true;
    }

    if (await Permission.backgroundRefresh.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> calendarWriteOnly() async {
    if (await Permission.calendarWriteOnly.status.isGranted) {
      return true;
    }

    if (await Permission.calendarWriteOnly.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> calendarFullAccess() async {
    if (await Permission.calendarFullAccess.status.isGranted) {
      return true;
    }

    if (await Permission.calendarFullAccess.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> scheduleExactAlarm() async {
    if (await Permission.scheduleExactAlarm.status.isGranted) {
      return true;
    }

    if (await Permission.scheduleExactAlarm.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> bluetoothAdvertise() async {
    if (await Permission.bluetoothAdvertise.status.isGranted) {
      return true;
    }

    if (await Permission.bluetoothAdvertise.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> accessMediaLocation() async {
    if (await Permission.accessMediaLocation.status.isGranted) {
      return true;
    }

    if (await Permission.accessMediaLocation.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> activityRecognition() async {
    if (await Permission.activityRecognition.status.isGranted) {
      return true;
    }

    if (await Permission.activityRecognition.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> manageExternalStorage() async {
    if (await Permission.manageExternalStorage.status.isGranted) {
      return true;
    }

    if (await Permission.manageExternalStorage.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> requestInstallPackages() async {
    if (await Permission.requestInstallPackages.status.isGranted) {
      return true;
    }

    if (await Permission.requestInstallPackages.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> appTrackingTransparency() async {
    // IOS only

    if (await Permission.appTrackingTransparency.status.isGranted) {
      return true;
    }

    if (await Permission.appTrackingTransparency.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> ignoreBatteryOptimizations() async {
    // Android only

    if (await Permission.ignoreBatteryOptimizations.status.isGranted) {
      return true;
    }

    if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> accessNotificationPolicy() async {
    if (await Permission.accessNotificationPolicy.status.isGranted) {
      return true;
    }

    if (await Permission.accessNotificationPolicy.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> locationWhenInUse() async {
    if (await Permission.locationWhenInUse.status.isGranted) {
      return true;
    }

    if (await Permission.locationWhenInUse.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> locationAlways() async {
    if (await Permission.locationAlways.status.isGranted) {
      return true;
    }

    if (await Permission.locationAlways.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> criticalAlerts() async {
    // IOS only

    if (await Permission.criticalAlerts.status.isGranted) {
      return true;
    }

    if (await Permission.criticalAlerts.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> bluetoothScan() async {
    if (await Permission.bluetoothScan.status.isGranted) {
      return true;
    }

    if (await Permission.bluetoothScan.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> notification() async {
    if (await Permission.notification.status.isGranted) {
      return true;
    }

    if (await Permission.notification.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> microphone() async {
    if (await Permission.microphone.status.isGranted) {
      return true;
    }

    if (await Permission.microphone.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> bluetooth() async {
    if (await Permission.bluetooth.status.isGranted) {
      return true;
    }

    if (await Permission.bluetooth.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> reminders() async {
    // IOS only

    if (await Permission.reminders.status.isGranted) {
      return true;
    }

    if (await Permission.reminders.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> assistant() async {
    if (await Permission.assistant.status.isGranted) {
      return true;
    }

    if (await Permission.assistant.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> location() async {
    if (await Permission.location.status.isGranted) {
      return true;
    }

    if (await Permission.location.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> contacts() async {
    if (await Permission.contacts.status.isGranted) {
      return true;
    }

    if (await Permission.contacts.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> storage() async {
    if (await Permission.storage.status.isGranted) {
      return true;
    }

    if (await Permission.storage.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> sensors() async {
    if (await Permission.sensors.status.isGranted) {
      return true;
    }

    if (await Permission.sensors.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> speech() async {
    if (await Permission.speech.status.isGranted) {
      return true;
    }

    if (await Permission.speech.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> camera() async {
    if (await Permission.camera.status.isGranted) {
      return true;
    }

    if (await Permission.camera.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> photos() async {
    if (await Permission.photos.status.isGranted) {
      return true;
    }

    if (await Permission.photos.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> videos() async {
    if (await Permission.videos.status.isGranted) {
      return true;
    }

    if (await Permission.videos.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> audio() async {
    if (await Permission.audio.status.isGranted) {
      return true;
    }

    if (await Permission.audio.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> phone() async {
    // Android only

    if (await Permission.phone.status.isGranted) {
      return true;
    }

    if (await Permission.phone.request().isGranted) {
      return true;
    }

    return false;
  }

  static Future<bool> sms() async {
    // Android only

    if (await Permission.sms.status.isGranted) {
      return true;
    }

    if (await Permission.sms.request().isGranted) {
      return true;
    }

    return false;
  }
}
