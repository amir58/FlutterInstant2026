class DbTables {
  DbTables._();

  static const String fileName = 'masrofy.db';
  static const int version = 1;

  static const String categories = 'categories';
  static const String expenses = 'expenses';

  static const String createCategories = '''
    CREATE TABLE categories (
      id    INTEGER PRIMARY KEY AUTOINCREMENT,
      name  TEXT    NOT NULL UNIQUE,
      color INTEGER NOT NULL
    )
  ''';

  static const String createExpenses = '''
    CREATE TABLE expenses (
      id              INTEGER PRIMARY KEY AUTOINCREMENT,
      title           TEXT    NOT NULL,
      amount_piasters INTEGER NOT NULL CHECK (amount_piasters > 0),
      category_id     INTEGER NOT NULL
                      REFERENCES categories (id) ON DELETE RESTRICT,
      spent_at        INTEGER NOT NULL,
      is_recurring    INTEGER NOT NULL DEFAULT 0
    )
  ''';

  static const List<Map<String, Object>> defaultCategories = [
    {'name': 'أكل وشرب', 'color': 0xFFF59E0B},
    {'name': 'مواصلات', 'color': 0xFF38BDF8},
    {'name': 'فواتير', 'color': 0xFFA78BFA},
    {'name': 'ترفيه', 'color': 0xFFF472B6},
    {'name': 'هدايا', 'color': 0xFF34D399},
  ];
}