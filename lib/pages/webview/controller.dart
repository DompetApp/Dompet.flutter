import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:collection';
import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dompet/routes/router.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/models/web.dart';

class PageWebviewController extends GetxController {
  late final localeController = Get.find<LocaleController>();
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final webChannelController = Get.find<WebviewChannelController>();
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
  late final languageCode = localeController.languageCode;
  late final inAppWebViewSettings = InAppWebViewSettings(
    regexToAllowSyncUrlLoading: r'^(http://|https://).*',
    allowsBackForwardNavigationGestures: true,
    limitsNavigationsToAppBoundDomains: false,
    mediaPlaybackRequiresUserGesture: false,
    allowUniversalAccessFromFileURLs: false,
    useShouldInterceptFetchRequest: false,
    useShouldInterceptAjaxRequest: false,
    allowFileAccessFromFileURLs: false,
    useShouldOverrideUrlLoading: true,
    javaScriptEnabled: true,
    isInspectable: debug,
    cacheEnabled: true,
  );

  UnmodifiableListView<UserScript>? initialScripts;
  InAppWebViewController? webviewController;
  InAppWebViewInitialData? initialData;
  Rx<bool> canPop = true.obs;

  URLRequest? initialUrl;
  bool? injectScript;
  bool? localUrl;

  @override
  onInit() async {
    super.onInit();

    webviewMeta.popup.value = false;
    webviewMeta.loading.value = false;

    HardwareKeyboard.instance.addHandler(keyboard);

    if (Platform.isAndroid) {
      InAppWebViewController.setWebContentsDebuggingEnabled(debug);
    }

    await loading(true);
    await loadAgent();
    await loadUrl();
  }

  @override
  onClose() async {
    if (injectScript == true) {
      webChannelController.removeScriptHandlers(this);
    }

    HardwareKeyboard.instance.removeHandler(keyboard);

    webviewMeta.loading.value = false;
    webviewController = null;
    initialScripts = null;
    injectScript = null;
    initialData = null;
    initialUrl = null;
    localUrl = null;

    super.onClose();
  }

  // back
  Future<void> back() async {
    try {
      final allow = await webviewController?.canGoBack() ?? false;
      return allow ? webviewController!.goBack() : GetRouter.back();
    } catch (e) {
      GetRouter.offAllNamed(GetRoutes.home);
    }
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
      localUrl = true;
    }

    if (initialUrl == null && initialData == null && !checkHttps) {
      final data = await rootBundle.loadString(errorHttpsHtml);
      initialData = InAppWebViewInitialData(data: data);
      localUrl = true;
    }

    if (initialUrl == null && initialData == null && fromUrl) {
      await loadScripts();

      initialUrl = URLRequest(
        url: WebUri.uri(Uri.parse(url)),
        headers: {'Accept-Language': languageCode},
        cachePolicy: URLRequestCachePolicy.USE_PROTOCOL_CACHE_POLICY,
      );
    }

    update(['webview']);
  }

  // loadAgent
  Future<void> loadAgent() async {
    return InAppWebViewController.getDefaultUserAgent().then((ua) {
      inAppWebViewSettings.userAgent = '$ua DompetApp/1.0';
    });
  }

  // loadScripts
  Future<void> loadScripts() async {
    if (localUrl == true) {
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
    if (localUrl == true) {
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
      } catch (e) {
        /* e */
      }
    }
  }

  // focusWebview
  Future<void> focusWebview() async {
    await webviewController?.requestFocus();
  }

  // loading
  Future<void> loading([bool? loading = false]) async {
    webviewMeta.loading.value = loading == true;
  }

  // popuping
  void popuping([bool? popup = false]) {
    if (mediaQueryController.orientation.value == Orientation.landscape) {
      return;
    }

    if (webviewMeta.loading.value == true) {
      return;
    }

    webviewMeta.popup.value = popup == true;
  }

  // titling
  void titling([String? title = '']) {
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

  // keyboard
  bool keyboard(KeyEvent event) {
    if (event.logicalKey != LogicalKeyboardKey.goBack) {
      return false;
    }

    if (event is KeyUpEvent) {
      back();
    }

    return true;
  }
}
