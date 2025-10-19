class GetRoutes {
  /// Route Root
  static const home = '/home';
  static const card = '/card';
  static const stats = '/stats';
  static const login = '/login';
  static const scanner = '/scanner';
  static const webview = '/webview';
  static const register = '/register';
  static const operater = '/operater';
  static const settings = '/settings';
  static const notification = '/notification';

  /// Route Settings
  static const langs = '/langs';
  static const logger = '/logger';
  static const profile = '/profile';

  /// Static Methods
  static String join(List<String> routes) {
    return routes.join('/').replaceAll(RegExp(r'/+'), '/');
  }

  static List<String> get authorize {
    return [
      GetRoutes.home,
      GetRoutes.card,
      GetRoutes.stats,
      GetRoutes.langs,
      GetRoutes.logger,
      GetRoutes.scanner,
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

  static List<String> get flipping {
    return [GetRoutes.stats, GetRoutes.logger, GetRoutes.webview];
  }
}
