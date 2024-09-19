import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/service/media.dart';

class Toaster {
  static void error({String? message, Duration? timeout, bool clear = true}) {
    if (!message.bv) {
      return;
    }

    if (!Get.context.bv) {
      return;
    }

    final fToast = FToast();
    final mediaQuery = Get.find<MediaQueryController>();
    final mediaPadding = mediaQuery.padding;

    if (clear) fToast.removeQueuedCustomToasts();

    fToast.init(Get.context!);

    fToast.showToast(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: 640.max * 10.sr,
          left: 640.max * 20.sr,
          right: 640.max * 15.sr,
          bottom: 640.max * 10.sr,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(640.max * 32.sr),
          color: Colors.redAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 640.max * 10.sr),
                child: IntrinsicWidth(
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontSize: 640.max * 14.sr,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 640.max * 24.sr,
              height: 640.max * 24.sr,
              child: IconButton(
                color: Colors.white,
                iconSize: 640.max * 24.sr,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.close),
                onPressed: () => fToast.removeCustomToast(),
              ),
            ),
          ],
        ),
      ),
      toastDuration: timeout ?? const Duration(seconds: 3),
      positionedToastBuilder: (context, child) {
        return Positioned(
          top: max(640.max * 15.sr, mediaPadding.value.top),
          left: 640.max * 24.sr,
          right: 640.max * 24.sr,
          child: child,
        );
      },
    );
  }

  static void success({String? message, Duration? timeout, bool clear = true}) {
    if (!message.bv) {
      return;
    }

    if (!Get.context.bv) {
      return;
    }

    final fToast = FToast();
    final mediaQuery = Get.find<MediaQueryController>();
    final mediaPadding = mediaQuery.padding;

    if (clear) fToast.removeQueuedCustomToasts();

    fToast.init(Get.context!);

    fToast.showToast(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: 640.max * 10.sr,
          left: 640.max * 20.sr,
          right: 640.max * 15.sr,
          bottom: 640.max * 10.sr,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(640.max * 32.sr),
          color: const Color(0xff52c41b),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 640.max * 10.sr),
                child: IntrinsicWidth(
                  child: Text(
                    message!,
                    style: TextStyle(
                      fontSize: 640.max * 14.sr,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 640.max * 24.sr,
              height: 640.max * 24.sr,
              child: IconButton(
                color: Colors.white,
                iconSize: 640.max * 24.sr,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.check),
                onPressed: () => fToast.removeCustomToast(),
              ),
            ),
          ],
        ),
      ),
      toastDuration: timeout ?? const Duration(seconds: 3),
      positionedToastBuilder: (context, child) {
        return Positioned(
          top: max(640.max * 15.sr, mediaPadding.value.top),
          left: 640.max * 24.sr,
          right: 640.max * 24.sr,
          child: child,
        );
      },
    );
  }
}
