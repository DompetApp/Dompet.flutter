import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dompet/pages/register/controller.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/routes/router.dart';

class PageRegister extends GetView<PageRegisterController> {
  const PageRegister({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PageRegisterController>()) {
      Get.put(PageRegisterController());
    }

    return Obx(
      () => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        behavior: HitTestBehavior.opaque,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            alignment: AlignmentDirectional.topCenter,
            children: [
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  width: 640.wmax,
                  height: 100.vh,
                  child: ListView(
                    shrinkWrap: false,
                    padding: EdgeInsets.only(bottom: 50.wdp),
                    physics: const ClampingScrollPhysics(),
                    children: [
                      buildMainTitle(context),
                      buildThirdAuth(context),
                      buildFormInput(context),
                      buildFormButton(context),
                    ],
                  ),
                ),
              ),
              buildLoading(context),
              buildBack(context),
            ],
          ),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
        ),
      ),
    );
  }

  Widget buildBack(BuildContext context) {
    final mediaPadding = controller.mediaPadding;
    final top = mediaPadding.value.top;

    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Align(
        alignment: Alignment.topCenter,
        child: Container(
          width: 680.wmax,
          height: 640.wmax * 36.sr,
          margin: EdgeInsets.only(
            top: max(top, 640.wmax * 20.sr),
            left: 640.wmax * 20.sr,
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

  Widget buildLoading(BuildContext context) {
    return Obx(() {
      return Positioned(
        child: Offstage(
          offstage: !controller.loading.value,
          child: Container(
            constraints: const BoxConstraints.expand(),
            color: const Color(0xffffffff).withValues(alpha: 0.8),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    strokeWidth: 3.2,
                    color: const Color(0xff707177),
                    semanticsValue: 'Requesting...'.tr,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(30, 20, 30, 80),
                    child: Text(
                      'Requesting...'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        color: Color(0xff707177),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: double.infinity,
                    height: 80,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget buildMainTitle(BuildContext context) {
    final mediaQueryController = controller.mediaQueryController;
    final orientation = mediaQueryController.orientation;

    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        bottom: 640.wmax * 32.sr,
        right: 640.wmax * 48.sr,
        left: 640.wmax * 48.sr,
        top: orientation.value == Orientation.portrait
            ? 640.wmax * 95.sr
            : 640.wmax * 60.sr,
      ),
      child: Text(
        'Experience the convenience of handed trading'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 640.wmax * 24.sr,
          fontFamily: 'PingFang-Bold',
          color: const Color(0xff2f1155),
          fontWeight: FontWeight.w700,
          height: 1.2,
        ),
      ),
    );
  }

  Widget buildThirdAuth(BuildContext context) {
    final loginTimeout = controller.loginTimeout;
    final signInWithGoogle = controller.signInWithGoogle;
    final signInWithGithub = controller.signInWithGithub;

    return Column(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 640.wmax * 1.5.sr,
            left: 640.wmax * 45.sr,
            right: 640.wmax * 45.sr,
            bottom: 640.wmax * 1.5.sr,
          ),
          child: Text(
            'Sign up with'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 640.wmax * 13.sr,
              fontFamily: 'PingFang-Bold',
              color: const Color(0xffbdbdbd),
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 640.wmax * 22.sr,
            left: 640.wmax * 28.sr,
            right: 640.wmax * 28.sr,
            bottom: 640.wmax * 38.sr,
          ),
          child: Wrap(
            spacing: 640.wmax * 20.sr,
            runSpacing: 640.wmax * 15.sr,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 640.wmax * 18.sr,
                      horizontal: 640.wmax * 20.sr,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        640.wmax * 15.sr,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                            'lib/assets/images/auth/google.png',
                          ),
                          width: 640.wmax * 24.sr,
                          height: 640.wmax * 24.sr,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 640.wmax * 6.sr),
                        Text(
                          'Google',
                          style: TextStyle(
                            fontSize: 640.wmax * 16.sr,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xffbdbdbd),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  loginTimeout(
                    signInWithGoogle(),
                    Duration(seconds: 30),
                  );
                },
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 640.wmax * 18.sr,
                      horizontal: 640.wmax * 20.sr,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff4368c7),
                      borderRadius: BorderRadius.circular(
                        640.wmax * 15.sr,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          offset: const Offset(0, 2),
                          spreadRadius: 0,
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: const AssetImage(
                            'lib/assets/images/auth/github.png',
                          ),
                          width: 640.wmax * 24.sr,
                          height: 640.wmax * 24.sr,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 640.wmax * 6.sr),
                        Text(
                          'Github',
                          style: TextStyle(
                            fontSize: 640.wmax * 16.sr,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  loginTimeout(
                    signInWithGithub(),
                    Duration(seconds: 30),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFormInput(BuildContext context) {
    final nameFocusNode = controller.nameFocusNode;
    final emailFocusNode = controller.emailFocusNode;
    final passwordFocusNode1 = controller.passwordFocusNode1;
    final passwordFocusNode2 = controller.passwordFocusNode2;
    final passwordController1 = controller.passwordController1;
    final passwordController2 = controller.passwordController2;
    final emailController = controller.emailController;
    final nameController = controller.nameController;
    final passwordError1 = controller.passwordError1;
    final passwordError2 = controller.passwordError2;
    final emailError = controller.emailError;
    final nameError = controller.nameError;

    return Column(
      children: [
        Container(
          width: 640.wmax * 310.sr,
          height: 640.wmax * 54.sr,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 640.wmax * 18.sr),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(640.wmax * 15.sr),
            border: Border.all(
              width: 1,
              color: emailError.value
                  ? const Color(0xfff34d4d)
                  : const Color(0xfff2f2f2),
            ),
          ),
          child: TextField(
            focusNode: emailFocusNode,
            controller: emailController,
            cursorWidth: 640.wmax * 1.8.sr,
            cursorHeight: 640.wmax * 18.sr,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Email'.tr,
              prefixIcon: Container(
                width: 640.wmax * 64.sr,
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage(
                    'lib/assets/images/auth/email.png',
                  ),
                  width: 640.wmax * 24.sr,
                  height: 640.wmax * 24.sr,
                  fit: BoxFit.fill,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(
                letterSpacing: 1.5,
                fontSize: 640.wmax * 16.sr,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                color: const Color(0xff909399),
              ),
            ),
            style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 640.wmax * 16.sr,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w500,
              color: const Color(0xff606266),
            ),
            onChanged: (v) {
              emailError.value = false;
            },
            onSubmitted: (v) {
              FocusScope.of(context).requestFocus(nameFocusNode);
            },
          ),
        ),
        Container(
          width: 640.wmax * 310.sr,
          height: 640.wmax * 54.sr,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 640.wmax * 18.sr),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(640.wmax * 15.sr),
            border: Border.all(
              width: 1,
              color: nameError.value
                  ? const Color(0xfff34d4d)
                  : const Color(0xfff2f2f2),
            ),
          ),
          child: TextField(
            focusNode: nameFocusNode,
            controller: nameController,
            cursorWidth: 640.wmax * 1.8.sr,
            cursorHeight: 640.wmax * 18.sr,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Username'.tr,
              prefixIcon: Container(
                width: 640.wmax * 64.sr,
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage(
                    'lib/assets/images/auth/profile.png',
                  ),
                  width: 640.wmax * 24.sr,
                  height: 640.wmax * 24.sr,
                  fit: BoxFit.fill,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(
                letterSpacing: 1.5,
                fontSize: 640.wmax * 16.sr,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                color: const Color(0xff909399),
              ),
            ),
            style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 640.wmax * 16.sr,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w500,
              color: const Color(0xff606266),
            ),
            onChanged: (v) {
              nameError.value = false;
              emailError.value = emailController.text.trim() == '';
            },
            onSubmitted: (v) {
              FocusScope.of(context).requestFocus(passwordFocusNode1);
            },
          ),
        ),
        Container(
          width: 640.wmax * 310.sr,
          height: 640.wmax * 54.sr,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 640.wmax * 18.sr),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(640.wmax * 15.sr),
            border: Border.all(
              width: 1,
              color: passwordError1.value
                  ? const Color(0xfff34d4d)
                  : const Color(0xfff2f2f2),
            ),
          ),
          child: TextField(
            obscureText: true,
            focusNode: passwordFocusNode1,
            controller: passwordController1,
            cursorWidth: 640.wmax * 1.8.sr,
            cursorHeight: 640.wmax * 18.sr,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Password'.tr,
              prefixIcon: Container(
                width: 640.wmax * 64.sr,
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage(
                    'lib/assets/images/auth/password.png',
                  ),
                  width: 640.wmax * 24.sr,
                  height: 640.wmax * 24.sr,
                  fit: BoxFit.fill,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(
                letterSpacing: 1.5,
                fontSize: 640.wmax * 16.sr,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                color: const Color(0xff909399),
              ),
            ),
            style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 640.wmax * 16.sr,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w500,
              color: const Color(0xff606266),
            ),
            onChanged: (v) {
              passwordError1.value = false;
              nameError.value = nameController.text.trim() == '';
              emailError.value = emailController.text.trim() == '';
            },
            onSubmitted: (v) {
              FocusScope.of(context).requestFocus(passwordFocusNode2);
            },
          ),
        ),
        Container(
          width: 640.wmax * 310.sr,
          height: 640.wmax * 54.sr,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 640.wmax * 18.sr),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(640.wmax * 15.sr),
            border: Border.all(
              width: 1,
              color: passwordError2.value
                  ? const Color(0xfff34d4d)
                  : const Color(0xfff2f2f2),
            ),
          ),
          child: TextField(
            obscureText: true,
            focusNode: passwordFocusNode2,
            controller: passwordController2,
            cursorWidth: 640.wmax * 1.8.sr,
            cursorHeight: 640.wmax * 18.sr,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Confirm Password'.tr,
              prefixIcon: Container(
                width: 640.wmax * 64.sr,
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage(
                    'lib/assets/images/auth/password.png',
                  ),
                  width: 640.wmax * 24.sr,
                  height: 640.wmax * 24.sr,
                  fit: BoxFit.fill,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(
                letterSpacing: 1.5,
                fontSize: 640.wmax * 16.sr,
                fontFamily: 'PingFang SC',
                fontWeight: FontWeight.w500,
                color: const Color(0xff909399),
              ),
            ),
            style: TextStyle(
              letterSpacing: 1.5,
              fontSize: 640.wmax * 16.sr,
              fontFamily: 'PingFang SC',
              fontWeight: FontWeight.w500,
              color: const Color(0xff606266),
            ),
            onChanged: (v) {
              passwordError2.value = false;
              nameError.value = nameController.text.trim() == '';
              emailError.value = emailController.text.trim() == '';
              passwordError1.value = passwordController1.text.trim() == '';
            },
          ),
        ),
      ],
    );
  }

  Widget buildFormButton(BuildContext context) {
    final loginTimeout = controller.loginTimeout;
    final mediaPadding = controller.mediaPadding;
    final signUpWithAccount = controller.signUpWithAccount;

    return Container(
      width: 100.vw,
      height: 640.wmax * 100.sr + mediaPadding.value.bottom,
      margin: EdgeInsets.only(top: 640.wmax * 36.sr),
      alignment: Alignment.center,
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 640.wmax * 200.sr,
              height: 640.wmax * 64.sr,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xff5b259f),
                borderRadius: BorderRadius.circular(640.wmax * 15.sr),
              ),
              child: Text(
                'Register'.tr,
                style: TextStyle(
                  letterSpacing: 1.2,
                  color: Colors.white,
                  fontSize: 640.wmax * 18.sr,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PingFang',
                ),
              ),
            ),
            onTap: () {
              loginTimeout(
                signUpWithAccount(),
                Duration(seconds: 5),
              );
            },
          ),
          SizedBox(height: 640.wmax * 12.sr),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'You have account？'.tr,
                  style: TextStyle(
                    fontSize: 640.wmax * 14.sr,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffbdbdbd),
                  ),
                ),
                TextSpan(
                  text: 'Login'.tr,
                  style: TextStyle(
                    fontSize: 640.wmax * 14.sr,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff81c2ff),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => GetRouter.back(),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
