import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
export 'package:dompet/pages/logger/controller.dart';
import 'package:dompet/pages/logger/controller.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/routes/router.dart';

class PageLogger extends GetView<PageLoggerController> {
  const PageLogger({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      const physics = NeverScrollableScrollPhysics();
      final mediaPadding = controller.mediaPadding;
      final mediaTopBar = controller.mediaTopBar;
      final isShadow = controller.isShadow;

      final height = max(640.wmax * 40.sr, mediaTopBar.value);
      final offset = max(mediaPadding.value.top, 640.wmax * 20.sr);

      return Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            NestedScrollView(
              physics: physics,
              headerSliverBuilder: (context, isScrolled) {
                return [
                  SliverOverlapAbsorber(
                    handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                      context,
                    ),
                    sliver: SliverAppBar(
                      pinned: true,
                      elevation: 0.0,
                      expandedHeight: height,
                      collapsedHeight: height,
                      scrolledUnderElevation: 0.0,
                      automaticallyImplyLeading: false,
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
                          padding: EdgeInsets.only(top: offset),
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
                    physics: physics,
                    slivers: [
                      SliverOverlapInjector(
                        handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
                          context,
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate((context, index) {
                          return Obx(
                            () => Container(
                              width: 100.vw,
                              height: 100.vh - height - offset,
                              alignment: Alignment.center,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  buildContent(context),
                                  buildLoading(context),
                                ],
                              ),
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
        'Run Logger'.tr,
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

  Widget buildContent(BuildContext context) {
    return Obx(() {
      final mediaPadding = controller.mediaPadding;
      final mediaTopBar = controller.mediaTopBar;
      final mediaTop = mediaPadding.value.top;

      final header = max(640.wmax * 40.sr, mediaTopBar.value);
      final offset = max(mediaTop, 640.wmax * 20.sr);
      final height = 100.vh - offset - header;

      return SizedBox(
        width: 640.wmax,
        height: height,
        child: InteractiveViewer(
          minScale: 1.0,
          maxScale: 5.0,
          constrained: false,
          child: Container(
            padding: EdgeInsets.only(
              top: 640.wmax * 5.sr,
              left: 640.wmax * 5.sr,
              right: 640.wmax * 5.sr,
              bottom: 640.wmax * 20.sr,
            ),
            child: TextSelectionTheme(
              data: TextSelectionThemeData(
                selectionColor: Color(0xff6750a4).withValues(alpha: 0.28),
                selectionHandleColor: Color(0xff6750a4).withValues(alpha: 0.28),
              ),
              child: SelectableText(
                controller.string.value,
                style: GoogleFonts.robotoMono(
                  fontWeight: FontWeight.w400,
                  fontSize: max(640.wmax * 11.sr, 11),
                  color: Color(0xff303133),
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildLoading(BuildContext context) {
    return Obx(
      () => Positioned(
        child: Offstage(
          offstage: !controller.loading.value,
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
                    color: Color(0xff707177),
                    semanticsValue: 'Loading logs, please wait...'.tr,
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(30, 20, 30, 80),
                    child: Text(
                      'Loading logs, please wait...'.tr,
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
      ),
    );
  }
}
