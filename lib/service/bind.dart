import 'package:get/get.dart';

import 'package:dompet/service/event.dart';
import 'package:dompet/service/media.dart';
import 'package:dompet/service/store.dart';
import 'package:dompet/service/locale.dart';
import 'package:dompet/service/native.dart';
import 'package:dompet/service/socket.dart';
import 'package:dompet/service/sqlite.dart';
import 'package:dompet/service/webview.dart';

export 'package:dompet/service/event.dart';
export 'package:dompet/service/media.dart';
export 'package:dompet/service/store.dart';
export 'package:dompet/service/locale.dart';
export 'package:dompet/service/native.dart';
export 'package:dompet/service/socket.dart';
export 'package:dompet/service/sqlite.dart';
export 'package:dompet/service/webview.dart';

class AllBinding implements Bindings {
  @override
  void dependencies() {
    Get.put<EventController>(EventController());
    Get.put<StoreController>(StoreController());
    Get.put<LocaleController>(LocaleController());
    Get.put<SocketController>(SocketController());
    Get.put<SqliteController>(SqliteController());
    Get.put<MediaQueryController>(MediaQueryController());
    Get.put<NativeChannelController>(NativeChannelController());
    Get.put<WebviewChannelController>(WebviewChannelController());
  }
}
