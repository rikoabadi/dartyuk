import 'package:dart_frog/dart_frog.dart';
import 'package:dartyuk/database/database.dart';
import 'package:dartyuk/middleware/error_handler.dart';

Handler middleware(Handler handler) {
  // Initialize database if not already initialized
  try {
    DatabaseManager.database;
  } catch (e) {
    DatabaseManager.initialize();
  }

  return handler.use(errorHandler());
}
