import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dompet/models/webview.dart';
import 'package:dompet/routes/router.dart';
import 'package:dompet/service/bind.dart';

class PageWebviewController extends GetxController {
  late final webChannelController = Get.find<WebviewChannelController>();
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final errorHttpsHtml = 'lib/assets/webview/errorHttps.html';
  late final errorUrlHtml = 'lib/assets/webview/errorUrl.html';
  late final vconsoleJs = 'lib/assets/scripts/vconsole.min.js';
  late final webviewJs = 'lib/assets/scripts/webview.min.js';
  late final flutterJs = 'lib/assets/scripts/flutter.min.js';
  late final vdebugJs = 'lib/assets/scripts/vdebug.min.js';
  late final metaJs = 'lib/assets/scripts/meta.min.js';
  late final app = 'lib/assets/webview/app.png';

  late final debug = kDebugMode;
  late final webViewKey = GlobalKey();
  late final webviewMeta = RxWebviewMeta(Get.arguments);
  late final inAppWebViewSettings = InAppWebViewSettings(
    mediaPlaybackRequiresUserGesture: false,
    useShouldOverrideUrlLoading: true,
    javaScriptEnabled: true,
    isInspectable: debug,
    cacheEnabled: true,
  );

  UnmodifiableListView<UserScript>? initialScripts;
  InAppWebViewController? webviewController;
  InAppWebViewInitialData? initialData;
  URLRequest? initialUrl;
  bool? injectScript;
  bool? injectUrl;

  @override
  onInit() async {
    super.onInit();

    webviewMeta.canBack.value = false;
    webviewMeta.loading.value = false;

    if (Platform.isAndroid) {
      InAppWebViewController.setWebContentsDebuggingEnabled(debug);
    }

    loading(true);
    loadUrl();
  }

  @override
  onClose() async {
    super.onClose();

    if (injectScript == true) {
      webChannelController.removeScriptHandlers(this);
    }

    webviewMeta.canBack.value = false;
    webviewMeta.loading.value = false;
    webviewController = null;
    initialScripts = null;
    injectScript = null;
    initialData = null;
    initialUrl = null;
    injectUrl = null;
  }

  // back
  Future<void> back() async {
    if (webviewController == null) {
      return GetRouter.back().catchError((e) {
        GetRouter.offAllNamed(GetRoutes.home);
      });
    }

    if (!await webviewController!.canGoBack()) {
      return GetRouter.back().catchError((e) {
        GetRouter.offAllNamed(GetRoutes.home);
      });
    }

    return webviewController!.goBack();
  }

  // loadUrl
  Future<void> loadUrl() async {
    final url = webviewMeta.url.value;
    final html = webviewMeta.html.value;
    final fromUrl = webviewMeta.fromUrl.value;
    final fromHtml = webviewMeta.fromHtml.value;
    final checkUrl = webviewMeta.checkUrl.value;
    final checkHttps = webviewMeta.checkHttps.value;

    if (initialUrl == null && initialData == null && fromHtml) {
      await loadScripts();
      initialData = InAppWebViewInitialData(data: html);
    }

    if (initialUrl == null && initialData == null && !checkUrl) {
      final data = await rootBundle.loadString(errorUrlHtml);
      initialData = InAppWebViewInitialData(data: data);
      injectUrl = true;
    }

    if (initialUrl == null && initialData == null && !checkHttps) {
      final data = await rootBundle.loadString(errorHttpsHtml);
      initialData = InAppWebViewInitialData(data: data);
      injectUrl = true;
    }

    if (initialUrl == null && initialData == null && fromUrl) {
      await loadScripts();
      initialUrl = URLRequest(url: WebUri.uri(Uri.parse(url)));
    }

    update(['webview']);
  }

  // loadScripts
  Future<void> loadScripts() async {
    if (injectUrl == true) {
      return;
    }

    initialScripts = UnmodifiableListView([
      UserScript(
        source: await rootBundle.loadString(metaJs),
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
      ),
      UserScript(
        source: await rootBundle.loadString(vconsoleJs),
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
      ),
      UserScript(
        source: await rootBundle.loadString(vdebugJs),
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
      ),
      UserScript(
        source: await rootBundle.loadString(flutterJs),
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
      ),
      UserScript(
        source: await rootBundle.loadString(webviewJs),
        injectionTime: UserScriptInjectionTime.AT_DOCUMENT_END,
      ),
    ]);
  }

  // writeScripts
  Future<void> writeScripts() async {
    if (injectUrl == true) {
      return;
    }

    if (webviewController != null) {
      try {
        const id = "_inject__control-app-img";
        const image = "document.getElementById('$id')";
        final buffer = (await rootBundle.load(app)).buffer;
        final bytes = Uint8List.view(buffer);
        final data = base64Encode(bytes);

        webviewController!.evaluateJavascript(
          source: "$image.src='data:image/png;base64,$data'",
        );
      } catch (e) {/* e */}
    }
  }

  // titling
  Future<void> titling(String? title) async {
    title = title ?? '';

    final isEmpty = title.trim() == '';
    final isBlank = title.trim() == 'about:blank';
    final isHtmlContent = title.trim().startsWith('data:text/html;') == true;
    final isFromHttps = title.trim().startsWith('https://') == true;
    final isFromHttp = title.trim().startsWith('http://') == true;

    if (!isEmpty && !isBlank && !isHtmlContent && !isFromHttps && !isFromHttp) {
      webviewMeta.title.value = title.isEmpty ? webviewMeta.title.value : title;
    }

    if (webviewMeta.title.value == '') {
      webviewMeta.title.value = 'Dompet';
    }
  }

  // leading
  Future<void> leading(bool? canBack) async {
    if (webviewMeta.canBack.value != canBack) {
      webviewMeta.canBack.value = canBack == true;
    }
  }

  // loading
  Future<void> loading(bool? loading) async {
    if (loading != null) {
      webviewMeta.loading.value = loading;
    }
  }

  // popuping
  Future<void> popuping(bool? popup) async {
    if (mediaQueryController.orientation.value == Orientation.landscape) {
      return;
    }

    if (popup != null) {
      webviewMeta.popup.value = popup;
    }
  }
}
