import 'package:dartyuk/database/database.dart';
import 'package:dartyuk/repositories/todo_repository.dart';
import 'package:test/test.dart';

void main() {
  late TodoRepository repository;

  setUp(() {
    // Initialize in-memory database for testing
    DatabaseManager.initialize(dbPath: ':memory:');
    repository = TodoRepository();
  });

  tearDown(() {
    DatabaseManager.close();
  });

  group('TodoRepository', () {
    test('should create a todo', () {
      final todo = repository.create(
        title: 'Test Todo',
        description: 'Test description',
        completed: false,
      );

      expect(todo.id, isNotNull);
      expect(todo.title, equals('Test Todo'));
      expect(todo.description, equals('Test description'));
      expect(todo.completed, equals(false));
      expect(todo.deletedAt, isNull);
    });

    test('should find todo by id', () {
      final created = repository.create(
        title: 'Test Todo',
        description: 'Test description',
      );

      final found = repository.findById(created.id!);

      expect(found, isNotNull);
      expect(found!.id, equals(created.id));
      expect(found.title, equals('Test Todo'));
    });

    test('should return null when todo not found', () {
      final found = repository.findById(999);

      expect(found, isNull);
    });

    test('should list all todos', () {
      repository.create(title: 'Todo 1', description: 'Desc 1');
      repository.create(title: 'Todo 2', description: 'Desc 2');
      repository.create(title: 'Todo 3', description: 'Desc 3');

      final todos = repository.findAll();

      expect(todos.length, equals(3));
    });

    test('should paginate todos', () {
      for (var i = 1; i <= 5; i++) {
        repository.create(title: 'Todo $i');
      }

      final page1 = repository.findAll(page: 1, limit: 2);
      final page2 = repository.findAll(page: 2, limit: 2);

      expect(page1.length, equals(2));
      expect(page2.length, equals(2));
      expect(page1.first.id, isNot(equals(page2.first.id)));
    });

    test('should count todos', () {
      repository.create(title: 'Todo 1');
      repository.create(title: 'Todo 2');
      repository.create(title: 'Todo 3');

      final count = repository.count();

      expect(count, equals(3));
    });

    test('should filter by completed status', () {
      repository.create(title: 'Todo 1', completed: true);
      repository.create(title: 'Todo 2', completed: false);
      repository.create(title: 'Todo 3', completed: true);

      final completed = repository.findAll(completed: true);
      final notCompleted = repository.findAll(completed: false);

      expect(completed.length, equals(2));
      expect(notCompleted.length, equals(1));
    });

    test('should search in title and description', () {
      repository.create(title: 'Important Todo', description: 'Work task');
      repository.create(title: 'Shopping', description: 'Buy groceries');
      repository.create(title: 'Exercise', description: 'Important workout');

      final results = repository.findAll(search: 'Important');

      expect(results.length, equals(2));
    });

    test('should sort by title', () {
      repository.create(title: 'Zebra');
      repository.create(title: 'Apple');
      repository.create(title: 'Mango');

      final ascending = repository.findAll(sort: 'title', order: 'asc');

      expect(ascending.first.title, equals('Apple'));
      expect(ascending.last.title, equals('Zebra'));
    });

    test('should update todo', () {
      final created = repository.create(title: 'Original Title');

      final updated = repository.update(created.id!, {
        'title': 'Updated Title',
        'completed': true,
      });

      expect(updated, isNotNull);
      expect(updated!.title, equals('Updated Title'));
      expect(updated.completed, equals(true));
      expect(updated.updatedAt.isAfter(created.updatedAt), isTrue);
    });

    test('should return null when updating non-existent todo', () {
      final result = repository.update(999, {'title': 'Updated'});

      expect(result, isNull);
    });

    test('should soft delete todo', () {
      final created = repository.create(title: 'Test Todo');

      final deleted = repository.delete(created.id!);

      expect(deleted, isTrue);

      final found = repository.findById(created.id!);
      expect(found, isNull);

      final foundWithDeleted = repository.findById(
        created.id!,
        includeDeleted: true,
      );
      expect(foundWithDeleted, isNotNull);
      expect(foundWithDeleted!.deletedAt, isNotNull);
    });

    test('should not include deleted todos in list by default', () {
      repository.create(title: 'Todo 1');
      final todo2 = repository.create(title: 'Todo 2');
      repository.create(title: 'Todo 3');

      repository.delete(todo2.id!);

      final todos = repository.findAll();
      expect(todos.length, equals(2));

      final todosWithDeleted = repository.findAll(includeDeleted: true);
      expect(todosWithDeleted.length, equals(3));
    });

    test('should return false when deleting non-existent todo', () {
      final result = repository.delete(999);

      expect(result, isFalse);
    });
  });
}
