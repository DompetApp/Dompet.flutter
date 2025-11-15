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
          top: 10.vp,
          left: 20.vp,
          right: 15.vp,
          bottom: 10.vp,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.vp),
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
                  padding: EdgeInsets.only(left: 10.vp),
                  child: IntrinsicWidth(
                    child: Text(
                      message!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.fp,
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
              width: 24.vp,
              height: 24.vp,
              child: IconButton(
                color: Colors.white,
                iconSize: 24.vp,
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
          top: max(48.vp, mediaPadding.top + 6.vp),
          left: 20.vp,
          right: 20.vp,
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
          top: 10.vp,
          left: 20.vp,
          right: 15.vp,
          bottom: 10.vp,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.vp),
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
                  padding: EdgeInsets.only(left: 10.vp),
                  child: IntrinsicWidth(
                    child: Text(
                      message!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.fp,
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
              width: 24.vp,
              height: 24.vp,
              child: IconButton(
                color: Colors.white,
                iconSize: 24.vp,
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
          top: max(48.vp, mediaPadding.top + 6.vp),
          left: 20.vp,
          right: 20.vp,
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
          top: 10.vp,
          left: 20.vp,
          right: 15.vp,
          bottom: 10.vp,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32.vp),
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
                  padding: EdgeInsets.only(left: 10.vp),
                  child: IntrinsicWidth(
                    child: Text(
                      message!,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 14.fp,
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
              width: 24.vp,
              height: 24.vp,
              child: IconButton(
                iconSize: 24.vp,
                color: Colors.white,
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
          top: max(48.vp, mediaPadding.top + 6.vp),
          left: 20.vp,
          right: 20.vp,
          child: child,
        );
      },
    );
  }
}
