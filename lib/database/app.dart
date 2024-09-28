import 'dart:typed_data';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dompet/models/user.dart';
import 'package:dompet/extension/bool.dart';

class AppDatabaser {
  static Database? db;
  static get isCreated => db.bv;

  // init
  static Future<void> close() async {
    await db?.close();
    AppDatabaser.db = null;
  }

  static Future<void> create(Database? db) async {
    if (db != null) {
      AppDatabaser.db = db;

      return db.execute(
        '''
        CREATE TABLE AppUser (
          uid TEXT PRIMARY KEY NOT NULL,
          name TEXT,
          email TEXT,
          avatar BLOB,
          activate TEXT NOT NULL DEFAULT 'Y',
          create_date TEXT NOT NULL
        )
        ''',
      );
    }
  }

  // User
  static Future<void> closeUser(String? uid) async {
    if (!uid.bv) {
      return;
    }

    return db!.transaction((txn) async {
      await txn.rawUpdate(
        'update AppUser set activate = ? where uid == ?',
        ['N', uid],
      );
    });
  }

  static Future<void> deleteUser(String? uid) async {
    if (!uid.bv) {
      return;
    }

    return db!.transaction((txn) async {
      txn.rawDelete('Delete from AppUser where uid == "$uid"');
    });
  }

  static Future<User?> createUser(User? user) async {
    if (user == null) {
      return null;
    }

    if (!user.uid.bv || !user.email.bv) {
      return null;
    }

    const format = 'yyyy-MM-dd HH:mm:ss';
    final formatter = DateFormat(format);

    return db!.transaction<User?>((txn) async {
      await txn.rawUpdate(
        'update AppUser set activate = "N" where activate == "Y"',
      );

      final list = await txn.rawQuery(
        'select uid, name, avatar from AppUser where email == ?',
        [user.email],
      );

      if (list.isNotEmpty) {
        final uid = list[0]['uid'];
        final name = (list[0]['name'] ?? '') as String;
        final avatar = list[0]['avatar'] as Uint8List?;
        final isChangeName = !name.bv && user.name.bv;
        final isChangeAvatar = !avatar.bv && user.avatar.bv;

        await txn.rawUpdate(
          'update AppUser set name = ?, avatar = ?, create_date = ?, activate = ? where uid == ?',
          [
            isChangeName ? user.name : name,
            isChangeAvatar ? user.avatar : avatar,
            formatter.format(DateTime.now()),
            'Y',
            uid,
          ],
        );

        return user;
      }

      if (list.isEmpty) {
        await txn.rawInsert(
          'insert into AppUser(uid, name, email, avatar, create_date, activate) VALUES(?, ?, ?, ?, ?, ?)',
          [
            user.uid,
            user.name,
            user.email,
            user.avatar,
            formatter.format(DateTime.now()),
            'Y',
          ],
        );

        return user;
      }

      return null;
    });
  }

  static Future<User?> updateUser(User? user) async {
    if (user == null) {
      return null;
    }

    if (!user.uid.bv || !user.email.bv) {
      return null;
    }

    const format = 'yyyy-MM-dd HH:mm:ss';
    final formatter = DateFormat(format);

    return db!.transaction<User?>((txn) async {
      final result = await txn.rawQuery(
        'select count(*) from AppUser where uid == "${user.uid}"',
      );

      if (result.isNotEmpty) {
        await txn.rawUpdate(
          'update AppUser set name = ?, email = ?, avatar = ?, create_date = ?, activate = ? where uid == ?',
          [
            user.name,
            user.email,
            user.avatar,
            formatter.format(DateTime.now()),
            user.activate,
            user.uid,
          ],
        );

        return user;
      }

      return null;
    });
  }

  static Future<User?> recentUser() async {
    return db?.transaction<User?>((txn) async {
      final result = await txn.rawQuery(
        '''
        select
          uid,
          name,
          email,
          avatar,
          activate,
          create_date
        from AppUser 
        where activate = "Y" 
        order by datetime(create_date) desc
        ''',
      );

      if (result.isNotEmpty) {
        return User.from(result[0]);
      }

      return null;
    });
  }
}
