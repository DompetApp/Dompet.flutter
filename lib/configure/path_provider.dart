import 'dart:io';
import 'package:path_provider/path_provider.dart' as provider;

class PathProvider {
  // 临时路径 - 适用于存储下载文件的缓存
  static Future<Directory> getTemporaryDirectory() async {
    return provider.getTemporaryDirectory();
  }

  // 应用程序支持的目录路径 - 不向用户公开的文件
  static Future<Directory> getApplicationSupportDirectory() async {
    return provider.getApplicationSupportDirectory();
  }

  // 由用户生成的，应用程序无法创建
  static Future<Directory> getApplicationDocumentsDirectory() async {
    return provider.getApplicationDocumentsDirectory();
  }

  // 返回可用的顶级存储的文件路径 - Android
  static Future<List<Directory>?> getExternalStorageDirectories() async {
    if (Platform.isAndroid) {
      return provider.getExternalStorageDirectories();
    }
    return null;
  }

  // 返回可用的顶级存储的缓存路径 - Android
  static Future<List<Directory>?> getExternalCacheDirectories() async {
    if (Platform.isAndroid) {
      return provider.getExternalCacheDirectories();
    }
    return null;
  }

  // 应用程序访问顶级存储的文件路径 - Android
  static Future<Directory?> getExternalStorageDirectory() async {
    if (Platform.isAndroid) {
      return provider.getExternalStorageDirectory();
    }
    return null;
  }

  // 应用程序访问顶级存储的缓存路径 - Desktop
  static Future<Directory?> getDownloadsDirectory() async {
    if (Platform.isFuchsia ||
        Platform.isLinux ||
        Platform.isMacOS ||
        Platform.isWindows) {
      return provider.getDownloadsDirectory();
    }
    return null;
  }

  // 应用程序可以存储持久文件的目录的路径 - IOS
  static Future<Directory?> getLibraryDirectory() async {
    if (Platform.isIOS) {
      return provider.getLibraryDirectory();
    }
    return null;
  }
}
