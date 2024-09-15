import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/stats/controller.dart';

class PageStats extends GetView<PageStatsController> {
  const PageStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Stats',
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
