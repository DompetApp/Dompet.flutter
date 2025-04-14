import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:dompet/configure/fluttertoast.dart';
import 'package:dompet/extension/money.dart';
import 'package:dompet/models/message.dart';
import 'package:dompet/models/operate.dart';
import 'package:dompet/routes/router.dart';
import 'package:dompet/models/order.dart';
import 'package:dompet/service/bind.dart';

class PageOperaterController extends GetxController {
  late final mediaQueryController = Get.find<MediaQueryController>();
  late final storeController = Get.find<StoreController>();
  late final eventController = Get.find<EventController>();

  late final mediaPadding = mediaQueryController.viewPadding;
  late final mediaTopBar = mediaQueryController.topBar;
  late final loginUser = storeController.user;

  late String type = Get.arguments ?? '';
  late Rx<List<PayOperate>> options;
  late Rx<PayOperate> operate;
  late Rx<double> money;

  @override
  onInit() {
    init(0.0);
    super.onInit();
  }

  void init(double num) {
    if (!['Payment', 'Top up'].contains(type)) {
      type = 'Transfer';
    }

    switch (type) {
      case 'Transfer':
        {
          operate = Rx(
            PayOperate(type: 'Payment', from: 'Me', to: 'David', id: '1'),
          );

          options = Rx([
            PayOperate(id: '1', to: 'David', from: 'Me', type: 'Payment'),
            PayOperate(id: '2', to: 'Emma', from: 'Me', type: 'Payment'),
            PayOperate(id: '3', to: 'Me', from: 'David', type: 'Receipt'),
            PayOperate(id: '4', to: 'Me', from: 'Emma', type: 'Receipt'),
          ]);

          break;
        }
      case 'Payment':
        {
          operate = Rx(
            PayOperate(type: 'Payment', from: 'Me', to: 'David', id: '5'),
          );

          options = Rx([
            PayOperate(id: '5', to: 'David', from: 'Me', type: 'Payment'),
            PayOperate(id: '6', to: 'Emma', from: 'Me', type: 'Payment'),
            PayOperate(id: '7', to: 'Netflix', from: 'Me', type: 'Payment'),
            PayOperate(id: '8', to: 'PayPal', from: 'Me', type: 'Payment'),
          ]);

          break;
        }
      case 'Top up':
        {
          operate = Rx(
            PayOperate(type: 'Receipt', from: 'David', to: 'Me', id: '9'),
          );

          options = Rx([
            PayOperate(id: '9', to: 'Me', from: 'David', type: 'Receipt'),
            PayOperate(id: '10', to: 'Me', from: 'Emma', type: 'Receipt'),
            PayOperate(id: '11', to: 'Me', from: 'Me', type: 'Receipt'),
          ]);
          break;
        }
    }

    money = num.obs;
  }

  void find(dynamic id) {
    operate.value = options.value.firstWhereOrNull((opt) => opt.id == id)!;
  }

  void addition(String num) {
    try {
      var cache = 0.0;
      final value = money.value.toInt();

      if (value != 0) {
        cache = double.parse('$value$num');
      }

      if (value == 0) {
        cache = double.parse(num);
      }

      if (cache > 999999.0) {
        Toaster.warning(
          message: 'The amount entered cannot exceed 999999.00'.tr,
        );
      }

      if (cache <= 999999.0) {
        money.value = cache;
      }
    } catch (e) {
      /* e */
    }
  }

  void delete(String? num) {
    try {
      var value = money.value.toInt();
      var input = value.toString();

      if (input != '') {
        input = input.substring(0, input.length - 1);
      }

      if (input != '') {
        money.value = double.parse(input);
      }

      if (input == '') {
        money.value = 0.0;
      }
    } catch (e) {
      /* e */
    }
  }

  void clear(String? num) {
    money.value = 0.0;
  }

  void pay() async {
    if (money.value <= 0.0) {
      return;
    }

    try {
      final now = DateTime.now();
      const format = 'yyyy-MM-dd HH:mm:ss';
      final formatter = DateFormat(format);
      final from = operate.value.from;
      final to = operate.value.to;

      if (type == 'Transfer' && operate.value.type == 'Payment') {
        final desc = 'You transferred money to $to';

        await eventController.createUserOrder([
          Order(
            type: type,
            name: to,
            icon: to.toLowerCase(),
            date: formatter.format(now),
            money: -money.value,
          ),
        ]);

        await eventController.createUserMessage([
          Message(
            type: 'Transfer',
            desc: desc,
            date: formatter.format(now),
            money: -money.value,
          ),
        ]);

        await FlutterRingtonePlayer().playNotification();

        Future.delayed(Duration(seconds: 3), () => money.value = 0.0);

        Toaster.success(
          message: '${desc.tr} (-${money.value.usd})',
          onTap: () => GetRouter.toNamed(GetRoutes.notification),
        );
      }

      if (type == 'Transfer' && operate.value.type == 'Receipt') {
        final desc = 'You received a transfer from $from';

        await eventController.createUserOrder([
          Order(
            type: type,
            name: from,
            icon: from.toLowerCase(),
            date: formatter.format(now),
            money: money.value,
          ),
        ]);

        await eventController.createUserMessage([
          Message(
            type: 'Transfer',
            desc: desc,
            date: formatter.format(now),
            money: money.value,
          ),
        ]);

        await FlutterRingtonePlayer().playNotification();

        Future.delayed(Duration(seconds: 3), () => money.value = 0.0);

        Toaster.success(
          message: '${desc.tr} (${money.value.usd})',
          onTap: () => GetRouter.toNamed(GetRoutes.notification),
        );
      }

      if (type == 'Payment') {
        final desc = 'You paid money to $to';

        await eventController.createUserOrder([
          Order(
            type: type,
            name: to,
            icon: to.toLowerCase(),
            date: formatter.format(now),
            money: -money.value,
          ),
        ]);

        await eventController.createUserMessage([
          Message(
            type: type,
            desc: desc,
            date: formatter.format(now),
            money: -money.value,
          ),
        ]);

        await FlutterRingtonePlayer().playNotification();

        Future.delayed(Duration(seconds: 3), () => money.value = 0.0);

        Toaster.success(
          message: '${desc.tr} (-${money.value.usd})',
          onTap: () => GetRouter.toNamed(GetRoutes.notification),
        );
      }

      if (type == 'Top up') {
        final desc =
            from != 'Me'
                ? 'You received a top-up from $from'
                : 'You top-up some money';

        await eventController.createUserOrder([
          Order(
            type: type,
            name: from,
            icon: from.toLowerCase(),
            date: formatter.format(now),
            money: money.value,
          ),
        ]);

        await eventController.createUserMessage([
          Message(
            type: type,
            desc: desc,
            date: formatter.format(now),
            money: money.value,
          ),
        ]);

        await FlutterRingtonePlayer().playNotification();

        Future.delayed(Duration(seconds: 3), () => money.value = 0.0);

        Toaster.success(
          message: '${desc.tr} (${money.value.usd})',
          onTap: () => GetRouter.toNamed(GetRoutes.notification),
        );
      }
    } catch (e) {
      Toaster.error(message: e.toString());
    }
  }
}
