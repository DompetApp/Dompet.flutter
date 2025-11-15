import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/extension/size.dart';

class Dialoger {
  static Future<bool?> show({
    // extend
    String? title,
    String? message,
    String? textCancel,
    String? textConfirm,
    bool showCancelButton = true,
    bool showConfirmButton = true,
    PopInvokedWithResultCallback? onPopInvokedWithResult,
    EdgeInsetsGeometry titlePadding = const EdgeInsets.fromLTRB(10, 20, 10, 8),
    EdgeInsetsGeometry contentPadding = const EdgeInsets.fromLTRB(20, 8, 20, 8),
    EdgeInsetsGeometry buttonPadding = EdgeInsets.zero,
    Color confirmTextColor = const Color(0xff606266),
    Color cancelTextColor = const Color(0xff9f9f9f),
    Color? backgroundColor,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    List<Widget>? actions,
    double? borderRadius,
    Widget? content,
    Widget? confirm,
    Widget? cancel,

    // default
    String? name,
    Object? arguments,
    Duration? transitionDuration,
    RouteSettings? routeSettings,
    GlobalKey<NavigatorState>? navigatorKey,
    bool barrierDismissible = true,
    bool useSafeArea = true,
    Curve? transitionCurve,
    Color? barrierColor,
  }) {
    if (message == null && content == null) {
      return Future.value(false);
    }

    if (cancel == null && showCancelButton == true) {
      cancel = TextButton(
        onPressed: () {
          Navigator.of(Get.overlayContext!).pop(false);
          onCancel?.call();
        },
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        child: Text(
          textCancel ?? 'System_Cancel'.tr,
          style: TextStyle(color: cancelTextColor),
        ),
      );
    }

    if (confirm == null && showConfirmButton == true) {
      confirm = TextButton(
        onPressed: () {
          Navigator.of(Get.overlayContext!).pop(true);
          onConfirm?.call();
        },
        style: TextButton.styleFrom(
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
        child: Text(
          textConfirm ?? 'System_Confirm'.tr,
          style: TextStyle(color: confirmTextColor),
        ),
      );
    }

    if (actions == null || cancel != null || confirm != null) {
      actions ??= [
        if (cancel != null || textCancel != null) cancel!,
        if (confirm != null || textConfirm != null) confirm!,
      ];
    }

    messageStyle ??= TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w400,
      fontSize: 14.fp,
    );

    titleStyle ??= TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.w600,
      fontSize: 16.fp,
    );

    final mediaQueryController = Get.find<MediaQueryController>();
    final mediaQueryWidth = mediaQueryController.width.value;

    final alertDialog = AlertDialog(
      title: Text(
        title ?? 'System_Prompt'.tr,
        textAlign: TextAlign.center,
        style: titleStyle,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          content ??
              Padding(
                padding: const EdgeInsets.only(top: 3, bottom: 15),
                child: Text(
                  message ?? '',
                  textAlign: TextAlign.center,
                  style: messageStyle,
                ),
              ),
          ButtonTheme(
            minWidth: 80.0,
            height: 34.0,
            child: Wrap(
              alignment: WrapAlignment.spaceAround,
              spacing: 8,
              runSpacing: 8,
              children: actions,
            ),
          ),
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 20.0)),
      ),
      insetPadding: EdgeInsets.only(
        left: (mediaQueryWidth - 255) / 2,
        right: (mediaQueryWidth - 255) / 2,
      ),
      titlePadding: titlePadding,
      buttonPadding: buttonPadding,
      contentPadding: contentPadding,
      backgroundColor: backgroundColor,
    );

    return Get.dialog<bool>(
      PopScope(
        onPopInvokedWithResult: onPopInvokedWithResult,
        child: alertDialog,
      ),
      barrierDismissible: barrierDismissible,
      transitionDuration: transitionDuration,
      transitionCurve: transitionCurve,
      routeSettings: routeSettings,
      navigatorKey: navigatorKey,
      barrierColor: barrierColor,
      useSafeArea: useSafeArea,
      arguments: arguments,
      name: name,
    );
  }
}
