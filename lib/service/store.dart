import 'dart:async';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/models/message.dart';
import 'package:dompet/models/order.dart';
import 'package:dompet/models/card.dart';
import 'package:dompet/models/user.dart';

class StoreController extends GetxService {
  late final ready = Completer<bool>().obs;
  late final today = DateTime.now().millisecondsSinceEpoch;
  late final storage = GetStorage('dompet.store', null, {'expired': 0});
  late final logined = (storage.read('logined') == true).obs;
  late final expired = storage.read('expired') as int?;

  Future<bool> get future => ready.value.future;

  late final messages = RxMessages.init();
  late final orders = RxOrders.init();
  late final user = RxUser.init();
  late final card = RxCard.init();

  @override
  onInit() async {
    super.onInit();

    if (logined.value) {
      logined.value = expired.bv && (today < expired!);
    }
  }

  Future<bool> login() async {
    final date = DateTime.now();
    final time = date.millisecondsSinceEpoch;
    await storage.write('expired', time + 604800000);
    await storage.write('logined', true);

    if (ready.value.isCompleted) {
      ready.value = Completer();
    }

    ready.value.complete(true);
    logined.value = true;

    return future;
  }

  Future<bool> logout() async {
    await storage.write('expired', DateTime.now().millisecondsSinceEpoch);
    await storage.write('logined', false);

    if (ready.value.isCompleted) {
      ready.value = Completer();
    }

    ready.value.complete(false);
    logined.value = false;

    return future;
  }

  // store
  Future<void> storeMessages(List<Message> list) async {
    messages.change(list);
  }

  Future<void> storeOrders(List<Order> list) async {
    orders.change(list);
  }

  Future<void> storeCard(Card card) async {
    this.card.change(card);
  }

  Future<void> storeUser(User user) async {
    this.user.change(user);
  }

  // clear
  Future<void> clearMessage() async {
    messages.clear();
  }

  Future<void> clearOrder() async {
    orders.clear();
  }

  Future<void> clearCard() async {
    card.clear();
  }

  Future<void> clearUser() async {
    user.clear();
  }
}
