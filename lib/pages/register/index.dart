import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
export 'package:dompet/pages/register/controller.dart';
import 'package:dompet/pages/register/controller.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/size.dart';

class PageRegister extends GetView<PageRegisterController> {
  const PageRegister({super.key});

  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsets.only(bottom: 50.vp),
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
          height: 36.vp,
          margin: EdgeInsets.only(top: max(top, 20.vp), left: 20.vp),
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
                      style: TextStyle(
                        color: Color(0xff707177),
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.5,
                        fontSize: 16.fp,
                      ),
                    ),
                  ),
                  const SizedBox(width: double.infinity, height: 80),
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
        bottom: 32.vp,
        right: 48.vp,
        left: 48.vp,
        top: orientation.value == Orientation.portrait ? 95.vp : 60.vp,
      ),
      child: Text(
        'Experience the convenience of handed trading'.tr,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: const Color(0xff2f1155),
          fontWeight: FontWeight.w700,
          fontFamily: 'PingFang',
          fontSize: 24.fp,
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
            top: 1.5.vp,
            left: 45.vp,
            right: 45.vp,
            bottom: 1.5.vp,
          ),
          child: Text(
            'Sign up with'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xffbdbdbd),
              fontWeight: FontWeight.w500,
              fontFamily: 'PingFang',
              fontSize: 13.fp,
              height: 1.2,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
            top: 22.vp,
            left: 28.vp,
            right: 28.vp,
            bottom: 38.vp,
          ),
          child: Wrap(
            spacing: 20.vp,
            runSpacing: 15.vp,
            children: [
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 18.vp,
                      horizontal: 20.vp,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15.vp),
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
                          width: 24.vp,
                          height: 24.vp,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 6.vp),
                        Text(
                          'Google',
                          style: TextStyle(
                            color: const Color(0xffbdbdbd),
                            fontWeight: FontWeight.w500,
                            fontSize: 16.fp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  loginTimeout(signInWithGoogle(), Duration(seconds: 30));
                },
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: IntrinsicWidth(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 18.vp,
                      horizontal: 20.vp,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xff4368c7),
                      borderRadius: BorderRadius.circular(15.vp),
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
                          width: 24.vp,
                          height: 24.vp,
                          fit: BoxFit.fill,
                        ),
                        SizedBox(width: 6.vp),
                        Text(
                          'Github',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                            fontSize: 16.fp,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                onTap: () {
                  loginTimeout(signInWithGithub(), Duration(seconds: 30));
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
          width: 310.vp,
          height: 54.vp,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 18.vp),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(15.vp),
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
            cursorWidth: 1.8.vp,
            cursorHeight: 18.vp,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Email'.tr,
              prefixIcon: Container(
                width: 64.vp,
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage('lib/assets/images/auth/email.png'),
                  width: 24.vp,
                  height: 24.vp,
                  fit: BoxFit.fill,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(
                letterSpacing: 1.5,
                color: const Color(0xff909399),
                fontWeight: FontWeight.w500,
                fontFamily: 'PingFang',
                fontSize: 16.fp,
              ),
            ),
            style: TextStyle(
              color: const Color(0xff606266),
              fontWeight: FontWeight.w500,
              fontFamily: 'PingFang',
              letterSpacing: 1.5,
              fontSize: 16.fp,
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
          width: 310.vp,
          height: 54.vp,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 18.vp),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(15.vp),
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
            cursorWidth: 1.8.vp,
            cursorHeight: 18.vp,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Username'.tr,
              prefixIcon: Container(
                width: 64.vp,
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage('lib/assets/images/auth/profile.png'),
                  width: 24.vp,
                  height: 24.vp,
                  fit: BoxFit.fill,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(
                color: const Color(0xff909399),
                fontWeight: FontWeight.w500,
                fontFamily: 'PingFang',
                letterSpacing: 1.5,
                fontSize: 16.fp,
              ),
            ),
            style: TextStyle(
              color: const Color(0xff606266),
              fontWeight: FontWeight.w500,
              fontFamily: 'PingFang',
              letterSpacing: 1.5,
              fontSize: 16.fp,
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
          width: 310.vp,
          height: 54.vp,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 18.vp),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(15.vp),
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
            cursorWidth: 1.8.vp,
            cursorHeight: 18.vp,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Password'.tr,
              prefixIcon: Container(
                width: 64.vp,
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage(
                    'lib/assets/images/auth/password.png',
                  ),
                  width: 24.vp,
                  height: 24.vp,
                  fit: BoxFit.fill,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(
                color: const Color(0xff909399),
                fontWeight: FontWeight.w500,
                fontFamily: 'PingFang',
                letterSpacing: 1.5,
                fontSize: 16.fp,
              ),
            ),
            style: TextStyle(
              color: const Color(0xff606266),
              fontWeight: FontWeight.w500,
              fontFamily: 'PingFang',
              letterSpacing: 1.5,
              fontSize: 16.fp,
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
          width: 310.vp,
          height: 54.vp,
          alignment: Alignment.center,
          margin: EdgeInsets.only(bottom: 18.vp),
          decoration: BoxDecoration(
            color: const Color(0xfff2f2f2),
            borderRadius: BorderRadius.circular(15.vp),
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
            cursorWidth: 1.8.vp,
            cursorHeight: 18.vp,
            keyboardType: TextInputType.text,
            textAlignVertical: TextAlignVertical.center,
            decoration: InputDecoration(
              filled: true,
              hintText: 'Confirm Password'.tr,
              prefixIcon: Container(
                width: 64.vp,
                alignment: Alignment.center,
                child: Image(
                  image: const AssetImage(
                    'lib/assets/images/auth/password.png',
                  ),
                  width: 24.vp,
                  height: 24.vp,
                  fit: BoxFit.fill,
                ),
              ),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              fillColor: Colors.transparent,
              hintStyle: TextStyle(
                color: const Color(0xff909399),
                fontWeight: FontWeight.w500,
                fontFamily: 'PingFang',
                letterSpacing: 1.5,
                fontSize: 16.fp,
              ),
            ),
            style: TextStyle(
              color: const Color(0xff606266),
              fontWeight: FontWeight.w500,
              fontFamily: 'PingFang',
              letterSpacing: 1.5,
              fontSize: 16.fp,
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
      height: 100.vp + mediaPadding.value.bottom,
      margin: EdgeInsets.only(top: 36.vp),
      alignment: Alignment.center,
      child: Column(
        children: [
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            child: Container(
              width: 200.vp,
              height: 64.vp,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color(0xff5b259f),
                borderRadius: BorderRadius.circular(15.vp),
              ),
              child: Text(
                'Register'.tr,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'PingFang',
                  letterSpacing: 1.2,
                  fontSize: 18.fp,
                ),
              ),
            ),
            onTap: () {
              loginTimeout(signUpWithAccount(), Duration(seconds: 5));
            },
          ),
          SizedBox(height: 12.vp),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'You have account？'.tr,
                  style: TextStyle(
                    color: const Color(0xffbdbdbd),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.fp,
                  ),
                ),
                TextSpan(
                  text: 'Login'.tr,
                  style: TextStyle(
                    color: const Color(0xff81c2ff),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.fp,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => GetNavigate.back(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
