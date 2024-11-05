import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/webview/controller.dart';
import 'package:dompet/pages/webview/_scaffold.dart';
import 'package:dompet/pages/webview/_popup.dart';
import 'package:dompet/theme/light.dart';

class PageWebview extends StatelessWidget {
  PageWebview({super.key});

  late final controller = PageWebviewController();
  late final webviewMeta = controller.webviewMeta.value;

  @override
  Widget build(BuildContext context) {
    if (!Get.isRegistered<PageWebviewController>(tag: webviewMeta.key)) {
      Get.put(controller, tag: webviewMeta.key);
    }

    return Theme(
      data: lightTheme,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GetBuilder<PageWebviewController>(
            id: 'scaffold',
            tag: webviewMeta.key,
            builder: (_) {
              return PageWebviewScaffold(
                controller: controller,
                tag: webviewMeta.key,
              );
            },
          ),
          GetBuilder<PageWebviewController>(
            id: 'popup',
            tag: webviewMeta.key,
            builder: (_) {
              return Obx(() {
                if (controller.webviewMeta.popup.value == true) {
                  return PageWebviewPopup(
                    controller: controller,
                    tag: webviewMeta.key,
                  );
                }
                return const SizedBox.shrink();
              });
            },
          )
        ],
      ),
    );
  }
}
