import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/configure/image_picker.dart';
import 'package:dompet/configure/fluttertoast.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/mixins/watcher.dart';
import 'package:dompet/service/bind.dart';

class PageProfileController extends GetxController with RxWatcher {
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final storeController = Get.find<StoreController>();
  late final eventController = Get.find<EventController>();
  late final nameController = TextEditingController();

  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaTopBar = mediaQueryController.topBar;
  late final loginUser = storeController.user;

  late Rx<bool> readonly = true.obs;
  late FocusNode nameFocusNode = FocusNode();
  late Rx<Uint8List?> avatar;

  @override
  void onInit() {
    super.onInit();

    avatar = loginUser.avatar.value.obs;
    readonly = loginUser.name.value.bv.obs;
    nameController.text = loginUser.name.value;

    rxEver(loginUser.name, (_) => nameController.text = loginUser.name.value);
    rxEver(loginUser.name, (_) => readonly.value = loginUser.name.value.bv);
    rxEver(loginUser.avatar, (_) => avatar.value = loginUser.avatar.value);
  }

  @override
  void onClose() {
    super.onClose();
    rxOff();
  }

  Future<void> changeName() async {
    readonly.value = false;

    FocusScope.of(Get.context!).unfocus();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(Get.context!).requestFocus(nameFocusNode);
    });
  }

  Future<void> pickAvater() async {
    avatar.value = await MediaPicker.pickImage(source: ImageSource.gallery);
  }

  Future<void> updateUser() async {
    final oldName = loginUser.name.value;
    final oldAvatar = loginUser.avatar.value;
    final newUsername = nameController.text.trim();
    final userAvatar = avatar.value.bv ? avatar.value : oldAvatar;
    final userName = newUsername.isNotEmpty ? newUsername : oldName;

    if (userName != oldName || userAvatar != oldAvatar) {
      await eventController.updateUser(loginUser.value.from({
        'avatar': userAvatar,
        'name': userName,
      }));

      Toaster.success(
        message: 'Update user successfully!'.tr,
        duration: Duration(seconds: 1),
      );
    }

    if (Get.context != null) {
      FocusScope.of(Get.context!).unfocus();
    }
  }
}
