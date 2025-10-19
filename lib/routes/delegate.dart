import 'package:flutter/material.dart';
import 'package:dompet/routes/vendor.dart';
import 'package:dompet/routes/router.dart';

final rootBackButtonDispatcher = RootBackButtonDispatcher();
final rootRouteObserver = RouteObserver<ModalRoute>();
final rootObservers = [rootRouteObserver];

class AppDelegate extends GetDelegate {
  AppDelegate({
    super.navigatorKey,
    super.showHashOnUrl,
    super.notFoundRoute,
    super.transitionDelegate,
    super.preventDuplicateHandlingMode,
    super.restorationScopeId,
    super.backButtonPopMode,
    required super.pages,
  }) : super(
         navigatorObservers: rootObservers,
         pickPagesForRootNavigator: (decoder) {
           final routes = GetRouter.flatten('/') ?? [];
           return Get.rootController.rootDelegate.activePages
               .where((p) => routes.any((r) => r.name == p.route?.name))
               .where((p) => p.route != null)
               .map((p) => p.route!)
               .toList();
         },
       );
}
