import 'package:get/get.dart';

import 'package:dompet/service/store.dart';
import 'package:dompet/service/event.dart';
import 'package:dompet/service/media.dart';
import 'package:dompet/service/locale.dart';
import 'package:dompet/service/linker.dart';
import 'package:dompet/service/native.dart';
import 'package:dompet/service/sqlite.dart';
import 'package:dompet/service/webview.dart';

export 'package:dompet/service/store.dart';
export 'package:dompet/service/event.dart';
export 'package:dompet/service/media.dart';
export 'package:dompet/service/locale.dart';
export 'package:dompet/service/linker.dart';
export 'package:dompet/service/native.dart';
export 'package:dompet/service/sqlite.dart';
export 'package:dompet/service/webview.dart';

final bindings = [
  Bind.put<StoreController>(StoreController()),
  Bind.put<EventController>(EventController()),
  Bind.put<LocaleController>(LocaleController()),
  Bind.put<SqliteController>(SqliteController()),
  Bind.put<AppLinkController>(AppLinkController()),
  Bind.put<MediaQueryController>(MediaQueryController()),
  Bind.put<NativeChannelController>(NativeChannelController()),
  Bind.put<WebviewChannelController>(WebviewChannelController()),
];
