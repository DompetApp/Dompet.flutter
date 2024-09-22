import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dompet/configure/get_translate.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/routes/pages.dart';
import 'package:dompet/themes/light.dart';

const pingUrl = 'https://pub.dev/';
const enUSLocale = Locale('en', 'US');
final translations = JsonTranslations();
final navigatorKey = GlobalKey<NavigatorState>();
final routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await GetStorage.init('dompet.store');
  await Firebase.initializeApp();
  await translations.init();
  runApp(const MyApp());
  runNet(pingUrl);
}

void runNet(String url) async {
  try {
    await Dio().get(url);
  } catch (e) {/* e */}
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> with WidgetsBindingObserver {
  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.put(MediaQueryController()).update(
        mediaQuery: MediaQuery.of(context),
      );
    });

    Get.put(LocaleController()).update(Get.locale ?? enUSLocale);
  }

  @override
  void didChangeMetrics() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      Get.find<MediaQueryController>().update(
        mediaQuery: MediaQuery.of(context),
      );
    });
  }

  @override
  void didChangeLocales(List<Locale>? locales) {
    if (locales != null && locales.isNotEmpty) {
      Get.updateLocale(locales.first);
    }

    if (locales == null || locales.isEmpty) {
      Get.find<LocaleController>().update(enUSLocale);
    }
  }

  @override
  void didChangeAppLifecycleState(state) {
    if (state == AppLifecycleState.resumed) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        Get.find<MediaQueryController>().update(
          mediaQuery: MediaQuery.of(context),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: (context, child) {
        return Obx(() {
          final mediaQuery = Get.find<MediaQueryController>();
          final textScaler = mediaQuery.textScaler.value;

          Widget builder(context) => child!;

          return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaler: textScaler),
            child: Overlay(initialEntries: [OverlayEntry(builder: builder)]),
          );
        });
      },
      debugShowCheckedModeBanner: false,
      navigatorObservers: [routeObserver],
      defaultTransition: Transition.rightToLeft,
      initialBinding: AllBinding(),
      fallbackLocale: enUSLocale,
      initialRoute: GetRoutes.login,
      navigatorKey: navigatorKey,
      translations: translations,
      getPages: GetRoutes.pages(),
      locale: Get.deviceLocale,
      theme: lightTheme,
      title: 'Dompet',
    );
  }
}
