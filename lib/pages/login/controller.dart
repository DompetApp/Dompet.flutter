import 'dart:async';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dompet/configure/fluttertoast.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/models/user.dart';

class PageLoginController extends GetxController {
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final sqliteController = Get.find<SqliteController>();
  late final eventController = Get.find<EventController>();
  late final passwordController = TextEditingController();
  late final emailController = TextEditingController();

  late final signInWithUserAccount = instance.signInWithEmailAndPassword;
  late final signInWithCredential = instance.signInWithCredential;
  late final signInWithProvider = instance.signInWithProvider;
  late final instance = FirebaseAuth.instance;

  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaHeight = mediaQueryController.height;
  late final mediaWidth = mediaQueryController.width;

  FocusNode passwordFocusNode = FocusNode();
  FocusNode emailFocusNode = FocusNode();

  Rx<bool> passwordError = false.obs;
  Rx<bool> emailError = false.obs;
  Rx<bool> loading = false.obs;

  @override
  onClose() async {
    super.onClose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
  }

  Future<void> signInWithGoogle() async {
    try {
      loading.value = true;

      final googleUser = await GoogleSignIn().signIn();
      final googleAuth = await googleUser?.authentication;

      final authCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      final credential = await signInWithCredential(
        authCredential,
      );

      await storeCredentialUser(
        credential,
      );
    } on FirebaseAuthException catch (e) {
      Toaster.error(message: e.message);
    } catch (e) {
      Toaster.error(message: e.toString());
    }

    loading.value = false;
  }

  Future<void> signInWithGithub() async {
    try {
      loading.value = true;

      final githubProvider = GithubAuthProvider();
      final userCredential = await signInWithProvider(githubProvider);

      await storeCredentialUser(
        userCredential,
      );
    } on FirebaseAuthException catch (e) {
      Toaster.error(message: e.message);
    } catch (e) {
      Toaster.error(message: e.toString());
    }

    loading.value = false;
  }

  Future<void> signInWithAccount() async {
    try {
      loading.value = true;

      String message = '';
      final email = emailController.value.text;
      final password = passwordController.value.text;

      if (password.trim() == '') {
        message = 'The password is empty!'.tr;
        emailError.value = true;
      }

      if (email.trim() == '') {
        message = 'The email is empty!'.tr;
        emailError.value = true;
      }

      if (message != '') {
        Toaster.error(message: message);
        loading.value = false;
        return;
      }

      final credential = await signInWithUserAccount(
        password: password,
        email: email,
      );

      await storeCredentialUser(
        credential,
      );
    } on FirebaseAuthException catch (e) {
      Toaster.error(message: e.message);
    } catch (e) {
      Toaster.error(message: e.toString());
    }

    loading.value = false;
  }

  Future<void> signInWithGuestUser() async {
    loading.value = true;

    await Future.delayed(Duration(milliseconds: 1500));

    final user = await eventController.createUser(
      User(
        uid: 'guest-user-uid',
        email: 'tester@dompet.com',
        name: 'tester',
        avatar: null,
      ),
    );

    if (user == null) {
      loading.value = false;
      Toaster.error(message: 'Failed to login user!'.tr);
    }

    if (user != null) {
      Future.delayed(300.milliseconds, () => loading.value = false);
      eventController.login();
    }
  }

  Future<void> storeCredentialUser(UserCredential credential) async {
    if (credential.user == null) {
      Toaster.error(message: 'The credential user is empty!'.tr);
      return;
    }

    if (!credential.user!.email.bv) {
      Toaster.error(message: 'The credential user email address is empty!'.tr);
      return;
    }

    final user = await eventController.createUser(
      User(
        uid: credential.user!.uid,
        email: credential.user!.email!,
        name: credential.user!.displayName ?? '',
        avatar: await fetchImageAsUint8List(credential.user!.photoURL),
      ),
    );

    return user == null
        ? Toaster.error(message: 'Failed to login user!'.tr)
        : eventController.login();
  }

  Future<void> registerTimeout(Future future, Duration duration) async {
    try {
      await future.timeout(duration, onTimeout: () {
        throw TimeoutException("Registration request timed out!".tr);
      });
    } on TimeoutException catch (e) {
      Toaster.error(message: e.message);
      loading.value = false;
    } catch (e) {
      Toaster.error(message: e.toString());
      loading.value = false;
    }
  }

  Future<void> loginTimeout(Future future, Duration duration) async {
    try {
      await future.timeout(duration, onTimeout: () {
        throw TimeoutException("Login request timed out!".tr);
      });
    } on TimeoutException catch (e) {
      Toaster.error(message: e.message);
      loading.value = false;
    } catch (e) {
      Toaster.error(message: e.toString());
      loading.value = false;
    }
  }

  Future<Uint8List?> fetchImageAsUint8List(String? imageUrl) async {
    if (!imageUrl.bv) {
      return null;
    }

    try {
      final dio = Dio();
      final options = Options(responseType: ResponseType.bytes);
      final response = await dio.get(imageUrl!, options: options);
      return Uint8List.fromList(response.data);
    } catch (e) {
      return null;
    }
  }
}
