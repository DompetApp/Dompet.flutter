import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
export 'package:dompet/pages/home/controller.dart';
import 'package:dompet/pages/home/controller.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/money.dart';
import 'package:dompet/extension/date.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/size.dart';

class PageHome extends GetView<PageHomeController> {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        final mediaPadding = controller.mediaPadding.value;
        final mediaBottom = max(mediaPadding.bottom, 30.vp);

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
                    bottom: mediaBottom + 92.vp,
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
          height: max(88.vp, mediaTop + 56.vp),
          padding: EdgeInsets.only(
            top: max(32.vp, mediaTop),
            left: 32.vp,
            right: 32.vp,
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
      padding: EdgeInsets.only(top: 122.vp),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
            margin: EdgeInsets.only(top: 42.vp),
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => GetNavigate.toNamed(GetRoutes.card),
              child: Container(
                width: 310.vp,
                height: 140.vp,
                padding: EdgeInsets.only(top: 32.vp, left: 38.vp, right: 35.vp),
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
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.fp,
                        height: 1.2,
                      ),
                    ),
                    Text(
                      balance.value.USD,
                      style: TextStyle(
                        color: const Color(0xffdfdfdf),
                        fontWeight: FontWeight.bold,
                        fontSize: 20.fp,
                        height: 1.4,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 10.vp),
                      alignment: Alignment.centerRight,
                      child: Text(
                        'Citibank',
                        style: TextStyle(
                          color: const Color(0xfff0f0f0),
                          fontWeight: FontWeight.bold,
                          fontSize: 22.fp,
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
            padding: EdgeInsets.only(left: 52.vp, right: 52.vp),
            margin: EdgeInsets.only(top: 36.vp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => GetNavigate.toNamed(
                    GetRoutes.operater,
                    arguments: 'Transfer',
                  ),
                  child: SizedBox(
                    width: 80.vp,
                    child: Column(
                      children: [
                        Container(
                          width: 48.vp,
                          height: 48.vp,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.vp),
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
                            width: 28.vp,
                            height: 28.vp,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 16.vp),
                        Text(
                          'Transfer'.tr,
                          style: TextStyle(
                            color: const Color(0xff8438FF),
                            fontWeight: FontWeight.w500,
                            fontSize: 13.fp,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => GetNavigate.toNamed(
                    GetRoutes.operater,
                    arguments: 'Payment',
                  ),
                  child: SizedBox(
                    width: 80.vp,
                    child: Column(
                      children: [
                        Container(
                          width: 48.vp,
                          height: 48.vp,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.vp),
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
                            width: 28.vp,
                            height: 28.vp,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 16.vp),
                        Text(
                          'Payment'.tr,
                          style: TextStyle(
                            color: const Color(0xff8438FF),
                            fontWeight: FontWeight.w500,
                            fontSize: 13.fp,
                            height: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => GetNavigate.toNamed(
                    GetRoutes.operater,
                    arguments: 'Top up',
                  ),
                  child: SizedBox(
                    width: 80.vp,
                    child: Column(
                      children: [
                        Container(
                          width: 48.vp,
                          height: 48.vp,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.vp),
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
                            width: 28.vp,
                            height: 28.vp,
                            fit: BoxFit.fill,
                          ),
                        ),
                        SizedBox(height: 16.vp),
                        Text(
                          'Top up'.tr,
                          style: TextStyle(
                            color: const Color(0xff8438FF),
                            fontWeight: FontWeight.w500,
                            fontSize: 13.fp,
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
            width: 39.vp,
            height: 39.vp,
            fit: BoxFit.fill,
          ),
        );
      }

      return ClipOval(
        child: Image.asset(
          'lib/assets/images/payer/$icon.png',
          width: 39.vp,
          height: 39.vp,
          fit: BoxFit.fill,
        ),
      );
    }

    return Container(
      padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
      margin: EdgeInsets.only(top: 42.vp, bottom: 15.vp),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 640.wmax,
            height: 21.vp,
            margin: EdgeInsets.only(left: 2.vp, right: 2.vp, bottom: 25.vp),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Transactions'.tr,
                  style: TextStyle(
                    color: const Color(0xff130138),
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.35,
                    fontSize: 18.fp,
                    height: 1,
                  ),
                ),
                Text(
                  'Money'.tr,
                  style: TextStyle(
                    color: const Color(0xff130138),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.fp,
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
                height: 39.vp,
                child: Row(
                  children: [
                    buildIconAvatar(order.icon),
                    SizedBox(width: 15.vp),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 19.vp,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.name.tr,
                                  style: TextStyle(
                                    color: const Color(0xff000000),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.fp,
                                  ),
                                ),
                                Text(
                                  order.money.usd,
                                  style: TextStyle(
                                    color: const Color(0xff363853),
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: -0.6,
                                    fontSize: 16.fp,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 2.vp),
                          SizedBox(
                            height: 18.vp,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  order.type.tr,
                                  style: TextStyle(
                                    color: const Color(0xff909399),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14.fp,
                                  ),
                                ),
                                Text(
                                  order.date.yMMMd(),
                                  style: TextStyle(
                                    color: const Color(0xffababab),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 12.fp,
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
              return SizedBox(height: 21.vp);
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
          height: 56.vp,
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
                          color: const Color(0xff130138),
                          fontWeight: FontWeight.bold,
                          fontSize: 24.fp,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 5.vp),
                      Text(
                        'available'.tr,
                        style: TextStyle(
                          color: const Color(0xffbdbdbd),
                          fontWeight: FontWeight.normal,
                          fontSize: 16.fp,
                          height: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => GetNavigate.toNamed(GetRoutes.profile),
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
          width: 44.vp,
          height: 44.vp,
          fit: BoxFit.fill,
        ),
      );
    }

    return ClipOval(
      child: Image.asset(
        'lib/assets/images/home/avatar.png',
        width: 44.vp,
        height: 44.vp,
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
          height: 56.vp,
          padding: EdgeInsets.only(left: 14.vp, right: 14.vp),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => GetNavigate.toNamed(
                  GetRoutes.operater,
                  arguments: 'Transfer',
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80.vp,
                      height: 28.vp,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 2.vp),
                      child: Image.asset(
                        'lib/assets/images/home/transfer.png',
                        width: 26.vp,
                        height: 26.vp,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Transfer'.tr,
                      style: TextStyle(
                        color: const Color(0xff2f1155),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.fp,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => GetNavigate.toNamed(
                  GetRoutes.operater,
                  arguments: 'Payment',
                ),
                child: Column(
                  children: [
                    Container(
                      width: 80.vp,
                      height: 28.vp,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 2.vp),
                      child: Image.asset(
                        'lib/assets/images/home/payment.png',
                        width: 26.vp,
                        height: 26.vp,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Payment'.tr,
                      style: TextStyle(
                        color: const Color(0xff2f1155),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.fp,
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  GetNavigate.toNamed(GetRoutes.operater, arguments: 'Top up');
                },
                child: Column(
                  children: [
                    Container(
                      width: 80.vp,
                      height: 28.vp,
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.only(top: 2.vp),
                      child: Image.asset(
                        'lib/assets/images/home/topup.png',
                        width: 26.vp,
                        height: 26.vp,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Top up'.tr,
                      style: TextStyle(
                        color: const Color(0xff2f1155),
                        fontWeight: FontWeight.w600,
                        fontSize: 13.fp,
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
    final mediaBottom = max(mediaPadding.bottom, 30.vp);

    return Positioned(
      left: 0,
      bottom: 0,
      child: Container(
        width: 640.wmax,
        color: Colors.white.withValues(alpha: 0.88),
        height: mediaBottom + 92.vp,
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: 10.vp,
          left: 24.vp,
          right: 24.vp,
          bottom: mediaBottom,
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Positioned(
              top: 32.vp,
              left: 24.vp,
              child: Image.asset(
                'lib/assets/images/tabbar/bg.png',
                width: 280.vp,
                height: 52.vp,
                fit: BoxFit.fill,
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                height: 78.vp,
                padding: EdgeInsets.only(
                  top: 25.vp,
                  left: 40.vp,
                  right: 40.vp,
                  bottom: 25.vp,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xff2f1155),
                  borderRadius: BorderRadius.circular(30.vp),
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
                        width: 28.vp,
                        height: 28.vp,
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => GetNavigate.toNamed(GetRoutes.stats),
                      child: Image.asset(
                        'lib/assets/images/tabbar/chart.png',
                        width: 28.vp,
                        height: 28.vp,
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => GetNavigate.toNamed(GetRoutes.notification),
                      child: Image.asset(
                        'lib/assets/images/tabbar/notification.png',
                        width: 28.vp,
                        height: 28.vp,
                        fit: BoxFit.fill,
                      ),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () => GetNavigate.toNamed(GetRoutes.settings),
                      child: Image.asset(
                        'lib/assets/images/tabbar/settings.png',
                        width: 28.vp,
                        height: 28.vp,
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
