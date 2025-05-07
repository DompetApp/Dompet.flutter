import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dompet/pages/webview/controller.dart';
import 'package:dompet/configure/fluttertoast.dart';
import 'package:dompet/configure/share_plus.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/routes/router.dart';

class PageWebviewPopup extends StatefulWidget {
  const PageWebviewPopup({
    required this.controller,
    required this.tag,
    super.key,
  });

  final PageWebviewController controller;
  final String tag;

  @override
  State<PageWebviewPopup> createState() => PageWebviewPopupState();
}

class PageWebviewPopupState extends State<PageWebviewPopup>
    with SingleTickerProviderStateMixin {
  late final controller = widget.controller;
  late final mediaHeight = mediaQueryController.height;
  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaQueryController = controller.mediaQueryController;

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    animation = Tween(begin: 0.0, end: 1.0).animate(animationController);

    animation.addListener(() {
      setState(() => {});
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        controller.popuping(false);
      }
    });

    animationController.forward();
  }

  @override
  dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Obx(() {
        if (mediaHeight.value <= 350.wdp) {
          return const SizedBox.shrink();
        }

        return Stack(
          fit: StackFit.expand,
          children: [opacityLayer(context), controlPanel(context)],
        );
      }),
    );
  }

  // layer
  Widget opacityLayer(BuildContext context) {
    return Opacity(
      opacity: animation.value,
      child: GestureDetector(
        child: Container(
          color: const Color(0x77000000),
          constraints: const BoxConstraints.expand(),
        ),
        onTap: () => animationController.reverse(),
      ),
    );
  }

  // panel
  Widget controlPanel(BuildContext context) {
    final panelList = [
      'back',
      'clear',
      'refresh',
      'browser',
      'debug',
      'share',
      'link',
    ];

    return Positioned(
      left: 0,
      right: 0,
      bottom: (animation.value - 1) * 420,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(640.wmax * 15.sr)),
          color: const Color(0xffebebeb),
        ),
        child: Padding(
          padding: EdgeInsets.all(640.wmax * 15.sr),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      left: 640.wmax * 8.sr,
                      right: 640.wmax * 8.sr,
                    ),
                    child: Text(
                      'Webview_Settings'.tr,
                      style: TextStyle(
                        color: const Color(0xff303133),
                        letterSpacing: max(640.wmax * 1.2.sr, 1.2),
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: 640.wmax * 16.sr,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: .5,
                margin: EdgeInsets.symmetric(vertical: 640.wmax * 15.sr),
                color: const Color(0xffcfcfcf),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: min(640.wmax * 150.sr, 30.vh),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  itemCount: panelList.length,
                  padding: EdgeInsets.all(640.wmax * 3.sr),
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 640.wmax * 66.sr,
                    crossAxisSpacing: 640.wmax * 15.sr,
                    mainAxisSpacing: 640.wmax * 15.sr,
                    childAspectRatio: 0.60,
                  ),
                  itemBuilder: (context, index) {
                    return controlPlate(context, panelList[index]);
                  },
                ),
              ),
              Container(
                height: .5,
                margin: EdgeInsets.symmetric(vertical: 640.wmax * 15.sr),
                color: const Color(0xffcfcfcf),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.only(
                    top: 5,
                    left: 25,
                    right: 25,
                    bottom: max(20, mediaPadding.value.bottom),
                  ),
                  child: Align(
                    child: Text(
                      'System_Cancel'.tr,
                      style: TextStyle(
                        color: const Color(0xff646e93),
                        letterSpacing: max(640.wmax * 1.2.sr, 1.2),
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        fontSize: 640.wmax * 16.sr,
                      ),
                    ),
                  ),
                ),
                onTap: () => animationController.reverse(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // plate
  Widget controlPlate(BuildContext context, String type) {
    var image = '';
    var title = '';

    switch (type) {
      case 'back':
        image = 'lib/assets/webview/home.png';
        title = 'Webview_Back_App'.tr;
        break;

      case 'clear':
        image = 'lib/assets/webview/clear.png';
        title = 'Webview_Clear_Cache'.tr;
        break;

      case 'refresh':
        image = 'lib/assets/webview/refresh.png';
        title = 'Webview_Refresh_Page'.tr;
        break;

      case 'browser':
        image = 'lib/assets/webview/browser.png';
        title = 'Webview_Open_Browser'.tr;
        break;

      case 'debug':
        image = 'lib/assets/webview/debug.png';
        title = 'Webview_Turn_Debug'.tr;
        break;

      case 'share':
        image = 'lib/assets/webview/share.png';
        title = 'Webview_Share_Website'.tr;
        break;

      case 'link':
        image = 'lib/assets/webview/link.png';
        title = 'Webview_Copy_Link'.tr;
        break;
    }

    return GestureDetector(
      child: SizedBox(
        width: 640.wmax * 60.sr,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 640.wmax * 56.sr,
              height: 640.wmax * 56.sr,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(640.wmax * 15.sr),
                ),
                color: const Color(0xffffffff),
              ),
              child: Image(
                width: 640.wmax * 30.sr,
                height: 640.wmax * 30.sr,
                image: AssetImage(image),
                fit: BoxFit.fill,
              ),
            ),
            Container(
              width: 640.wmax * 56.sr,
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 640.wmax * 9.sr),
              child: Text(
                title,
                style: TextStyle(
                  height: 1.1,
                  fontSize: 640.wmax * 10.sr,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  decoration: TextDecoration.none,
                  color: const Color(0xff606266),
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      onTap: () async {
        if (await trigger(context, type)) {
          animationController.reverse();
        }
      },
    );
  }

  // trigger
  Future<bool> trigger(BuildContext context, String type) async {
    if (type == 'back') {
      await GetRouter.until((route) => route.name != GetRoutes.webview);
      return true;
    }

    if (type == 'clear') {
      await InAppWebViewController.clearAllCache();
      await controller.webviewController?.reload();
      return true;
    }

    if (type == 'refresh') {
      await controller.webviewController?.reload();
      return true;
    }

    if (type == 'browser') {
      final url = await controller.webviewController?.getUrl();

      if (url != null && await canLaunchUrl(url)) {
        launchUrl(url, mode: LaunchMode.externalApplication);
        return true;
      }
    }

    if (type == 'debug') {
      const event = 'CallOpenVConsoleDebug';
      const source = 'window.dispatchEvent(new CustomEvent("$event"));';
      await controller.webviewController?.evaluateJavascript(source: source);
      return true;
    }

    if (type == 'share') {
      final url = await controller.webviewController?.getUrl();

      if (url != null) {
        Sharer.shareUri(url);
        return true;
      }
    }

    if (type == 'link') {
      final url = await controller.webviewController?.getUrl();

      if (url != null && url.toString().isNotEmpty) {
        final clipboard = ClipboardData(text: url.toString());
        final future = Clipboard.setData(clipboard);

        future.then((_) {
          Toaster.success(
            message: 'Webview_Copy_Successful'.tr,
            duration: 1.5.seconds,
          );
        });

        return true;
      }
    }

    return false;
  }
}
