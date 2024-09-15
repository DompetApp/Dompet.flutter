import 'dart:async';
import 'package:get/get.dart';
import 'package:dompet/models/socket.dart';

class SocketController extends GetxService {
  StreamController<SocketMeta> controller = StreamController.broadcast();
  get listen => controller.stream.listen;
  get add => controller.sink.add;

  @override
  void onClose() {
    super.onClose();
    controller.close();
  }
}
