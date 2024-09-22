import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/services.dart';

class JsonTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => _keys;

  final Map<String, Map<String, String>> _keys = {};

  Future<void> init() async {
    final enUsJson = await rootBundle.loadString('lib/assets/langs/en_US.json');
    final zhCnJson = await rootBundle.loadString('lib/assets/langs/zh_CN.json');

    final enUsMap = Map<String, String>.from(jsonDecode(enUsJson));
    final zhCnMap = Map<String, String>.from(jsonDecode(zhCnJson));

    _keys['en_US'] = enUsMap;
    _keys['zh_CN'] = zhCnMap;
  }
}
