import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
export 'package:dompet/pages/login/controller.dart';
import 'package:dompet/pages/login/controller.dart';
import 'package:dompet/routes/navigator.dart';
import 'package:dompet/extension/size.dart';

class PageLogin extends GetView<PageLoginController> {
  const PageLogin({super.key});

  @override
  Widget build(BuildContext context) {
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
                    padding: EdgeInsets.only(bottom: 50.vp),
                    physics: const ClampingScrollPhysics(),
                    children: [
                      buildMainTitle(context),
                      buildThirdAuth(context),
                      buildFormInput(context),
                      buildFormButton(context),
                      buildFormGuestor(context),
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
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: 95.vp,
        left: 48.vp,
        right: 48.vp,
        bottom: 32.vp,
      ),
      child: Column(
        children: [
          Text(
            'Welcome back'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xff2f1155),
              fontWeight: FontWeight.w700,
              fontFamily: 'PingFang',
              fontSize: 24.fp,
              height: 1.3,
            ),
          ),
          Text(
            'Digital Wallet'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xff2f1155),
              fontWeight: FontWeight.w700,
              fontFamily: 'PingFang',
              fontSize: 24.fp,
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
            top: 1.5.vp,
            left: 45.vp,
            right: 45.vp,
            bottom: 1.5.vp,
          ),
          child: Text(
            'Sign in with'.tr,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: const Color(0xffbdbdbd),
              fontWeight: FontWeight.w500,
              fontFamily: 'PingFang',
              fontSize: 14.fp,
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
            runSpacing: 18.vp,
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
                        SizedBox(width: 7.vp),
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
                        SizedBox(width: 9.vp),
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
    final emailFocusNode = controller.emailFocusNode;
    final passwordFocusNode = controller.passwordFocusNode;
    final passwordController = controller.passwordController;
    final emailController = controller.emailController;
    final passwordError = controller.passwordError;
    final emailError = controller.emailError;

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
              emailError.value = false;
            },
            onSubmitted: (v) {
              FocusScope.of(context).requestFocus(passwordFocusNode);
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
              color: passwordError.value
                  ? const Color(0xfff34d4d)
                  : const Color(0xfff2f2f2),
            ),
          ),
          child: TextField(
            obscureText: true,
            focusNode: passwordFocusNode,
            controller: passwordController,
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
    final signInWithAccount = controller.signInWithAccount;

    return Container(
      width: 100.vw,
      height: 100.vp,
      alignment: Alignment.center,
      margin: EdgeInsets.only(top: 36.vp),
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
                'Login'.tr,
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
              loginTimeout(signInWithAccount(), Duration(seconds: 5));
            },
          ),
          SizedBox(height: 12.vp),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Don't have an account yet？".tr,
                  style: TextStyle(
                    color: const Color(0xffbdbdbd),
                    fontWeight: FontWeight.w500,
                    fontSize: 14.fp,
                  ),
                ),
                TextSpan(
                  text: 'Register'.tr,
                  style: TextStyle(
                    color: const Color(0xff81c2ff),
                    fontWeight: FontWeight.w600,
                    fontSize: 14.fp,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => GetNavigate.toNamed(GetRoutes.register),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFormGuestor(BuildContext context) {
    Widget withInWell({required Widget child, dynamic onTap}) {
      return Material(
        color: Colors.transparent,
        child: InkResponse(
          radius: 180.0,
          containedInkWell: true,
          highlightShape: BoxShape.rectangle,
          borderRadius: BorderRadius.all(Radius.circular(30.0.vp)),
          highlightColor: const Color(0xff5b259f).withValues(alpha: 0.08),
          splashColor: const Color(0xff5b259f).withValues(alpha: 0.08),
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onTap: onTap,
          child: child,
        ),
      );
    }

    return Container(
      width: 100.vw,
      height: 40.vp + controller.mediaPadding.value.bottom,
      margin: EdgeInsets.only(top: 21.vp),
      alignment: Alignment.center,
      child: withInWell(
        child: Container(
          width: 160.vp,
          height: 40.vp,
          alignment: Alignment.center,
          child: Text(
            'Guest Mode'.tr,
            style: TextStyle(
              color: const Color(0xff909399),
              fontWeight: FontWeight.w500,
              fontSize: 14.fp,
            ),
          ),
        ),
        onTap: () {
          controller.signInWithGuestUser();
        },
      ),
    );
  }
}
