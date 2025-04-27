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
      avatar = Rx<Uint8List?>(user.avatar);

  User get value {
    return User(
      avatar: avatar.value,
      createDate: createDate.value,
      activate: activate.value,
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
        activate: map['activate'],
        createDate: map['createDate'],
        avatar: map['avatar'],
      ),
    );
  }

  RxUser change(User user) {
    avatar.value = user.avatar;
    createDate.value = user.createDate;
    activate.value = user.activate;
    email.value = user.email;
    name.value = user.name;
    uid.value = user.uid;
    return this;
  }

  RxUser patch({
    String? uid,
    String? name,
    String? email,
    String? activate,
    String? createDate,
    Uint8List? avatar,
  }) {
    this.avatar.value = avatar ?? this.avatar.value;
    this.createDate.value = createDate ?? this.createDate.value;
    this.activate.value = activate ?? this.activate.value;
    this.email.value = email ?? this.email.value;
    this.name.value = name ?? this.name.value;
    this.uid.value = uid ?? this.uid.value;
    return this;
  }

  RxUser clear() {
    avatar.value = null;
    createDate.value = '';
    activate.value = 'N';
    email.value = '';
    name.value = '';
    uid.value = '';
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
    this.activate = 'N',
    this.createDate = '',
    this.avatar,
  });

  factory User.from(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      activate: map['activate'] ?? '',
      createDate: map['createDate'] ?? '',
      avatar: map['avatar'],
    );
  }

  User from(Map<String, dynamic> map) {
    return User(
      uid: map['uid'] ?? uid,
      name: map['name'] ?? name,
      email: map['email'] ?? email,
      activate: map['activate'] ?? activate,
      createDate: map['createDate'] ?? createDate,
      avatar: map['avatar'] ?? avatar,
    );
  }

  User change(User user) {
    avatar = user.avatar;
    createDate = user.createDate;
    activate = user.activate;
    email = user.email;
    name = user.name;
    uid = user.uid;
    return this;
  }

  User patch({
    String? uid,
    String? name,
    String? email,
    String? activate,
    String? createDate,
    Uint8List? avatar,
  }) {
    this.avatar = avatar ?? this.avatar;
    this.createDate = createDate ?? this.createDate;
    this.activate = activate ?? this.activate;
    this.email = email ?? this.email;
    this.name = name ?? this.name;
    this.uid = uid ?? this.uid;
    return this;
  }

  User clear() {
    avatar = null;
    createDate = '';
    activate = 'N';
    email = '';
    name = '';
    uid = '';
    return this;
  }
}
