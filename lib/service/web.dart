import 'dart:async';
import 'package:get/get.dart';
import 'package:dompet/configure/get_dialoger.dart';
import 'package:dompet/configure/permission_handler.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dompet/pages/webview/controller.dart';
import 'package:dompet/models/channel.dart';
import 'package:dompet/routes/router.dart';
import 'package:dompet/service/bind.dart';

class WebviewChannelController extends GetxService {
  Future<void> createScriptHandlers(PageWebviewController controller) async {
    late final nativeChannelController = Get.find<NativeChannelController>();
    late final webviewController = controller.webviewController;

    if (webviewController != null) {
      final proxyer = WebviewChannelHandler(
        webviewController: webviewController,
        nativeChannelController: nativeChannelController,
      );

      webviewController.addJavaScriptHandler(
        handlerName: 'ToJavaScriptHandler',
        callback: (params) async {
          final caller = params[0];
          final options = params[1];

          if (caller == 'CallRelaunch') {
            return proxyer.relaunch(options: options);
          }

          if (caller == 'CallRedirectTo') {
            return proxyer.redirectTo(options: options);
          }

          if (caller == 'CallNavigateTo') {
            return proxyer.navigateTo(options: options);
          }

          if (caller == 'CallNavigateBack') {
            return proxyer.navigateBack(options: options);
          }

          if (caller == 'CallScanQRCode') {
            return proxyer.scanQRCode(options: options);
          }

          return ChannelResult(status: 'failure', message: null, result: null);
        },
      );

      controller.injectScript = true;
    }
  }

  Future<void> removeScriptHandlers(PageWebviewController controller) async {
    if (controller.webviewController != null) {
      controller.webviewController!.removeJavaScriptHandler(
        handlerName: 'ToJavaScriptHandler',
      );
    }

    controller.injectScript = false;
  }
}

class WebviewChannelHandler {
  WebviewChannelHandler({
    required this.webviewController,
    required this.nativeChannelController,
  });

  InAppWebViewController webviewController;
  NativeChannelController nativeChannelController;

  Future<ChannelResult> relaunch({required dynamic options}) async {
    try {
      final page = options['page'];

      if (page is! String) {
        return ChannelResult.failure(
          message: '[page] was not provided or invalid',
        );
      }

      await GetRouter.offAllNamed(page);
      return ChannelResult.success();
    } catch (e) {
      return ChannelResult(message: e.toString(), status: 'failure');
    }
  }

  Future<ChannelResult> redirectTo({required dynamic options}) async {
    try {
      final page = options['page'];

      if (page is! String) {
        return ChannelResult.failure(
          message: '[page] was not provided or invalid',
        );
      }

      await GetRouter.offNamed(page);
      return ChannelResult.success();
    } catch (e) {
      return ChannelResult(message: e.toString(), status: 'failure');
    }
  }

  Future<ChannelResult> navigateTo({required dynamic options}) async {
    try {
      final page = options['page'];

      if (page is! String) {
        return ChannelResult.failure(
          message: '[page] was not provided or invalid',
        );
      }

      await GetRouter.toNamed(page);
      return ChannelResult.success();
    } catch (e) {
      return ChannelResult(message: e.toString(), status: 'failure');
    }
  }

  Future<ChannelResult> navigateBack({required dynamic options}) async {
    try {
      var delta = options['delta'];

      if (delta is! int || delta <= 0) {
        return ChannelResult.failure(
          message: '[page] was not provided or invalid',
        );
      }

      if (delta > 0) {
        await GetRouter.until((route) {
          return route.name != GetRoutes.webview || delta-- <= 0;
        });
      }

      return ChannelResult.success();
    } catch (e) {
      return ChannelResult(message: e.toString(), status: 'failure');
    }
  }

  Future<ChannelResult> scanQRCode({required dynamic options}) async {
    if (!await Permissioner.camera()) {
      await Dialoger.show(
        message: 'System_Open_Camera_Permission'.tr,
        textConfirm: 'System_To_Settings'.tr,
        onConfirm: () {
          Permissioner.openSettings();
        },
      );

      return ChannelResult.failure(
        message: 'scanQRCode requires camera permission for authorization',
      );
    }

    try {
      final result = await GetRouter.toNamed<ChannelResult>(GetRoutes.scanner);
      return result ?? ChannelResult.failure(message: 'Scanned result unknown');
    } catch (error) {
      return ChannelResult.failure(message: error.toString());
    }
  }
}
