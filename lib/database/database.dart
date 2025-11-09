import 'package:sqlite3/sqlite3.dart';

class DatabaseManager {
  static Database? _database;
  static const String _dbName = 'dartyuk.db';

  static Database get database {
    if (_database == null) {
      throw StateError('Database not initialized. Call initialize() first.');
    }
    return _database!;
  }

  static void initialize({String? dbPath}) {
    final path = dbPath ?? _dbName;
    _database = sqlite3.open(path);
    _createTables();
    _createIndexes();
  }

  static void _createTables() {
    _database!.execute('''
      CREATE TABLE IF NOT EXISTS todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        description TEXT,
        completed INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        deleted_at TEXT
      )
    ''');
  }

  static void _createIndexes() {
    _database!.execute('''
      CREATE INDEX IF NOT EXISTS idx_todos_created_at ON todos(created_at)
    ''');
    _database!.execute('''
      CREATE INDEX IF NOT EXISTS idx_todos_completed ON todos(completed)
    ''');
    _database!.execute('''
      CREATE INDEX IF NOT EXISTS idx_todos_deleted_at ON todos(deleted_at)
    ''');
  }

  static void close() {
    _database?.dispose();
    _database = null;
  }

  static void reset() {
    if (_database != null) {
      _database!.execute('DROP TABLE IF EXISTS todos');
      _createTables();
      _createIndexes();
    }
  }
}
