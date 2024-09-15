import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/profile/controller.dart';

class PageProfile extends GetView<PageProfileController> {
  const PageProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: const Text(
          'Profile',
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
