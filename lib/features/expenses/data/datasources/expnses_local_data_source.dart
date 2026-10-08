import 'package:navigations/core/database/db.dart';
import 'package:navigations/core/database/db_tables.dart';

class ExpensesLocalDataSource {
  final DatabaseHelper _dbHelper;
  const ExpensesLocalDataSource(this._dbHelper);

  Future<int> insertExpense() async {
    final db = await _dbHelper.database;

    final id = await db.insert(DbTables.expenses, {
      'title': 'شاورما',
      'amount_piasters': 9500,
      'category_id': 1,
      'spent_at': DateTime.now().millisecondsSinceEpoch,
      'is_recurring': 0,
    });

    return id;
  }
}
