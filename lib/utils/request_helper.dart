import 'dart:convert';
import 'package:dart_frog/dart_frog.dart';
import '../models/api_response.dart';

Future<Map<String, dynamic>?> parseJsonBody(Request request) async {
  try {
    final body = await request.body();
    if (body.isEmpty) {
      return null;
    }
    return jsonDecode(body) as Map<String, dynamic>;
  } catch (e) {
    return null;
  }
}

Response jsonResponse({
  required int statusCode,
  required Map<String, dynamic> body,
}) {
  return Response.json(
    statusCode: statusCode,
    body: body,
  );
}

Response successResponse<T>(T data, {int statusCode = 200}) {
  final response = ApiResponse<T>.success(data);
  return jsonResponse(
    statusCode: statusCode,
    body: response.toJson(),
  );
}

Response successListResponse<T>(
  List<T> data, {
  required int page,
  required int limit,
  required int total,
  int statusCode = 200,
}) {
  final response = ApiResponse<List<T>>.success(
    data,
    meta: PaginationMeta(page: page, limit: limit, total: total),
  );
  return jsonResponse(
    statusCode: statusCode,
    body: response.toJson(),
  );
}

Response errorResponse({
  required int statusCode,
  required String code,
  required String message,
  dynamic details,
}) {
  final response = ApiResponse<dynamic>.error(
    ApiError(code: code, message: message, details: details),
  );
  return jsonResponse(
    statusCode: statusCode,
    body: response.toJson(),
  );
}

int? parseIntQueryParam(Request request, String key, {int? defaultValue}) {
  final value = request.uri.queryParameters[key];
  if (value == null) return defaultValue;
  return int.tryParse(value) ?? defaultValue;
}

String? parseStringQueryParam(Request request, String key, {String? defaultValue}) {
  return request.uri.queryParameters[key] ?? defaultValue;
}

bool? parseBoolQueryParam(Request request, String key) {
  final value = request.uri.queryParameters[key];
  if (value == null) return null;
  if (value.toLowerCase() == 'true') return true;
  if (value.toLowerCase() == 'false') return false;
  return null;
}
