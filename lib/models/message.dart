import 'package:get/get.dart';

class RxMessages {
  Rx<List<Message>> list;

  RxMessages(List<Message>? list) : list = Rx(list ?? []);

  factory RxMessages.from(List<Map<String, dynamic>> maps) {
    final iterable = maps.map(
      (map) => Message(
        id: map['id'] ?? 0,
        type: map['type'] ?? '',
        desc: map['desc'] ?? '',
        date: map['date'] ?? '',
        money: map['money'] ?? 0.0,
      ),
    );

    return RxMessages(iterable.toList());
  }

  factory RxMessages.init() => RxMessages(null);

  RxMessages change(List<Message> list) {
    this.list.value = list;
    return this;
  }

  RxMessages clear() {
    list.value = [];
    return this;
  }
}

class Message {
  int id;
  String type;
  String desc;
  String date;
  double money;

  Message({
    this.id = 0,
    required this.type,
    required this.desc,
    required this.date,
    required this.money,
  });

  factory Message.from(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? 0,
      type: map['type'] ?? '',
      desc: map['desc'] ?? '',
      date: map['date'] ?? '',
      money: map['money'] ?? 0.0,
    );
  }
}
