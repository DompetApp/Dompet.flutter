import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/settings/controller.dart';
import 'package:dompet/models/webview.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/routes/router.dart';

class PageSettings extends GetView<PageSettingsController> {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PageSettingsController>()) {
      Get.put(PageSettingsController());
    }

    return Obx(() {
      const physics = AlwaysScrollableScrollPhysics();
      final scrollController = controller.scrollController;
      final mediaPadding = controller.mediaPadding;
      final mediaTopBar = controller.mediaTopBar;
      final isShadow = controller.isShadow;

      final top = max(
        mediaPadding.value.top,
        640.wmax * 20.sr,
      );

      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            NestedScrollView(
              physics: physics,
              controller: scrollController,
              headerSliverBuilder: (context, isScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                    sliver: SliverAppBar(
                      pinned: true,
                      elevation: 0.0,
                      scrolledUnderElevation: 0.0,
                      automaticallyImplyLeading: false,
                      collapsedHeight: max(640.wmax * 40.sr, mediaTopBar.value),
                      expandedHeight: 640.wmax * 138.sr,
                      flexibleSpace: Obx(() {
                        List<BoxShadow>? boxShadow;

                        if (isShadow.value) {
                          boxShadow = [
                            BoxShadow(
                              color: const Color(0xff000000).withOpacity(.048),
                              offset: const Offset(0, 1.2),
                              spreadRadius: 0,
                              blurRadius: 10,
                            ),
                          ];
                        }

                        return Container(
                          constraints: const BoxConstraints.expand(),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: boxShadow,
                          ),
                          padding: EdgeInsets.only(top: top),
                          child: buildTitle(context),
                        );
                      }),
                    ),
                  ),
                ];
              },
              body: Builder(
                builder: (BuildContext context) {
                  return CustomScrollView(
                    slivers: [
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Obx(
                              () => ListView(
                                shrinkWrap: true,
                                padding: const EdgeInsets.all(0),
                                physics: const NeverScrollableScrollPhysics(),
                                children: [
                                  buildItems(context),
                                  buildLogout(context),
                                  buildSafeArea(context),
                                ],
                              ),
                            );
                          },
                          childCount: 1,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            buildBack(context),
          ],
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
      );
    });
  }

  Widget buildBack(BuildContext context) {
    final mediaTopBar = controller.mediaTopBar.value;
    final mediaPadding = controller.mediaPadding.value;
    final height = max(640.wmax * 40.sr, mediaTopBar);

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 680.wmax,
          height: height,
          margin: EdgeInsets.only(
            top: max(mediaPadding.top, 640.wmax * 20.sr),
            left: 640.wmax * 20.sr,
          ),
          padding: EdgeInsets.only(
            top: (height - 640.wmax * 36.sr) / 2,
            bottom: (height - 640.wmax * 36.sr) / 2,
          ),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => GetRouter.back(),
                child: Image(
                  image: const AssetImage('lib/assets/images/auth/back.png'),
                  width: 640.wmax * 36.sr,
                  height: 640.wmax * 36.sr,
                  fit: BoxFit.fill,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: const BoxConstraints.expand(),
      padding: EdgeInsets.only(
        left: 640.wmax * 32.sr,
        right: 640.wmax * 32.sr,
      ),
      child: Text(
        'Settings'.tr,
        style: TextStyle(
          fontSize: 640.wmax * 20.sr,
          fontWeight: FontWeight.bold,
          color: const Color(0xff130138),
          letterSpacing: 3,
          height: 1,
        ),
      ),
    );
  }

  Widget buildItems(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 640.wmax * 12.sr,
        left: 640.wmax * 32.sr,
        right: 640.wmax * 32.sr,
        bottom: 640.wmax * 32.sr,
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => GetRouter.toNamed(GetRoutes.profile),
            child: Container(
              height: 640.wmax * 44.sr,
              margin: EdgeInsets.only(bottom: 640.wmax * 30.sr),
              child: Row(
                children: [
                  Container(
                    width: 640.wmax * 44.sr,
                    height: 640.wmax * 44.sr,
                    margin: EdgeInsets.only(right: 640.wmax * 26.sr),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(640.wmax * 22.sr),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withOpacity(.08),
                          offset: Offset(0, 640.wmax * 4.sr),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/profile.png',
                      height: 640.wmax * 24.sr,
                      width: 640.wmax * 24.sr,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Persion Profile'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 16.sr,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff130138),
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 640.wmax * 28.sr,
                    width: 640.wmax * 28.sr,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => GetRouter.toNamed(GetRoutes.notification),
            child: Container(
              height: 640.wmax * 44.sr,
              margin: EdgeInsets.only(bottom: 640.wmax * 30.sr),
              child: Row(
                children: [
                  Container(
                    width: 640.wmax * 44.sr,
                    height: 640.wmax * 44.sr,
                    margin: EdgeInsets.only(right: 640.wmax * 26.sr),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(640.wmax * 22.sr),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withOpacity(.08),
                          offset: Offset(0, 640.wmax * 4.sr),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/notification.png',
                      height: 640.wmax * 24.sr,
                      width: 640.wmax * 24.sr,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Message Notification'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 16.sr,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff130138),
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 640.wmax * 28.sr,
                    width: 640.wmax * 28.sr,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => GetRouter.toNamed(GetRoutes.card),
            child: Container(
              height: 640.wmax * 44.sr,
              margin: EdgeInsets.only(bottom: 640.wmax * 30.sr),
              child: Row(
                children: [
                  Container(
                    width: 640.wmax * 44.sr,
                    height: 640.wmax * 44.sr,
                    margin: EdgeInsets.only(right: 640.wmax * 26.sr),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(640.wmax * 22.sr),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withOpacity(.08),
                          offset: Offset(0, 640.wmax * 4.sr),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/card.png',
                      height: 640.wmax * 24.sr,
                      width: 640.wmax * 24.sr,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'My Bank Card'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 16.sr,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff130138),
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 640.wmax * 28.sr,
                    width: 640.wmax * 28.sr,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => GetRouter.toNamed(GetRoutes.langs),
            child: Container(
              height: 640.wmax * 44.sr,
              margin: EdgeInsets.only(bottom: 640.wmax * 30.sr),
              child: Row(
                children: [
                  Container(
                    width: 640.wmax * 44.sr,
                    height: 640.wmax * 44.sr,
                    margin: EdgeInsets.only(right: 640.wmax * 26.sr),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(640.wmax * 22.sr),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withOpacity(.08),
                          offset: Offset(0, 640.wmax * 4.sr),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/langs.png',
                      height: 640.wmax * 24.sr,
                      width: 640.wmax * 24.sr,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Switch Language'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 16.sr,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff130138),
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 640.wmax * 28.sr,
                    width: 640.wmax * 28.sr,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => GetRouter.toNamed(GetRoutes.logger),
            child: Container(
              height: 640.wmax * 44.sr,
              margin: EdgeInsets.only(bottom: 640.wmax * 30.sr),
              child: Row(
                children: [
                  Container(
                    width: 640.wmax * 44.sr,
                    height: 640.wmax * 44.sr,
                    margin: EdgeInsets.only(right: 640.wmax * 26.sr),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(640.wmax * 22.sr),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withOpacity(.08),
                          offset: Offset(0, 640.wmax * 4.sr),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/logger.png',
                      height: 640.wmax * 24.sr,
                      width: 640.wmax * 24.sr,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'App Logger'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 16.sr,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff130138),
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 640.wmax * 28.sr,
                    width: 640.wmax * 28.sr,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 640.wmax * 44.sr,
              margin: EdgeInsets.only(bottom: 640.wmax * 30.sr),
              child: Row(
                children: [
                  Container(
                    width: 640.wmax * 44.sr,
                    height: 640.wmax * 44.sr,
                    margin: EdgeInsets.only(right: 640.wmax * 26.sr),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(640.wmax * 22.sr),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withOpacity(.08),
                          offset: Offset(0, 640.wmax * 4.sr),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/github.png',
                      height: 640.wmax * 24.sr,
                      width: 640.wmax * 24.sr,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'About App'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 16.sr,
                        fontWeight: FontWeight.w600,
                        color: Color(0xff130138),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 640.wmax * 5.sr,
                      left: 640.wmax * 5.sr,
                      right: 640.wmax * 7.sr,
                      bottom: 640.wmax * 5.sr,
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/link.png',
                      height: 640.wmax * 18.sr,
                      width: 640.wmax * 18.sr,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              GetRouter.toNamed(
                GetRoutes.webview,
                arguments: WebviewMeta(
                  title: 'Github DompetApp'.tr,
                  url: 'https://github.com/DompetApp/Dompet.flutter',
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget buildLogout(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: 640.wmax * 32.sr,
        right: 640.wmax * 32.sr,
      ),
      child: Column(
        children: [
          Material(
            color: Colors.transparent,
            child: InkResponse(
              radius: 64.0,
              containedInkWell: true,
              hoverColor: Colors.transparent,
              focusColor: Colors.transparent,
              highlightShape: BoxShape.rectangle,
              borderRadius: BorderRadius.all(Radius.circular(640.wmax * 32.sr)),
              highlightColor: const Color(0xff5b259f).withOpacity(0.0),
              splashColor: const Color(0xff5b259f).withOpacity(0.0),
              onTap: () => showAlertDialog(context),
              child: Container(
                width: 640.wmax * 64.sr,
                height: 640.wmax * 64.sr,
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 640.wmax * 3.sr),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(640.wmax * 32.sr),
                  border: Border.all(color: Color(0xffe0e0e0), width: .8),
                ),
                child: Image.asset(
                  'lib/assets/images/settings/logout.png',
                  height: 640.wmax * 36.sr,
                  width: 640.wmax * 36.sr,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => showAlertDialog(context),
            child: Padding(
              padding: EdgeInsets.only(top: 640.wmax * 12.sr),
              child: Text(
                'Logout'.tr,
                style: TextStyle(
                  fontSize: 640.wmax * 18.sr,
                  fontWeight: FontWeight.w600,
                  color: Color(0xff5b259f),
                  letterSpacing: 3,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget buildSafeArea(BuildContext context) {
    final mediaPadding = controller.mediaPadding;
    final mediaBottom = mediaPadding.value.bottom;

    return SizedBox(
      width: 640.wmax,
      height: max(mediaBottom - 640.wmax * 20.sr, 640.wmax * 10.sr),
    );
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Color(0xff000000).withOpacity(0.65),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          top: 640.wmax * 20.sr,
          bottom: 640.wmax * 100.sr,
        ),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          iconPadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.only(
            top: 640.wmax * 30.sr,
            left: 640.wmax * 30.sr,
            right: 640.wmax * 30.sr,
          ),
          actionsPadding: EdgeInsets.only(
            top: 640.wmax * 14.sr,
            left: 640.wmax * 20.sr,
            right: 640.wmax * 20.sr,
            bottom: 640.wmax * 8.sr,
          ),
          buttonPadding: EdgeInsets.only(
            top: 640.wmax * 10.sr,
            left: 640.wmax * 5.sr,
            right: 640.wmax * 5.sr,
            bottom: 640.wmax * 10.sr,
          ),
          backgroundColor: Colors.white,
          content: Text(
            'Do you want to logout?'.tr,
            style: TextStyle(
              fontSize: 640.wmax * 17.6.sr,
              fontWeight: FontWeight.w600,
              color: Color(0xfff34d4d),
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 7),
                minimumSize: Size(0, 44),
              ),
              child: Text(
                'Cancel'.tr,
                style: TextStyle(
                  fontSize: 640.wmax * 15.sr,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff9f9f9f),
                  letterSpacing: 1.2,
                ),
              ),
            ),
            TextButton(
              onPressed: () => controller.logout(),
              style: TextButton.styleFrom(
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                padding: EdgeInsets.symmetric(horizontal: 7),
                minimumSize: Size(0, 44),
              ),
              child: Text(
                'Logout'.tr,
                style: TextStyle(
                  fontSize: 640.wmax * 15.sr,
                  fontWeight: FontWeight.w500,
                  color: Color(0xff606266),
                  letterSpacing: 1.2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
