import 'package:get/get.dart';
import 'package:dompet/configure/sqflite.dart';
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

    if (AppDatabaser.isClosed) {
      await openAppDatabase();
    }

    if (AppDatabaser.isCreated) {
      nowUser = (await AppDatabaser.findRecentUser());
      storeController.storeUser(nowUser);
      await openUserDatabase();
    }
  }

  // 创建/关闭/销毁 App Database
  Future<dynamic> openAppDatabase() async {
    if (AppDatabaser.isCreated) {
      return;
    }

    await Sqfliter.openDatabase(
      appDBName,
      version: 1,
      readOnly: false,
      singleInstance: true,
      onCreate: (db, v1) async {
        return AppDatabaser.create(db);
      },
    );
  }

  Future<dynamic> closeAppDatabase() async {
    AppDatabaser.close();
  }

  Future<dynamic> deleteAppDatabase() async {
    await closeAppDatabase();
    await Sqfliter.deleteDatabase(appDBName);
  }

  // 创建/关闭/销毁 User Database
  Future<dynamic> openUserDatabase() async {
    if (nowUser?.key == '') {
      return;
    }

    if (nowUser?.key == null) {
      return;
    }

    await Sqfliter.openDatabase(
      appDBName,
      version: 1,
      subName: nowUser!.key,
      readOnly: false,
      singleInstance: true,
      onCreate: (db, v1) async {
        UserDatabaser.create(db);
      },
    );
  }

  Future<dynamic> closeUserDatabase() async {
    UserDatabaser.close();
    nowUser = null;
  }

  Future<dynamic> deleteUserDatabase() async {
    if (nowUser?.key == '') {
      return;
    }

    if (nowUser?.key == null) {
      return;
    }

    final key = nowUser!.key;
    await closeUserDatabase();
    await Sqfliter.deleteDatabase(userDBName, subName: key);
    await AppDatabaser.deleteUser(key);
  }

  // 关闭/删除/清理 所有 Database
  Future<dynamic> closeAllDatabases() async {
    await closeUserDatabase();
    await closeAppDatabase();
  }

  Future<dynamic> deleteAllDatabases() async {
    await deleteUserDatabase();
    await deleteAppDatabase();
  }

  Future<dynamic> clearAllDatabases() async {
    await deleteAllDatabases();
    await Sqfliter.clearDatabase();
  }
}
