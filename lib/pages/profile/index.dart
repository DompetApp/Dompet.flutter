import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
export 'package:dompet/pages/profile/controller.dart';
import 'package:dompet/pages/profile/controller.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/date.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/routes/router.dart';

class PageProfile extends GetView<PageProfileController> {
  const PageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
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
                    children: [buildProfile(context), buildUpdateBtn(context)],
                  ),
                ),
              ),
              buildBack(context),
            ],
          ),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
        ),
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

  Widget buildAvatar(BuildContext context) {
    final loginUser = controller.loginUser;
    final userAvatar = loginUser.avatar;

    if (controller.avatar.value.bv) {
      return Image.memory(
        controller.avatar.value!,
        width: 640.wmax * 96.sr,
        height: 640.wmax * 96.sr,
        fit: BoxFit.fill,
      );
    }

    if (userAvatar.value.bv) {
      return Image.memory(
        userAvatar.value!,
        width: 640.wmax * 96.sr,
        height: 640.wmax * 96.sr,
        fit: BoxFit.fill,
      );
    }

    return Image.asset(
      'lib/assets/images/home/avatar.png',
      width: 640.wmax * 96.sr,
      height: 640.wmax * 96.sr,
      fit: BoxFit.fill,
    );
  }

  Widget buildProfile(BuildContext context) {
    final nameController = controller.nameController;
    final nameFocusNode = controller.nameFocusNode;
    final loginUser = controller.loginUser;
    final readonly = controller.readonly;

    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: 640.wmax * 30.sr, right: 640.wmax * 30.sr),
      margin: EdgeInsets.only(top: 640.wmax * 110.sr, bottom: 640.wmax * 18.sr),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 640.wmax * 10.sr),
            child: ClipOval(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.pickAvatar(),
                child: Container(
                  width: 640.wmax * 96.sr,
                  height: 640.wmax * 96.sr,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(640.wmax * 48.sr),
                    ),
                    color: Color(0xffeae9e5).withValues(alpha: 0.85),
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      buildAvatar(context),
                      Positioned(
                        left: 0,
                        bottom: 0,
                        child: Container(
                          width: 640.wmax * 96.sr,
                          height: 640.wmax * 24.sr,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: 640.wmax * 3.sr),
                          color: Color(0xff2f1155).withValues(alpha: 0.75),
                          child: Text(
                            'change'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 12.sr,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              letterSpacing: 1.0,
                              height: 1,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 640.wmax * 30.sr),
            child: IntrinsicWidth(
              child: TextField(
                readOnly: readonly.value,
                focusNode: nameFocusNode,
                controller: nameController,
                cursorWidth: 640.wmax * 1.8.sr,
                cursorHeight: 640.wmax * 18.sr,
                keyboardType: TextInputType.text,
                textAlignVertical: TextAlignVertical.center,
                decoration: InputDecoration(
                  filled: true,
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  fillColor: Colors.transparent,
                  suffixIcon: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: () => controller.changeName(),
                    child: Container(
                      width: 640.wmax * 42.sr,
                      height: 640.wmax * 42.sr,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'lib/assets/images/profile/edit.png'.tr,
                        height: 640.wmax * 22.sr,
                        width: 640.wmax * 22.sr,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  hintStyle: TextStyle(
                    fontSize: 640.wmax * 20.sr,
                    fontFamily: 'PingFang',
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff9f9f9f),
                  ),
                  hintText: nameController.text.isEmpty
                      ? 'please enter your name...'.tr
                      : null,
                ),
                style: TextStyle(
                  fontSize: 640.wmax * 22.sr,
                  fontFamily: 'PingFang',
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff130138),
                ),
              ),
            ),
          ),
          IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(
                minWidth: 640.wmax * 240.sr,
                minHeight: 640.wmax * 44.sr,
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 640.wmax * 10.sr),
                    constraints: BoxConstraints(minHeight: 640.wmax * 30.sr),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 640.wmax * 56.sr,
                          child: Text(
                            'Email:'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff130138),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            loginUser.email.value,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff303133),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 640.wmax * 10.sr),
                    constraints: BoxConstraints(minHeight: 640.wmax * 30.sr),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 640.wmax * 56.sr,
                          child: Text(
                            'Date:'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff130138),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            loginUser.createDate.value.yMMMd(),
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff303133),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 640.wmax * 10.sr),
                    constraints: BoxConstraints(minHeight: 640.wmax * 30.sr),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 640.wmax * 56.sr,
                          child: Text(
                            'State:'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff130138),
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            loginUser.activate.value != 'Y'
                                ? 'unavailable'.tr
                                : 'available'.tr,
                            style: TextStyle(
                              fontSize: 640.wmax * 16.sr,
                              fontWeight: FontWeight.w600,
                              color: Color(0xff303133),
                            ),
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

  Widget buildUpdateBtn(BuildContext context) {
    final updateUser = controller.updateUser;
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
      margin: EdgeInsets.only(top: 640.wmax * 42.sr),
      child: IntrinsicWidth(
        child: withInWell(
          onTap: () => updateUser(),
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            constraints: BoxConstraints(minWidth: 640.wmax * 160.sr),
            padding: EdgeInsets.symmetric(
              vertical: 640.wmax * 15.sr,
              horizontal: 640.wmax * 18.sr,
            ),
            child: Text(
              'Update'.tr,
              style: TextStyle(
                fontSize: 640.wmax * 18.sr,
                fontWeight: FontWeight.bold,
                color: const Color(0xff5b259f),
                letterSpacing: 1.2,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
