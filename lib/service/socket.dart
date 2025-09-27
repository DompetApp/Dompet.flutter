import 'dart:async';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:flutter/widgets.dart';
import 'package:dompet/service/network.dart';
import 'package:web_socket_channel/io.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/logger/logger.dart';
import 'package:dompet/models/socket.dart';
import 'package:dompet/utils/empty.dart';

typedef Callback = SocketCallback;

class IOSocketController extends GetxService {
  late final List<SocketSubscribe> queues = [];
  late final AppLifecycleListener appLifecycleListener;

  late final networkController = Get.find<NetworkController>();
  late final connectController = networkController.connectController;

  StreamSubscription<dynamic>? subscription;
  IOWebSocketChannel? channel;
  Worker? worker;
  Timer? timer;

  bool network = false;
  bool created = false;
  bool pinged = false;
  bool enable = false;
  bool showed = true;
  int times = 5000;
  int pings = 0;

  @override
  onInit() async {
    super.onInit();
    stageWatcher();
    netWatcher();
  }

  @override
  onClose() async {
    await closeWebSocket().catchError(Empty.fn);
    appLifecycleListener.dispose();
    subscription?.cancel();
    worker?.dispose();
    super.onClose();
  }

  Future<void> start() async {
    if (enable) {
      timer?.cancel();
      timer = Timer(times.milliseconds, start);
    }

    if (!enable) {
      closeWebSocket().catchError(Empty.fn);
      return;
    }

    if (!showed) {
      return;
    }

    if (!network) {
      return;
    }

    if (created.bv) {
      times = pinged || pings > 3 ? 5000 : 1000;
      pings = pinged || pings > 3 ? 0 : pings + 1;
      channel?.sink.add(jsonEncode({'type': 'ping', 'data': null}));
    }

    if (!channel.bv) {
      await connectWebSocket().catchError(Empty.fn);
      times = 5000;
      pings = 0;
    }
  }

  Future<void> close() async {
    closeWebSocket().catchError(Empty.fn);
  }

  Future<void> netWatcher() async {
    network = networkController.available.value;

    worker = ever(networkController.available, (status) {
      if (network == status) {
        return;
      }

      network = status;
      start();
    });
  }

  Future<void> stageWatcher() async {
    appLifecycleListener = AppLifecycleListener(
      onHide: () => showed = false,
      onShow: () {
        showed = true;
        start();
      },
    );
  }

  Future<void> resetWebSocket() async {
    timer?.cancel();

    if (channel.bv) {
      await channel?.sink.close().catchError(Empty.fn);
      await subscription?.cancel().catchError(Empty.fn);
    }

    timer = null;
    channel = null;
    subscription = null;
    created = false;
    pinged = false;
    times = 5000;
    pings = 0;

    start();
  }

  Future<void> closeWebSocket() async {
    timer?.cancel();

    if (channel.bv) {
      await channel?.sink.close().catchError(Empty.fn);
      await subscription?.cancel().catchError(Empty.fn);
    }

    timer = null;
    channel = null;
    subscription = null;
    created = false;
    pinged = false;
    times = 5000;
    pings = 0;
  }

  Future<void> connectWebSocket() async {
    try {
      channel?.sink.close();
      subscription?.cancel();

      channel = IOWebSocketChannel.connect(
        Uri.parse('wss://localhost/api'),
        headers: {},
      );

      pinged = false;
      times = 5000;
      pings = 0;

      await channel!.ready.then((_) {
        pings = 0;
        times = 5000;
        pinged = true;
        created = true;
        notifySocketSubscribe('connected');
        start().catchError(Empty.fn);
      });

      subscription = channel!.stream.listen(
        (event) => streamListenHandler(event),
        onError: (_) => resetWebSocket(),
        onDone: () => closeWebSocket(),
      );
    } catch (e) {
      logger.error('Socketor.channel connect: $e');
      resetWebSocket();
    }
  }

  Future<void> streamListenHandler(dynamic event) async {
    if (event is! String) {
      return;
    }

    try {
      final code = json.decode(event);
      final type = code['type'];
      final data = code['data'];

      switch (type) {
        case 'ping':
          {
            pinged = data == 'success';
            break;
          }
      }
    } catch (e) {
      logger.error('Socketor.stream event: $e');
    }
  }

  Future<void> notifySocketSubscribe(String type, [dynamic data]) async {
    for (final ref in queues) {
      if (ref.type == type) {
        try {
          ref.callback(type, data);
        } catch (e) {
          /* e */
        }
      }
    }
  }

  Future<void> destroySocketSubscribe(String type, Callback callback) async {
    queues.removeWhere((ref) => ref.type == type && ref.callback == callback);
  }

  Future<void> registerSocketSubscribe(String type, Callback callback) async {
    if (!queues.any((ref) => ref.type == type && ref.callback == callback)) {
      queues.add(SocketSubscribe(type: type, callback: callback));
    }
  }
}
