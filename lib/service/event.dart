import 'package:get/get.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/database/app.dart';
import 'package:dompet/database/user.dart';
import 'package:dompet/routes/router.dart';
import 'package:dompet/models/message.dart';
import 'package:dompet/models/order.dart';
import 'package:dompet/models/card.dart';
import 'package:dompet/models/user.dart';

class EventController extends GetxService {
  late final sqliteController = Get.find<SqliteController>();
  late final storeController = Get.find<StoreController>();

  // Auth
  Future<void> login() async {
    await sqliteController.initUserDatabase();

    final messages = await queryUserMessages();
    final orders = await queryUserOrders();
    final card = await queryUserCard();
    final user = await recentUser();

    await storeController.storeMessages(messages);
    await storeController.storeOrders(orders);
    await storeController.storeCard(card!);
    await storeController.storeUser(user!);
    await storeController.login();

    GetRouter.login();
  }

  Future<void> logout() async {
    await sqliteController.closeUserDatabase();

    await storeController.clearMessage();
    await storeController.clearOrder();
    await storeController.clearCard();
    await storeController.clearUser();
    await storeController.logout();

    GetRouter.logout();
  }

  // User
  Future<User?> recentUser() async {
    return AppDatabaser.recentUser();
  }

  Future<User?> updateUser(User user) async {
    return AppDatabaser.updateUser(user);
  }

  Future<User?> createUser(User user) async {
    return AppDatabaser.createUser(user);
  }

  // UserCard
  Future<Card?> queryUserCard() async {
    return UserDatabaser.queryUserCard();
  }

  Future<Card?> updateUserCard(Card card) async {
    return UserDatabaser.updateUserCard(card);
  }

  Future<Card?> createUserCard(Card card) async {
    return UserDatabaser.createUserCard(card);
  }

  // UserOrder
  Future<List<Order>> queryUserOrders() async {
    return UserDatabaser.queryUserOrders();
  }

  Future<List<Order>> createUserOrder(Object orders) async {
    return UserDatabaser.createUserOrder(orders);
  }

  // UserMessage
  Future<List<Message>> queryUserMessages() async {
    return UserDatabaser.queryUserMessages();
  }

  Future<List<Message>> createUserMessage(Object message) async {
    return UserDatabaser.createUserMessage(message);
  }
}