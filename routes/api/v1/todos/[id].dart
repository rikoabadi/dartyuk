import 'package:dart_frog/dart_frog.dart';
import 'package:dartyuk/repositories/todo_repository.dart';
import 'package:dartyuk/utils/request_helper.dart';
import 'package:dartyuk/utils/validation.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  final repository = TodoRepository();
  
  // Parse id
  final todoId = int.tryParse(id);
  if (todoId == null) {
    return errorResponse(
      statusCode: 400,
      code: 'INVALID_ID',
      message: 'Invalid todo ID',
    );
  }

  switch (context.request.method) {
    case HttpMethod.get:
      return _handleGet(context, repository, todoId);
    case HttpMethod.patch:
      return _handlePatch(context, repository, todoId);
    case HttpMethod.delete:
      return _handleDelete(context, repository, todoId);
    default:
      return errorResponse(
        statusCode: 405,
        code: 'METHOD_NOT_ALLOWED',
        message: 'Method not allowed',
      );
  }
}

Response _handleGet(RequestContext context, TodoRepository repository, int id) {
  final todo = repository.findById(id);
  
  if (todo == null) {
    return errorResponse(
      statusCode: 404,
      code: 'NOT_FOUND',
      message: 'Todo not found',
    );
  }

  return successResponse(todo.toJson());
}

Future<Response> _handlePatch(
  RequestContext context,
  TodoRepository repository,
  int id,
) async {
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
  final validationResult = Validator.validateUpdateTodo(body);
  if (!validationResult.isValid) {
    return errorResponse(
      statusCode: 422,
      code: 'VALIDATION_ERROR',
      message: 'Validation failed',
      details: validationResult.errors.map((e) => e.toJson()).toList(),
    );
  }

  // Update todo
  final todo = repository.update(id, body);
  
  if (todo == null) {
    return errorResponse(
      statusCode: 404,
      code: 'NOT_FOUND',
      message: 'Todo not found',
    );
  }

  return successResponse(todo.toJson());
}

Response _handleDelete(RequestContext context, TodoRepository repository, int id) {
  final deleted = repository.delete(id);
  
  if (!deleted) {
    return errorResponse(
      statusCode: 404,
      code: 'NOT_FOUND',
      message: 'Todo not found',
    );
  }

  // Return 204 No Content
  return Response(statusCode: 204);
}
