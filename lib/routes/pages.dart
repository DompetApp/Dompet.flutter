import 'package:dompet/service/bind.dart';
import 'package:dompet/routes/imports.dart';
import 'package:dompet/pages/home/index.dart';
import 'package:dompet/pages/card/index.dart';
import 'package:dompet/pages/login/index.dart';
import 'package:dompet/pages/stats/index.dart';
import 'package:dompet/pages/langs/index.dart';
import 'package:dompet/pages/profile/index.dart';
import 'package:dompet/pages/settings/index.dart';
import 'package:dompet/pages/webview/index.dart';
import 'package:dompet/pages/register/index.dart';
import 'package:dompet/pages/operater/index.dart';
import 'package:dompet/pages/notification/index.dart';

typedef PreventMode = PreventDuplicateHandlingMode;

class RouteMiddleware extends GetMiddleware {
  RouteMiddleware({super.priority});

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final logined = Get.find<StoreController>().logined;

    if (GetRoutes.overturns.contains(route.route?.name)) {
      final orientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      SystemChrome.setPreferredOrientations(orientations);
    }

    if (!GetRoutes.overturns.contains(route.route?.name)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

    if (logined.value && GetRoutes.defaults.contains(route.route?.name)) {
      return RouteDecoder.fromRoute('/home');
    }

    if (!logined.value && GetRoutes.authorize.contains(route.route?.name)) {
      return RouteDecoder.fromRoute('/login');
    }

    return route;
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

  static List<String> get overturns {
    return [
      GetRoutes.stats,
    ];
  }

  static List<String> get authorize {
    return [
      GetRoutes.home,
      GetRoutes.card,
      GetRoutes.stats,
      GetRoutes.langs,
      GetRoutes.profile,
      GetRoutes.webview,
      GetRoutes.operater,
      GetRoutes.settings,
      GetRoutes.notification,
    ];
  }

  static List<String> get defaults {
    return [
      GetRoutes.login,
      GetRoutes.register,
    ];
  }

  static List<GetPage> pages() {
    return [
      GetPage(
        name: home,
        page: () => const PageHome(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.popUntilOriginalRoute,
      ),
      GetPage(
        name: card,
        page: () => const PageCard(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
      ),
      GetPage(
        name: login,
        page: () => const PageLogin(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.popUntilOriginalRoute,
      ),
      GetPage(
        name: stats,
        page: () => const PageStats(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
      ),
      GetPage(
        name: langs,
        page: () => const PageLangs(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
      ),
      GetPage(
        name: profile,
        page: () => const PageProfile(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
      ),
      GetPage(
        name: webview,
        page: () => PageWebview(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
      ),
      GetPage(
        name: register,
        page: () => const PageRegister(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
      ),
      GetPage(
        name: operater,
        page: () => const PageOperater(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
      ),
      GetPage(
        name: settings,
        page: () => const PageSettings(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
      ),
      GetPage(
        name: notification,
        page: () => const PageNotification(),
        middlewares: [RouteMiddleware(priority: 0)],
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
      ),
    ];
  }
}
