import 'package:dartyuk/models/todo.dart';
import 'package:test/test.dart';

void main() {
  group('Todo', () {
    test('should create a Todo instance', () {
      final now = DateTime.now().toUtc();
      final todo = Todo(
        id: 1,
        title: 'Test Todo',
        description: 'Test description',
        completed: false,
        createdAt: now,
        updatedAt: now,
      );

      expect(todo.id, equals(1));
      expect(todo.title, equals('Test Todo'));
      expect(todo.description, equals('Test description'));
      expect(todo.completed, equals(false));
      expect(todo.createdAt, equals(now));
      expect(todo.updatedAt, equals(now));
      expect(todo.deletedAt, isNull);
    });

    test('should convert Todo to JSON', () {
      final now = DateTime.parse('2025-11-07T00:00:00.000Z');
      final todo = Todo(
        id: 1,
        title: 'Test Todo',
        description: 'Test description',
        completed: true,
        createdAt: now,
        updatedAt: now,
      );

      final json = todo.toJson();

      expect(json['id'], equals(1));
      expect(json['title'], equals('Test Todo'));
      expect(json['description'], equals('Test description'));
      expect(json['completed'], equals(true));
      expect(json['created_at'], equals('2025-11-07T00:00:00.000Z'));
      expect(json['updated_at'], equals('2025-11-07T00:00:00.000Z'));
      expect(json['deleted_at'], isNull);
    });

    test('should create Todo from JSON', () {
      final json = {
        'id': 1,
        'title': 'Test Todo',
        'description': 'Test description',
        'completed': true,
        'created_at': '2025-11-07T00:00:00.000Z',
        'updated_at': '2025-11-07T00:00:00.000Z',
      };

      final todo = Todo.fromJson(json);

      expect(todo.id, equals(1));
      expect(todo.title, equals('Test Todo'));
      expect(todo.description, equals('Test description'));
      expect(todo.completed, equals(true));
      expect(
        todo.createdAt,
        equals(DateTime.parse('2025-11-07T00:00:00.000Z')),
      );
      expect(
        todo.updatedAt,
        equals(DateTime.parse('2025-11-07T00:00:00.000Z')),
      );
      expect(todo.deletedAt, isNull);
    });

    test('should handle completed as integer in fromJson', () {
      final json = {
        'title': 'Test Todo',
        'completed': 1,
        'created_at': '2025-11-07T00:00:00.000Z',
        'updated_at': '2025-11-07T00:00:00.000Z',
      };

      final todo = Todo.fromJson(json);

      expect(todo.completed, equals(true));
    });

    test('should copy Todo with updated fields', () {
      final now = DateTime.now().toUtc();
      final todo = Todo(
        id: 1,
        title: 'Test Todo',
        description: 'Test description',
        completed: false,
        createdAt: now,
        updatedAt: now,
      );

      final updated = todo.copyWith(title: 'Updated Todo', completed: true);

      expect(updated.id, equals(1));
      expect(updated.title, equals('Updated Todo'));
      expect(updated.description, equals('Test description'));
      expect(updated.completed, equals(true));
    });
  });
}
