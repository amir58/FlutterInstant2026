
import 'package:navigations/core/database/db.dart';
import 'package:navigations/core/database/db_tables.dart';

import '../models/category_model.dart';
import '../models/category_total_model.dart';
import '../models/expense_model.dart';

abstract class ExpensesLocalDataSource {
  Future<List<CategoryModel>> getCategories();

  Future<List<ExpenseModel>> getExpenses({
    required int from,
    required int to,
    int? categoryId,
  });

  Future<List<CategoryTotalModel>> getTotals({required int from, required int to});

  Future<int> insertExpense(ExpenseModel expense);

  Future<int> updateExpense(ExpenseModel expense);

  Future<int> deleteExpense(int id);
}

class ExpensesLocalDataSourceImpl implements ExpensesLocalDataSource {
  final DatabaseHelper _dbHelper;
  const ExpensesLocalDataSourceImpl(this._dbHelper);

  @override
  Future<List<CategoryModel>> getCategories() async {
    final db = await _dbHelper.database;
    final rows = await db.query(DbTables.categories, orderBy: 'id');
    return rows.map(CategoryModel.fromMap).toList();
  }

  @override
  Future<List<ExpenseModel>> getExpenses({
    required int from,
    required int to,
    int? categoryId,
  }) async {
    final db = await _dbHelper.database;
    final rows = await db.rawQuery('''
      SELECT e.id, e.title, e.amount_piasters, e.spent_at, e.is_recurring,
             e.category_id,
             c.name  AS category_name,
             c.color AS category_color
      FROM expenses e
      INNER JOIN categories c ON c.id = e.category_id
      WHERE e.spent_at >= ? AND e.spent_at < ?
        AND (? IS NULL OR e.category_id = ?)
      ORDER BY e.spent_at DESC, e.id DESC
    ''', [from, to, categoryId, categoryId]);
    return rows.map(ExpenseModel.fromMap).toList();
  }

  @override
  Future<List<CategoryTotalModel>> getTotals({
    required int from,
    required int to,
  }) async {
    final db = await _dbHelper.database;
    final rows = await db.rawQuery('''
      SELECT c.id, c.name, c.color,
             SUM(e.amount_piasters) AS total_piasters
      FROM expenses e
      INNER JOIN categories c ON c.id = e.category_id
      WHERE e.spent_at >= ? AND e.spent_at < ?
      GROUP BY c.id, c.name, c.color
      ORDER BY total_piasters DESC
    ''', [from, to]);
    return rows.map(CategoryTotalModel.fromMap).toList();
  }

  @override
  Future<int> insertExpense(ExpenseModel expense) async {
    final db = await _dbHelper.database;
    return db.insert(DbTables.expenses, expense.toMap());
  }

  @override
  Future<int> updateExpense(ExpenseModel expense) async {
    final db = await _dbHelper.database;
    return db.update(
      DbTables.expenses,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  @override
  Future<int> deleteExpense(int id) async {
    final db = await _dbHelper.database;
    return db.delete(DbTables.expenses, where: 'id = ?', whereArgs: [id]);
  }
}