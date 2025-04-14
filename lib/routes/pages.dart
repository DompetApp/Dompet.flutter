import 'package:dompet/models/web.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/logger/logger.dart';
import 'package:dompet/routes/imports.dart';
import 'package:dompet/pages/home/index.dart';
import 'package:dompet/pages/card/index.dart';
import 'package:dompet/pages/login/index.dart';
import 'package:dompet/pages/stats/index.dart';
import 'package:dompet/pages/langs/index.dart';
import 'package:dompet/pages/logger/index.dart';
import 'package:dompet/pages/profile/index.dart';
import 'package:dompet/pages/webview/index.dart';
import 'package:dompet/pages/register/index.dart';
import 'package:dompet/pages/operater/index.dart';
import 'package:dompet/pages/settings/index.dart';
import 'package:dompet/pages/notification/index.dart';

void logWriterCallback(String message, {bool? isError}) {
  if (isError == true) logger.error('GetX: $message');
  if (isError != true) logger.info('GetX: $message');
}

typedef PreventMode = PreventDuplicateHandlingMode;

class RouteMiddleware extends GetMiddleware {
  RouteMiddleware({super.priority});

  @override
  RouteSettings? redirect(String? route) {
    return null;
  }

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final logined = Get.find<StoreController>().logined;
    final arguments = route.pageSettings?.arguments;
    final name = route.pageSettings?.name;

    if (GetRoutes.overturns.contains(name)) {
      final orientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      SystemChrome.setPreferredOrientations(orientations);
    }

    if (!GetRoutes.overturns.contains(name)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

    if (logined.value && GetRoutes.defaults.contains(name)) {
      return RouteDecoder.fromRoute(GetRoutes.home);
    }

    if (!logined.value && GetRoutes.authorize.contains(name)) {
      return RouteDecoder.fromRoute(GetRoutes.login);
    }

    if (name == GetRoutes.webview && arguments is WebviewMeta) {
      route.route = route.route!.copyWith(
        key: WebviewKey(arguments.key),
        name: GetRoutes.webview,
        arguments: arguments,
      );

      return route;
    }

    if (name == GetRoutes.webview && arguments is! WebviewMeta) {
      return null;
    }

    return name != Get.currentRoute ? route : null;
  }
}

class GetRoutes {
  static const home = '/PageHome';
  static const card = '/PageCard';
  static const login = '/PageLogin';
  static const stats = '/PageStats';
  static const langs = '/PageLangs';
  static const logger = '/PageLogger';
  static const profile = '/PageProfile';
  static const webview = '/PageWebview';
  static const register = '/PageRegister';
  static const operater = '/PageOperater';
  static const settings = '/PageSettings';
  static const notification = '/PageNotification';

  static List<String> get overturns {
    return [GetRoutes.stats, GetRoutes.logger, GetRoutes.webview];
  }

  static List<String> get authorize {
    return [
      GetRoutes.home,
      GetRoutes.card,
      GetRoutes.stats,
      GetRoutes.langs,
      GetRoutes.logger,
      GetRoutes.profile,
      GetRoutes.webview,
      GetRoutes.operater,
      GetRoutes.settings,
      GetRoutes.notification,
    ];
  }

  static List<String> get defaults {
    return [GetRoutes.login, GetRoutes.register];
  }

  static List<GetPage> pages() {
    return [
      GetPage(
        name: home,
        page: () => const PageHome(),
        preventDuplicateHandlingMode: PreventMode.popUntilOriginalRoute,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: card,
        page: () => const PageCard(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: login,
        page: () => const PageLogin(),
        preventDuplicateHandlingMode: PreventMode.popUntilOriginalRoute,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: stats,
        page: () => const PageStats(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: langs,
        page: () => const PageLangs(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: logger,
        page: () => const PageLogger(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: profile,
        page: () => const PageProfile(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: webview,
        page: () => PageWebview(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: register,
        page: () => const PageRegister(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: operater,
        page: () => const PageOperater(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: settings,
        page: () => const PageSettings(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: notification,
        page: () => const PageNotification(),
        preventDuplicateHandlingMode: PreventMode.reorderRoutes,
        middlewares: [RouteMiddleware(priority: 0)],
        popGesture: false,
      ),
    ];
  }
}
