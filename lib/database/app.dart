import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:dompet/models/user.dart';

class AppDatabaser {
  static Database? db;
  static bool isClosed = true;
  static bool isCreated = false;

  static Future<void> close() async {
    await db?.close();
    AppDatabaser.db = null;
    AppDatabaser.isClosed = true;
    AppDatabaser.isCreated = false;
  }

  static Future<void> create(Database? db) async {
    if (db != null) {
      AppDatabaser.db = db;
      AppDatabaser.isClosed = false;
      AppDatabaser.isCreated = true;

      return db.execute(
        '''
        CREATE TABLE AppUser (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          key TEXT NOT NULL,
          name TEXT,
          email TEXT,
          avatar BLOB,
          password TEXT NOT NULL,
          activate TEXT NOT NULL DEFAULT 'Y',
          create_date TEXT NOT NULL
        )
        ''',
      );
    }
  }

  static Future<void> creatUser(User user) async {
    if (user.key != '') {
      final dater = DateFormat('yyyy-MM-dd HH:mm:ss');

      return db!.transaction((txn) async {
        await txn.rawUpdate(
          'update AppUser set activate = "N" where activate == "Y"',
        );

        final result = await txn.rawQuery(
          'select count(*) from AppUser where key == ${user.key}',
        );

        if (result.isNotEmpty) {
          await txn.rawUpdate(
            'update AppUser set create_date = ?, activate = ? where key == ?',
            [dater.format(DateTime.now()), 'Y', user.key],
          );
        }

        if (!result.isNotEmpty) {
          await txn.rawInsert(
            'insert into AppUser(key, name, email, avatar, password, create_date, activate) VALUES(?, ?, ?, ?, ?, ?, ?)',
            [
              user.key,
              user.name,
              user.email,
              user.avatar,
              user.password,
              dater.format(DateTime.now()),
              user.activate,
            ],
          );
        }
      });
    }
  }

  static Future<void> updateUser(User user) async {
    if (user.key != '') {
      final dater = DateFormat('yyyy-MM-dd HH:mm:ss');

      return db!.transaction((txn) async {
        final result = await txn.rawQuery(
          'select count(*) from AppUser where key == ${user.key}',
        );

        if (result.isNotEmpty) {
          await txn.rawUpdate(
            'update AppUser set name = ?, email = ?, avatar = ?, password = ?, create_date = ?, activate = ? where key == ?',
            [
              user.name,
              user.email,
              user.avatar,
              user.password,
              dater.format(DateTime.now()),
              user.activate,
              user.key,
            ],
          );
        }
      });
    }
  }

  static Future<void> deleteUser(String key) async {
    return db!.transaction((txn) async {
      txn.rawDelete('Delete from AppUser where key == $key');
    });
  }

  static Future<User?> queryUser(String key) async {
    return db?.transaction<User?>((txn) async {
      final result = await txn.rawQuery(
        '''
        select 
          id,
          key,
          name,
          email,
          avatar,
          password,
          activate,
          create_date
        from AppUser 
        where key = $key
        ''',
      );

      if (result.isNotEmpty) {
        return User.from(result[0]);
      }

      return null;
    });
  }

  static Future<User?> findRecentUser() async {
    return db?.transaction<User?>((txn) async {
      final result = await txn.rawQuery(
        '''
        select 
          id,
          key,
          name,
          email,
          avatar,
          password,
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
