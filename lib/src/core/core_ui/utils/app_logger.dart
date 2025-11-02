import 'package:flutter/foundation.dart';

/// Pequeño wrapper de logging para centralizar impresiones de debug.
class AppLogger {
  AppLogger._();

  static void d(String message) {
    if (!kReleaseMode) {
      debugPrint(message);
    }
  }

  static void e(String message, [Object? error, StackTrace? stackTrace]) {
    if (!kReleaseMode) {
      debugPrint('ERROR: $message');
      if (error != null) debugPrint(error.toString());
      if (stackTrace != null) debugPrint(stackTrace.toString());
    }
  }
}
