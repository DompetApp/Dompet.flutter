import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/login/controller.dart';

class PageLogin extends GetView<PageLoginController> {
  const PageLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Login',
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
