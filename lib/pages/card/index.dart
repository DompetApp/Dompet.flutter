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
    final isAnimating = controller.isAnimating;
    final isExpand = controller.isExpand;
    final duration = controller.duration;

    return AnimatedContainer(
      duration: duration,
      onEnd: () => isAnimating.value = false,
      margin: EdgeInsets.only(
        top: isExpand.value ? 640.wmax * 103.sr : 640.wmax * 136.sr,
        bottom: isExpand.value ? 640.wmax * 6.sr : 640.wmax * 61.sr,
      ),
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: 640.wmax * 32.sr,
          right: 640.wmax * 32.sr,
        ),
        child: Text(
          'Bank Card'.tr,
          style: TextStyle(
            fontSize: 640.wmax * 24.sr,
            fontWeight: FontWeight.bold,
            color: const Color(0xff130138),
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
      margin: EdgeInsets.only(
        bottom: isExpand.value ? 640.wmax * 56.sr : 640.wmax * 48.sr,
      ),
      child: Container(
        color: Colors.white,
        alignment: Alignment.center,
        padding: EdgeInsets.only(
          left: isExpand.value ? 640.wmax * 32.sr : 640.wmax * 17.sr,
          right: isExpand.value ? 640.wmax * 32.sr : 640.wmax * 17.sr,
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
                    ? 640.wmax * 220.sr * scale
                    : 640.wmax * 240.sr;

                final height = isAnimating.value || isExpand.value
                    ? 640.wmax * 311.sr * scale
                    : 640.wmax * 340.sr;

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
                          right: 640.wmax * 38.5.sr * scale,
                          bottom: 640.wmax * 21.sr * scale,
                          child: Image.asset(
                            'lib/assets/images/card/visa.png',
                            width: 640.wmax * 29.2.sr * scale,
                            height: 640.wmax * 44.sr * scale,
                            fit: BoxFit.fill,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            SizedBox(
              width: 640.wmax,
              height: isExpand.value ? 640.wmax * 13.sr : 640.wmax * 40.sr,
            ),
          ],
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: isExpand.value ? 640.wmax * 15.sr : 0,
          child: Offstage(
            offstage: isAnimating.value,
            child: Container(
              alignment: Alignment.topCenter,
              child: Image.asset(
                'lib/assets/images/card/shadow.png',
                width: 640.wmax * 206.sr,
                height: 640.wmax * 79.sr,
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
      duration: duration,
      onEnd: () => isAnimating.value = false,
      width: 640.wmax,
      height: isExpand.value ? 640.wmax * 172.sr : 0,
      child: ListView(
        shrinkWrap: false,
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.only(
          top: 0,
          left: 640.wmax * 25.sr,
          right: 640.wmax * 25.sr,
          bottom: 0,
        ),
        children: [
          AnimatedOpacity(
            opacity: isExpand.value ? 1.0 : 0.0,
            duration: duration,
            child: SizedBox(
              height: 640.wmax * 172.sr,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 640.wmax * 20.sr,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 640.wmax * 80.sr,
                          child: Text(
                            'CardNo'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xffbdbdbd),
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.cardNo.tr,
                          style: TextStyle(
                            fontSize: 640.wmax * 15.sr,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff303133),
                            letterSpacing: 1.2,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 640.wmax, height: 640.wmax * 18.sr),
                  Container(
                    height: 640.wmax * 20.sr,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 640.wmax * 80.sr,
                          child: Text(
                            'Type'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xffbdbdbd),
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.cardType.tr,
                          style: TextStyle(
                            fontSize: 640.wmax * 16.sr,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff303133),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 640.wmax, height: 640.wmax * 18.sr),
                  Container(
                    height: 640.wmax * 20.sr,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 640.wmax * 80.sr,
                          child: Text(
                            'Bank'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xffbdbdbd),
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.bankName.tr,
                          style: TextStyle(
                            fontSize: 640.wmax * 16.sr,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff303133),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 640.wmax, height: 640.wmax * 18.sr),
                  Container(
                    height: 640.wmax * 20.sr,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 640.wmax * 80.sr,
                          child: Text(
                            'Status'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xffbdbdbd),
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.status == 'Y'
                              ? 'Available'.tr
                              : 'Unavailable'.tr,
                          style: TextStyle(
                            fontSize: 640.wmax * 16.sr,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff303133),
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 640.wmax, height: 640.wmax * 18.sr),
                  Container(
                    height: 640.wmax * 20.sr,
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        SizedBox(
                          width: 640.wmax * 80.sr,
                          child: Text(
                            'Valid'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xffbdbdbd),
                              height: 1,
                            ),
                          ),
                        ),
                        Text(
                          bankCard.value.expiryDate.yMMM(),
                          style: TextStyle(
                            fontSize: 640.wmax * 16.sr,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xff303133),
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
    final mediaBottom = max(mediaPadding.bottom, 640.wmax * 30.sr);

    Widget withInWell({required Widget child, dynamic onTap}) {
      return Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: 200.0,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(640.wmax * 30.0.sr)),
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
      padding: EdgeInsets.only(
        left: 640.wmax * 32.sr,
        right: 640.wmax * 32.sr,
        bottom: mediaBottom,
      ),
      child: IntrinsicWidth(
        child: withInWell(
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            constraints: BoxConstraints(minWidth: 640.wmax * 160.sr),
            padding: EdgeInsets.symmetric(
              vertical: 640.wmax * 15.sr,
              horizontal: 640.wmax * 18.sr,
            ),
            child: Text(
              isExpand.value ? 'Hide'.tr : 'Display'.tr,
              style: TextStyle(
                fontSize: 640.wmax * 18.sr,
                fontWeight: FontWeight.bold,
                color: const Color(0xff5b259f),
                letterSpacing: 1.2,
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
