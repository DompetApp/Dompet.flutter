import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/pages/home/index.dart';
import 'package:dompet/pages/card/index.dart';
import 'package:dompet/pages/login/index.dart';
import 'package:dompet/pages/stats/index.dart';
import 'package:dompet/pages/langs/index.dart';
import 'package:dompet/pages/profile/index.dart';
import 'package:dompet/pages/webview/index.dart';
import 'package:dompet/pages/register/index.dart';
import 'package:dompet/pages/operater/index.dart';
import 'package:dompet/pages/settings/index.dart';
import 'package:dompet/pages/notification/index.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final logined = Get.find<StoreController>().logined;

    if (!logined.value && !GetRoutes.defaults.contains(route)) {
      return const RouteSettings(name: '/login');
    }

    if (logined.value && GetRoutes.defaults.contains(route)) {
      return const RouteSettings(name: '/home');
    }

    return null;
  }
}

class GetRoutes {
  static const home = '/home';
  static const card = '/card';
  static const login = '/login';
  static const stats = '/stats';
  static const langs = '/langs';
  static const profile = '/profile';
  static const webview = '/webview';
  static const register = '/register';
  static const operater = '/operater';
  static const settings = '/settings';
  static const notification = '/notification';

  static List<String> get defaults {
    return [
      GetRoutes.login,
      GetRoutes.register,
    ];
  }

  static List<String> get list {
    return [
      GetRoutes.login,
      GetRoutes.card,
      GetRoutes.login,
      GetRoutes.stats,
      GetRoutes.langs,
      GetRoutes.profile,
      GetRoutes.webview,
      GetRoutes.register,
      GetRoutes.operater,
      GetRoutes.settings,
      GetRoutes.notification,
    ];
  }

  static List<GetPage> pages() {
    return [
      GetPage(
        name: home,
        page: () => const PageHome(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: card,
        page: () => const PageCard(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: login,
        page: () => const PageLogin(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: stats,
        page: () => const PageStats(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: langs,
        page: () => const PageLangs(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: profile,
        page: () => const PageProfile(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: webview,
        page: () => PageWebview(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: register,
        page: () => const PageRegister(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: operater,
        page: () => const PageOperater(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: settings,
        page: () => const PageSettings(),
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: notification,
        page: () => const PageNotification(),
        middlewares: [AuthMiddleware()],
      ),
    ];
  }
}
