import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/pages/webview/controller.dart';
import 'package:dompet/pages/webview/_scaffold.dart';
import 'package:dompet/pages/webview/_popup.dart';
import 'package:dompet/theme/light.dart';

class PageWebview extends StatelessWidget {
  PageWebview({super.key});

  late final dep = PageWebviewController();
  late final tag = dep.webviewMeta.key.value;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(dep, tag: tag);

    return Theme(
      data: lightTheme,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GetBuilder<PageWebviewController>(
            id: 'scaffold',
            tag: tag,
            builder: (_) {
              return PageWebviewScaffold(controller: controller, tag: tag);
            },
          ),
          GetBuilder<PageWebviewController>(
            id: 'popup',
            tag: tag,
            builder: (_) {
              return Obx(
                () => controller.webviewMeta.popup.value == true
                    ? PageWebviewPopup(controller: controller, tag: tag)
                    : const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}
