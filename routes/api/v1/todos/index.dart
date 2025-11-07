import 'package:dart_frog/dart_frog.dart';
import 'package:dartyuk/repositories/todo_repository.dart';
import 'package:dartyuk/utils/request_helper.dart';
import 'package:dartyuk/utils/validation.dart';

Future<Response> onRequest(RequestContext context) async {
  final repository = TodoRepository();

  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGet(context, repository);
    case HttpMethod.post:
      return _handlePost(context, repository);
    default:
      return errorResponse(
        statusCode: 405,
        code: 'METHOD_NOT_ALLOWED',
        message: 'Method not allowed',
      );
  }
}

Response _handleGet(RequestContext context, TodoRepository repository) {
  // Parse query parameters
  final page = parseIntQueryParam(context.request, 'page', defaultValue: 1) ?? 1;
  var limit = parseIntQueryParam(context.request, 'limit', defaultValue: 20) ?? 20;
  
  // Enforce max limit of 100
  if (limit > 100) {
    limit = 100;
  }
  
  final sort = parseStringQueryParam(context.request, 'sort', defaultValue: 'created_at') ?? 'created_at';
  final order = parseStringQueryParam(context.request, 'order', defaultValue: 'desc') ?? 'desc';
  final completed = parseBoolQueryParam(context.request, 'completed');
  final search = parseStringQueryParam(context.request, 'q');
  final includeDeleted = parseBoolQueryParam(context.request, 'include_deleted') ?? false;

  // Get todos from repository
  final todos = repository.findAll(
    page: page,
    limit: limit,
    sort: sort,
    order: order,
    completed: completed,
    search: search,
    includeDeleted: includeDeleted,
  );

  // Get total count
  final total = repository.count(
    completed: completed,
    search: search,
    includeDeleted: includeDeleted,
  );

  // Convert todos to JSON
  final todosJson = todos.map((todo) => todo.toJson()).toList();

  return successListResponse(
    todosJson,
    page: page,
    limit: limit,
    total: total,
  );
}

Future<Response> _handlePost(RequestContext context, TodoRepository repository) async {
  // Parse request body
  final body = await parseJsonBody(context.request);
  
  if (body == null) {
    return errorResponse(
      statusCode: 400,
      code: 'INVALID_REQUEST',
      message: 'Invalid JSON in request body',
    );
  }

  // Validate input
  final validationResult = Validator.validateCreateTodo(body);
  if (!validationResult.isValid) {
    return errorResponse(
      statusCode: 422,
      code: 'VALIDATION_ERROR',
      message: 'Validation failed',
      details: validationResult.errors.map((e) => e.toJson()).toList(),
    );
  }

  // Create todo
  final todo = repository.create(
    title: body['title'] as String,
    description: body['description'] as String?,
    completed: body['completed'] as bool? ?? false,
  );

  return successResponse(todo.toJson(), statusCode: 201);
}
