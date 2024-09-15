import 'package:get/get.dart';
import 'dart:typed_data';

class RxUser {
  Rx<int?> id;
  Rx<String> key;
  Rx<String> name;
  Rx<String> email;
  Rx<String> password;
  Rx<String> activate;
  Rx<String> createDate;
  Rx<Uint8List?> avatar;

  RxUser(User user)
      : id = user.id.obs,
        key = user.key.obs,
        name = user.name.obs,
        email = user.email.obs,
        password = user.password.obs,
        activate = user.activate.obs,
        createDate = user.createDate.obs,
        avatar = user.avatar.obs;

  User get value {
    return User(
      createDate: createDate.value,
      activate: activate.value,
      password: password.value,
      avatar: avatar.value,
      email: email.value,
      name: name.value,
      key: key.value,
      id: id.value,
    );
  }

  factory RxUser.init() {
    return RxUser(User());
  }

  factory RxUser.from(Map<String, dynamic> map) {
    return RxUser(
      User(
        id: map['id'],
        key: map['key'],
        name: map['name'],
        email: map['email'],
        avatar: map['avatar'],
        password: map['password'],
        activate: map['activate'],
        createDate: map['createDateid'],
      ),
    );
  }

  RxUser change(User? user) {
    createDate.value = user?.createDate ?? '';
    activate.value = user?.activate ?? '';
    password.value = user?.password ?? '';
    avatar.value = user?.avatar;
    email.value = user?.email ?? '';
    name.value = user?.name ?? '';
    key.value = user?.key ?? '';
    id.value = user?.id;
    return this;
  }

  RxUser clear() {
    createDate.value = '';
    activate.value = 'N';
    password.value = '';
    avatar.value = null;
    email.value = '';
    name.value = '';
    key.value = '';
    id.value = null;
    return this;
  }

  RxUser patch({
    String? key,
    String? name,
    String? email,
    String? password,
    String? activate,
    String? createDate,
    Uint8List? avatar,
  }) {
    this.createDate.value = createDate ?? this.createDate.value;
    this.activate.value = activate ?? this.activate.value;
    this.password.value = password ?? this.password.value;
    this.avatar.value = avatar ?? this.avatar.value;
    this.email.value = email ?? this.email.value;
    this.name.value = name ?? this.name.value;
    this.key.value = key ?? this.key.value;
    return this;
  }
}

class User {
  int? id;
  String key;
  String name;
  String email;
  String password;
  String activate;
  String createDate;
  Uint8List? avatar;

  User({
    this.id,
    this.key = '',
    this.name = '',
    this.email = '',
    this.avatar,
    this.password = '',
    this.activate = 'N',
    this.createDate = '',
  });

  factory User.from(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      key: map['key'],
      name: map['name'],
      email: map['email'],
      avatar: map['avatar'],
      password: map['password'],
      activate: map['activate'],
      createDate: map['createDateid'],
    );
  }

  User change(User? user) {
    createDate = user?.createDate ?? '';
    activate = user?.activate ?? 'N';
    password = user?.password ?? '';
    avatar = user?.avatar;
    email = user?.email ?? '';
    name = user?.name ?? '';
    key = user?.key ?? '';
    id = user?.id;
    return this;
  }

  User clear() {
    createDate = '';
    activate = 'N';
    password = '';
    avatar = null;
    email = '';
    name = '';
    key = '';
    id = null;
    return this;
  }

  User patch({
    String? key,
    String? name,
    String? email,
    String? password,
    String? activate,
    String? createDate,
    Uint8List? avatar,
  }) {
    this.createDate = createDate ?? this.createDate;
    this.activate = activate ?? this.activate;
    this.password = password ?? this.password;
    this.avatar = avatar ?? this.avatar;
    this.email = email ?? this.email;
    this.name = name ?? this.name;
    this.key = key ?? this.key;
    return this;
  }
}
