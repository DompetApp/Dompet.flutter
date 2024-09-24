import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/operater/controller.dart';

class PageOperater extends GetView<PageOperaterController> {
  const PageOperater({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Transfer',
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