import 'dart:convert';
import 'package:get/get.dart';
import 'package:crypto/crypto.dart';
import 'package:convert/convert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:dompet/pages/webview/controller.dart';
import 'package:dompet/pages/webview/index.dart';
import 'package:dompet/models/webview.dart';
import 'package:dompet/routes/pages.dart';

export 'package:dompet/routes/pages.dart';

class Webview {
  static String encode(String decode) {
    try {
      return Uri.encodeComponent(decode);
    } catch (e) {
      return decode;
    }
  }

  static String decode(String encode) {
    try {
      return Uri.decodeComponent(encode);
    } catch (e) {
      return encode;
    }
  }

  static String parseUrl(dynamic arguments) {
    if (arguments is! WebviewMeta) {
      return '';
    }

    final Map<String, dynamic> params = {};
    final query = arguments.query;
    final url = arguments.url;

    final queryIndex = url.indexOf('?');
    final hashIndex = url.indexOf('#');
    final hasQuery = queryIndex != -1;
    final hasHash = hashIndex != -1;

    if (!hasQuery) {
      String temp = '';

      query.forEach((key, value) {
        key = decode(key);
        value = decode(value);
        params.addAll({key: value});
      });

      params.forEach((key, value) {
        key = encode(key);
        value = encode(value);
        temp = '$key=$value&$temp';
      });

      if (temp != '') {
        temp = temp.trim();
        temp = temp.replaceFirst(RegExp(r'&+$'), '');
      }

      if (temp != '') {
        return '$url?$temp';
      }

      return url;
    }

    if (hasQuery && !hasHash) {
      String temp = '';
      String path = url.substring(0, queryIndex);
      String search = url.substring(queryIndex + 1);

      search.split('&').forEach((string) {
        final index = string.indexOf('=');
        final one = index > -1 ? string.substring(0, index) : '';
        final two = index > -1 ? string.substring(index + 1) : '';

        final key = decode(one);
        final value = decode(two);

        if (key.trim() != '') {
          params.addAll({key: value});
        }
      });

      query.forEach((key, value) {
        key = decode(key);
        value = decode(value);
        params.addAll({key: value});
      });

      params.forEach((key, value) {
        key = encode(key);
        value = encode(value);
        temp = '$key=$value&$temp';
      });

      if (temp != '') {
        temp = temp.trim();
        temp = temp.replaceFirst(RegExp(r'&+$'), '');
      }

      if (temp != '') {
        return '$path?$temp';
      }

      return path;
    }

    if (hasQuery && hasHash && queryIndex < hashIndex) {
      String temp = '';
      String hash = url.substring(hashIndex);
      String path = url.substring(0, queryIndex);
      String search = url.substring(queryIndex + 1, hashIndex);

      search.split('&').forEach((string) {
        final index = string.indexOf('=');
        final one = index > -1 ? string.substring(0, index) : '';
        final two = index > -1 ? string.substring(index + 1) : '';

        final key = decode(one);
        final value = decode(two);

        if (key.trim() != '') {
          params.addAll({key: value});
        }
      });

      arguments.query.forEach((key, value) {
        key = decode(key);
        value = decode(value);
        params.addAll({key: value});
      });

      params.forEach((key, value) {
        key = encode(key);
        value = encode(value);
        temp = '$key=$value&$temp';
      });

      if (temp != '') {
        temp = temp.trim();
        temp = temp.replaceFirst(RegExp(r'&+$'), '');
      }

      if (temp != '') {
        return '$path?$temp$hash';
      }

      return '$path?$hash';
    }

    if (hasQuery && hasHash && queryIndex > hashIndex) {
      String temp = '';
      String path = url.substring(0, queryIndex);
      String search = url.substring(queryIndex + 1);

      search.split('&').forEach((string) {
        final index = string.indexOf('=');
        final one = index > -1 ? string.substring(0, index) : '';
        final two = index > -1 ? string.substring(index + 1) : '';

        final key = decode(one);
        final value = decode(two);

        if (key.trim() != '') {
          params.addAll({key: value});
        }
      });

      query.forEach((key, value) {
        key = decode(key);
        value = decode(value);
        params.addAll({key: value});
      });

      params.forEach((key, value) {
        key = encode(key);
        value = encode(value);
        temp = '$key=$value&$temp';
      });

      if (temp != '') {
        temp = temp.trim();
        temp = temp.replaceFirst(RegExp(r'&+$'), '');
      }

      if (temp != '') {
        return '$path?$temp';
      }

      return path;
    }

    return '';
  }

  static bool checkMeta(dynamic arguments) {
    return arguments is WebviewMeta;
  }

  static bool checkKey(dynamic arguments) {
    if (arguments is! WebviewMeta) {
      return false;
    }

    try {
      final key = arguments.key;
      final code = utf8.encode(key);
      final bytes = md5.convert(code).bytes;
      Get.find<PageWebviewController>(tag: hex.encode(bytes));
      return false;
    } catch (e) {
      return true;
    }
  }

  static bool checkUrl(dynamic arguments) {
    if (arguments is! WebviewMeta) {
      return false;
    }

    final regex = RegExp(
      r'^https?://([\w-]+\.)+[\w-]+(/[\w- ./?%&=]*)?',
      caseSensitive: true,
      multiLine: false,
    );

    if (arguments.url != '') {
      return regex.hasMatch(arguments.url);
    }

    return false;
  }

  static bool checkHttps(dynamic arguments) {
    if (arguments is! WebviewMeta) {
      return false;
    }

    if (arguments.url != '') {
      return arguments.url.startsWith(
        RegExp(r'^https://|^https?://127.0.0.1|^https?://localhost'),
      );
    }

    return false;
  }

  static Future<bool> duplicate(dynamic arguments) async {
    if (arguments is! WebviewMeta) {
      return true;
    }

    return !checkKey(arguments);
  }

  static Future<dynamic> format(dynamic arguments) async {
    if (arguments is! WebviewMeta) {
      return Future.error(GetRouteError.webview);
    }

    if (!checkMeta(arguments)) {
      return Future.error(GetRouteError.webview);
    }

    if (!checkKey(arguments)) {
      return Future.error(GetRouteError.webview);
    }

    if (arguments.url != '') {
      return WebviewMeta(
        url: parseUrl(arguments),
        key: arguments.key,
        html: arguments.html,
        title: arguments.title,
        query: Map.from(arguments.query),
        checkHttps: checkHttps(arguments),
        checkUrl: checkUrl(arguments),
        fromHtml: false,
        fromUrl: true,
        canBack: false,
        loading: false,
        popup: false,
      );
    }

    if (arguments.html != '') {
      return WebviewMeta(
        key: arguments.key,
        url: arguments.url,
        html: arguments.html,
        title: arguments.title,
        query: Map.from(arguments.query),
        checkHttps: false,
        checkUrl: false,
        fromHtml: true,
        fromUrl: false,
        canBack: false,
        loading: false,
        popup: false,
      );
    }

    return Future.error(GetRouteError.webview);
  }
}

class GetRouter {
  static Future<T?> to<T>(
    Widget Function() page, {
    String? id,
    Curve? curve,
    bool? opaque,
    String? routeName,
    dynamic arguments,
    Duration? duration,
    Transition? transition,
    bool? popGesture,
    bool rebuildStack = true,
    bool preventDuplicates = true,
    bool fullscreenDialog = false,
    bool showCupertinoParallax = true,
    List<BindingsInterface> bindings = const [],
    double Function(BuildContext context)? gestureWidth,
    PreventDuplicateHandlingMode? preventDuplicateHandlingMode,
  }) async {
    if (page() is PageWebview) {
      preventDuplicates = await Webview.duplicate(arguments);
      arguments = await Webview.format(arguments);
    }

    return Get.to<T>(
      page,
      id: id,
      curve: curve,
      opaque: opaque,
      bindings: bindings,
      duration: duration,
      routeName: routeName,
      arguments: arguments,
      transition: transition,
      popGesture: popGesture,
      gestureWidth: gestureWidth,
      rebuildStack: rebuildStack,
      fullscreenDialog: fullscreenDialog,
      preventDuplicates: preventDuplicates,
      showCupertinoParallax: showCupertinoParallax,
      preventDuplicateHandlingMode: preventDuplicateHandlingMode ??
          PreventDuplicateHandlingMode.reorderRoutes,
    );
  }

  static Future<T?> off<T>(
    Widget Function() page, {
    String? id,
    Curve? curve,
    bool? opaque,
    String? routeName,
    dynamic arguments,
    Duration? duration,
    Transition? transition,
    bool? popGesture,
    bool fullscreenDialog = false,
    bool preventDuplicates = true,
    List<BindingsInterface> bindings = const [],
    double Function(BuildContext context)? gestureWidth,
  }) async {
    if (page() is PageWebview) {
      preventDuplicates = await Webview.duplicate(arguments);
      arguments = await Webview.format(arguments);
    }

    return Get.off<T>(
      page,
      id: id,
      curve: curve,
      opaque: opaque,
      bindings: bindings,
      duration: duration,
      routeName: routeName,
      arguments: arguments,
      transition: transition,
      popGesture: popGesture,
      gestureWidth: gestureWidth,
      fullscreenDialog: fullscreenDialog,
      preventDuplicates: preventDuplicates,
    );
  }

  static Future<T?> offAll<T>(
    Widget Function() page, {
    String? id,
    Curve? curve,
    bool? opaque,
    String? routeName,
    dynamic arguments,
    Duration? duration,
    Transition? transition,
    bool? popGesture,
    bool fullscreenDialog = false,
    List<BindingsInterface> bindings = const [],
    double Function(BuildContext context)? gestureWidth,
    bool Function(GetPage<dynamic>)? predicate,
  }) async {
    if (page() is PageWebview) {
      arguments = await Webview.format(arguments);
    }

    return Get.offAll<T>(
      page,
      id: id,
      curve: curve,
      opaque: opaque,
      bindings: bindings,
      duration: duration,
      routeName: routeName,
      arguments: arguments,
      predicate: predicate,
      transition: transition,
      popGesture: popGesture,
      gestureWidth: gestureWidth,
      fullscreenDialog: fullscreenDialog,
    );
  }

  static Future<T?> offNamed<T>(
    String page, {
    String? id,
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    if (page == GetRoutes.webview) {
      arguments = await Webview.format(arguments);
    }

    return Get.offNamed<T>(
      page,
      id: id,
      arguments: arguments,
      parameters: parameters,
    );
  }

  static Future<T?> offNamedUntil<T>(
    String page, {
    String? id,
    dynamic arguments,
    Map<String, String>? parameters,
    bool Function(GetPage<dynamic>)? predicate,
  }) async {
    if (page == GetRoutes.webview) {
      arguments = await Webview.format(arguments);
    }

    return Get.offNamedUntil<T>(
      page,
      predicate,
      id: id,
      arguments: arguments,
      parameters: parameters,
    );
  }

  static Future<T?> offAndToNamed<T>(
    String page, {
    String? id,
    dynamic result,
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    if (page == GetRoutes.webview) {
      arguments = await Webview.format(arguments);
    }

    return Get.offAndToNamed<T>(
      page,
      id: id,
      result: result,
      arguments: arguments,
      parameters: parameters,
    );
  }

  static Future<T?> offAllNamed<T>(
    String page, {
    String? id,
    dynamic arguments,
    Map<String, String>? parameters,
  }) async {
    if (page == GetRoutes.webview) {
      arguments = await Webview.format(arguments);
    }

    return Get.offAllNamed<T>(
      page,
      id: id,
      arguments: arguments,
      parameters: parameters,
    );
  }

  static Future<T?> toNamed<T>(
    String page, {
    String? id,
    dynamic arguments,
    Map<String, String>? parameters,
    bool preventDuplicates = true,
  }) async {
    if (page == GetRoutes.webview) {
      preventDuplicates = await Webview.duplicate(arguments);
      arguments = await Webview.format(arguments);
    }

    return Get.toNamed<T>(
      page,
      id: id,
      arguments: arguments,
      parameters: parameters,
      preventDuplicates: preventDuplicates,
    );
  }

  static Future<bool> canBack({
    String? id,
  }) async {
    try {
      return Get.searchDelegate(id).canBack;
    } catch (e) {
      return false;
    }
  }

  static Future<void> back<T>({
    String? id,
    int times = 1,
    bool canPop = true,
    T? result,
  }) async {
    return Get.back<T>(
      id: id,
      times: times,
      canPop: canPop,
      result: result,
    );
  }

  static Future<void> until(
    bool Function(GetPage<dynamic>) predicate, {
    String? id,
  }) async {
    return Get.until(
      predicate,
      id: id,
    );
  }

  static Future<void> close({
    String? id,
    dynamic result,
    bool closeAll = true,
    bool closeDialog = true,
    bool closeSnackbar = true,
    bool closeBottomSheet = true,
  }) async {
    return Get.close(
      id: id,
      result: result,
      closeAll: closeAll,
      closeDialog: closeDialog,
      closeSnackbar: closeSnackbar,
      closeBottomSheet: closeBottomSheet,
    );
  }

  static Future<void> exit({
    bool? animated,
  }) async {
    return SystemNavigator.pop(animated: animated);
  }

  static Future<void> login({
    String? page,
  }) async {
    if (GetRoutes.defaults.contains(Get.currentRoute)) {
      final redirect = page ?? GetRoutes.home;
      final isGetRoute = GetRoutes.authorize.contains(page);
      offAllNamed(isGetRoute ? redirect : GetRoutes.home);
    }
  }

  static Future<void> logout({
    String? page,
  }) async {
    if (!GetRoutes.defaults.contains(Get.currentRoute)) {
      final redirect = page ?? GetRoutes.login;
      final isGetRoute = GetRoutes.defaults.contains(page);
      offAllNamed(isGetRoute ? redirect : GetRoutes.login);
    }
  }
}

enum GetRouteError {
  webview,
  route,
}
