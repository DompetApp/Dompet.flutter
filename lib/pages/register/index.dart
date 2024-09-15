import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/register/controller.dart';

class PageRegister extends GetView<PageRegisterController> {
  const PageRegister({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Register',
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
