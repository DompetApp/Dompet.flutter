import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
export 'package:dompet/pages/langs/controller.dart';
import 'package:dompet/pages/langs/controller.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/size.dart';

class PageLangs extends GetView<PageLangsController> {
  const PageLangs({super.key});

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
                      expandedHeight: 152.vp,
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
                                buildOptions(context),
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
        'Language'.tr,
        style: TextStyle(
          color: const Color(0xff130138),
          fontWeight: FontWeight.bold,
          fontSize: 20.fp,
          letterSpacing: 3,
          height: 1,
        ),
      ),
    );
  }

  Widget buildOptions(BuildContext context) {
    final localer = controller.localer;
    final locale = controller.locale;
    final isZhCn = controller.isZhCn;
    final isEnUs = controller.isEnUs;
    final isNull = !locale.value.bv;
    final zhCn = controller.zhCn;
    final enUs = controller.enUs;

    return Container(
      padding: EdgeInsets.only(
        top: 30.vp,
        left: 48.vp,
        right: 48.vp,
        bottom: 35.vp,
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 640.wmax,
              height: 64.vp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.vp),
                border: Border.all(
                  color: isNull ? Color(0xff8438FF) : Colors.black26,
                  width: isNull ? 1.4.vp : 1.2.vp,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.vp, vertical: 20.vp),
              margin: EdgeInsets.only(bottom: 25.vp),
              child: Text(
                'Follow System Language'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isNull ? Color(0xff8438FF) : Color(0xff808288),
                  fontWeight: isNull ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 16.fp,
                  height: 1.0,
                ),
              ),
            ),
            onTap: () {
              if (!isNull) {
                localer(null);
              }
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 640.wmax,
              height: 64.vp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.vp),
                border: Border.all(
                  color: isZhCn ? Color(0xff8438FF) : Colors.black26,
                  width: isZhCn ? 1.4.vp : 1.2.vp,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.vp, vertical: 20.vp),
              margin: EdgeInsets.only(bottom: 25.vp),
              child: Text(
                'Chinese (zh-CN)'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isZhCn ? Color(0xff8438FF) : Color(0xff909399),
                  fontWeight: isZhCn ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 16.fp,
                  height: 1.0,
                ),
              ),
            ),
            onTap: () {
              if (!isZhCn) {
                localer(zhCn);
              }
            },
          ),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 640.wmax,
              height: 64.vp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15.vp),
                border: Border.all(
                  color: isEnUs ? Color(0xff8438FF) : Colors.black26,
                  width: isEnUs ? 1.4.vp : 1.2.vp,
                ),
              ),
              padding: EdgeInsets.symmetric(horizontal: 20.vp, vertical: 20.vp),
              margin: EdgeInsets.only(bottom: 25.vp),
              child: Text(
                'English (en-US)'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isEnUs ? Color(0xff8438FF) : Color(0xff909399),
                  fontWeight: isEnUs ? FontWeight.w600 : FontWeight.w400,
                  fontSize: 16.fp,
                  height: 1.0,
                ),
              ),
            ),
            onTap: () {
              if (!isEnUs) {
                localer(enUs);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget buildSafeArea(BuildContext context) {
    final mediaPadding = controller.mediaPadding;
    final mediaBottom = mediaPadding.value.bottom;

    return SizedBox(width: 640.wmax, height: max(mediaBottom, 30.vp));
  }
}
