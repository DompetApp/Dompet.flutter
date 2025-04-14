import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dompet/pages/webview/controller.dart';
import 'package:dompet/extension/bool.dart';

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
    final back = controller.back;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(webviewMeta.title.value)),
        leading: BackButton(onPressed: () => back()),
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
                  margin: const EdgeInsets.only(right: 10),
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
                        margin: const EdgeInsets.only(left: 3, right: 3),
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

              if (!initialUrl.bv && !initialData.bv) {
                return const SizedBox.shrink();
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
                onTitleChanged: (webviewController, title) async {
                  titling(title);
                },
                onReceivedError: (webviewController, request, error) async {
                  loading(false);
                },
                shouldOverrideUrlLoading: (webviewController, action) async {
                  final url = action.request.url;

                  if (!url.bv) {
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
                  ].contains(url!.scheme)) {
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onPermissionRequest: (webviewController, request) async {
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
                onProgressChanged: (webviewController, progress) async {
                  if (progress == 100) {
                    loading(false);
                  }
                },
                onWebViewCreated: (webviewController) async {
                  controller.webviewController = webviewController;
                  controller.webChannelController.createScriptHandlers(
                    controller,
                  );
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
                  color: const Color(0xffffffff).withValues(alpha: 0.8),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          strokeWidth: 3.2,
                          color: const Color(0xff707177),
                          semanticsValue: 'Loading...'.tr,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 80),
                          child: Text(
                            'Loading...'.tr,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.5,
                              color: Color(0xff707177),
                            ),
                          ),
                        ),
                        SizedBox(width: double.infinity, height: 80),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
