import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
export 'package:dompet/pages/profile/controller.dart';
import 'package:dompet/pages/profile/controller.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/date.dart';
import 'package:dompet/extension/size.dart';

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

  Widget buildAvatar(BuildContext context) {
    final loginUser = controller.loginUser;
    final userAvatar = loginUser.avatar;

    if (controller.avatar.value.bv) {
      return Image.memory(
        controller.avatar.value!,
        width: 96.vp,
        height: 96.vp,
        fit: BoxFit.fill,
      );
    }

    if (userAvatar.value.bv) {
      return Image.memory(
        userAvatar.value!,
        width: 96.vp,
        height: 96.vp,
        fit: BoxFit.fill,
      );
    }

    return Image.asset(
      'lib/assets/images/home/avatar.png',
      width: 96.vp,
      height: 96.vp,
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
      padding: EdgeInsets.only(left: 30.vp, right: 30.vp),
      margin: EdgeInsets.only(top: 110.vp, bottom: 18.vp),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 10.vp),
            child: ClipOval(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () => controller.pickAvatar(),
                child: Container(
                  width: 96.vp,
                  height: 96.vp,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(48.vp)),
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
                          width: 96.vp,
                          height: 24.vp,
                          alignment: Alignment.center,
                          padding: EdgeInsets.only(bottom: 3.vp),
                          color: Color(0xff2f1155).withValues(alpha: 0.75),
                          child: Text(
                            'change'.tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              letterSpacing: 1.0,
                              fontSize: 12.fp,
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
            padding: EdgeInsets.only(bottom: 30.vp),
            child: IntrinsicWidth(
              child: TextField(
                readOnly: readonly.value,
                focusNode: nameFocusNode,
                controller: nameController,
                cursorWidth: 1.8.vp,
                cursorHeight: 18.vp,
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
                      width: 42.vp,
                      height: 42.vp,
                      alignment: Alignment.center,
                      child: Image.asset(
                        'lib/assets/images/profile/edit.png'.tr,
                        height: 22.vp,
                        width: 22.vp,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: const Color(0xff9f9f9f),
                    fontWeight: FontWeight.w400,
                    fontFamily: 'PingFang',
                    fontSize: 20.fp,
                  ),
                  hintText: nameController.text.isEmpty
                      ? 'please enter your name...'.tr
                      : null,
                ),
                style: TextStyle(
                  color: const Color(0xff130138),
                  fontWeight: FontWeight.w600,
                  fontFamily: 'PingFang',
                  fontSize: 22.fp,
                ),
              ),
            ),
          ),
          IntrinsicWidth(
            child: Container(
              constraints: BoxConstraints(minWidth: 240.vp, minHeight: 44.vp),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 10.vp),
                    constraints: BoxConstraints(minHeight: 30.vp),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 56.vp,
                          child: Text(
                            'Email:'.tr,
                            style: TextStyle(
                              color: Color(0xff130138),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.fp,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            loginUser.email.value,
                            style: TextStyle(
                              color: Color(0xff303133),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.fp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 10.vp),
                    constraints: BoxConstraints(minHeight: 30.vp),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 56.vp,
                          child: Text(
                            'Date:'.tr,
                            style: TextStyle(
                              color: Color(0xff130138),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.fp,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            loginUser.createDate.value.yMMMd(),
                            style: TextStyle(
                              color: Color(0xff303133),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.fp,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    margin: EdgeInsets.only(bottom: 10.vp),
                    constraints: BoxConstraints(minHeight: 30.vp),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: 56.vp,
                          child: Text(
                            'State:'.tr,
                            style: TextStyle(
                              color: Color(0xff130138),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.fp,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            loginUser.activate.value != 'Y'
                                ? 'unavailable'.tr
                                : 'available'.tr,
                            style: TextStyle(
                              color: Color(0xff303133),
                              fontWeight: FontWeight.w600,
                              fontSize: 16.fp,
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
      margin: EdgeInsets.only(top: 42.vp),
      child: IntrinsicWidth(
        child: withInWell(
          onTap: () => updateUser(),
          child: Container(
            color: Colors.transparent,
            alignment: Alignment.center,
            constraints: BoxConstraints(minWidth: 160.vp),
            padding: EdgeInsets.symmetric(vertical: 15.vp, horizontal: 18.vp),
            child: Text(
              'Update'.tr,
              style: TextStyle(
                color: const Color(0xff5b259f),
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontSize: 18.fp,
                height: 1.2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
