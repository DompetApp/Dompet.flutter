import 'dart:io';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:dompet/configure/get_translate.dart';
import 'package:dompet/logger/logger.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/routes/pages.dart';
import 'package:dompet/theme/light.dart';

final translations = JsonTranslations();
final navigatorKey = GlobalKey<NavigatorState>();
final routeObserver = RouteObserver<ModalRoute<void>>();
const fallbackLocale = Locale('en', 'US');

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FlutterError.onError = (FlutterErrorDetails details) {
    final stack = details.stack;
    final exception = details.exception;

    if (exception is DioException || exception is WebSocketException) {
      return;
    }

    if (exception is Exception || exception is Error) {
      logger.error('App FlutterError.onError...', exception, stack);
      return;
    }
  };

  PlatformDispatcher.instance.onError = (Object error, StackTrace stack) {
    if (error is DioException || error is WebSocketException) {
      return true;
    }

    if (error is Exception || error is Error) {
      logger.error('App PlatformDispatcher.onError...', error, stack);
      return true;
    }

    return true;
  };

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  FirebaseAuth.instanceFor(app: await Firebase.initializeApp());

  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
      systemStatusBarContrastEnforced: false,
      statusBarColor: Colors.transparent,
    ),
  );

  await initializeDateFormatting('en_US');
  await initializeDateFormatting('zh_CN');
  await GetStorage.init('dompet.store');
  await translations.init();
  await logger.init;

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  Locale? get locale => storeController.locale.value ?? Get.deviceLocale;

  late final mediaQueryController = Get.put(MediaQueryController());
  late final localeController = Get.put(LocaleController());
  late final storeController = Get.put(StoreController());

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();

    localeController.update(locale);

    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      mediaQueryController.update(mediaQuery: MediaQuery.of(context));
    });
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null && locales.isNotEmpty) {
      Get.updateLocale(locales.first);
    }

    if (locales == null || locales.isEmpty) {
      Get.find<LocaleController>().update(fallbackLocale);
    }
  }

  @override
  void didChangeAppLifecycleState(state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        mediaQueryController.update(mediaQuery: MediaQuery.of(context));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQueryController.update(mediaQuery: MediaQuery.of(context));

    return GetMaterialApp(
      builder: (context, child) {
        return Obx(() {
          final mediaQuery = mediaQueryController;
          final textScaler = mediaQuery.textScaler.value;

          Widget builder(context) => child!;

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: Overlay(initialEntries: [OverlayEntry(builder: builder)]),
          );
        });
      },
      supportedLocales: [Locale('en'), Locale('zh')],
      localizationsDelegates: [
        GlobalWidgetsLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      defaultTransition: Transition.rightToLeft,
      logWriterCallback: logWriterCallback,
      fallbackLocale: fallbackLocale,
      initialRoute: GetRoutes.login,
      navigatorKey: navigatorKey,
      translations: translations,
      enableLog: kDebugMode,
      getPages: GetRoutes.pages(),
      locale: locale,
      theme: lightTheme,
      binds: bindings,
      title: 'Dompet',
    );
  }
}
