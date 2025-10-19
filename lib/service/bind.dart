import 'package:get/get.dart';

import 'package:dompet/service/web.dart';
import 'package:dompet/service/store.dart';
import 'package:dompet/service/event.dart';
import 'package:dompet/service/media.dart';
import 'package:dompet/service/locale.dart';
import 'package:dompet/service/linker.dart';
import 'package:dompet/service/native.dart';
import 'package:dompet/service/sqlite.dart';
import 'package:dompet/service/socket.dart';
import 'package:dompet/service/network.dart';

export 'package:dompet/service/web.dart';
export 'package:dompet/service/store.dart';
export 'package:dompet/service/event.dart';
export 'package:dompet/service/media.dart';
export 'package:dompet/service/locale.dart';
export 'package:dompet/service/linker.dart';
export 'package:dompet/service/native.dart';
export 'package:dompet/service/sqlite.dart';
export 'package:dompet/service/socket.dart';
export 'package:dompet/service/network.dart';

final binds = [
  Bind.put<StoreController>(StoreController()),
  Bind.put<EventController>(EventController()),
  Bind.put<LocaleController>(LocaleController()),
  Bind.put<SqliteController>(SqliteController()),
  Bind.put<NetworkController>(NetworkController()),
  Bind.put<AppLinkController>(AppLinkController()),
  Bind.put<IOSocketController>(IOSocketController()),
  Bind.put<MediaQueryController>(MediaQueryController()),
  Bind.put<NativeChannelController>(NativeChannelController()),
  Bind.put<WebviewChannelController>(WebviewChannelController()),
];
