import 'package:get/get.dart';
import 'package:dompet/configure/sqflite.dart';
import 'package:dompet/extension/bool.dart';
import 'package:dompet/database/user.dart';
import 'package:dompet/database/app.dart';
import 'package:dompet/service/bind.dart';
import 'package:dompet/models/user.dart';

class SqliteController extends GetxService {
  late final storeController = Get.find<StoreController>();
  late final userDBName = 'dompet.user.db';
  late final appDBName = 'dompet.app.db';
  late User? nowUser;

  @override
  void onInit() async {
    super.onInit();
    await initAppDatabase();
  }

  // 创建/关闭/销毁 App Database
  Future<void> initAppDatabase() async {
    if (AppDatabaser.isClosed) {
      await openAppDatabase();
    }

    if (AppDatabaser.isCreated) {
      await initUserDatabase();
    }
  }

  Future<void> openAppDatabase() async {
    if (AppDatabaser.isCreated) {
      return;
    }

    AppDatabaser.db = await Sqfliter.openDatabase(
      appDBName,
      version: 1,
      singleInstance: true,
      onCreate: (db, v1) async {
        return AppDatabaser.create(db);
      },
    );
  }

  Future<void> closeAppDatabase() async {
    AppDatabaser.close();
  }

  Future<void> deleteAppDatabase() async {
    await closeAppDatabase();
    await Sqfliter.deleteDatabase(appDBName);
  }

  // 创建/关闭/销毁 User Database
  Future<void> initUserDatabase() async {
    nowUser = (await AppDatabaser.findRecentUser());
    storeController.createUser(nowUser);
    await openUserDatabase();
  }

  Future<void> openUserDatabase() async {
    if (nowUser == null) {
      return;
    }

    if (!nowUser!.uid.bv) {
      return;
    }

    UserDatabaser.db = await Sqfliter.openDatabase(
      appDBName,
      version: 1,
      subName: nowUser!.uid,
      readOnly: false,
      singleInstance: true,
      onCreate: (db, v1) async {
        UserDatabaser.create(db);
      },
    );
  }

  Future<void> closeUserDatabase() async {
    UserDatabaser.close();
    nowUser = null;
  }

  Future<void> deleteUserDatabase() async {
    if (nowUser == null) {
      return;
    }

    if (!nowUser!.uid.bv) {
      return;
    }

    final uid = nowUser!.uid;
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
