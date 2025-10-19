import 'package:dompet/models/web.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/routes/vendor.dart';
import 'package:dompet/routes/routes.dart';

class GetNavigateMiddleware extends GetMiddleware {
  GetNavigateMiddleware({super.priority});

  @override
  RouteSettings? redirect(String? route) {
    return null;
  }

  @override
  Future<RouteDecoder?> redirectDelegate(RouteDecoder route) async {
    final logined = Get.find<StoreController>().logined;
    final arguments = route.pageSettings?.arguments;
    final name = route.pageSettings?.name;

    if (GetRoutes.flipping.contains(name)) {
      final orientations = [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ];
      SystemChrome.setPreferredOrientations(orientations);
    }

    if (!GetRoutes.flipping.contains(name)) {
      SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    }

    if (logined.value && GetRoutes.defaults.contains(name)) {
      return null;
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
