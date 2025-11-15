import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
export 'package:dompet/pages/settings/controller.dart';
import 'package:dompet/pages/settings/controller.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/size.dart';

class PageSettings extends GetView<PageSettingsController> {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      const physics = AlwaysScrollableScrollPhysics();
      final scrollController = controller.scrollController;
      final mediaPadding = controller.mediaPadding;
      final mediaTopBar = controller.mediaTopBar;
      final isShadow = controller.isShadow;

      final top = max(mediaPadding.value.top, 20.vp);

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
                      collapsedHeight: max(40.vp, mediaTopBar.value),
                      expandedHeight: 138.vp,
                      flexibleSpace: Obx(() {
                        List<BoxShadow>? boxShadow;

                        if (isShadow.value) {
                          boxShadow = [
                            BoxShadow(
                              color: const Color(0x0c000000),
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
                        delegate: SliverChildBuilderDelegate((context, index) {
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
                        }, childCount: 1),
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
    final height = max(40.vp, mediaTopBar);

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
            top: max(mediaPadding.top, 20.vp),
            left: 20.vp,
          ),
          padding: EdgeInsets.only(
            top: (height - 36.vp) / 2,
            bottom: (height - 36.vp) / 2,
          ),
          child: Row(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => GetNavigate.back(),
                child: Image(
                  image: const AssetImage('lib/assets/images/auth/back.png'),
                  width: 36.vp,
                  height: 36.vp,
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
      padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
      child: Text(
        'Settings'.tr,
        style: TextStyle(
          color: const Color(0xff130138),
          fontWeight: FontWeight.bold,
          letterSpacing: 3.0,
          fontSize: 20.fp,
          height: 1,
        ),
      ),
    );
  }

  Widget buildItems(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: 12.vp,
        left: 32.vp,
        right: 32.vp,
        bottom: 32.vp,
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44.vp,
              margin: EdgeInsets.only(bottom: 30.vp),
              child: Row(
                children: [
                  Container(
                    width: 44.vp,
                    height: 44.vp,
                    margin: EdgeInsets.only(right: 26.vp),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.vp),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withValues(alpha: .08),
                          offset: Offset(0, 4.vp),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/profile.png',
                      height: 24.vp,
                      width: 24.vp,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Person Profile'.tr,
                      style: TextStyle(
                        color: Color(0xff130138),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.fp,
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 28.vp,
                    width: 28.vp,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            onTap: () {
              GetNavigate.toNamed(
                GetRoutes.join([GetRoutes.settings, GetRoutes.profile]),
              );
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44.vp,
              margin: EdgeInsets.only(bottom: 30.vp),
              child: Row(
                children: [
                  Container(
                    width: 44.vp,
                    height: 44.vp,
                    margin: EdgeInsets.only(right: 26.vp),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.vp),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withValues(alpha: .08),
                          offset: Offset(0, 4.vp),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/notification.png',
                      height: 24.vp,
                      width: 24.vp,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Message Notification'.tr,
                      style: TextStyle(
                        color: Color(0xff130138),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.fp,
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 28.vp,
                    width: 28.vp,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            onTap: () {
              GetNavigate.toNamed(GetRoutes.notification);
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44.vp,
              margin: EdgeInsets.only(bottom: 30.vp),
              child: Row(
                children: [
                  Container(
                    width: 44.vp,
                    height: 44.vp,
                    margin: EdgeInsets.only(right: 26.vp),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.vp),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withValues(alpha: .08),
                          offset: Offset(0, 4.vp),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/card.png',
                      height: 24.vp,
                      width: 24.vp,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'My Bank Card'.tr,
                      style: TextStyle(
                        color: Color(0xff130138),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.fp,
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 28.vp,
                    width: 28.vp,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            onTap: () {
              GetNavigate.toNamed(GetRoutes.card);
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44.vp,
              margin: EdgeInsets.only(bottom: 30.vp),
              child: Row(
                children: [
                  Container(
                    width: 44.vp,
                    height: 44.vp,
                    margin: EdgeInsets.only(right: 26.vp),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.vp),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withValues(alpha: .08),
                          offset: Offset(0, 4.vp),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/langs.png',
                      height: 24.vp,
                      width: 24.vp,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Switch Language'.tr,
                      style: TextStyle(
                        color: Color(0xff130138),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.fp,
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 28.vp,
                    width: 28.vp,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            onTap: () {
              GetNavigate.toNamed(
                GetRoutes.join([GetRoutes.settings, GetRoutes.langs]),
              );
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44.vp,
              margin: EdgeInsets.only(bottom: 30.vp),
              child: Row(
                children: [
                  Container(
                    width: 44.vp,
                    height: 44.vp,
                    margin: EdgeInsets.only(right: 26.vp),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.vp),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withValues(alpha: .08),
                          offset: Offset(0, 4.vp),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/logger.png',
                      height: 24.vp,
                      width: 24.vp,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Run Logger'.tr,
                      style: TextStyle(
                        color: Color(0xff130138),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.fp,
                      ),
                    ),
                  ),
                  Image.asset(
                    'lib/assets/images/settings/right.png',
                    height: 28.vp,
                    width: 28.vp,
                    fit: BoxFit.fill,
                  ),
                ],
              ),
            ),
            onTap: () {
              GetNavigate.toNamed(
                GetRoutes.join([GetRoutes.settings, GetRoutes.logger]),
              );
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              height: 44.vp,
              margin: EdgeInsets.only(bottom: 30.vp),
              child: Row(
                children: [
                  Container(
                    width: 44.vp,
                    height: 44.vp,
                    margin: EdgeInsets.only(right: 26.vp),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22.vp),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xff272246).withValues(alpha: .08),
                          offset: Offset(0, 4.vp),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/github.png',
                      height: 24.vp,
                      width: 24.vp,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'About App'.tr,
                      style: TextStyle(
                        color: Color(0xff130138),
                        fontWeight: FontWeight.w600,
                        fontSize: 16.fp,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5.vp,
                      left: 5.vp,
                      right: 7.vp,
                      bottom: 5.vp,
                    ),
                    child: Image.asset(
                      'lib/assets/images/settings/link.png',
                      height: 18.vp,
                      width: 18.vp,
                      fit: BoxFit.fill,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              GetNavigate.toNamed(
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
      padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
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
              borderRadius: BorderRadius.all(Radius.circular(32.vp)),
              highlightColor: const Color(0xff5b259f).withValues(alpha: 0.0),
              splashColor: const Color(0xff5b259f).withValues(alpha: 0.0),
              onTap: () => showAlertDialog(context),
              child: Container(
                width: 64.vp,
                height: 64.vp,
                alignment: Alignment.center,
                padding: EdgeInsets.only(right: 3.vp),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32.vp),
                  border: Border.all(color: Color(0xffe0e0e0), width: .8),
                ),
                child: Image.asset(
                  'lib/assets/images/settings/logout.png',
                  height: 36.vp,
                  width: 36.vp,
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () => showAlertDialog(context),
            child: Padding(
              padding: EdgeInsets.only(top: 12.vp),
              child: Text(
                'Logout'.tr,
                style: TextStyle(
                  color: Color(0xff5b259f),
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3,
                  fontSize: 18.fp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSafeArea(BuildContext context) {
    final mediaPadding = controller.mediaPadding;
    final mediaBottom = mediaPadding.value.bottom;

    return SizedBox(width: 640.wmax, height: max(mediaBottom - 20.vp, 10.vp));
  }

  void showAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Color(0xff000000).withValues(alpha: 0.65),
      builder: (context) => Padding(
        padding: EdgeInsets.only(top: 20.vp, bottom: 100.vp),
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          iconPadding: EdgeInsets.all(0),
          contentPadding: EdgeInsets.only(
            top: 30.vp,
            left: 30.vp,
            right: 30.vp,
          ),
          actionsPadding: EdgeInsets.only(
            top: 14.vp,
            left: 20.vp,
            right: 20.vp,
            bottom: 8.vp,
          ),
          buttonPadding: EdgeInsets.only(
            top: 10.vp,
            left: 5.vp,
            right: 5.vp,
            bottom: 10.vp,
          ),
          backgroundColor: Colors.white,
          content: Text(
            'Do you want to logout?'.tr,
            style: TextStyle(
              color: Color(0xfff34d4d),
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              fontSize: 17.6.fp,
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
                'System_Cancel'.tr,
                style: TextStyle(
                  color: Color(0xff9f9f9f),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  fontSize: 15.fp,
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
                  color: Color(0xff606266),
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.2,
                  fontSize: 15.fp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
