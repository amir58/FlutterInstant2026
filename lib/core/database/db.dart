import 'package:navigations/core/database/db_tables.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  DatabaseHelper();

  Future<Database>? _database;

  Future<Database> get database => _database ??= _open();

  Future<Database> _open() async {
    return openDatabase(
      DbTables.fileName,
      version: DbTables.version,
      onConfigure: _onConfigure,
      onCreate: _onCreate,
    );
  }

  Future<void> _onConfigure(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(DbTables.createCategories);
    await db.execute(DbTables.createExpenses);

    // seed = بذرة
    // seeder = بيضيف البيانات الاساسية في الداتا بيز 
    
    // batch = كذا عملية في رحلة واحدة للداتابيز
    final batch = db.batch();
    for (final category in DbTables.defaultCategories) {
      batch.insert(DbTables.categories, category);
    }
    await batch.commit(noResult: true);
  }
}
