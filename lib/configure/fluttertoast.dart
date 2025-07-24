import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/extension/size.dart';
import 'package:dompet/service/media.dart';

class Toaster {
  static void error({
    String? message,
    Duration? duration,
    Function? onTap,
    bool? clear,
  }) {
    if (!message.bv) {
      return;
    }

    if (!Get.context.bv) {
      return;
    }

    final fToast = FToast();
    final mediaQuery = Get.find<MediaQueryController>();
    final mediaPadding = mediaQuery.viewPadding.value;

    fToast.init(Get.context!);

    if (clear != false) {
      fToast.removeQueuedCustomToasts();
    }

    fToast.showToast(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: 640.wmax * 10.sr,
          left: 640.wmax * 20.sr,
          right: 640.wmax * 15.sr,
          bottom: 640.wmax * 10.sr,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(640.wmax * 32.sr),
          color: Colors.redAccent,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 640.wmax * 10.sr),
                  child: IntrinsicWidth(
                    child: Text(
                      message!,
                      style: TextStyle(
                        fontSize: 640.wmax * 14.sr,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (onTap != null) {
                    fToast.removeCustomToast();
                    onTap();
                  }
                },
              ),
            ),
            SizedBox(
              width: 640.wmax * 24.sr,
              height: 640.wmax * 24.sr,
              child: IconButton(
                color: Colors.white,
                iconSize: 640.wmax * 24.sr,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.close),
                onPressed: () => fToast.removeCustomToast(),
              ),
            ),
          ],
        ),
      ),
      toastDuration: duration ?? const Duration(seconds: 3),
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(
          top: max(640.wmax * 48.sr, mediaPadding.top + 640.wmax * 6.sr),
          left: 640.wmax * 20.sr,
          right: 640.wmax * 20.sr,
          child: child,
        );
      },
    );
  }

  static void warning({
    String? message,
    Duration? duration,
    Function? onTap,
    bool? clear,
  }) {
    if (!message.bv) {
      return;
    }

    if (!Get.context.bv) {
      return;
    }

    final fToast = FToast();
    final mediaQuery = Get.find<MediaQueryController>();
    final mediaPadding = mediaQuery.viewPadding.value;

    fToast.init(Get.context!);

    if (clear != false) {
      fToast.removeQueuedCustomToasts();
    }

    fToast.showToast(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: 640.wmax * 10.sr,
          left: 640.wmax * 20.sr,
          right: 640.wmax * 15.sr,
          bottom: 640.wmax * 10.sr,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(640.wmax * 32.sr),
          color: Color(0xffffc107),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 640.wmax * 10.sr),
                  child: IntrinsicWidth(
                    child: Text(
                      message!,
                      style: TextStyle(
                        fontSize: 640.wmax * 14.sr,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (onTap != null) {
                    fToast.removeCustomToast();
                    onTap();
                  }
                },
              ),
            ),
            SizedBox(
              width: 640.wmax * 24.sr,
              height: 640.wmax * 24.sr,
              child: IconButton(
                color: Colors.white,
                iconSize: 640.wmax * 24.sr,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.error_outline),
                onPressed: () => fToast.removeCustomToast(),
              ),
            ),
          ],
        ),
      ),
      toastDuration: duration ?? const Duration(seconds: 3),
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(
          top: max(640.wmax * 48.sr, mediaPadding.top + 640.wmax * 6.sr),
          left: 640.wmax * 20.sr,
          right: 640.wmax * 20.sr,
          child: child,
        );
      },
    );
  }

  static void success({
    String? message,
    Duration? duration,
    Function? onTap,
    bool? clear,
  }) {
    if (!message.bv) {
      return;
    }

    if (!Get.context.bv) {
      return;
    }

    final fToast = FToast();
    final mediaQuery = Get.find<MediaQueryController>();
    final mediaPadding = mediaQuery.viewPadding.value;

    fToast.init(Get.context!);

    if (clear != false) {
      fToast.removeQueuedCustomToasts();
    }

    fToast.showToast(
      child: Container(
        alignment: Alignment.topCenter,
        padding: EdgeInsets.only(
          top: 640.wmax * 10.sr,
          left: 640.wmax * 20.sr,
          right: 640.wmax * 15.sr,
          bottom: 640.wmax * 10.sr,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(640.wmax * 32.sr),
          color: const Color(0xff52c41b),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 640.wmax * 10.sr),
                  child: IntrinsicWidth(
                    child: Text(
                      message!,
                      style: TextStyle(
                        fontSize: 640.wmax * 14.sr,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        height: 1.3,
                      ),
                    ),
                  ),
                ),
                onTap: () {
                  if (onTap != null) {
                    fToast.removeCustomToast();
                    onTap();
                  }
                },
              ),
            ),
            SizedBox(
              width: 640.wmax * 24.sr,
              height: 640.wmax * 24.sr,
              child: IconButton(
                color: Colors.white,
                iconSize: 640.wmax * 24.sr,
                padding: const EdgeInsets.all(0),
                icon: const Icon(Icons.check),
                onPressed: () => fToast.removeCustomToast(),
              ),
            ),
          ],
        ),
      ),
      toastDuration: duration ?? const Duration(seconds: 3),
      positionedToastBuilder: (context, child, gravity) {
        return Positioned(
          top: max(640.wmax * 48.sr, mediaPadding.top + 640.wmax * 6.sr),
          left: 640.wmax * 20.sr,
          right: 640.wmax * 20.sr,
          child: child,
        );
      },
    );
  }
}
