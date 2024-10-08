import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:dompet/pages/webview/controller.dart';
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
  late Function? closedCallback;

  @override
  initState() {
    super.initState();

    animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    animation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(animationController);

    animation.addListener(() {
      setState(() => {});
    });

    animation.addStatusListener((status) {
      if (status == AnimationStatus.dismissed) {
        controller.popuping(false);
      }
    });

    animationController.forward();

    closedCallback = null;
  }

  @override
  dispose() {
    super.dispose();

    animationController.dispose();

    Future.delayed(const Duration(seconds: 0), () {
      if (closedCallback != null) {
        closedCallback!();
      }
    });
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
          children: [
            opacityLayer(context),
            controlPanel(context),
          ],
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
      'backHome',
      'refreshPage',
      'clearCache',
      'openDebug',
    ];

    return Positioned(
      left: 0,
      right: 0,
      bottom: (animation.value - 1) * 420,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(
            Radius.circular(15.wdp),
          ),
          color: const Color(0xffebebeb),
        ),
        child: Padding(
          padding: EdgeInsets.all(15.wdp),
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
                      left: 8.wdp,
                      right: 8.wdp,
                    ),
                    child: Text(
                      'Settings'.tr,
                      style: TextStyle(
                        color: const Color(0xff303133),
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 16.wdp,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: .5,
                margin: EdgeInsets.symmetric(vertical: 15.wdp),
                color: const Color(0xffcfcfcf),
              ),
              Container(
                constraints: BoxConstraints(
                  minHeight: min(128.wdp, 30.vh),
                ),
                child: GridView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: panelList.length,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 65.wdp,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemBuilder: (context, index) {
                    return panelPlate(panelList[index]);
                  },
                ),
              ),
              Container(
                height: .5,
                margin: EdgeInsets.symmetric(vertical: 15.wdp),
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
                      'Cancel'.tr,
                      style: TextStyle(
                        color: const Color(0xff646e93),
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        fontSize: 16.wdp,
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
  Widget panelPlate(String type) {
    String image = '';
    String title = '';

    switch (type) {
      case 'backHome':
        image = 'lib/assets/webview/home.png';
        title = 'back'.tr;
        break;

      case 'refreshPage':
        image = 'lib/assets/webview/refresh.png';
        title = 'refresh'.tr;
        break;

      case 'clearCache':
        image = 'lib/assets/webview/clear.png';
        title = 'clear'.tr;
        break;

      case 'openDebug':
        image = 'lib/assets/webview/debug.png';
        title = 'debug'.tr;
        break;
    }

    return GestureDetector(
      child: SizedBox(
        width: 60.wdp,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 54.wdp,
              height: 54.wdp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(15.wdp),
                ),
                color: const Color(0xffffffff),
              ),
              child: Image(
                width: 30.wdp,
                height: 30.wdp,
                fit: BoxFit.fill,
                image: AssetImage(image),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                top: 7.wdp,
                left: 4.wdp,
                right: 4.wdp,
              ),
              child: Text(
                title,
                style: TextStyle(
                  height: 1.2.wdp,
                  fontSize: 11.wdp,
                  fontWeight: FontWeight.w600,
                  overflow: TextOverflow.ellipsis,
                  decoration: TextDecoration.none,
                  color: const Color(0xff606266),
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        closedCallback = callback(type);
        animationController.reverse();
      },
    );
  }

  // callback
  Function? callback(String type) {
    switch (type) {
      case 'backHome':
        return () async {
          return GetRouter.until((route) {
            return route.settings.name != GetRoutes.webview;
          });
        };

      case 'refreshPage':
        return () async {
          return controller.webviewController?.reload();
        };

      case 'clearCache':
        return () async {
          await InAppWebViewController.clearAllCache();
          await controller.webviewController?.reload();
          return;
        };

      case 'openDebug':
        return () {
          const event = 'CallOpenVConsoleDebug';
          const source = 'window.dispatchEvent(new CustomEvent("$event"));';
          controller.webviewController?.evaluateJavascript(source: source);
        };
    }

    return null;
  }
}
