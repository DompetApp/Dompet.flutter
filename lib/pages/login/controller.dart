import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:dompet/configure/fluttertoast.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/routes/router.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/database/app.dart';
import 'package:dompet/models/user.dart';

class PageLoginController extends GetxController {
  late final emailController = TextEditingController().obs;
  late final passwordController = TextEditingController().obs;
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final sqliteController = Get.find<SqliteController>();
  late final storeController = Get.find<StoreController>();

  late final signInWithUserAccount = instance.signInWithEmailAndPassword;
  late final signInWithCredential = instance.signInWithCredential;
  late final signInWithProvider = instance.signInWithProvider;
  late final mediaPadding = mediaQueryController.padding;
  late final mediaHeight = mediaQueryController.height;
  late final mediaWidth = mediaQueryController.width;
  late final instance = FirebaseAuth.instance;

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
        message = 'The password address is empty!';
        emailError.value = true;
      }

      if (email.trim() == '') {
        message = 'The email is empty!';
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

  Future<void> storeCredentialUser(UserCredential credential) async {
    if (credential.user == null) {
      Toaster.error(message: 'The credential user is empty!');
      return;
    }

    if (!credential.user!.email.bv) {
      Toaster.error(message: 'The credential user email address is empty!');
      return;
    }

    final uid = await AppDatabaser.creatUser(
      User(
        uid: credential.user!.uid,
        email: credential.user!.email!,
        name: credential.user!.displayName ?? '',
        avatar: await fetchImageAsUint8List(credential.user!.photoURL),
      ),
    );

    final user = await AppDatabaser.queryUser(uid);

    if (user == null) {
      Toaster.error(message: 'Failed to login user!');
      return;
    }

    await sqliteController.initUserDatabase();
    await storeController.future;

    loading.value = false;

    GetRouter.login();
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
