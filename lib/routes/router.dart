import 'package:dompet/logger/logger.dart';
import 'package:dompet/routes/vendor.dart';
import 'package:dompet/routes/routes.dart';
import 'package:dompet/routes/binding.dart';
import 'package:dompet/routes/middleware.dart';

import 'package:dompet/pages/home/index.dart';
import 'package:dompet/pages/card/index.dart';
import 'package:dompet/pages/login/index.dart';
import 'package:dompet/pages/stats/index.dart';
import 'package:dompet/pages/langs/index.dart';
import 'package:dompet/pages/logger/index.dart';
import 'package:dompet/pages/scanner/index.dart';
import 'package:dompet/pages/profile/index.dart';
import 'package:dompet/pages/webview/index.dart';
import 'package:dompet/pages/register/index.dart';
import 'package:dompet/pages/operater/index.dart';
import 'package:dompet/pages/settings/index.dart';
import 'package:dompet/pages/notification/index.dart';

class GetRouter {
  static final Map<String, List<GetPage>> flattens = {};
  static final Map<String, List<GetPage>> childrens = {};

  static void logWriter(String message, {bool? isError}) {
    if (isError == true) logger.warning('GetX: $message');
    if (isError != true) logger.info('GetX: $message');
  }

  static String normalize(String route, String? parent) {
    route = route.replaceFirst(RegExp(r'/+$'), '');
    route = route.replaceFirst(RegExp(r'^/*'), '/');
    parent = parent?.replaceFirst(RegExp(r'/+$'), '');
    return parent != null ? parent + route : route;
  }

  static List<GetPage>? children([String route = '/']) {
    addAll(String route, List<GetPage> pages) {
      for (GetPage page in pages) {
        final name = normalize(page.name, route);

        if (page.inheritParentPath) {
          page = page.copyWith(name: name);
        }

        childrens[route] = childrens[route] ?? [];
        childrens[route]?.addAll([page]);
        addAll(name, page.children);
      }
    }

    if (childrens.isEmpty) {
      addAll('/', pages());
    }

    return childrens[route];
  }

  static List<GetPage>? flatten([String route = '/']) {
    addAll(String route, List<GetPage> pages) {
      List<GetPage> list = [];

      for (GetPage page in pages) {
        final name = normalize(page.name, route);
        final more = addAll(name, page.children);

        if (page.inheritParentPath) {
          page = page.copyWith(name: name);
        }

        flattens[route] ??= flattens[route] ?? [];
        flattens[route]?.addAll([page, ...more]);
        list.addAll([page, ...more]);
      }

      return list;
    }

    if (flattens.isEmpty) {
      addAll('/', pages());
    }

    return flattens[route];
  }

  static List<GetPage> pages() {
    return [
      GetPage(
        name: GetRoutes.home,
        page: () => const PageHome(),
        binding: GetBindingBuilder.lazyPut(() => PageHomeController()),
        preventDuplicateHandlingMode: DuplicateMode.popUntilOriginalRoute,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: GetRoutes.card,
        page: () => const PageCard(),
        binding: GetBindingBuilder.lazyPut(() => PageCardController()),
        preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: GetRoutes.stats,
        page: () => const PageStats(),
        binding: GetBindingBuilder.lazyPut(() => PageStatsController()),
        preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: GetRoutes.login,
        page: () => const PageLogin(),
        binding: GetBindingBuilder.lazyPut(() => PageLoginController()),
        preventDuplicateHandlingMode: DuplicateMode.popUntilOriginalRoute,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: GetRoutes.scanner,
        page: () => const PageScanner(),
        binding: GetBindingBuilder.lazyPut(() => PageScannerController()),
        preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: GetRoutes.webview,
        page: () => PageWebview(),
        preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: true,
      ),
      GetPage(
        name: GetRoutes.register,
        page: () => const PageRegister(),
        binding: GetBindingBuilder.lazyPut(() => PageRegisterController()),
        preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: GetRoutes.operater,
        page: () => const PageOperater(),
        binding: GetBindingBuilder.lazyPut(() => PageOperaterController()),
        preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: false,
      ),
      GetPage(
        name: GetRoutes.settings,
        page: () => const PageSettings(),
        binding: GetBindingBuilder.lazyPut(() => PageSettingsController()),
        preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: false,
        children: [
          GetPage(
            name: GetRoutes.langs,
            page: () => const PageLangs(),
            binding: GetBindingBuilder.lazyPut(() => PageLangsController()),
            preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
            middlewares: [GetNavigateMiddleware(priority: 0)],
            popGesture: false,
          ),
          GetPage(
            name: GetRoutes.logger,
            page: () => const PageLogger(),
            binding: GetBindingBuilder.lazyPut(() => PageLoggerController()),
            preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
            middlewares: [GetNavigateMiddleware(priority: 0)],
            popGesture: false,
          ),
          GetPage(
            name: GetRoutes.profile,
            page: () => const PageProfile(),
            binding: GetBindingBuilder.lazyPut(() => PageProfileController()),
            preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
            middlewares: [GetNavigateMiddleware(priority: 0)],
            popGesture: false,
          ),
        ],
      ),
      GetPage(
        name: GetRoutes.notification,
        page: () => const PageNotification(),
        binding: GetBindingBuilder.lazyPut(() => PageNotificationController()),
        preventDuplicateHandlingMode: DuplicateMode.reorderRoutes,
        middlewares: [GetNavigateMiddleware(priority: 0)],
        popGesture: false,
      ),
    ];
  }
}
