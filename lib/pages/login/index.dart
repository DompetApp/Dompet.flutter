import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/pages/login/controller.dart';
import 'package:dompet/routes/router.dart';

class PageLogin extends GetView<PageLoginController> {
  const PageLogin({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PageLoginController>()) {
      Get.put(PageLoginController());
    }

    return Obx(() {
      return GestureDetector(
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
            ],
          ),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
        ),
      );
    });
  }

  Widget buildLoading(BuildContext context) {
    return Obx(() {
      return Positioned(
        child: Offstage(
          offstage: !controller.loading.value,
          child: Container(
            constraints: const BoxConstraints.expand(),
            color: const Color(0xffffffff).withOpacity(0.8),
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
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: 640.wmax * 95.sr,
        left: 640.wmax * 48.sr,
        right: 640.wmax * 48.sr,
        bottom: 640.wmax * 32.sr,
      ),
      child: Column(
        children: [
          Text(
            'Welcome back'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 640.wmax * 24.sr,
              fontFamily: 'PingFang-Bold',
              color: const Color(0xff2f1155),
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
          Text(
            'Digital Wallet'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 640.wmax * 24.sr,
              fontFamily: 'PingFang-Bold',
              color: const Color(0xff2f1155),
              fontWeight: FontWeight.w700,
              height: 1.3,
            ),
          ),
        ],
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
            'Sign in with'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 640.wmax * 14.sr,
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
            runSpacing: 640.wmax * 18.sr,
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
                          color: Colors.black.withOpacity(0.1),
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
                        SizedBox(width: 640.wmax * 7.sr),
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
                          color: Colors.black.withOpacity(0.1),
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
                        SizedBox(width: 640.wmax * 9.sr),
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
    final emailFocusNode = controller.emailFocusNode;
    final passwordFocusNode = controller.passwordFocusNode;
    final passwordController = controller.passwordController;
    final emailController = controller.emailController;
    final passwordError = controller.passwordError;
    final emailError = controller.emailError;

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
              FocusScope.of(context).requestFocus(passwordFocusNode);
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
              color: passwordError.value
                  ? const Color(0xfff34d4d)
                  : const Color(0xfff2f2f2),
            ),
          ),
          child: TextField(
            obscureText: true,
            focusNode: passwordFocusNode,
            controller: passwordController,
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
              passwordError.value = false;
              emailError.value = emailController.text.trim() == '';
            },
          ),
        ),
      ],
    );
  }

  Widget buildFormButton(BuildContext context) {
    final loginTimeout = controller.loginTimeout;
    final mediaPadding = controller.mediaPadding;
    final signInWithAccount = controller.signInWithAccount;

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
                'Login'.tr,
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
                signInWithAccount(),
                Duration(seconds: 5),
              );
            },
          ),
          SizedBox(height: 640.wmax * 12.sr),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Don't have an account yet？".tr,
                  style: TextStyle(
                    fontSize: 640.wmax * 14.sr,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xffbdbdbd),
                  ),
                ),
                TextSpan(
                  text: 'Register'.tr,
                  style: TextStyle(
                    fontSize: 640.wmax * 14.sr,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff81c2ff),
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => GetRouter.toNamed(GetRoutes.register),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
