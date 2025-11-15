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
        'Notification'.tr,
        style: TextStyle(
          color: const Color(0xff130138),
          fontWeight: FontWeight.bold,
          letterSpacing: 3,
          fontSize: 20.fp,
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
          width: 312.vp,
          margin: EdgeInsets.only(bottom: 10.vp),
          child: Stack(
            fit: StackFit.loose,
            children: [
              Padding(
                padding: EdgeInsets.all(1.vp),
                child: Container(
                  width: 310.vp,
                  padding: EdgeInsets.only(
                    top: 10.vp,
                    left: 28.vp,
                    right: 20.vp,
                    bottom: 10.vp,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(17.vp),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xff000000).withValues(alpha: .058),
                        offset: Offset(3.vp, 3.vp),
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
                        width: 220.vp,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 21.vp,
                              child: Text(
                                '${message.date.yMMMd()} ${message.date.jm()}',
                                style: TextStyle(
                                  color: const Color(0xffafafaf),
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12.4.fp,
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              child: Text(
                                message.desc.tr,
                                style: TextStyle(
                                  color: const Color(0xff363853),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.fp,
                                  height: 1.4,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              height: 21.vp,
                              child: Text(
                                message.money.usd,
                                style: TextStyle(
                                  color: const Color(0xff606266),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 12.4.fp,
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
                        height: 20.vp,
                        width: 20.vp,
                        fit: BoxFit.fill,
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                right: 9.vp,
                child: Offstage(
                  offstage: message.isRead != 'N',
                  child: Container(
                    width: 7.vp,
                    height: 7.vp,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3.5.vp),
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
        width: 312.vp,
        margin: EdgeInsets.only(bottom: 20.vp),
        padding: EdgeInsets.only(bottom: 1.vp),
        child: Column(
          children: [
            Container(
              width: 312.vp,
              height: 20.vp,
              alignment: Alignment.center,
              child: Text(
                msgYear.tr,
                style: TextStyle(
                  color: const Color(0xff363853),
                  letterSpacing: group.year == nowYear ? 3 : 1,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.8.fp,
                  height: 1,
                ),
              ),
            ),
            SizedBox(width: 312.vp, height: 15.vp),
            SizedBox(
              width: 312.vp,
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
      padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
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

    return SizedBox(width: 640.wmax, height: max(mediaBottom - 20.vp, 10.vp));
  }
}
