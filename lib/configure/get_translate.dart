import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class JsonTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => _keys;

  final Map<String, Map<String, String>> _keys = {};

  Future<void> init() async {
    const zh = 'lib/assets/langs/zh_CN.json';
    const us = 'lib/assets/langs/en_US.json';

    final zhCn = await rootBundle.loadString(zh);
    final enUs = await rootBundle.loadString(us);

    final zhCnMap = Map<String, String>.from(jsonDecode(zhCn));
    final enUsMap = Map<String, String>.from(jsonDecode(enUs));

    _keys['zh_CN'] = zhCnMap;
    _keys['en_US'] = enUsMap;
  }
}
