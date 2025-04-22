import 'package:get/get.dart';
import 'package:dompet/configure/sqflite.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/database/user.dart';
import 'package:dompet/database/app.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/models/user.dart';

class SqliteController extends GetxService {
  late final storeController = Get.find<StoreController>();
  late final eventController = Get.find<EventController>();
  late final userDBName = 'dompet.user.db';
  late final appDBName = 'dompet.app.db';
  late User? appUser;

  @override
  void onInit() async {
    super.onInit();
    await initAppDatabase();
  }

  // 创建/关闭/销毁 App Database
  Future<void> initAppDatabase() async {
    if (!AppDatabaser.created) {
      await openAppDatabase();
    }

    if (AppDatabaser.created) {
      appUser = await AppDatabaser.recentUser();
    }

    if (appUser != null) {
      !storeController.logined.value
          ? eventController.logout()
          : eventController.login();
    }
  }

  Future<void> openAppDatabase() async {
    if (AppDatabaser.created) {
      return;
    }

    AppDatabaser.db = await Sqfliter.openDatabase(
      appDBName,
      version: 1,
      singleInstance: true,
      onDowngrade: (db, v1, v2) async {},
      onUpgrade: (db, v1, v2) async {},
      onCreate: (db, v1) async {
        return AppDatabaser.create(db);
      },
    );
  }

  Future<void> closeAppDatabase() async {
    await AppDatabaser.close();
  }

  Future<void> deleteAppDatabase() async {
    await closeAppDatabase();
    await Sqfliter.deleteDatabase(appDBName);
  }

  // 创建/关闭/销毁 User Database
  Future<void> initUserDatabase() async {
    appUser ??= await AppDatabaser.recentUser();
    return openUserDatabase();
  }

  Future<void> openUserDatabase() async {
    if (appUser == null) {
      return;
    }

    if (!appUser!.uid.bv) {
      return;
    }

    UserDatabaser.db = await Sqfliter.openDatabase(
      appDBName,
      version: 1,
      subName: appUser!.uid,
      readOnly: false,
      singleInstance: true,
      onDowngrade: (db, v1, v2) async {},
      onUpgrade: (db, v1, v2) async {},
      onCreate: (db, v1) async {
        return UserDatabaser.create(db);
      },
    );
  }

  Future<void> closeUserDatabase() async {
    await AppDatabaser.closeUser(appUser?.uid);
    await UserDatabaser.close();
    appUser = null;
  }

  Future<void> deleteUserDatabase() async {
    if (appUser == null) {
      return;
    }

    if (!appUser!.uid.bv) {
      return;
    }

    final uid = appUser!.uid;
    await closeUserDatabase();
    await Sqfliter.deleteDatabase(userDBName, subName: uid);
    await AppDatabaser.deleteUser(uid);
  }

  // 关闭/删除/清理 所有 Database
  Future<void> closeAllDatabases() async {
    await closeUserDatabase();
    await closeAppDatabase();
  }

  Future<void> deleteAllDatabases() async {
    await deleteUserDatabase();
    await deleteAppDatabase();
  }

  Future<void> clearAllDatabases() async {
    await deleteAllDatabases();
    await Sqfliter.clearDatabase();
  }
}
