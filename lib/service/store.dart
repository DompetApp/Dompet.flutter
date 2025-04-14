import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:get_storage/get_storage.dart';
import 'package:dompet/models/message.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/models/order.dart';
import 'package:dompet/models/card.dart';
import 'package:dompet/models/user.dart';

class StoreController extends GetxService {
  Future<bool> get homeFuture => home.value.future;
  Future<bool> get readyFuture => ready.value.future;

  late final storager = GetStorage('dompet.store', null, {'expired': 0});
  late final logined = (storager.read<bool>('logined') == true).obs;
  late final expired = (storager.read<int>('expired') ?? 0).obs;
  late final today = DateTime.now().millisecondsSinceEpoch;
  late final ready = Completer<bool>().obs;
  late final home = Completer<bool>().obs;

  late final locale = Rx<Locale?>(null);
  late final messages = RxMessages.init();
  late final orders = RxOrders.init();
  late final user = RxUser.init();
  late final card = RxCard.init();

  @override
  onInit() {
    super.onInit();
    init();
  }

  // Auth / Locale
  Future<void> init() async {
    final language = storager.read<String>('locale');
    final languages = language?.split('_') ?? [];

    if (languages.length == 2) {
      locale.value = Locale(languages[0], languages[1]);
    }

    if (languages.length == 1) {
      locale.value = Locale(languages[0]);
    }

    if (logined.value) {
      logined.value = today < expired.value;
    }
  }

  Future<bool> login() async {
    final date = DateTime.now();
    final time = date.millisecondsSinceEpoch + 604800000;
    await storager.write('expired', time);
    await storager.write('logined', true);

    if (ready.value.isCompleted) {
      ready.value = Completer();
    }

    ready.value.complete(true);
    logined.value = true;
    expired.value = time;

    return readyFuture;
  }

  Future<bool> logout() async {
    final date = DateTime.now();
    final time = date.millisecondsSinceEpoch;
    await storager.write('logined', false);
    await storager.write('expired', time);

    if (ready.value.isCompleted) {
      ready.value = Completer();
    }

    if (home.value.isCompleted) {
      home.value = Completer();
    }

    ready.value.complete(false);
    logined.value = false;
    expired.value = time;

    return readyFuture;
  }

  Future<bool> visited() async {
    if (home.value.isCompleted) {
      home.value = Completer();
    }

    home.value.complete(true);

    return home.value.future;
  }

  Future<void> localer(Locale? locale) async {
    if (locale != null) await storager.write('locale', locale.toString());
    if (locale == null) await storager.remove('locale');

    if (!Get.isRegistered<LocaleController>()) {
      Get.put(LocaleController());
    }

    Get.find<LocaleController>().update(locale ?? Get.deviceLocale);

    this.locale.value = locale;
  }

  // Store business
  Future<void> storeMessages(List<Message> list) async {
    messages.change(list);
  }

  Future<void> storeOrders(List<Order> list) async {
    orders.change(list);
  }

  Future<void> storeCard(Card? card) async {
    if (card != null) {
      this.card.change(card);
    }
  }

  Future<void> storeUser(User? user) async {
    if (user != null) {
      this.user.change(user);
    }
  }

  // Clear business
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
