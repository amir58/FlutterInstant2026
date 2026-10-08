import 'package:navigations/core/database/db_tables.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper();

  Future<Database>? _database;

  Future<Database> get database => _database ??= _open();

  Future<Database> _open() async {
    try {
      return await openDatabase(
        DbTables.fileName,
        version: DbTables.version,
        onConfigure: _onConfigure,
        onCreate: _onCreate,
      );
    } catch (_) {
      _database =
          null; // الفتح فشل؟ النداء الجاي يحاول من الأول بدل ما يفضل فاشل للأبد
      rethrow;
    }
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DbTables.createCategories);
    await db.execute(DbTables.createExpenses);

    final batch = db.batch();
    for (final category in DbTables.defaultCategories) {
      batch.insert(DbTables.categories, category);
    }
    await batch.commit(noResult: true);
  }

  Future<void> close() async {
    final pending = _database;
    _database = null;
    if (pending != null) await (await pending).close();
  }
}
