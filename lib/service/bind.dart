import 'package:get/get.dart';
import 'package:dompet/service/media.dart';
import 'package:dompet/service/store.dart';
import 'package:dompet/service/native.dart';
import 'package:dompet/service/socket.dart';
import 'package:dompet/service/sqlite.dart';
import 'package:dompet/service/webview.dart';

export 'package:dompet/service/media.dart';
export 'package:dompet/service/store.dart';
export 'package:dompet/service/native.dart';
export 'package:dompet/service/socket.dart';
export 'package:dompet/service/sqlite.dart';
export 'package:dompet/service/webview.dart';

class AllBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<StoreController>(StoreController());
    Get.put<SocketController>(SocketController());
    Get.put<SqliteController>(SqliteController());
    Get.put<MediaQueryController>(MediaQueryController());
    Get.put<NativeChannelController>(NativeChannelController());
    Get.put<WebviewChannelController>(WebviewChannelController());
  }
}
