import 'dart:async';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:dompet/models/webview.dart';
import 'package:dompet/routes/router.dart';
import 'package:dompet/service/bind.dart';

class AppLinkController extends GetxService {
  late final storeController = Get.find<StoreController>();
  late final AppLinks appLinker = AppLinks();

  late StreamSubscription? subscription;
  late Completer completer;
  late Timer? timer;

  @override
  void onInit() {
    super.onInit();
    subscription = appLinker.stringLinkStream.listen((link) => forward(link));
    completer = Completer()..complete(false);
    timer = null;
  }

  @override
  void onClose() {
    super.onClose();
    timer?.cancel();
    subscription?.cancel();

    if (!completer.isCompleted) {
      completer.complete(false);
    }

    subscription = null;
    timer = null;
  }

  Future<void> timeout(Completer completer) async {
    timer?.cancel();

    timer = Timer(Duration(seconds: 90), () {
      if (!completer.isCompleted) {
        completer.complete(false);
        timer = null;
      }
    });
  }

  Future<void> waiting(Completer completer) async {
    final status = await storeController.homeFuture;

    if (!completer.isCompleted) {
      completer.complete(status);
      timer?.cancel();
      timer = null;
    }
  }

  Future<void> forward(dynamic link, [dynamic params]) async {
    if (link == true) {
      link = await appLinker.getLatestLinkString();
    }

    if (link is! String) {
      return;
    }

    if (link.trim().isEmpty) {
      return;
    }

    if (link.trim().isNotEmpty) {
      link = link.trim();
    }

    if (completer.isCompleted != true) {
      completer.complete(false);
      timer?.cancel();
      timer = null;
    }

    if (completer.isCompleted == true) {
      completer = Completer();
      waiting(completer);
      timeout(completer);
    }

    completer.future.then((ready) {
      if (ready != true || !GetRoutes.authorize.contains(link)) {
        return;
      }

      if (link != GetRoutes.webview) {
        GetRouter.toNamed(link, arguments: params);
        return;
      }

      if (params is WebviewMeta) {
        GetRouter.toNamed(link, arguments: params);
        return;
      }

      if (params is Map) {
        final arguments = WebviewMeta(
          key: params['key'] is String ? params['key'] : null,
          url: params['url'] is String ? params['url'] : null,
          html: params['html'] is String ? params['html'] : null,
          title: params['title'] is String ? params['title'] : null,
          query: params['query'] is Map ? params['query'] : null,
          checkHttps: params['checkHttps'] == true,
          checkUrl: params['checkUrl'] == true,
          fromHtml: params['fromHtml'] == true,
          fromUrl: params['fromUrl'] == true,
          loading: params['loading'] == true,
          popup: params['popup'] == true,
        );

        GetRouter.toNamed(link, arguments: arguments);
        return;
      }
    });
  }
}
