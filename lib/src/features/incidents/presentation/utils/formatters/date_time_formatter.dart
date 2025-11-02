// lib/src/features/incidents/presentation/formatters/date_time_formatter.dart
import 'package:intl/intl.dart';

/// Utilidad centralizada para formateo de fechas en el módulo de incidencias
class DateTimeFormatter {
  DateTimeFormatter._(); // Constructor privado para clase estática

  /// Formato de fecha corto: dd/MM/yyyy
  /// Ejemplo: 15/03/2024
  static String formatShortDate(DateTime date) {
    return DateFormat('dd/MM/yyyy').format(date);
  }

  /// Formato de fecha y hora: dd/MM/yyyy HH:mm
  /// Ejemplo: 15/03/2024 14:30
  static String formatDateTime(DateTime date) {
    return DateFormat('dd/MM/yyyy HH:mm').format(date);
  }

  /// Formato de tiempo relativo: "Ahora", "Hace 2h", "Hace 3d", etc.
  /// Si pasan más de 7 días, muestra fecha corta
  static String formatRelativeTime(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Ahora';
    } else if (difference.inHours < 1) {
      return 'Hace ${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return 'Hace ${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays}d';
    } else {
      return formatShortDate(date);
    }
  }

  /// Formato de fecha legible: dd MMM yyyy
  /// Ejemplo: 15 Mar 2024
  static String formatReadableDate(DateTime date) {
    return DateFormat('dd MMM yyyy', 'es_ES').format(date);
  }

  /// Formato de fecha y hora legible: dd MMM yyyy - HH:mm
  /// Ejemplo: 15 Mar 2024 - 14:30
  static String formatReadableDateTime(DateTime date) {
    return DateFormat('dd MMM yyyy - HH:mm', 'es_ES').format(date);
  }
}
