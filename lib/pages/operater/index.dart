import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/operater/controller.dart';
import 'package:dompet/extension/money.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/routes/router.dart';

class PageOperater extends GetView<PageOperaterController> {
  const PageOperater({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PageOperaterController>()) {
      Get.put(PageOperaterController());
    }

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
                    buildMoney(context),
                    buildOptions(context),
                    buildKeyboard(context),
                    buildConfirmBtn(context),
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

  Widget buildMoney(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
        alignment: Alignment.center,
        margin: EdgeInsets.only(
          top: 640.wmax * 130.sr,
          bottom: 640.wmax * 44.sr,
        ),
        padding: EdgeInsets.only(
          left: 640.wmax * 32.sr,
          right: 640.wmax * 32.sr,
        ),
        child: Text(
          controller.money.value.USD,
          style: TextStyle(
            fontSize: 640.wmax * 32.sr,
            fontWeight: FontWeight.bold,
            color: const Color(0xff2f1155),
            height: 1,
          ),
        ),
      ),
    );
  }

  Widget buildOptions(BuildContext context) {
    return Obx(() {
      final options = controller.options;
      final operate = controller.operate;
      final isTopup = controller.type == 'Top up';
      final isTransfer = controller.type == 'Transfer';
      final isSamePerson = operate.value.from == operate.value.to;
      final loginUser = controller.loginUser;
      final avatar = loginUser.avatar;
      final from = operate.value.from;
      final to = operate.value.to;

      Widget withSplash(Widget child) {
        return Theme(
          data: Theme.of(context).copyWith(
            splashColor: Color(0xfff0f0f0),
            highlightColor: Color(0xfff0f0f0),
          ),
          child: child,
        );
      }

      Widget iconAvatar(String icon) {
        icon = icon.toLowerCase();

        if (!isTransfer && icon == 'me') {
          if (avatar.value.bv) {
            return ClipOval(
              child: Image.memory(
                loginUser.avatar.value!,
                width: 640.wmax * 20.sr,
                height: 640.wmax * 20.sr,
                fit: BoxFit.fill,
              ),
            );
          }
        }

        if (isTransfer && icon == 'me') {
          return SizedBox.shrink();
        }

        return ClipOval(
          child: Image.asset(
            'lib/assets/images/payer/$icon.png',
            width: 640.wmax * 20.sr,
            height: 640.wmax * 20.sr,
            fit: BoxFit.fill,
          ),
        );
      }

      dynamic itemBuilder() {
        final iterable = options.value.map((opt) {
          return PopupMenuItem(
            value: opt.id,
            padding: EdgeInsets.zero,
            child: Container(
              width: 640.wmax * 375.sr,
              height: 640.wmax * 48.sr,
              padding: EdgeInsets.only(
                top: 640.wmax * 12.sr,
                left: 640.wmax * 30.sr,
                right: 640.wmax * 24.sr,
                bottom: 640.wmax * 12.sr,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 640.wmax * 4.sr),
                    child: iconAvatar(isTopup ? opt.from : opt.to),
                  ),
                  Text(
                    isTopup ? opt.from.tr : opt.to.tr,
                    style: TextStyle(
                      fontSize: 640.wmax * 16.sr,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff363853),
                    ),
                  ),
                  Offstage(
                    offstage: !isTransfer || opt.from == opt.to,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            left: 640.wmax * 15.sr,
                            right: 640.wmax * 15.sr,
                          ),
                          child: Image.asset(
                            'lib/assets/images/operater/left.png',
                            height: 640.wmax * 26.sr,
                            width: 640.wmax * 24.sr,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 640.wmax * 4.sr),
                          child: iconAvatar(opt.from.toLowerCase()),
                        ),
                        Text(
                          opt.from.tr,
                          style: TextStyle(
                            fontSize: 640.wmax * 16.sr,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff363853),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });

        return iterable.toList();
      }

      return withSplash(
        Container(
          color: Colors.white,
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            left: 640.wmax * 32.sr,
            right: 640.wmax * 32.sr,
          ),
          margin: EdgeInsets.only(
            bottom: 640.wmax * 42.sr,
          ),
          child: PopupMenuButton(
            elevation: 2.5,
            color: Colors.white,
            padding: EdgeInsets.zero,
            menuPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            position: PopupMenuPosition.under,
            shadowColor: Color(0x88000000),
            constraints: BoxConstraints(
              minWidth: 640.wmax * 311.sr,
              maxWidth: 640.wmax * 311.sr,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(640.wmax * 20.sr),
            ),
            offset: Offset(0, 640.wmax * 3.sr),
            onSelected: (id) => controller.find(id),
            itemBuilder: (BuildContext context) => itemBuilder(),
            child: Container(
              height: 640.wmax * 66.sr,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(640.wmax * 20.sr),
                color: Color(0xfff2f2f2),
              ),
              padding: EdgeInsets.only(
                top: 640.wmax * 20.sr,
                left: 640.wmax * 30.sr,
                right: 640.wmax * 24.sr,
                bottom: 640.wmax * 20.sr,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 640.wmax * 4.sr),
                          child: iconAvatar(isTopup ? from : to),
                        ),
                        Text(
                          isTopup ? from.tr : to.tr,
                          style: TextStyle(
                            fontSize: 640.wmax * 16.sr,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff363853),
                          ),
                        ),
                        Offstage(
                          offstage: !isTransfer || isSamePerson,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 640.wmax * 15.sr,
                                  right: 640.wmax * 15.sr,
                                ),
                                child: Image.asset(
                                  'lib/assets/images/operater/left.png',
                                  height: 640.wmax * 26.sr,
                                  width: 640.wmax * 24.sr,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  right: 640.wmax * 4.sr,
                                ),
                                child: iconAvatar(from.toLowerCase()),
                              ),
                              Text(
                                from.tr,
                                style: TextStyle(
                                  fontSize: 640.wmax * 16.sr,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xff363853),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      left: 640.wmax * 15.sr,
                      right: 640.wmax * 6.sr,
                    ),
                    child: Image.asset(
                      'lib/assets/images/operater/down.png',
                      height: 640.wmax * 24.sr,
                      width: 640.wmax * 24.sr,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildKeyboard(BuildContext context) {
    final addition = controller.addition;
    final delete = controller.delete;
    final clear = controller.clear;

    Widget buildKey(String text) {
      Widget? child;

      if (text != 'Delete' && text != 'Clear') {
        child = Text(
          text,
          style: TextStyle(
            fontSize: 640.wmax * 24.sr,
            fontWeight: FontWeight.w500,
            color: Color(0xff363853),
            height: 1.0,
          ),
        );
      }

      if (text == 'Delete') {
        child = Image.asset(
          'lib/assets/images/operater/delete.png',
          height: 640.wmax * 27.sr,
          width: 640.wmax * 25.sr,
          fit: BoxFit.fill,
        );
      }

      if (text == 'Clear') {
        child = Image.asset(
          'lib/assets/images/operater/clear.png',
          height: 640.wmax * 24.sr,
          width: 640.wmax * 24.sr,
          fit: BoxFit.fill,
        );
      }

      return Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: 100.0,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(640.wmax * 20.0.sr)),
          highlightColor: const Color(0xfff0f0f0).withOpacity(1),
          splashColor: const Color(0xfff0f0f0).withOpacity(1),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Container(
            width: 640.wmax * 60.sr,
            height: 640.wmax * 60.sr,
            alignment: Alignment.center,
            child: child,
          ),
          onTap: () {
            if (text == 'Delete') {
              delete(null);
              return;
            }

            if (text == 'Clear') {
              clear(null);
              return;
            }

            addition(text);
          },
        ),
      );
    }

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: 640.wmax * 32.sr,
        right: 640.wmax * 32.sr,
      ),
      margin: EdgeInsets.only(
        bottom: 640.wmax * 68.sr,
      ),
      child: SizedBox(
        width: 640.wmax * 250.sr,
        child: Column(
          children: [
            Container(
              width: 640.wmax * 250.sr,
              margin: EdgeInsets.only(bottom: 640.wmax * 20.sr),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildKey('1'),
                  buildKey('2'),
                  buildKey('3'),
                ],
              ),
            ),
            Container(
              width: 640.wmax * 250.sr,
              margin: EdgeInsets.only(bottom: 640.wmax * 20.sr),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildKey('4'),
                  buildKey('5'),
                  buildKey('6'),
                ],
              ),
            ),
            Container(
              width: 640.wmax * 250.sr,
              margin: EdgeInsets.only(bottom: 640.wmax * 30.sr),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildKey('7'),
                  buildKey('8'),
                  buildKey('9'),
                ],
              ),
            ),
            Container(
              width: 640.wmax * 250.sr,
              margin: EdgeInsets.only(bottom: 0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  buildKey('0'),
                  buildKey('Delete'),
                  buildKey('Clear'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildConfirmBtn(BuildContext context) {
    final mediaPadding = controller.mediaPadding.value;
    final mediaBottom = max(mediaPadding.bottom, 640.wmax * 30.sr);

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: 640.wmax * 32.sr,
        right: 640.wmax * 32.sr,
      ),
      margin: EdgeInsets.only(
        bottom: mediaBottom,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: 100.0,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(640.wmax * 20.0.sr)),
          highlightColor: const Color(0xff5b259f).withOpacity(1),
          splashColor: const Color(0xff5b259f).withOpacity(1),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Container(
            width: 640.wmax * 195.sr,
            height: 640.wmax * 65.sr,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(640.wmax * 15.sr),
              color: Color(0xff5b259f).withOpacity(0.85),
            ),
            child: Text(
              controller.type.tr,
              style: TextStyle(
                fontSize: 640.wmax * 20.sr,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          onTap: () {
            controller.pay();
          },
        ),
      ),
    );
  }
}
