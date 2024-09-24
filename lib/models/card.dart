import 'package:get/get.dart';

class RxCard {
  Rx<int> id;
  Rx<String> cardNo;
  Rx<double> balance;
  Rx<String> cardType;
  Rx<String> bankName;
  Rx<String> expiryDate;
  Rx<String> status;

  RxCard(Card card)
      : id = card.id.obs,
        cardNo = card.cardNo.obs,
        balance = card.balance.obs,
        cardType = card.cardType.obs,
        bankName = card.bankName.obs,
        expiryDate = card.expiryDate.obs,
        status = card.status.obs;

  Card get value {
    return Card(
      id: id.value,
      cardNo: cardNo.value,
      balance: balance.value,
      cardType: cardType.value,
      bankName: bankName.value,
      expiryDate: expiryDate.value,
      status: status.value,
    );
  }

  factory RxCard.init() {
    return RxCard(Card());
  }

  factory RxCard.from(Map<String, dynamic> map) {
    return RxCard(
      Card(
        id: map['id'],
        cardNo: map['cardNo'],
        balance: map['balance'],
        cardType: map['cardType'],
        bankName: map['bankName'],
        expiryDate: map['expiryDate'],
        status: map['status'],
      ),
    );
  }

  RxCard from(Map<String, dynamic> map) {
    return RxCard(
      Card(
        id: map['id'] ?? id,
        cardNo: map['cardNo'] ?? cardNo,
        balance: map['balance'] ?? balance,
        cardType: map['cardType'] ?? cardType,
        bankName: map['bankName'] ?? bankName,
        expiryDate: map['expiryDate'] ?? expiryDate,
        status: map['status'] ?? status,
      ),
    );
  }

  RxCard change(Card card) {
    status.value = card.status;
    expiryDate.value = card.expiryDate;
    bankName.value = card.bankName;
    cardType.value = card.cardType;
    balance.value = card.balance;
    cardNo.value = card.cardNo;
    id.value = card.id;
    return this;
  }

  RxCard clear() {
    status.value = 'N';
    expiryDate.value = '';
    bankName.value = '';
    cardType.value = '';
    balance.value = 0.0;
    cardNo.value = '';
    id.value = 0;
    return this;
  }

  RxCard patch({
    int? id,
    String? cardNo,
    double? balance,
    String? cardType,
    String? bankName,
    String? expiryDate,
    String? status,
  }) {
    this.status.value = status ?? this.status.value;
    this.expiryDate.value = expiryDate ?? this.expiryDate.value;
    this.bankName.value = bankName ?? this.bankName.value;
    this.cardType.value = cardType ?? this.cardType.value;
    this.balance.value = balance ?? this.balance.value;
    this.cardNo.value = cardNo ?? this.cardNo.value;
    this.id.value = id ?? this.id.value;
    return this;
  }
}

class Card {
  int id;
  String cardNo;
  double balance;
  String cardType;
  String bankName;
  String expiryDate;
  String status;

  Card({
    this.id = 0,
    this.balance = 0.0,
    this.cardNo = '',
    this.cardType = '',
    this.bankName = '',
    this.expiryDate = '',
    this.status = 'Y',
  });

  factory Card.from(Map<String, dynamic> map) {
    return Card(
      id: map['id'] ?? 0,
      cardNo: map['cardNo'] ?? '',
      balance: map['balance'] ?? 0.0,
      cardType: map['cardType'] ?? '',
      bankName: map['bankName'] ?? '',
      expiryDate: map['expiryDate'] ?? '',
      status: map['status'] ?? 'Y',
    );
  }

  Card from(Map<String, dynamic> map) {
    return Card(
      id: map['id'] ?? id,
      cardNo: map['cardNo'] ?? cardNo,
      balance: map['balance'] ?? balance,
      cardType: map['cardType'] ?? cardType,
      bankName: map['bankName'] ?? bankName,
      expiryDate: map['expiryDate'] ?? expiryDate,
      status: map['status'] ?? status,
    );
  }

  Card change(Card card) {
    status = card.status;
    expiryDate = card.expiryDate;
    bankName = card.bankName;
    cardType = card.cardType;
    balance = card.balance;
    cardNo = card.cardNo;
    id = card.id;
    return this;
  }

  Card patch({
    int? id,
    String? cardNo,
    double? balance,
    String? cardType,
    String? bankName,
    String? expiryDate,
    String? status,
  }) {
    this.status = status ?? this.status;
    this.expiryDate = expiryDate ?? this.expiryDate;
    this.bankName = bankName ?? this.bankName;
    this.cardType = cardType ?? this.cardType;
    this.balance = balance ?? this.balance;
    this.cardNo = cardNo ?? this.cardNo;
    this.id = id ?? this.id;
    return this;
  }

  Card clear() {
    status = 'N';
    expiryDate = '';
    bankName = '';
    cardType = '';
    balance = 0.0;
    cardNo = '';
    id = 0;
    return this;
  }
}