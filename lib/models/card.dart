import 'package:get/get.dart';

class RxCard {
  Rx<int> id;
  Rx<String> cardNo;
  Rx<String> cardType;
  Rx<String> bankName;
  Rx<String> expiryDate;
  Rx<double> balance;
  Rx<String> status;

  RxCard(Card card)
      : id = card.id.obs,
        cardNo = card.cardNo.obs,
        cardType = card.cardType.obs,
        bankName = card.bankName.obs,
        expiryDate = card.expiryDate.obs,
        balance = card.balance.obs,
        status = card.status.obs;

  Card get value {
    return Card(
      id: id.value,
      cardNo: cardNo.value,
      cardType: cardType.value,
      bankName: bankName.value,
      expiryDate: expiryDate.value,
      balance: balance.value,
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
        cardNo: map['card_no'] ?? map['cardNo'],
        cardType: map['card_type'] ?? map['cardType'],
        bankName: map['bank_name'] ?? map['bankName'],
        expiryDate: map['expiry_date'] ?? map['expiryDate'],
        balance: map['balance'],
        status: map['status'],
      ),
    );
  }

  RxCard from(Map<String, dynamic> map) {
    return RxCard(
      Card(
        id: map['id'] ?? id,
        cardNo: map['card_no'] ?? map['cardNo'] ?? cardNo,
        cardType: map['card_type'] ?? map['cardType'] ?? cardType,
        bankName: map['bank_name'] ?? map['bankName'] ?? bankName,
        expiryDate: map['expiry_date'] ?? map['expiryDate'] ?? expiryDate,
        balance: map['balance'] ?? balance,
        status: map['status'] ?? status,
      ),
    );
  }

  RxCard change(Card card) {
    status.value = card.status;
    balance.value = card.balance;
    expiryDate.value = card.expiryDate;
    bankName.value = card.bankName;
    cardType.value = card.cardType;
    cardNo.value = card.cardNo;
    id.value = card.id;
    return this;
  }

  RxCard clear() {
    status.value = 'N';
    balance.value = 0.0;
    expiryDate.value = '';
    bankName.value = '';
    cardType.value = '';
    cardNo.value = '';
    id.value = 0;
    return this;
  }

  RxCard patch({
    int? id,
    String? cardNo,
    String? cardType,
    String? bankName,
    String? expiryDate,
    double? balance,
    String? status,
  }) {
    this.status.value = status ?? this.status.value;
    this.balance.value = balance ?? this.balance.value;
    this.expiryDate.value = expiryDate ?? this.expiryDate.value;
    this.bankName.value = bankName ?? this.bankName.value;
    this.cardType.value = cardType ?? this.cardType.value;
    this.cardNo.value = cardNo ?? this.cardNo.value;
    this.id.value = id ?? this.id.value;
    return this;
  }
}

class Card {
  int id;
  String cardNo;
  String cardType;
  String bankName;
  String expiryDate;
  double balance;
  String status;

  Card({
    this.id = 0,
    this.cardNo = '',
    this.cardType = '',
    this.bankName = '',
    this.expiryDate = '',
    this.balance = 0.0,
    this.status = 'Y',
  });

  factory Card.from(Map<String, dynamic> map) {
    return Card(
      id: map['id'] ?? 0,
      cardNo: map['card_no'] ?? map['cardNo'] ?? '',
      cardType: map['card_type'] ?? map['cardType'] ?? '',
      bankName: map['bank_name'] ?? map['bankName'] ?? '',
      expiryDate: map['expiry_date'] ?? map['expiryDate'] ?? '',
      balance: map['balance'] ?? 0.0,
      status: map['status'] ?? 'Y',
    );
  }

  Card from(Map<String, dynamic> map) {
    return Card(
      id: map['id'] ?? id,
      cardNo: map['card_no'] ?? map['cardNo'] ?? cardNo,
      cardType: map['card_type'] ?? map['cardType'] ?? cardType,
      bankName: map['bank_name'] ?? map['bankName'] ?? bankName,
      expiryDate: map['expiry_date'] ?? map['expiryDate'] ?? expiryDate,
      balance: map['balance'] ?? balance,
      status: map['status'] ?? status,
    );
  }

  Card change(Card card) {
    status = card.status;
    balance = card.balance;
    expiryDate = card.expiryDate;
    bankName = card.bankName;
    cardType = card.cardType;
    cardNo = card.cardNo;
    id = card.id;
    return this;
  }

  Card patch({
    int? id,
    String? cardNo,
    String? cardType,
    String? bankName,
    String? expiryDate,
    double? balance,
    String? status,
  }) {
    this.status = status ?? this.status;
    this.balance = balance ?? this.balance;
    this.expiryDate = expiryDate ?? this.expiryDate;
    this.bankName = bankName ?? this.bankName;
    this.cardType = cardType ?? this.cardType;
    this.cardNo = cardNo ?? this.cardNo;
    this.id = id ?? this.id;
    return this;
  }

  Card clear() {
    status = 'N';
    balance = 0.0;
    expiryDate = '';
    bankName = '';
    cardType = '';
    cardNo = '';
    id = 0;
    return this;
  }
}
