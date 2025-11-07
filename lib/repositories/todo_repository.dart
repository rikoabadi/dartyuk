import 'package:sqlite3/sqlite3.dart';
import '../database/database.dart';
import '../models/todo.dart';

class TodoRepository {
  final Database _db;

  TodoRepository() : _db = DatabaseManager.database;

  Todo create({
    required String title,
    String? description,
    bool completed = false,
  }) {
    final now = DateTime.now().toUtc();
    final result = _db.select(
      '''
      INSERT INTO todos (title, description, completed, created_at, updated_at)
      VALUES (?, ?, ?, ?, ?)
      RETURNING *
      ''',
      [
        title,
        description,
        completed ? 1 : 0,
        now.toIso8601String(),
        now.toIso8601String(),
      ],
    );

    return Todo.fromRow(result.first);
  }

  Todo? findById(int id, {bool includeDeleted = false}) {
    final query = includeDeleted
        ? 'SELECT * FROM todos WHERE id = ?'
        : 'SELECT * FROM todos WHERE id = ? AND deleted_at IS NULL';

    final result = _db.select(query, [id]);

    if (result.isEmpty) {
      return null;
    }

    return Todo.fromRow(result.first);
  }

  List<Todo> findAll({
    int page = 1,
    int limit = 20,
    String sort = 'created_at',
    String order = 'desc',
    bool? completed,
    String? search,
    bool includeDeleted = false,
  }) {
    final conditions = <String>[];
    final params = <Object>[];

    // Filter by deleted_at
    if (!includeDeleted) {
      conditions.add('deleted_at IS NULL');
    }

    // Filter by completed status
    if (completed != null) {
      conditions.add('completed = ?');
      params.add(completed ? 1 : 0);
    }

    // Search in title and description
    if (search != null && search.isNotEmpty) {
      conditions.add('(title LIKE ? OR description LIKE ?)');
      final searchPattern = '%$search%';
      params.add(searchPattern);
      params.add(searchPattern);
    }

    final whereClause = conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : '';

    // Validate sort field
    final validSortFields = ['created_at', 'title'];
    final sortField = validSortFields.contains(sort) ? sort : 'created_at';

    // Validate order
    final orderDir = order.toLowerCase() == 'asc' ? 'ASC' : 'DESC';

    // Calculate offset
    final offset = (page - 1) * limit;

    final query = '''
      SELECT * FROM todos
      $whereClause
      ORDER BY $sortField $orderDir
      LIMIT ? OFFSET ?
    ''';

    params.add(limit);
    params.add(offset);

    final result = _db.select(query, params);

    return result.map((row) => Todo.fromRow(row)).toList();
  }

  int count({
    bool? completed,
    String? search,
    bool includeDeleted = false,
  }) {
    final conditions = <String>[];
    final params = <Object>[];

    // Filter by deleted_at
    if (!includeDeleted) {
      conditions.add('deleted_at IS NULL');
    }

    // Filter by completed status
    if (completed != null) {
      conditions.add('completed = ?');
      params.add(completed ? 1 : 0);
    }

    // Search in title and description
    if (search != null && search.isNotEmpty) {
      conditions.add('(title LIKE ? OR description LIKE ?)');
      final searchPattern = '%$search%';
      params.add(searchPattern);
      params.add(searchPattern);
    }

    final whereClause = conditions.isNotEmpty ? 'WHERE ${conditions.join(' AND ')}' : '';

    final query = 'SELECT COUNT(*) as count FROM todos $whereClause';

    final result = _db.select(query, params);

    return result.first['count'] as int;
  }

  Todo? update(int id, Map<String, dynamic> updates) {
    // First, check if todo exists and is not deleted
    final existing = findById(id);
    if (existing == null) {
      return null;
    }

    final setClauses = <String>[];
    final params = <Object>[];

    if (updates.containsKey('title')) {
      setClauses.add('title = ?');
      params.add(updates['title'] as Object);
    }

    if (updates.containsKey('description')) {
      setClauses.add('description = ?');
      params.add(updates['description'] as Object? ?? '');
    }

    if (updates.containsKey('completed')) {
      setClauses.add('completed = ?');
      params.add(updates['completed'] == true ? 1 : 0);
    }

    if (setClauses.isEmpty) {
      return existing;
    }

    // Always update updated_at
    final now = DateTime.now().toUtc();
    setClauses.add('updated_at = ?');
    params.add(now.toIso8601String());

    // Add id to params
    params.add(id);

    final query = '''
      UPDATE todos
      SET ${setClauses.join(', ')}
      WHERE id = ? AND deleted_at IS NULL
    ''';

    _db.execute(query, params);

    return findById(id);
  }

  bool delete(int id) {
    // Soft delete: set deleted_at
    final existing = findById(id);
    if (existing == null) {
      return false;
    }

    final now = DateTime.now().toUtc();
    _db.execute(
      'UPDATE todos SET deleted_at = ? WHERE id = ?',
      [now.toIso8601String(), id],
    );

    return true;
  }
}
