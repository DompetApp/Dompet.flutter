import 'package:sqflite/sqflite.dart';
import 'package:dompet/extension/bool.dart';

class UserDatabaser {
  static Database? db;
  static get isClosed => !db.bv;
  static get isCreated => db.bv;

  static Future<void> close() async {
    await db?.close();
    UserDatabaser.db = null;
  }

  static Future<void> create(Database? db) async {
    if (db.bv) {
      UserDatabaser.db = db;

      return db!.execute(
        '''
        CREATE TABLE AppMessage (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          payer TEXT,
          title TEXT NOT NULL,
          message TEXT NOT NULL,
          timestamp INTEGER NOT NULL
        )
        ''',
      );
    }
  }
}
