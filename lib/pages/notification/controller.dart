import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/models/message.dart';
import 'package:dompet/service/bind.dart';

class PageNotificationController extends GetxController {
  late final scrollController = ScrollController();
  late final eventController = Get.find<EventController>();
  late final storeController = Get.find<StoreController>();
  late final mediaQueryController = Get.find<MediaQueryController>();

  late final readUserMessage = eventController.readUserMessage;
  late final mediaPadding = mediaQueryController.viewPadding;
  late final rawMessages = storeController.messages.list;
  late final mediaTopBar = mediaQueryController.topBar;
  late final msgGroups = Rx<List<GroupMessage>>([]);
  late final isShadow = false.obs;

  @override
  void onInit() {
    super.onInit();
    ever(rawMessages, (_) => transformer());
    transformer();
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
