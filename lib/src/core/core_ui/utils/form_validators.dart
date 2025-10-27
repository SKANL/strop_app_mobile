// lib/src/core/core_ui/utils/form_validators.dart

/// Clase utilitaria para validadores de formulario reutilizables
/// 
/// Centraliza la lógica de validación común en todos los formularios,
/// evitando duplicación de código y garantizando mensajes consistentes.
/// 
/// Ejemplo de uso:
/// ```dart
/// TextFormField(
///   validator: FormValidators.required('El nombre'),
///   // o componer validadores
///   validator: (value) {
///     final error = FormValidators.required('La descripción')(value);
///     if (error != null) return error;
///     return FormValidators.minLength(20)(value);
///   },
/// )
/// ```
class FormValidators {
  FormValidators._(); // Constructor privado para clase estática
  
  /// Validador para campos obligatorios
  /// 
  /// [fieldName] debe incluir artículo: "El nombre", "La contraseña", etc.
  static String? Function(String?) required(String fieldName) {
    return (value) {
      if (value == null || value.trim().isEmpty) {
        return '$fieldName es obligatorio';
      }
      return null;
    };
  }
  
  /// Validador para longitud mínima de texto
  /// 
  /// [minLength] longitud mínima requerida
  /// [fieldName] opcional, para mensaje personalizado
  static String? Function(String?) minLength(int minLength, [String? fieldName]) {
    return (value) {
      if (value != null && value.trim().length < minLength) {
        if (fieldName != null) {
          return '$fieldName debe tener al menos $minLength caracteres';
        }
        return 'Mínimo $minLength caracteres';
      }
      return null;
    };
  }
  
  /// Validador para longitud máxima de texto
  /// 
  /// [maxLength] longitud máxima permitida
  /// [fieldName] opcional, para mensaje personalizado
  static String? Function(String?) maxLength(int maxLength, [String? fieldName]) {
    return (value) {
      if (value != null && value.length > maxLength) {
        if (fieldName != null) {
          return '$fieldName no puede tener más de $maxLength caracteres';
        }
        return 'Máximo $maxLength caracteres';
      }
      return null;
    };
  }
  
  /// Validador para números positivos
  /// 
  /// Verifica que el valor sea un número válido mayor a 0
  static String? Function(String?) positiveNumber([String? fieldName]) {
    return (value) {
      if (value == null || value.isEmpty) {
        return fieldName != null ? '$fieldName es obligatorio' : 'Campo obligatorio';
      }
      final number = double.tryParse(value);
      if (number == null || number <= 0) {
        return fieldName != null ? '$fieldName inválido' : 'Número inválido';
      }
      return null;
    };
  }
  
  /// Validador para confirmación de contraseña
  /// 
  /// [passwordValue] el valor de la contraseña original a comparar
  static String? Function(String?) matchPassword(String passwordValue) {
    return (value) {
      if (value != passwordValue) {
        return 'Las contraseñas no coinciden';
      }
      return null;
    };
  }
  
  /// Combina múltiples validadores en uno solo
  /// 
  /// Ejecuta cada validador en orden y retorna el primer error encontrado
  static String? Function(String?) compose(List<String? Function(String?)> validators) {
    return (value) {
      for (final validator in validators) {
        final error = validator(value);
        if (error != null) return error;
      }
      return null;
    };
  }
}
