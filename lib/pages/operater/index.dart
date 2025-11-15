import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
export 'package:dompet/pages/operater/controller.dart';
import 'package:dompet/pages/operater/controller.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/money.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/size.dart';

class PageOperater extends GetView<PageOperaterController> {
  const PageOperater({super.key});

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

  Widget buildMoney(BuildContext context) {
    return Obx(
      () => Container(
        color: Colors.white,
        alignment: Alignment.center,
        margin: EdgeInsets.only(top: 130.vp, bottom: 44.vp),
        padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
        child: Text(
          controller.money.value.USD,
          style: TextStyle(
            color: const Color(0xff2f1155),
            fontWeight: FontWeight.bold,
            fontSize: 32.fp,
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
                width: 20.vp,
                height: 20.vp,
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
            width: 20.vp,
            height: 20.vp,
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
              width: 375.vp,
              height: 48.vp,
              padding: EdgeInsets.only(
                top: 12.vp,
                left: 30.vp,
                right: 24.vp,
                bottom: 12.vp,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 4.vp),
                    child: iconAvatar(isTopup ? opt.from : opt.to),
                  ),
                  Text(
                    isTopup ? opt.from.tr : opt.to.tr,
                    style: TextStyle(
                      color: Color(0xff363853),
                      fontWeight: FontWeight.w600,
                      fontSize: 16.fp,
                    ),
                  ),
                  Offstage(
                    offstage: !isTransfer || opt.from == opt.to,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 15.vp, right: 15.vp),
                          child: Image.asset(
                            'lib/assets/images/operater/left.png',
                            height: 26.vp,
                            width: 24.vp,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(right: 4.vp),
                          child: iconAvatar(opt.from.toLowerCase()),
                        ),
                        Text(
                          opt.from.tr,
                          style: TextStyle(
                            color: Color(0xff363853),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.fp,
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
          padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
          margin: EdgeInsets.only(bottom: 42.vp),
          child: PopupMenuButton(
            elevation: 2.5,
            color: Colors.white,
            padding: EdgeInsets.zero,
            menuPadding: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            position: PopupMenuPosition.under,
            shadowColor: Color(0x88000000),
            constraints: BoxConstraints(minWidth: 311.vp, maxWidth: 311.vp),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.vp),
            ),
            offset: Offset(0, 3.vp),
            onSelected: (id) => controller.find(id),
            itemBuilder: (BuildContext context) => itemBuilder(),
            child: Container(
              height: 66.vp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20.vp),
                color: Color(0xfff2f2f2),
              ),
              padding: EdgeInsets.only(
                top: 20.vp,
                left: 30.vp,
                right: 24.vp,
                bottom: 20.vp,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 4.vp),
                          child: iconAvatar(isTopup ? from : to),
                        ),
                        Text(
                          isTopup ? from.tr : to.tr,
                          style: TextStyle(
                            color: Color(0xff363853),
                            fontWeight: FontWeight.w600,
                            fontSize: 16.fp,
                          ),
                        ),
                        Offstage(
                          offstage: !isTransfer || isSamePerson,
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 15.vp,
                                  right: 15.vp,
                                ),
                                child: Image.asset(
                                  'lib/assets/images/operater/left.png',
                                  height: 26.vp,
                                  width: 24.vp,
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(right: 4.vp),
                                child: iconAvatar(from.toLowerCase()),
                              ),
                              Text(
                                from.tr,
                                style: TextStyle(
                                  color: Color(0xff363853),
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16.fp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 15.vp, right: 6.vp),
                    child: Image.asset(
                      'lib/assets/images/operater/down.png',
                      height: 24.vp,
                      width: 24.vp,
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
            color: Color(0xff363853),
            fontWeight: FontWeight.w500,
            fontSize: 24.fp,
            height: 1.0,
          ),
        );
      }

      if (text == 'Delete') {
        child = Image.asset(
          'lib/assets/images/operater/delete.png',
          height: 27.vp,
          width: 25.vp,
          fit: BoxFit.fill,
        );
      }

      if (text == 'Clear') {
        child = Image.asset(
          'lib/assets/images/operater/clear.png',
          height: 24.vp,
          width: 24.vp,
          fit: BoxFit.fill,
        );
      }

      return Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: 100.0,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(20.0.vp)),
          highlightColor: const Color(0xfff0f0f0).withValues(alpha: 1),
          splashColor: const Color(0xfff0f0f0).withValues(alpha: 1),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Container(
            width: 60.vp,
            height: 60.vp,
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
      padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
      margin: EdgeInsets.only(bottom: 68.vp),
      child: SizedBox(
        width: 250.vp,
        child: Column(
          children: [
            Container(
              width: 250.vp,
              margin: EdgeInsets.only(bottom: 20.vp),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [buildKey('1'), buildKey('2'), buildKey('3')],
              ),
            ),
            Container(
              width: 250.vp,
              margin: EdgeInsets.only(bottom: 20.vp),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [buildKey('4'), buildKey('5'), buildKey('6')],
              ),
            ),
            Container(
              width: 250.vp,
              margin: EdgeInsets.only(bottom: 30.vp),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [buildKey('7'), buildKey('8'), buildKey('9')],
              ),
            ),
            Container(
              width: 250.vp,
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
    final mediaBottom = max(mediaPadding.bottom, 30.vp);

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 32.vp, right: 32.vp),
      margin: EdgeInsets.only(bottom: mediaBottom),
      child: Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: 100.0,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(20.0.vp)),
          highlightColor: const Color(0xff5b259f).withValues(alpha: 1),
          splashColor: const Color(0xff5b259f).withValues(alpha: 1),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          child: Container(
            width: 195.vp,
            height: 65.vp,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.vp),
              color: Color(0xff5b259f).withValues(alpha: 0.85),
            ),
            child: Text(
              controller.type.tr,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 20.fp,
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
