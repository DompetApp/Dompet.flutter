import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/models/order.dart';

class PageStatsController extends GetxController {
  late final scrollController = ScrollController();
  late final storeController = Get.find<StoreController>();
  late final mediaQueryController = Get.find<MediaQueryController>();

  late final mediaPadding = mediaQueryController.viewPadding;
  late final isPortrait = mediaQueryController.isPortrait;
  late final bankOrders = storeController.orders;
  late final loginUser = storeController.user;
  late final bankCard = storeController.card;

  Rx<List<int>> years = Rx([]);
  Rx<List<int>> showings = Rx([]);
  Rx<List<double>> moneys = Rx([]);
  Rx<double> minMoney = double.infinity.obs;
  Rx<double> maxMoney = (-double.infinity).obs;
  Rx<bool> isShowTopBar = false.obs;

  @override
  void onInit() {
    super.onInit();

    scrollController.addListener(() {
      if (!scrollController.hasClients) {
        isShowTopBar.value = false;
        return;
      }

      final pixels = scrollController.position.pixels;
      final isMaxRange = pixels >= (640.wmax * 298.sr);
      isShowTopBar.value = isPortrait.value && isMaxRange;
    });

    ever(bankOrders.list, (_) {
      return transfer();
    });

    transfer();
  }

  void transfer() {
    double number = 0.0;
    List<YearOrder> groups = [];

    for (final order in bankOrders.list.value.reversed) {
      final date = DateTime.parse(order.date);
      final money = order.money;
      final year = date.year;

      number += money;

      final yearOrder = groups.firstWhereOrNull((order) {
        return order.year == year;
      });

      yearOrder == null
          ? groups.add(YearOrder(year: year, money: number))
          : yearOrder.money = number;
    }

    years.value = groups.map((order) => order.year).toList();
    moneys.value = groups.map((order) => order.money).toList();
    minMoney.value = moneys.value.reduce((a, b) => a < b ? a : b);
    maxMoney.value = moneys.value.reduce((a, b) => a > b ? a : b);
    showings.value = [years.value.length - 1];
  }
}
