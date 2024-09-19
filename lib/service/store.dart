import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/models/user.dart';

class StoreController extends GetxService {
  late final user = RxUser.init();
  late final ready = Completer<bool>().obs;
  late final weeks = 7 * 24 * 60 * 60 * 1000;
  late final today = DateTime.now().millisecondsSinceEpoch;
  late final storage = GetStorage('dompet.store', null, {'expired': 0});
  late final logined = (storage.read('logined') == true).obs;
  late final expired = storage.read('expired') as int?;

  @override
  onInit() async {
    super.onInit();

    if (logined.value) {
      logined.value = expired.bv && (today < expired!);
    }
  }

  Future<bool> get future => ready.value.future;

  Future<void> createUser(User? any) async {
    if (any == null) {
      deleteUser();
      return;
    }

    if (ready.value.isCompleted) {
      ready.value = Completer();
    }

    user.change(any);
    storage.write('expired', DateTime.now().millisecondsSinceEpoch + weeks);
    storage.write('logined', true);
    ready.value.complete(true);
    logined.value = true;
  }

  Future<void> deleteUser() async {
    if (ready.value.isCompleted) {
      ready.value = Completer();
    }

    user.clear();
    storage.write('expired', DateTime.now().millisecondsSinceEpoch);
    storage.write('logined', false);
    ready.value.complete(false);
    logined.value = false;
  }
}
