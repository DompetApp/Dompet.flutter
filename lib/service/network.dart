import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkController extends GetxService {
  late final connectionChecker = InternetConnection.createInstance(
    customCheckOptions: [
      InternetCheckOption(uri: Uri.parse('https://pub.dev')),
    ],
    enableStrictCheck: true,
    useDefaultOptions: false,
    checkInterval: 3.seconds,
  );

  late final List<StreamSubscription<dynamic>> connectSubscriptions = [];
  late final connectController = StreamController<bool>.broadcast();
  late final connectivity = Connectivity();
  late final available = true.obs;

  @override
  void onInit() async {
    super.onInit();

    final activityer = connectivity.onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        return;
      }

      if (available.value) {
        connectController.add(false);
        available.value = false;
        return;
      }
    });

    final statuser = connectionChecker.onStatusChange.listen((status) {
      final state = status == InternetStatus.connected;

      if (available.value == state) {
        return;
      }

      connectController.add(state);
      available.value = state;
    });

    available.value = await connectionChecker.hasInternetAccess;

    connectSubscriptions.addAll([statuser, activityer]);
  }

  @override
  void onClose() {
    for (var listener in connectSubscriptions) {
      listener.cancel();
    }

    connectSubscriptions.clear();
    connectController.close();
    super.onClose();
  }
}
