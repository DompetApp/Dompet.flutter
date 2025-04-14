import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/home/controller.dart';
import 'package:dompet/extension/money.dart';
import 'package:dompet/extension/date.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/routes/router.dart';

class PageHome extends GetView<PageHomeController> {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PageHomeController>()) {
      Get.put(PageHomeController());
    }

    return Scaffold(
      body: Obx(() {
        final mediaPadding = controller.mediaPadding.value;
        final mediaBottom = max(mediaPadding.bottom, 640.wmax * 30.sr);

        return Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: 640.wmax,
            height: 100.vh,
            child: Stack(
              fit: StackFit.expand,
              children: [
                ListView(
                  padding: EdgeInsets.only(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: mediaBottom + 640.wmax * 92.sr,
                  ),
                  physics: const ClampingScrollPhysics(),
                  controller: controller.scrollController,
                  children: [
                    buildBankCard(context),
                    buildTransactions(context),
                  ],
                ),
                buildHeader(context),
                buildBottomTabbar(context),
              ],
            ),
          ),
        );
      }),
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
    );
  }

  Widget buildHeader(BuildContext context) {
    return Obx(() {
      final mediaPadding = controller.mediaPadding;
      final mediaTop = mediaPadding.value.top;

      List<BoxShadow>? boxShadow;

      if (controller.showShadow.value) {
        boxShadow = [
          BoxShadow(
            color: const Color(0xff000000).withValues(alpha: 0.038),
            offset: const Offset(0, 1.2),
            spreadRadius: 0,
            blurRadius: 10,
          ),
        ];
      }

      return Positioned(
        top: 0,
        left: 0,
        child: Container(
          width: 640.wmax,
          height: max(640.wmax * 88.sr, mediaTop + 640.wmax * 56.sr),
          padding: EdgeInsets.only(
            top: max(640.wmax * 32.sr, mediaTop),
            left: 640.wmax * 32.sr,
            right: 640.wmax * 32.sr,
          ),
          decoration: BoxDecoration(color: Colors.white, boxShadow: boxShadow),
          child: Stack(
            fit: StackFit.expand,
            alignment: Alignment.center,
            children: [
              Positioned(top: 0, left: 0, child: buildHeaderTitle(context)),
              Positioned(top: 0, left: 0, child: buildHeaderActions(context)),
            ],
          ),
        ),
      );
    });
  }

  Widget buildBankCard(BuildContext context) {
    final bankCard = controller.bankCard;
    final balance = bankCard.balance;

    return Container(
      width: 640.wmax,
      padding: EdgeInsets.only(top: 640.wmax * 122.sr),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(
              left: 640.wmax * 32.sr,
              right: 640.wmax * 32.sr,
            ),
            margin: EdgeInsets.only(top: 640.wmax * 42.sr),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => GetRouter.toNamed(GetRoutes.card),
              child: Container(
                width: 640.wmax * 310.sr,
                height: 640.wmax * 140.sr,
                padding: EdgeInsets.only(
                  top: 640.wmax * 32.sr,
                  left: 640.wmax * 38.sr,
                  right: 640.wmax * 35.sr,
                ),
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('lib/assets/images/home/card.png'),
                    fit: BoxFit.fill,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Balance'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 16.sr,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      balance.value.USD,
                      style: TextStyle(
                        fontSize: 640.wmax * 20.sr,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xffdfdfdf),
                        height: 1.4,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 640.wmax * 10.sr),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Citibank',
                        style: TextStyle(
                          fontSize: 640.wmax * 22.sr,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xfff0f0f0),
                          height: 1.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.only(
              left: 640.wmax * 52.sr,
              right: 640.wmax * 52.sr,
            ),
            margin: EdgeInsets.only(top: 640.wmax * 36.sr),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap:
                      () => GetRouter.toNamed(
                        GetRoutes.operater,
                        arguments: 'Transfer',
                      ),
                  child: SizedBox(
                    width: 640.wmax * 80.sr,
                    child: Column(
                      children: [
                        Container(
                          width: 640.wmax * 48.sr,
                          height: 640.wmax * 48.sr,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              640.wmax * 20.sr,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x26272246),
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                                blurRadius: 12,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            'lib/assets/images/home/transfer.png',
                            width: 640.wmax * 28.sr,
                            height: 640.wmax * 28.sr,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 640.wmax * 16.sr),
                        Text(
                          'Transfer'.tr,
                          style: TextStyle(
                            fontSize: 640.wmax * 13.sr,
                            color: const Color(0xff8438FF),
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap:
                      () => GetRouter.toNamed(
                        GetRoutes.operater,
                        arguments: 'Payment',
                      ),
                  child: SizedBox(
                    width: 640.wmax * 80.sr,
                    child: Column(
                      children: [
                        Container(
                          width: 640.wmax * 48.sr,
                          height: 640.wmax * 48.sr,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              640.wmax * 20.sr,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x26272246),
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                                blurRadius: 12,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            'lib/assets/images/home/payment.png',
                            width: 640.wmax * 28.sr,
                            height: 640.wmax * 28.sr,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 640.wmax * 16.sr),
                        Text(
                          'Payment'.tr,
                          style: TextStyle(
                            fontSize: 640.wmax * 13.sr,
                            color: const Color(0xff8438FF),
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap:
                      () => GetRouter.toNamed(
                        GetRoutes.operater,
                        arguments: 'Top up',
                      ),
                  child: SizedBox(
                    width: 640.wmax * 80.sr,
                    child: Column(
                      children: [
                        Container(
                          width: 640.wmax * 48.sr,
                          height: 640.wmax * 48.sr,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              640.wmax * 20.sr,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x26272246),
                                offset: const Offset(0, 4),
                                spreadRadius: 0,
                                blurRadius: 12,
                              ),
                            ],
                            color: Colors.white,
                          ),
                          child: Image.asset(
                            'lib/assets/images/home/topup.png',
                            width: 640.wmax * 28.sr,
                            height: 640.wmax * 28.sr,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 640.wmax * 16.sr),
                        Text(
                          'Top up'.tr,
                          style: TextStyle(
                            fontSize: 640.wmax * 13.sr,
                            color: const Color(0xff8438FF),
                            fontWeight: FontWeight.w500,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTransactions(BuildContext context) {
    final loginUser = controller.loginUser;
    final userAvatar = loginUser.avatar.value;
    final bankOrders = controller.bankOrders;
    final rawOrders = bankOrders.list.value;

    Widget buildIconAvatar(String icon) {
      if (icon == 'me' && userAvatar != null) {
        return ClipOval(
          child: Image.memory(
            userAvatar,
            width: 640.wmax * 39.sr,
            height: 640.wmax * 39.sr,
            fit: BoxFit.fill,
          ),
        );
      }

      return ClipOval(
        child: Image.asset(
          'lib/assets/images/payer/$icon.png',
          width: 640.wmax * 39.sr,
          height: 640.wmax * 39.sr,
          fit: BoxFit.fill,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 640.wmax * 32.sr, right: 640.wmax * 32.sr),
      margin: EdgeInsets.only(top: 640.wmax * 42.sr, bottom: 640.wmax * 15.sr),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 640.wmax,
            height: 640.wmax * 21.sr,
            margin: EdgeInsets.only(
              left: 640.wmax * 2.sr,
              right: 640.wmax * 2.sr,
              bottom: 640.wmax * 25.sr,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Transactions'.tr,
                  style: TextStyle(
                    fontSize: 640.wmax * 18.sr,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff130138),
                    letterSpacing: -0.35,
                    height: 1,
                  ),
                ),
                Text(
                  'Money'.tr,
                  style: TextStyle(
                    fontSize: 640.wmax * 14.sr,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff130138),
                    height: 1,
                  ),
                ),
              ],
            ),
          ),
          ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            itemCount: rawOrders.length,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final order = rawOrders[index];

              return SizedBox(
                height: 640.wmax * 39.sr,
                child: Row(
                  children: [
                    buildIconAvatar(order.icon),
                    SizedBox(width: 640.wmax * 15.sr),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 640.wmax * 19.sr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.name.tr,
                                  style: TextStyle(
                                    fontSize: 640.wmax * 16.sr,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff000000),
                                  ),
                                ),
                                Text(
                                  order.money.usd,
                                  style: TextStyle(
                                    fontSize: 640.wmax * 16.sr,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xff363853),
                                    letterSpacing: -0.6,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 640.wmax * 2.sr),
                          SizedBox(
                            height: 640.wmax * 18.sr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.type.tr,
                                  style: TextStyle(
                                    fontSize: 640.wmax * 14.sr,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xff909399),
                                  ),
                                ),
                                Text(
                                  order.date.yMMMd(),
                                  style: TextStyle(
                                    fontSize: 640.wmax * 12.sr,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xffababab),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return SizedBox(height: 640.wmax * 21.sr);
            },
          ),
        ],
      ),
    );
  }

  Widget buildHeaderTitle(BuildContext context) {
    final showActions = controller.showActions;
    final isRunAnimating = controller.isRunAnimating;
    final isTitleOffstage = controller.isTitleOffstage;

    return Offstage(
      offstage: isTitleOffstage,
      child: AnimatedOpacity(
        opacity: showActions.value ? 0.0 : 1.0,
        duration: Duration(milliseconds: showActions.value ? 300 : 480),
        onEnd: () => isRunAnimating.value = false,
        child: SizedBox(
          width: 640.wmax * (1 - 64.sr),
          height: 640.wmax * 56.sr,
          child: Row(
            children: [
              Expanded(
                child: SizedBox(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Digital Wallet'.tr,
                        style: TextStyle(
                          fontSize: 640.wmax * 24.sr,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xff130138),
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 640.wmax * 5.sr),
                      Text(
                        'available'.tr,
                        style: TextStyle(
                          fontSize: 640.wmax * 16.sr,
                          fontWeight: FontWeight.normal,
                          color: const Color(0xffbdbdbd),
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => GetRouter.toNamed(GetRoutes.profile),
                child: buildHeaderAvatar(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildHeaderAvatar(BuildContext context) {
    final loginUser = controller.loginUser;
    final avatar = loginUser.avatar;

    if (avatar.value.bv) {
      return ClipOval(
        child: Image.memory(
          loginUser.avatar.value!,
          width: 640.wmax * 44.sr,
          height: 640.wmax * 44.sr,
          fit: BoxFit.fill,
        ),
      );
    }

    return ClipOval(
      child: Image.asset(
        'lib/assets/images/home/avatar.png',
        width: 640.wmax * 44.sr,
        height: 640.wmax * 44.sr,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget buildHeaderActions(BuildContext context) {
    final showActions = controller.showActions;
    final isRunAnimating = controller.isRunAnimating;
    final isActionOffstage = controller.isActionOffstage;

    return Offstage(
      offstage: isActionOffstage,
      child: AnimatedOpacity(
        opacity: !showActions.value ? 0.0 : 1.0,
        duration: Duration(milliseconds: showActions.value ? 480 : 300),
        onEnd: () => isRunAnimating.value = false,
        child: Container(
          width: 640.wmax * (1 - 64.sr),
          height: 640.wmax * 56.sr,
          padding: EdgeInsets.only(
            left: 640.wmax * 14.sr,
            right: 640.wmax * 14.sr,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap:
                    () => GetRouter.toNamed(
                      GetRoutes.operater,
                      arguments: 'Transfer',
                    ),
                child: Column(
                  children: [
                    Container(
                      width: 640.wmax * 80.sr,
                      height: 640.wmax * 28.sr,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 640.wmax * 2.sr),
                      child: Image.asset(
                        'lib/assets/images/home/transfer.png',
                        width: 640.wmax * 26.sr,
                        height: 640.wmax * 26.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Transfer'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 13.sr,
                        color: const Color(0xff2f1155),
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap:
                    () => GetRouter.toNamed(
                      GetRoutes.operater,
                      arguments: 'Payment',
                    ),
                child: Column(
                  children: [
                    Container(
                      width: 640.wmax * 80.sr,
                      height: 640.wmax * 28.sr,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 640.wmax * 2.sr),
                      child: Image.asset(
                        'lib/assets/images/home/payment.png',
                        width: 640.wmax * 26.sr,
                        height: 640.wmax * 26.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Payment'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 13.sr,
                        color: const Color(0xff2f1155),
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap:
                    () => GetRouter.toNamed(
                      GetRoutes.operater,
                      arguments: 'Top up',
                    ),
                child: Column(
                  children: [
                    Container(
                      width: 640.wmax * 80.sr,
                      height: 640.wmax * 28.sr,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 640.wmax * 2.sr),
                      child: Image.asset(
                        'lib/assets/images/home/topup.png',
                        width: 640.wmax * 26.sr,
                        height: 640.wmax * 26.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Top up'.tr,
                      style: TextStyle(
                        fontSize: 640.wmax * 13.sr,
                        color: const Color(0xff2f1155),
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildBottomTabbar(BuildContext context) {
    final mediaPadding = controller.mediaPadding.value;
    final mediaBottom = max(mediaPadding.bottom, 640.wmax * 30.sr);

    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: 640.wmax,
        color: Colors.white.withValues(alpha: 0.88),
        height: mediaBottom + 640.wmax * 92.sr,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: 640.wmax * 10.sr,
          left: 640.wmax * 24.sr,
          right: 640.wmax * 24.sr,
          bottom: mediaBottom,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 640.wmax * 32.sr,
              left: 640.wmax * 24.sr,
              child: Image.asset(
                'lib/assets/images/tabbar/bg.png',
                width: 640.wmax * 280.sr,
                height: 640.wmax * 52.sr,
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 640.wmax * 78.sr,
                padding: EdgeInsets.only(
                  top: 640.wmax * 25.sr,
                  left: 640.wmax * 40.sr,
                  right: 640.wmax * 40.sr,
                  bottom: 640.wmax * 25.sr,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff2f1155),
                  borderRadius: BorderRadius.circular(640.wmax * 30.sr),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0x19272246),
                      offset: const Offset(0, 8),
                      spreadRadius: 0,
                      blurRadius: 12,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {},
                      child: Image.asset(
                        'lib/assets/images/tabbar/home_select.png',
                        width: 640.wmax * 28.sr,
                        height: 640.wmax * 28.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => GetRouter.toNamed(GetRoutes.stats),
                      child: Image.asset(
                        'lib/assets/images/tabbar/chart.png',
                        width: 640.wmax * 28.sr,
                        height: 640.wmax * 28.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => GetRouter.toNamed(GetRoutes.notification),
                      child: Image.asset(
                        'lib/assets/images/tabbar/notification.png',
                        width: 640.wmax * 28.sr,
                        height: 640.wmax * 28.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => GetRouter.toNamed(GetRoutes.settings),
                      child: Image.asset(
                        'lib/assets/images/tabbar/settings.png',
                        width: 640.wmax * 28.sr,
                        height: 640.wmax * 28.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
