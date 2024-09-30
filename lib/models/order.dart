import 'package:get/get.dart';

class YearOrder {
  int year;
  double money;

  YearOrder({
    required this.year,
    required this.money,
  });
}

class RxOrders {
  Rx<List<Order>> list;

  RxOrders(List<Order>? list) : list = Rx(list ?? []);

  factory RxOrders.from(List<Map<String, dynamic>> maps) {
    final iterable = maps.map(
      (map) => Order(
        id: map['id'] ?? 0,
        icon: map['icon'] ?? '',
        name: map['name'] ?? '',
        type: map['type'] ?? '',
        date: map['date'] ?? '',
        money: map['money'] ?? 0.0,
      ),
    );

    return RxOrders(iterable.toList());
  }

  factory RxOrders.init() => RxOrders(null);

  RxOrders change(List<Order> list) {
    this.list.value = list;
    return this;
  }

  RxOrders clear() {
    list.value = [];
    return this;
  }
}

class Order {
  int id;
  String icon;
  String name;
  String type;
  String date;
  double money;

  Order({
    this.id = 0,
    required this.icon,
    required this.name,
    required this.type,
    required this.date,
    required this.money,
  });

  factory Order.from(Map<String, dynamic> map) {
    return Order(
      id: map['id'] ?? 0,
      icon: map['icon'] ?? '',
      name: map['name'] ?? '',
      type: map['type'] ?? '',
      date: map['date'] ?? '',
      money: map['money'] ?? 0.0,
    );
  }
}
