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
    limitsNavigationsToAppBoundDomains: true,
    mediaPlaybackRequiresUserGesture: false,
    useShouldOverrideUrlLoading: true,
    javaScriptEnabled: true,
    isInspectable: debug,
    cacheEnabled: true,
  );

  UnmodifiableListView<UserScript>? initialScripts;
  InAppWebViewController? webviewController;
  InAppWebViewInitialData? initialData;
  Map<String, String>? initialHeaders;
  URLRequest? initialUrl;
  WebUri? requestWebUri;
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

    await loading(true);
    await loadAgent();
    await loadUrl();
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
    initialHeaders = null;
    initialScripts = null;
    requestWebUri = null;
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

      initialHeaders = {'Accept-Language': languageCode};
      requestWebUri = WebUri.uri(Uri.parse(url));

      initialUrl = URLRequest(
        headers: initialHeaders,
        url: requestWebUri,
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

  // navigator
  Future<void> navigator([WebUri? uri]) async {
    requestWebUri = uri;
  }

  // titling
  Future<void> titling([String? title = '']) async {
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
  Future<void> leading([bool? canBack = false]) async {
    webviewMeta.canBack.value = canBack == true;
  }

  // loading
  Future<void> loading([bool? loading = false]) async {
    webviewMeta.loading.value = loading == true;
  }

  // popuping
  Future<void> popuping([bool? popup = false]) async {
    if (mediaQueryController.orientation.value == Orientation.landscape) {
      return;
    }

    webviewMeta.popup.value = popup == true;
  }
}
