import 'package:get/get.dart';
import 'dart:typed_data';

class RxUser {
  Rx<String> uid;
  Rx<String> name;
  Rx<String> email;
  Rx<String> activate;
  Rx<String> createDate;
  Rx<Uint8List?> avatar;

  RxUser(User user)
      : uid = user.uid.obs,
        name = user.name.obs,
        email = user.email.obs,
        activate = user.activate.obs,
        createDate = user.createDate.obs,
        avatar = user.avatar.obs;

  User get value {
    return User(
      createDate: createDate.value,
      activate: activate.value,
      avatar: avatar.value,
      email: email.value,
      name: name.value,
      uid: uid.value,
    );
  }

  factory RxUser.init() {
    return RxUser(User());
  }

  factory RxUser.from(Map<String, dynamic> map) {
    return RxUser(
      User(
        uid: map['uid'],
        name: map['name'],
        email: map['email'],
        avatar: map['avatar'],
        activate: map['activate'],
        createDate: map['createDateid'],
      ),
    );
  }

  RxUser change(User? user) {
    createDate.value = user?.createDate ?? '';
    activate.value = user?.activate ?? '';
    avatar.value = user?.avatar;
    email.value = user?.email ?? '';
    name.value = user?.name ?? '';
    uid.value = user?.uid ?? '';
    return this;
  }

  RxUser clear() {
    createDate.value = '';
    activate.value = 'N';
    avatar.value = null;
    email.value = '';
    name.value = '';
    uid.value = '';
    return this;
  }

  RxUser patch({
    String? uid,
    String? name,
    String? email,
    String? password,
    String? activate,
    String? createDate,
    Uint8List? avatar,
  }) {
    this.createDate.value = createDate ?? this.createDate.value;
    this.activate.value = activate ?? this.activate.value;
    this.avatar.value = avatar ?? this.avatar.value;
    this.email.value = email ?? this.email.value;
    this.name.value = name ?? this.name.value;
    this.uid.value = uid ?? this.uid.value;
    return this;
  }
}

class User {
  String uid;
  String name;
  String email;
  String activate;
  String createDate;
  Uint8List? avatar;

  User({
    this.uid = '',
    this.name = '',
    this.email = '',
    this.avatar,
    this.activate = 'N',
    this.createDate = '',
  });

  factory User.from(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      avatar: map['avatar'],
      activate: map['activate'] ?? '',
      createDate: map['createDateid'] ?? '',
    );
  }

  User from(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? uid,
      name: map['name'] ?? name,
      email: map['email'] ?? email,
      avatar: map['avatar'] ?? avatar,
      activate: map['activate'] ?? activate,
      createDate: map['createDateid'] ?? createDate,
    );
  }

  User change(User? user) {
    createDate = user?.createDate ?? '';
    activate = user?.activate ?? 'N';
    avatar = user?.avatar;
    email = user?.email ?? '';
    name = user?.name ?? '';
    uid = user?.uid ?? '';
    return this;
  }

  User clear() {
    createDate = '';
    activate = 'N';
    avatar = null;
    email = '';
    name = '';
    uid = '';
    return this;
  }

  User patch({
    String? uid,
    String? name,
    String? email,
    String? password,
    String? activate,
    String? createDate,
    Uint8List? avatar,
  }) {
    this.createDate = createDate ?? this.createDate;
    this.activate = activate ?? this.activate;
    this.avatar = avatar ?? this.avatar;
    this.email = email ?? this.email;
    this.name = name ?? this.name;
    this.uid = uid ?? this.uid;
    return this;
  }
}
