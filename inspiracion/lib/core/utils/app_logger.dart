import 'package:flutter/foundation.dart';

/// Sistema de logging centralizado con diferentes niveles de severidad
/// y capacidad de filtrado para debugging.
class AppLogger {
  static const String _prefix = '🔹 STROP';

  /// Niveles de logging
  static const int _levelDebug = 0;
  static const int _levelInfo = 1;
  static const int _levelWarning = 2;
  static const int _levelError = 3;

  // Nivel mínimo para mostrar logs (cambia a _levelInfo en producción)
  static int _minLevel = kDebugMode ? _levelDebug : _levelInfo;

  /// Categorías de logs para filtrado fácil
  static const String categorySync = '📡 SYNC';
  static const String categoryDatabase = '💾 DB';
  static const String categoryNetwork = '🌐 NET';
  static const String categoryRepository = '📦 REPO';
  static const String categoryUI = '🎨 UI';
  static const String categoryAuth = '🔐 AUTH';

  /// Log de debug (solo en modo desarrollo)
  static void debug(String message, {String category = ''}) {
    _log(message, _levelDebug, '🐛', category);
  }

  /// Log de información general
  static void info(String message, {String category = ''}) {
    _log(message, _levelInfo, 'ℹ️', category);
  }

  /// Log de advertencia
  static void warning(String message, {String category = ''}) {
    _log(message, _levelWarning, '⚠️', category);
  }

  /// Log de error
  static void error(String message, {String category = '', Object? error, StackTrace? stackTrace}) {
    _log(message, _levelError, '❌', category);
    if (error != null) {
      debugPrint('   └─ Error: $error');
    }
    if (stackTrace != null && kDebugMode) {
      debugPrint('   └─ StackTrace:\n$stackTrace');
    }
  }

  /// Método privado para realizar el logging
  static void _log(String message, int level, String emoji, String category) {
    if (level < _minLevel) return;

    final timestamp = DateTime.now().toIso8601String().substring(11, 23); // HH:mm:ss.SSS
    final categoryTag = category.isNotEmpty ? ' $category' : '';
    final fullMessage = '$emoji $_prefix$categoryTag [$timestamp] $message';

    debugPrint(fullMessage);
  }

  /// Log especializado para sincronización
  static void sync(String message, {bool isError = false}) {
    if (isError) {
      error(message, category: categorySync);
    } else {
      info(message, category: categorySync);
    }
  }

  /// Log especializado para base de datos
  static void database(String message, {bool isError = false}) {
    if (isError) {
      error(message, category: categoryDatabase);
    } else {
      debug(message, category: categoryDatabase);
    }
  }

  /// Log especializado para red
  static void network(String message, {bool isError = false}) {
    if (isError) {
      error(message, category: categoryNetwork);
    } else {
      info(message, category: categoryNetwork);
    }
  }

  /// Log especializado para repositorio
  static void repository(String message, {bool isError = false}) {
    if (isError) {
      error(message, category: categoryRepository);
    } else {
      debug(message, category: categoryRepository);
    }
  }

  /// Configura el nivel mínimo de logging (útil para testing)
  static void setMinLevel(int level) {
    _minLevel = level;
  }
}
