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

class PageRegisterController extends GetxController {
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final sqliteController = Get.find<SqliteController>();
  late final eventController = Get.find<EventController>();
  late final passwordController2 = TextEditingController();
  late final passwordController1 = TextEditingController();
  late final emailController = TextEditingController();
  late final nameController = TextEditingController();

  late final signUpWithUserAccount = instance.createUserWithEmailAndPassword;
  late final signInWithCredential = instance.signInWithCredential;
  late final signInWithProvider = instance.signInWithProvider;
  late final instance = FirebaseAuth.instance;

  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaHeight = mediaQueryController.height;
  late final mediaWidth = mediaQueryController.width;

  FocusNode passwordFocusNode2 = FocusNode();
  FocusNode passwordFocusNode1 = FocusNode();
  FocusNode emailFocusNode = FocusNode();
  FocusNode nameFocusNode = FocusNode();

  Rx<bool> passwordError2 = false.obs;
  Rx<bool> passwordError1 = false.obs;
  Rx<bool> emailError = false.obs;
  Rx<bool> nameError = false.obs;
  Rx<bool> loading = false.obs;

  @override
  onClose() async {
    super.onClose();
    nameFocusNode.dispose();
    emailFocusNode.dispose();
    passwordFocusNode1.dispose();
    passwordFocusNode2.dispose();
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

  Future<void> signUpWithAccount() async {
    try {
      loading.value = true;

      String message = '';
      final name = nameController.value.text;
      final email = emailController.value.text;
      final password1 = passwordController1.value.text;
      final password2 = passwordController2.value.text;

      if (password2.trim() != password1.trim()) {
        message = 'The confirm password is incorrect!'.tr;
        passwordError2.value = true;
      }

      if (password1.trim().length < 6) {
        message = 'The password is less than 6 characters long!'.tr;
        passwordError1.value = true;
        passwordError2.value = true;
      }

      if (name.trim() == "") {
        message = 'The username is empty!'.tr;
        nameError.value = true;
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

      final credential = await signUpWithUserAccount(
        password: password1,
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

  Future<void> storeCredentialUser(UserCredential credential) async {
    if (credential.user == null) {
      Toaster.error(message: 'The credential user is empty!'.tr);
      return;
    }

    if (!credential.user!.email.bv) {
      Toaster.error(message: 'The credential user email address is empty!');
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
        ? Toaster.error(message: 'Failed to register user!'.tr)
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
