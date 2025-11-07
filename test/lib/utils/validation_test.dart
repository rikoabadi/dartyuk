import 'package:dartyuk/utils/validation.dart';
import 'package:test/test.dart';

void main() {
  group('Validator.validateCreateTodo', () {
    test('should pass validation with valid data', () {
      final data = {
        'title': 'Test Todo',
        'description': 'Test description',
        'completed': false,
      };

      final result = Validator.validateCreateTodo(data);

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('should fail validation when title is missing', () {
      final data = {
        'description': 'Test description',
      };

      final result = Validator.validateCreateTodo(data);

      expect(result.isValid, isFalse);
      expect(result.errors.length, equals(1));
      expect(result.errors.first.field, equals('title'));
      expect(result.errors.first.message, equals('Title is required'));
    });

    test('should fail validation when title is empty', () {
      final data = {
        'title': '',
      };

      final result = Validator.validateCreateTodo(data);

      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.field == 'title'), isTrue);
    });

    test('should fail validation when title is too long', () {
      final data = {
        'title': 'a' * 201,
      };

      final result = Validator.validateCreateTodo(data);

      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.field == 'title'), isTrue);
    });

    test('should fail validation when description is too long', () {
      final data = {
        'title': 'Test Todo',
        'description': 'a' * 2001,
      };

      final result = Validator.validateCreateTodo(data);

      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.field == 'description'), isTrue);
    });

    test('should fail validation when completed is not a boolean', () {
      final data = {
        'title': 'Test Todo',
        'completed': 'yes',
      };

      final result = Validator.validateCreateTodo(data);

      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.field == 'completed'), isTrue);
    });

    test('should fail validation with unknown fields', () {
      final data = {
        'title': 'Test Todo',
        'unknown_field': 'value',
      };

      final result = Validator.validateCreateTodo(data);

      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.field == 'fields'), isTrue);
    });

    test('should allow optional fields to be omitted', () {
      final data = {
        'title': 'Test Todo',
      };

      final result = Validator.validateCreateTodo(data);

      expect(result.isValid, isTrue);
    });
  });

  group('Validator.validateUpdateTodo', () {
    test('should pass validation with valid partial data', () {
      final data = {
        'title': 'Updated Todo',
      };

      final result = Validator.validateUpdateTodo(data);

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('should pass validation with empty update', () {
      final data = <String, dynamic>{};

      final result = Validator.validateUpdateTodo(data);

      expect(result.isValid, isTrue);
      expect(result.errors, isEmpty);
    });

    test('should fail validation when title is empty', () {
      final data = {
        'title': '',
      };

      final result = Validator.validateUpdateTodo(data);

      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.field == 'title'), isTrue);
    });

    test('should fail validation with unknown fields', () {
      final data = {
        'unknown_field': 'value',
      };

      final result = Validator.validateUpdateTodo(data);

      expect(result.isValid, isFalse);
      expect(result.errors.any((e) => e.field == 'fields'), isTrue);
    });
  });
}
