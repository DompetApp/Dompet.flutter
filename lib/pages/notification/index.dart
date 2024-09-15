import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/notification/controller.dart';

class PageNotification extends GetView<PageNotificationController> {
  const PageNotification({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Notification',
          style: TextStyle(
            color: Color(0xff303133),
            fontSize: 18,
            height: 1,
          ),
        ),
      ),
    );
  }
}
