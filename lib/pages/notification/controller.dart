import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/mixins/watcher.dart';
import 'package:dompet/models/message.dart';
import 'package:dompet/service/bind.dart';

class PageNotificationController extends GetxController with RxWatcher {
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final storeController = Get.find<StoreController>();
  late final eventController = Get.find<EventController>();
  late final scrollController = ScrollController();

  late final readUserMessage = eventController.readUserMessage;
  late final mediaPadding = mediaQueryController.viewPadding;
  late final rawMessages = storeController.messages.list;
  late final mediaTopBar = mediaQueryController.topBar;

  Rx<List<GroupMessage>> msgGroups = Rx([]);
  Rx<bool> isShadow = false.obs;

  @override
  void onInit() {
    super.onInit();

    rxEver(rawMessages, (_) => transformer());

    scrollController.addListener(() {
      final expanded = 640.wmax * 152.sr;
      final collapsed = max(640.wmax * 40.sr, mediaTopBar.value);
      isShadow.value = scrollController.position.pixels >= expanded - collapsed;
    });

    transformer();
  }

  @override
  void onClose() {
    super.onClose();
    rxOff();
  }

  void transformer() {
    final List<GroupMessage> refGroups = [];

    for (var msg in rawMessages.value) {
      try {
        final year = DateTime.parse(msg.date).year;
        final newGroup = GroupMessage(year: year, messages: []);

        final refGroup = refGroups.firstWhere(
          (msg) => msg.year == year,
          orElse: () => newGroup,
        );

        if (refGroup == newGroup) {
          refGroups.add(newGroup);
        }

        refGroup.messages.add(msg);
      } catch (e) {/* e */}
    }

    msgGroups.value = refGroups;
  }

  void readMessage(Message message) {
    eventController.readUserMessage(message);
  }
}
