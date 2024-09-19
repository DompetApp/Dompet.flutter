import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dompet/routes/pages.dart';
import 'package:dompet/themes/light.dart';
import 'package:dompet/service/bind.dart';

const pingUrl = 'https://pub.dev/';
final navigatorKey = GlobalKey<NavigatorState>();
final routeObserver = RouteObserver<ModalRoute<void>>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  await GetStorage.init('dompet.store');
  await Firebase.initializeApp();
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
      initialRoute: GetRoutes.login,
      navigatorKey: navigatorKey,
      getPages: GetRoutes.pages(),
      theme: lightTheme,
      title: 'Dompet',
    );
  }
}
