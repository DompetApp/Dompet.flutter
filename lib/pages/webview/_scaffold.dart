import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
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
  PageWebviewController get controller => widget.controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final child = webview(context);
      final isAllow = controller.canPop.value;
      return PopScope(canPop: isAllow, child: child);
    });
  }

  Widget webview(BuildContext context) {
    final webViewKey = controller.webViewKey;
    final webviewMeta = controller.webviewMeta;
    final focusWebview = controller.focusWebview;
    final writeScripts = controller.writeScripts;
    final popuping = controller.popuping;
    final titling = controller.titling;
    final loading = controller.loading;
    final back = controller.back;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
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
              final canPop = controller.canPop;
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
                onLoadStop: (webController, url) async {
                  await writeScripts().catchError((_) => null);
                  await focusWebview().catchError((_) => null);
                  await loading(false).catchError((_) => null);
                },
                onTitleChanged: (webController, title) async {
                  titling(title);
                },
                onReceivedError: (webController, request, error) async {
                  loading(false);
                },
                shouldOverrideUrlLoading: (webController, action) async {
                  final url = action.request.url;

                  if (!url.bv) {
                    return NavigationActionPolicy.CANCEL;
                  }

                  if (["tel"].contains(url!.scheme)) {
                    launchUrl(url).catchError((_) => false);
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
                onUpdateVisitedHistory: (webController, url, _) async {
                  await Future.delayed(Duration(milliseconds: 100));
                  canPop.value = !await webController.canGoBack();
                },
                onPermissionRequest: (webController, request) async {
                  return PermissionResponse(
                    resources: request.resources,
                    action: PermissionResponseAction.GRANT,
                  );
                },
                onProgressChanged: (webController, progress) async {
                  if (progress == 100) {
                    await Future.delayed(Duration(milliseconds: 100));
                    canPop.value = !await webController.canGoBack();
                  }
                },
                onWebViewCreated: (webController) async {
                  controller.webviewController = webController;
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
                          semanticsValue: 'Webview_Loading'.tr,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(30, 20, 30, 80),
                          child: Text(
                            'Webview_Loading'.tr,
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
    );
  }
}
