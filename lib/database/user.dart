import 'package:sqflite/sqflite.dart';

class UserDatabaser {
  static Database? db;
  static bool isClosed = true;
  static bool isCreated = false;

  static Future<void> close() async {
    await db?.close();
    UserDatabaser.db = null;
    UserDatabaser.isClosed = true;
    UserDatabaser.isCreated = false;
  }

  static Future<void> create(Database? db) async {
    if (db != null) {
      UserDatabaser.db = db;
      UserDatabaser.isClosed = false;
      UserDatabaser.isCreated = true;

      return db.execute(
        '''
        CREATE TABLE AppMessage (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
        )
        ''',
      );
    }
  }
}
