// lib/src/core/core_ui/extensions/string_extensions.dart

/// Extensions útiles para String.
extension StringX on String {
  /// Capitaliza la primera letra
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  /// Capitaliza la primera letra de cada palabra
  String capitalizeWords() {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize()).join(' ');
  }

  /// Retorna true si el string es un email válido
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  /// Retorna true si el string es un número de teléfono válido (México)
  bool get isValidPhoneMX {
    final phoneRegex = RegExp(r'^(\+?52)?[0-9]{10}$');
    return phoneRegex.hasMatch(replaceAll(RegExp(r'[\s\-\(\)]'), ''));
  }

  /// Trunca el string a una longitud máxima con puntos suspensivos
  String truncate(int maxLength, {String ellipsis = '...'}) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength - ellipsis.length)}$ellipsis';
  }

  /// Remueve espacios en blanco al inicio y fin
  String get trimmed => trim();

  /// Remueve todos los espacios en blanco
  String get withoutSpaces => replaceAll(' ', '');

  /// Convierte el string a snake_case
  String toSnakeCase() {
    return replaceAllMapped(
      RegExp(r'[A-Z]'),
      (match) => '_${match.group(0)!.toLowerCase()}',
    ).replaceFirst(RegExp(r'^_'), '');
  }

  /// Convierte el string a camelCase
  String toCamelCase() {
    final words = split('_');
    if (words.length == 1) return this;
    return words.first +
        words
            .skip(1)
            .map((word) => word.capitalize())
            .join('');
  }

  /// Retorna true si el string es null o está vacío
  bool get isNullOrEmpty => isEmpty;

  /// Retorna true si el string no es null ni está vacío
  bool get isNotNullOrEmpty => isNotEmpty;
}

/// Extensions útiles para String? (nullable).
extension NullableStringX on String? {
  /// Retorna true si el string es null o está vacío
  bool get isNullOrEmpty => this == null || this!.isEmpty;

  /// Retorna true si el string no es null ni está vacío
  bool get isNotNullOrEmpty => this != null && this!.isNotEmpty;

  /// Retorna el string o un valor por defecto si es null
  String orDefault(String defaultValue) => this ?? defaultValue;

  /// Retorna el string o una cadena vacía si es null
  String get orEmpty => this ?? '';
}
