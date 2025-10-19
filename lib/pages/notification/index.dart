import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
export 'package:dompet/pages/notification/controller.dart';
import 'package:dompet/pages/notification/controller.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/money.dart';
import 'package:dompet/extension/date.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/models/message.dart';

class PageNotification extends GetView<PageNotificationController> {
  const PageNotification({super.key});

  @override
  Widget build(BuildContext context) {
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
                                buidlMessages(context),
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
                onTap: () => GetNavigate.back(),
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
        'Notification'.tr,
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

  Widget buidlMessages(BuildContext context) {
    final readMessage = controller.readMessage;
    final msgGroups = controller.msgGroups;

    Widget buildMessage(Message message) {
      return GestureDetector(
        behavior: HitTestBehavior.opaque,
        child: Container(
          width: 640.wmax * 312.sr,
          margin: EdgeInsets.only(bottom: 640.wmax * 10.sr),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Padding(
                padding: EdgeInsets.all(640.wmax * 1.sr),
                child: Container(
                  width: 640.wmax * 310.sr,
                  padding: EdgeInsets.only(
                    top: 640.wmax * 10.sr,
                    left: 640.wmax * 28.sr,
                    right: 640.wmax * 20.sr,
                    bottom: 640.wmax * 10.sr,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(640.wmax * 17.sr),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withValues(alpha: .058),
                        offset: Offset(640.wmax * 3.sr, 640.wmax * 3.sr),
                        spreadRadius: 0,
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 640.wmax * 220.sr,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 640.wmax * 21.sr,
                              child: Text(
                                '${message.date.yMMMd()} ${message.date.jm()}',
                                style: TextStyle(
                                  fontSize: 640.wmax * 12.4.sr,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xffafafaf),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                message.desc.tr,
                                style: TextStyle(
                                  fontSize: 640.wmax * 15.sr,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff363853),
                                  height: 1.4,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 640.wmax * 21.sr,
                              child: Text(
                                message.money.usd,
                                style: TextStyle(
                                  fontSize: 640.wmax * 12.4.sr,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xff606266),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        message.money > 0.0
                            ? 'lib/assets/images/notification/income.png'
                            : 'lib/assets/images/notification/expenditure.png',
                        height: 640.wmax * 20.sr,
                        width: 640.wmax * 20.sr,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 640.wmax * 9.sr,
                child: Offstage(
                  offstage: message.isRead != 'N',
                  child: Container(
                    width: 640.wmax * 7.sr,
                    height: 640.wmax * 7.sr,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(640.wmax * 3.5.sr),
                      color: const Color(0xffff3333),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        onTap: () {
          if (message.isRead == 'N') {
            readMessage(message);
          }
        },
      );
    }

    Widget buildGroup(GroupMessage group) {
      var msgYear = group.year.toString();
      final nowYear = DateTime.now().year;
      final messages = group.messages;

      if (group.year == nowYear) {
        msgYear = 'this year';
      }

      return Container(
        width: 640.wmax * 312.sr,
        margin: EdgeInsets.only(bottom: 640.wmax * 20.sr),
        padding: EdgeInsets.only(bottom: 640.wmax * 1.sr),
        child: Column(
          children: [
            Container(
              width: 640.wmax * 312.sr,
              height: 640.wmax * 20.sr,
              alignment: Alignment.center,
              child: Text(
                msgYear.tr,
                style: TextStyle(
                  fontSize: 640.wmax * 14.8.sr,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff363853),
                  letterSpacing: group.year == nowYear ? 3 : 1,
                  height: 1,
                ),
              ),
            ),
            SizedBox(width: 640.wmax * 312.sr, height: 640.wmax * 15.sr),
            SizedBox(
              width: 640.wmax * 312.sr,
              child: Column(
                children: [
                  ...messages.map((msg) {
                    return buildMessage(msg);
                  }),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 640.wmax * 32.sr, right: 640.wmax * 32.sr),
      child: Column(
        children: [
          ...msgGroups.value.map((group) {
            return buildGroup(group);
          }),
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
}
