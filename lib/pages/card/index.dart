import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
export 'package:dompet/pages/card/controller.dart';
import 'package:dompet/pages/card/controller.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/date.dart';
import 'package:dompet/extension/size.dart';

class PageCard extends GetView<PageCardController> {
  const PageCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                width: 640.wmax,
                height: 100.vh,
                child: ListView(
                  shrinkWrap: false,
                  padding: EdgeInsets.zero,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    buildTitle(context),
                    buildContent(context),
                    buildButton(context),
                  ],
                ),
              ),
            ),
            buildBack(context),
          ],
        ),
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: false,
      ),
    );
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
                  fit: BoxFit.fill,
                  image: const AssetImage('lib/assets/images/auth/back.png'),
                  width: 36.vp,
                  height: 36.vp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    final isAnimating = controller.isAnimating;
    final isExpand = controller.isExpand;
    final duration = controller.duration;

    return AnimatedContainer(
      duration: duration,
      onEnd: () => isAnimating.value = false,
      margin: EdgeInsets.only(
        top: isExpand.value ? 103.vp : 136.vp,
        bottom: isExpand.value ? 6.vp : 61.vp,
      ),
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
        child: Text(
          'Bank Card'.tr,
          style: TextStyle(
            color: const Color(0xff130138),
            fontWeight: FontWeight.bold,
            fontSize: 24.fp,
            height: 1.2,
          ),
        ),
      ),
    );
  }

  Widget buildContent(BuildContext context) {
    final isAnimating = controller.isAnimating;
    final isExpand = controller.isExpand;
    final duration = controller.duration;

    return AnimatedContainer(
      duration: duration,
      onEnd: () => isAnimating.value = false,
      margin: EdgeInsets.only(bottom: isExpand.value ? 56.vp : 48.vp),
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: isExpand.value ? 32.vp : 17.vp,
          right: isExpand.value ? 32.vp : 17.vp,
        ),
        child: Column(
          children: [buildCardImage(context), buildCardDetail(context)],
        ),
      ),
    );
  }

  Widget buildCardImage(BuildContext context) {
    final animationValue = controller.animationValue;
    final isAnimating = controller.isAnimating;
    final isExpand = controller.isExpand;

    return Stack(
      fit: StackFit.loose,
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            AnimatedBuilder(
              animation: animationValue,
              builder: (context, child) {
                final scale = !isExpand.value && animationValue.value < 1
                    ? 1 + 0.093 * (1 - animationValue.value)
                    : 1;

                final width = isAnimating.value || isExpand.value
                    ? 220.vp * scale
                    : 240.vp;

                final height = isAnimating.value || isExpand.value
                    ? 311.vp * scale
                    : 340.vp;

                return Transform.rotate(
                  angle: animationValue.value,
                  child: SizedBox(
                    width: width,
                    height: height,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Image.asset(
                          'lib/assets/images/card/bg.png',
                          fit: BoxFit.fill,
                        ),
                        Positioned(
                          right: 38.5.vp * scale,
                          bottom: 21.vp * scale,
                          child: Image.asset(
                            'lib/assets/images/card/visa.png',
                            width: 29.2.vp * scale,
                            height: 44.vp * scale,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(width: 640.wmax, height: isExpand.value ? 13.vp : 40.vp),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: isExpand.value ? 15.vp : 0,
          child: Offstage(
            offstage: isAnimating.value,
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'lib/assets/images/card/shadow.png',
                width: 206.vp,
                height: 79.vp,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCardDetail(BuildContext context) {
    final isAnimating = controller.isAnimating;
    final isExpand = controller.isExpand;
    final duration = controller.duration;
    final bankCard = controller.bankCard;

    return AnimatedContainer(
      onEnd: () {
        isAnimating.value = false;
      },
      width: 640.wmax,
      height: isExpand.value ? 172.vp : 0,
      duration: duration,
      child: ListView(
        shrinkWrap: false,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(top: 0, left: 25.vp, right: 25.vp, bottom: 0),
        children: [
          AnimatedOpacity(
            opacity: isExpand.value ? 1.0 : 0.0,
            duration: duration,
            child: SizedBox(
              height: 172.vp,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 20.vp,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80.vp,
                          child: Text(
                            'CardNo'.tr,
                            style: TextStyle(
                              color: const Color(0xffbdbdbd),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.fp,
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.cardNo.tr,
                          style: TextStyle(
                            color: const Color(0xff303133),
                            fontWeight: FontWeight.w500,
                            letterSpacing: 1.2,
                            fontSize: 15.fp,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 640.wmax, height: 18.vp),
                  Container(
                    height: 20.vp,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80.vp,
                          child: Text(
                            'Type'.tr,
                            style: TextStyle(
                              color: const Color(0xffbdbdbd),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.fp,
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.cardType.tr,
                          style: TextStyle(
                            color: const Color(0xff303133),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.fp,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 640.wmax, height: 18.vp),
                  Container(
                    height: 20.vp,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80.vp,
                          child: Text(
                            'Bank'.tr,
                            style: TextStyle(
                              color: const Color(0xffbdbdbd),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.fp,
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.bankName.tr,
                          style: TextStyle(
                            color: const Color(0xff303133),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.fp,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 640.wmax, height: 18.vp),
                  Container(
                    height: 20.vp,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80.vp,
                          child: Text(
                            'Status'.tr,
                            style: TextStyle(
                              color: const Color(0xffbdbdbd),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.fp,
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.status == 'Y'
                              ? 'Available'.tr
                              : 'Unavailable'.tr,
                          style: TextStyle(
                            color: const Color(0xff303133),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.fp,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 640.wmax, height: 18.vp),
                  Container(
                    height: 20.vp,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 80.vp,
                          child: Text(
                            'Valid'.tr,
                            style: TextStyle(
                              color: const Color(0xffbdbdbd),
                              fontWeight: FontWeight.w500,
                              fontSize: 16.fp,
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.expiryDate.yMMM(),
                          style: TextStyle(
                            color: const Color(0xff303133),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.fp,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildButton(BuildContext context) {
    final isExpand = controller.isExpand;
    final isAnimating = controller.isAnimating;
    final mediaPadding = controller.mediaPadding.value;
    final mediaBottom = max(mediaPadding.bottom, 30.vp);

    Widget withInWell({required Widget child, dynamic onTap}) {
      return Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: 200.0,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(30.0.vp)),
          highlightColor: const Color(0xff45197d).withValues(alpha: 0.05),
          splashColor: const Color(0xff45197d).withValues(alpha: 0.05),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: onTap,
          child: child,
        ),
      );
    }

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 32.vp, right: 32.vp, bottom: mediaBottom),
      child: IntrinsicWidth(
        child: withInWell(
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            constraints: BoxConstraints(minWidth: 160.vp),
            padding: EdgeInsets.symmetric(vertical: 15.vp, horizontal: 18.vp),
            child: Text(
              isExpand.value ? 'Hide'.tr : 'Display'.tr,
              style: TextStyle(
                color: const Color(0xff5b259f),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 18.fp,
                height: 1.2,
              ),
            ),
          ),
          onTap: () {
            if (!isAnimating.value) {
              isExpand.value = !isExpand.value;
              isAnimating.value = true;
            }
          },
        ),
      ),
    );
  }
}
