import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqflite.dart' show Database;
import 'package:dompet/configure/path_provider.dart';

class Sqfliter {
  static const defaultPath = 'sqflite/dompet';

  static Future<void> clearDatabase() async {
    final sqfliteRoot = await PathProvider.getApplicationDocumentsDirectory();
    final sqflitePath = join(sqfliteRoot.path, defaultPath);
    final sqfliteDir = Directory(sqflitePath);
    final sqfliteFile = File(sqflitePath);

    Future clearDatabase(String path) async {
      final file = File(path);
      final dir = Directory(path);
      final isDirectory = dir.existsSync();
      final isFile = file.existsSync();

      if (isDirectory) {
        for (final file in Directory(path).listSync()) {
          await clearDatabase(file.path);
        }
      }

      if (isFile && await sql.databaseExists(path)) {
        sql.deleteDatabase(path);
      }
    }

    await clearDatabase(sqflitePath);

    if (sqfliteDir.existsSync()) {
      sqfliteDir.deleteSync(recursive: true);
    }

    if (sqfliteFile.existsSync()) {
      sqfliteFile.deleteSync(recursive: true);
    }
  }

  static Future<void> deleteDatabase(
    String dbName, {
    String? subName,
  }) async {
    if (!RegExp(r'\.db$', caseSensitive: false).hasMatch(dbName)) {
      dbName = '$dbName.db';
    }

    final sqfliteRoot = await PathProvider.getApplicationDocumentsDirectory();
    final sqflitePath = join(sqfliteRoot.path, defaultPath, subName);
    final sqfliteFile = File(join(sqflitePath, dbName.toLowerCase()));

    if (await sql.databaseExists(sqfliteFile.path)) {
      await sql.deleteDatabase(sqfliteFile.path);
    }

    if (sqfliteFile.existsSync()) {
      sqfliteFile.deleteSync();
    }
  }

  static Future<Database> openDatabase(
    String dbName, {
    sql.OnDatabaseConfigureFn? onConfigure,
    sql.OnDatabaseVersionChangeFn? onUpgrade,
    sql.OnDatabaseVersionChangeFn? onDowngrade,
    sql.OnDatabaseCreateFn? onCreate,
    sql.OnDatabaseOpenFn? onOpen,
    bool singleInstance = true,
    bool readOnly = false,
    String? subName,
    int? version,
  }) async {
    if (!RegExp(r'\.db$', caseSensitive: false).hasMatch(dbName)) {
      dbName = '$dbName.db';
    }

    final sqfliteRoot = await PathProvider.getApplicationDocumentsDirectory();
    final sqflitePath = join(sqfliteRoot.path, defaultPath, subName);
    final sqfliteFile = join(sqflitePath, dbName.toLowerCase());
    final sqfliteDir = Directory(sqflitePath);

    if (!sqfliteDir.existsSync()) {
      sqfliteDir.createSync(recursive: true);
    }

    return sql.openDatabase(
      sqfliteFile,
      version: version,
      readOnly: readOnly,
      singleInstance: singleInstance,
      onConfigure: onConfigure,
      onDowngrade: onDowngrade,
      onUpgrade: onUpgrade,
      onCreate: onCreate,
      onOpen: onOpen,
    );
  }
}
