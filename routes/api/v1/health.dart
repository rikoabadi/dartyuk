import 'package:dart_frog/dart_frog.dart';
import 'package:dartyuk/utils/request_helper.dart';

Response onRequest(RequestContext context) {
  if (context.request.method != HttpMethod.get) {
    return errorResponse(
      statusCode: 405,
      code: 'METHOD_NOT_ALLOWED',
      message: 'Method not allowed',
    );
  }

  final now = DateTime.now().toUtc();
  return successResponse({
    'status': 'ok',
    'time': now.toIso8601String(),
  });
}
