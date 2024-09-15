import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dompet/pages/webview/controller.dart';
import 'package:dompet/routes/router.dart';

class PageWebviewScaffold extends StatefulWidget {
  const PageWebviewScaffold({
    required this.controller,
    required this.tag,
    super.key,
  });

  final PageWebviewController controller;
  final String tag;

  @override
  State<PageWebviewScaffold> createState() => PageWebviewScaffoldState();
}

class PageWebviewScaffoldState extends State<PageWebviewScaffold> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final webViewKey = controller.webViewKey;
    final webviewMeta = controller.webviewMeta;
    final writeScripts = controller.writeScripts;
    final popuping = controller.popuping;
    final titling = controller.titling;
    final loading = controller.loading;
    final leading = controller.leading;
    final back = controller.back;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(webviewMeta.title.value)),
        leading: Obx(() {
          return webviewMeta.canBack.value
              ? BackButton(onPressed: () => back())
              : Container();
        }),
        actions: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  constraints: const BoxConstraints.tightFor(
                    width: 44,
                    height: 26,
                  ),
                  margin: const EdgeInsets.only(
                    right: 10,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xff333333),
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                      Container(
                        width: 7,
                        height: 7,
                        margin: const EdgeInsets.only(
                          left: 3,
                          right: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xff333333),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: const Color(0xff333333),
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () => popuping(true),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          GetBuilder<PageWebviewController>(
            id: 'webview',
            tag: widget.tag,
            builder: (_) {
              final initialUrl = controller.initialUrl;
              final initialData = controller.initialData;
              final initialScripts = controller.initialScripts;
              final initialSettings = controller.inAppWebViewSettings;

              if (initialUrl == null && initialData == null) {
                return Container();
              }

              return InAppWebView(
                key: webViewKey,
                initialData: initialData,
                initialUrlRequest: initialUrl,
                initialSettings: initialSettings,
                initialUserScripts: initialScripts,
                onLoadStop: (webviewController, url) async {
                  await writeScripts();
                  await loading(false);
                },
                onWebViewCreated: (webviewController) async {
                  controller.webviewController = webviewController;
                  controller.webChannelController.createScriptHandlers(
                    controller,
                  );
                },
                onReceivedError: (webviewController, request, error) async {
                  loading(false);
                },
                onTitleChanged: (webviewController, title) async {
                  titling(title);
                },
                onProgressChanged: (webviewController, progress) async {
                  if (progress == 100) {
                    loading(false);
                  }
                },
                onPermissionRequest: (webviewController, request) async {
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
                shouldOverrideUrlLoading: (webviewController, action) async {
                  final url = action.request.url;

                  if (url == null || url.toString() == "") {
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (![
                    "data",
                    "file",
                    "http",
                    "https",
                    "about",
                    "chrome",
                    "javascript",
                  ].contains(url.scheme)) {
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onUpdateVisitedHistory: (webviewController, url, reload) async {
                  final canGoBack = await webviewController.canGoBack();
                  final canBack = await GetRouter.canBack();
                  leading(canGoBack || canBack);
                },
              );
            },
          ),
          Obx(() {
            return Positioned(
              child: Offstage(
                offstage: !webviewMeta.loading.value,
                child: Container(
                  constraints: const BoxConstraints.expand(),
                  color: const Color(0xffffffff).withOpacity(0.8),
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3.2,
                          color: Color(0xff707177),
                          semanticsValue: '加载中...',
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 80),
                          child: Text(
                            '加载中...',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Color(0xff707177),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 80,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          })
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
