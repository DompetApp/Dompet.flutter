import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:dompet/routes/routes.dart';
import 'package:dompet/routes/vendor.dart';
import 'package:dompet/service/linker.dart';
import 'package:quick_actions/quick_actions.dart';

typedef Handler = void Function(String);
typedef ShortcutItems = List<ShortcutItem>;

class ShortcutController extends GetxService with WidgetsBindingObserver {
  late List<Locale> locales = PlatformDispatcher.instance.locales;
  late QuickActions instance = const QuickActions();
  late List<String> langs = ['zh', 'en'];

  late final localizedTitles = {
    'MyBill': {'en': 'MyBill', 'zh': '我的账单'},
  };

  String get language {
    return langs.contains(locales.first.languageCode)
        ? locales.first.languageCode
        : 'en';
  }

  @override
  onInit() async {
    super.onInit();

    await initialize((type) {
      if (type == 'shortcut.bill') {
        Get.find<AppLinkController>().forward(GetRoutes.stats);
        return;
      }
    });

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  onReady() async {
    super.onReady();
    await setShortcutItems([
      const ShortcutItem(
        localizedTitle: 'MyBill',
        type: 'shortcut.bill',
        icon: 'MyBill',
      ),
    ]);
  }

  @override
  onClose() async {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  didChangeLocales(locales) async {
    this.locales = locales ?? this.locales;

    await setShortcutItems([
      const ShortcutItem(
        localizedTitle: 'MyBill',
        type: 'shortcut.bill',
        icon: 'MyBill',
      ),
    ]);
  }

  Future<void> initialize(Handler handler) {
    return instance.initialize(handler);
  }

  Future<void> setShortcutItems(ShortcutItems items) {
    return instance.setShortcutItems([
      ...items.map((item) {
        final regex = RegExp(r'(?<=[a-z])(?=[A-Z])');
        final title = localizedTitles[item.localizedTitle]?[language];
        final icon = item.icon?.replaceAllMapped(regex, (m) => '_');

        return ShortcutItem(
          localizedTitle: title ?? item.localizedTitle,
          icon: Platform.isAndroid ? icon?.toLowerCase() : item.icon,
          type: item.type,
        );
      }),
    ]);
  }

  Future<void> clearShortcutItems() {
    return instance.clearShortcutItems();
  }
}
