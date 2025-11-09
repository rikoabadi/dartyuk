import 'package:dart_frog/dart_frog.dart';
import 'package:dartyuk/models/api_response.dart';

Middleware errorHandler() {
  return (handler) {
    return (context) async {
      try {
        return await handler(context);
      } catch (error, stackTrace) {
        // Log the error
        print('Error: $error');
        print('Stack trace: $stackTrace');

        // Return a generic error response
        final response = ApiResponse<dynamic>.error(
          ApiError(
            code: 'INTERNAL_ERROR',
            message: 'An internal error occurred',
            details: null,
          ),
        );

        return Response.json(
          statusCode: 500,
          body: response.toJson(),
        );
      }
    };
  };
}
