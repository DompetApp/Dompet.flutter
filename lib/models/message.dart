import 'package:get/get.dart';

class GroupMessage {
  List<Message> messages;
  int year;

  GroupMessage({required this.messages, required this.year});
}

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
        isRead: map['is_read'] ?? map['isRead'] ?? 'N',
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
  String isRead;

  Message({
    this.id = 0,
    required this.type,
    required this.desc,
    required this.date,
    required this.money,
    this.isRead = 'N',
  });

  factory Message.from(Map<String, dynamic> map) {
    return Message(
      id: map['id'] ?? 0,
      type: map['type'] ?? '',
      desc: map['desc'] ?? '',
      date: map['date'] ?? '',
      money: map['money'] ?? 0.0,
      isRead: map['is_read'] ?? map['isRead'] ?? 'N',
    );
  }
}
