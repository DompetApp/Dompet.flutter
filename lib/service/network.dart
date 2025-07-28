import 'dart:async';
import 'package:get/get.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class NetworkController extends GetxService {
  late final connectionChecker = InternetConnectionChecker.createInstance(
    addresses: [AddressCheckOption(uri: Uri.parse('https://pub.dev/'))],
    connectivity: connectivity,
  );

  late final connectController = StreamController<bool>.broadcast();
  late final connectivity = Connectivity();
  late final available = true.obs;

  @override
  void onInit() async {
    super.onInit();

    available.value = await connectionChecker.hasConnection;

    connectivity.onConnectivityChanged.listen((results) {
      if (!results.contains(ConnectivityResult.none)) {
        return;
      }

      if (available.value) {
        connectController.add(false);
        available.value = false;
        return;
      }
    });

    connectionChecker.onStatusChange.listen((status) {
      final state = status == InternetConnectionStatus.connected;

      if (available.value == state) {
        return;
      }

      connectController.add(state);
      available.value = state;
    });
  }

  @override
  void onClose() {
    connectionChecker.dispose();
    connectController.close();
    super.onClose();
  }
}
