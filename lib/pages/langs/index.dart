import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/langs/controller.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/routes/router.dart';

class PageLangs extends GetView<PageLangsController> {
  const PageLangs({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PageLangsController>()) {
      Get.put(PageLangsController());
    }

    return Obx(() {
      const physics = AlwaysScrollableScrollPhysics();
      final scrollController = controller.scrollController;
      final mediaPadding = controller.mediaPadding;
      final mediaTopBar = controller.mediaTopBar;
      final isShadow = controller.isShadow;

      final top = max(mediaPadding.value.top, 640.wmax * 20.sr);

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
                      expandedHeight: 640.wmax * 152.sr,
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
      padding: EdgeInsets.only(left: 640.wmax * 32.sr, right: 640.wmax * 32.sr),
      child: Text(
        'Language'.tr,
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
        top: 640.wmax * 30.sr,
        left: 640.wmax * 48.sr,
        right: 640.wmax * 48.sr,
        bottom: 640.wmax * 35.sr,
      ),
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 640.wmax,
              height: 640.wmax * 64.sr,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(640.wmax * 15.sr),
                border: Border.all(
                  color: isNull ? Color(0xff8438FF) : Colors.black26,
                  width: isNull ? 640.wmax * 1.4.sr : 640.wmax * 1.2.sr,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 640.wmax * 20.sr,
                vertical: 640.wmax * 20.sr,
              ),
              margin: EdgeInsets.only(bottom: 640.wmax * 25.sr),
              child: Text(
                'Follow System Language'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 640.wmax * 16.sr,
                  fontWeight: isNull ? FontWeight.w600 : FontWeight.w400,
                  color: isNull ? Color(0xff8438FF) : Color(0xff808288),
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
              height: 640.wmax * 64.sr,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(640.wmax * 15.sr),
                border: Border.all(
                  color: isZhCn ? Color(0xff8438FF) : Colors.black26,
                  width: isZhCn ? 640.wmax * 1.4.sr : 640.wmax * 1.2.sr,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 640.wmax * 20.sr,
                vertical: 640.wmax * 20.sr,
              ),
              margin: EdgeInsets.only(bottom: 640.wmax * 25.sr),
              child: Text(
                'Chinese (zh-CN)'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 640.wmax * 16.sr,
                  fontWeight: isZhCn ? FontWeight.w600 : FontWeight.w400,
                  color: isZhCn ? Color(0xff8438FF) : Color(0xff909399),
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
              height: 640.wmax * 64.sr,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(640.wmax * 15.sr),
                border: Border.all(
                  color: isEnUs ? Color(0xff8438FF) : Colors.black26,
                  width: isEnUs ? 640.wmax * 1.4.sr : 640.wmax * 1.2.sr,
                ),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 640.wmax * 20.sr,
                vertical: 640.wmax * 20.sr,
              ),
              margin: EdgeInsets.only(bottom: 640.wmax * 25.sr),
              child: Text(
                'English (en-US)'.tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 640.wmax * 16.sr,
                  fontWeight: isEnUs ? FontWeight.w600 : FontWeight.w400,
                  color: isEnUs ? Color(0xff8438FF) : Color(0xff909399),
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

    return SizedBox(
      width: 640.wmax,
      height: max(mediaBottom, 640.wmax * 30.sr),
    );
  }
}
