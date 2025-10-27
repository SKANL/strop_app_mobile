// lib/src/core/core_ui/extensions/date_time_extensions.dart
import 'package:intl/intl.dart';

/// Extensions útiles para DateTime.
///
/// Proporciona formateo y manipulación de fechas de manera conveniente.
extension DateTimeX on DateTime {
  /// Formatea la fecha como "dd/MM/yyyy"
  String toFormattedDate() {
    return DateFormat('dd/MM/yyyy').format(this);
  }

  /// Formatea la fecha y hora como "dd/MM/yyyy HH:mm"
  String toFormattedDateTime() {
    return DateFormat('dd/MM/yyyy HH:mm').format(this);
  }

  /// Formatea solo la hora como "HH:mm"
  String toFormattedTime() {
    return DateFormat('HH:mm').format(this);
  }

  /// Formatea la fecha de manera relativa (Hoy, Ayer, hace X días)
  String toRelativeString() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final dateToCheck = DateTime(year, month, day);
    final difference = today.difference(dateToCheck).inDays;

    if (difference == 0) {
      return 'Hoy a las ${toFormattedTime()}';
    } else if (difference == 1) {
      return 'Ayer a las ${toFormattedTime()}';
    } else if (difference < 7) {
      return 'Hace $difference días';
    } else if (difference < 30) {
      final weeks = (difference / 7).floor();
      return weeks == 1 ? 'Hace 1 semana' : 'Hace $weeks semanas';
    } else if (difference < 365) {
      final months = (difference / 30).floor();
      return months == 1 ? 'Hace 1 mes' : 'Hace $months meses';
    } else {
      final years = (difference / 365).floor();
      return years == 1 ? 'Hace 1 año' : 'Hace $years años';
    }
  }

  /// Retorna true si la fecha es hoy
  bool get isToday {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }

  /// Retorna true si la fecha es ayer
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return year == yesterday.year &&
        month == yesterday.month &&
        day == yesterday.day;
  }

  /// Retorna true si la fecha es de esta semana
  bool get isThisWeek {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return isAfter(startOfWeek.subtract(const Duration(days: 1))) &&
        isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  /// Retorna true si la fecha es de este mes
  bool get isThisMonth {
    final now = DateTime.now();
    return year == now.year && month == now.month;
  }

  /// Retorna true si la fecha es de este año
  bool get isThisYear {
    return year == DateTime.now().year;
  }

  /// Copia la fecha con nuevos valores
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return DateTime(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }

  /// Retorna el inicio del día (00:00:00)
  DateTime get startOfDay {
    return DateTime(year, month, day);
  }

  /// Retorna el fin del día (23:59:59)
  DateTime get endOfDay {
    return DateTime(year, month, day, 23, 59, 59, 999);
  }

  /// Retorna el primer día del mes
  DateTime get firstDayOfMonth {
    return DateTime(year, month, 1);
  }

  /// Retorna el último día del mes
  DateTime get lastDayOfMonth {
    return DateTime(year, month + 1, 0);
  }
}
