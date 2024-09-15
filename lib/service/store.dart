import 'dart:async';
import 'package:get/get.dart';
import 'package:dompet/models/user.dart';

class StoreController extends GetxService {
  final user = RxUser.init();
  final ready = Completer<bool>().obs;
  final login = false.obs;

  Future<void> storeUser(User? user) async {
    ready.value.complete(user != null);
    login.value = user != null;
    this.user.change(user);
  }

  Future<void> clearUser() async {
    ready.value = Completer();
    login.value = false;
    user.clear();
  }

  Future<bool> loginUser() async {
    return ready.value.future;
  }
}
