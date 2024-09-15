import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/settings/controller.dart';

class PageSettings extends GetView<PageSettingsController> {
  const PageSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Settings',
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
