import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/pages/home/index.dart';
import 'package:dompet/pages/card/index.dart';
import 'package:dompet/pages/login/index.dart';
import 'package:dompet/pages/stats/index.dart';
import 'package:dompet/pages/profile/index.dart';
import 'package:dompet/pages/webview/index.dart';
import 'package:dompet/pages/register/index.dart';
import 'package:dompet/pages/transfer/index.dart';
import 'package:dompet/pages/settings/index.dart';
import 'package:dompet/pages/notification/index.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authorized = [GetRoutes.login, GetRoutes.register, GetRoutes.webview];
    final signing = [GetRoutes.login, GetRoutes.register];
    final login = Get.find<StoreController>().login;

    if (!login.value && !authorized.contains(route)) {
      return const RouteSettings(name: '/login');
    }

    if (login.value && signing.contains(route)) {
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
  static const profile = '/profile';
  static const webview = '/webview';
  static const register = '/register';
  static const transfer = '/transfer';
  static const settings = '/settings';
  static const notification = '/notification';

  static List<GetPage> pages() {
    return [
      GetPage(
        name: home,
        page: () => const PageHome(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: card,
        page: () => const PageCard(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: login,
        page: () => const PageLogin(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: stats,
        page: () => const PageStats(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: profile,
        page: () => const PageProfile(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: webview,
        page: () => PageWebview(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: register,
        page: () => const PageRegister(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: transfer,
        page: () => const PageTransfer(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: settings,
        page: () => const PageSettings(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
      GetPage(
        name: notification,
        page: () => const PageNotification(),
        transition: Transition.noTransition,
        middlewares: [AuthMiddleware()],
      ),
    ];
  }
}
