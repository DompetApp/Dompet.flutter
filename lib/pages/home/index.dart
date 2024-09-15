import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/home/controller.dart';

class PageHome extends GetView<PageHomeController> {
  const PageHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Home',
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
