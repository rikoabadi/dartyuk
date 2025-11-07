class ValidationError {
  final String field;
  final String message;

  ValidationError(this.field, this.message);

  Map<String, dynamic> toJson() {
    return {
      'field': field,
      'message': message,
    };
  }
}

class ValidationResult {
  final bool isValid;
  final List<ValidationError> errors;

  ValidationResult({required this.isValid, this.errors = const []});

  factory ValidationResult.success() {
    return ValidationResult(isValid: true);
  }

  factory ValidationResult.failure(List<ValidationError> errors) {
    return ValidationResult(isValid: false, errors: errors);
  }
}

class Validator {
  static ValidationResult validateCreateTodo(Map<String, dynamic> data) {
    final errors = <ValidationError>[];

    // Check for unknown fields
    final allowedFields = {'title', 'description', 'completed'};
    final providedFields = data.keys.toSet();
    final unknownFields = providedFields.difference(allowedFields);
    if (unknownFields.isNotEmpty) {
      errors.add(
        ValidationError(
          'fields',
          'Unknown fields: ${unknownFields.join(', ')}',
        ),
      );
    }

    // Validate title
    if (!data.containsKey('title') || data['title'] == null) {
      errors.add(ValidationError('title', 'Title is required'));
    } else if (data['title'] is! String) {
      errors.add(ValidationError('title', 'Title must be a string'));
    } else {
      final title = data['title'] as String;
      if (title.isEmpty) {
        errors.add(ValidationError('title', 'Title cannot be empty'));
      } else if (title.length < 1 || title.length > 200) {
        errors.add(
          ValidationError('title', 'Title must be between 1 and 200 characters'),
        );
      }
    }

    // Validate description
    if (data.containsKey('description') && data['description'] != null) {
      if (data['description'] is! String) {
        errors.add(ValidationError('description', 'Description must be a string'));
      } else {
        final description = data['description'] as String;
        if (description.length > 2000) {
          errors.add(
            ValidationError('description', 'Description must be at most 2000 characters'),
          );
        }
      }
    }

    // Validate completed
    if (data.containsKey('completed') && data['completed'] != null) {
      if (data['completed'] is! bool) {
        errors.add(ValidationError('completed', 'Completed must be a boolean'));
      }
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }

  static ValidationResult validateUpdateTodo(Map<String, dynamic> data) {
    final errors = <ValidationError>[];

    // Check for unknown fields
    final allowedFields = {'title', 'description', 'completed'};
    final providedFields = data.keys.toSet();
    final unknownFields = providedFields.difference(allowedFields);
    if (unknownFields.isNotEmpty) {
      errors.add(
        ValidationError(
          'fields',
          'Unknown fields: ${unknownFields.join(', ')}',
        ),
      );
    }

    // Validate title if provided
    if (data.containsKey('title')) {
      if (data['title'] == null) {
        errors.add(ValidationError('title', 'Title cannot be null'));
      } else if (data['title'] is! String) {
        errors.add(ValidationError('title', 'Title must be a string'));
      } else {
        final title = data['title'] as String;
        if (title.isEmpty) {
          errors.add(ValidationError('title', 'Title cannot be empty'));
        } else if (title.length < 1 || title.length > 200) {
          errors.add(
            ValidationError('title', 'Title must be between 1 and 200 characters'),
          );
        }
      }
    }

    // Validate description if provided
    if (data.containsKey('description') && data['description'] != null) {
      if (data['description'] is! String) {
        errors.add(ValidationError('description', 'Description must be a string'));
      } else {
        final description = data['description'] as String;
        if (description.length > 2000) {
          errors.add(
            ValidationError('description', 'Description must be at most 2000 characters'),
          );
        }
      }
    }

    // Validate completed if provided
    if (data.containsKey('completed') && data['completed'] != null) {
      if (data['completed'] is! bool) {
        errors.add(ValidationError('completed', 'Completed must be a boolean'));
      }
    }

    return errors.isEmpty
        ? ValidationResult.success()
        : ValidationResult.failure(errors);
  }
}
