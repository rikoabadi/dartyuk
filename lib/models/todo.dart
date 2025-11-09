class Todo {
  final int? id;
  final String title;
  final String? description;
  final bool completed;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deletedAt;

  Todo({
    this.id,
    required this.title,
    this.description,
    required this.completed,
    required this.createdAt,
    required this.updatedAt,
    this.deletedAt,
  });

  factory Todo.fromJson(Map<String, dynamic> json) {
    return Todo(
      id: json['id'] as int?,
      title: json['title'] as String,
      description: json['description'] as String?,
      completed: json['completed'] == true || json['completed'] == 1,
      createdAt: json['created_at'] is String
          ? DateTime.parse(json['created_at'] as String)
          : json['created_at'] as DateTime,
      updatedAt: json['updated_at'] is String
          ? DateTime.parse(json['updated_at'] as String)
          : json['updated_at'] as DateTime,
      deletedAt: json['deleted_at'] != null
          ? (json['deleted_at'] is String
              ? DateTime.parse(json['deleted_at'] as String)
              : json['deleted_at'] as DateTime)
          : null,
    );
  }

  Map<String, dynamic> toJson({bool includeId = true}) {
    final json = <String, dynamic>{
      'title': title,
      'description': description,
      'completed': completed,
      'created_at': createdAt.toUtc().toIso8601String(),
      'updated_at': updatedAt.toUtc().toIso8601String(),
      'deleted_at': deletedAt?.toUtc().toIso8601String(),
    };

    if (includeId && id != null) {
      json['id'] = id;
    }

    return json;
  }

  factory Todo.fromRow(Map<String, dynamic> row) {
    return Todo(
      id: row['id'] as int,
      title: row['title'] as String,
      description: row['description'] as String?,
      completed: (row['completed'] as int) == 1,
      createdAt: DateTime.parse(row['created_at'] as String),
      updatedAt: DateTime.parse(row['updated_at'] as String),
      deletedAt: row['deleted_at'] != null
          ? DateTime.parse(row['deleted_at'] as String)
          : null,
    );
  }

  Todo copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? deletedAt,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
    );
  }
}
