// lib/src/features/incidents/presentation/utils/converters/incident_converters.dart

import '../../../../../core/core_domain/entities/incident_entity.dart';

/// Utilidades compartidas para conversión de datos de incidencias
/// Convierte enums a strings legibles y viceversa
class IncidentConverters {
  IncidentConverters._(); // Private constructor para prevenir instanciación

  // ============================================================================
  // Conversión de Tipos a Labels
  // ============================================================================

  /// Convierte IncidentType enum a string legible en español
  static String getTypeLabel(IncidentType type) {
    switch (type) {
      case IncidentType.progressReport:
        return 'Avance';
      case IncidentType.problem:
        return 'Problema';
      case IncidentType.consultation:
        return 'Consulta';
      case IncidentType.safetyIncident:
        return 'Seguridad';
      case IncidentType.materialRequest:
        return 'Material';
    }
  }

  /// Convierte IncidentStatus enum a string legible en español
  static String getStatusLabel(IncidentStatus status) {
    switch (status) {
      case IncidentStatus.open:
        return 'Abierta';
      case IncidentStatus.closed:
        return 'Cerrada';
    }
  }

  /// Convierte IncidentPriority enum a string legible en español
  static String getPriorityLabel(IncidentPriority priority) {
    switch (priority) {
      case IncidentPriority.low:
        return 'Baja';
      case IncidentPriority.normal:
        return 'Normal';
      case IncidentPriority.high:
        return 'Alta';
      case IncidentPriority.critical:
        return 'Crítica';
    }
  }

  // ============================================================================
  // Conversión de Strings a Enums
  // ============================================================================

  /// Convierte string a IncidentType enum
  static IncidentType getIncidentTypeFromString(String typeStr) {
    switch (typeStr.toLowerCase()) {
      case 'avance':
      case 'progressreport':
        return IncidentType.progressReport;
      case 'problema':
      case 'problem':
        return IncidentType.problem;
      case 'consulta':
      case 'consultation':
        return IncidentType.consultation;
      case 'seguridad':
      case 'safetyincident':
        return IncidentType.safetyIncident;
      case 'material':
      case 'materialrequest':
        return IncidentType.materialRequest;
      default:
        return IncidentType.progressReport; // Default
    }
  }

  /// Convierte string a IncidentStatus enum
  static IncidentStatus getIncidentStatusFromString(String statusStr) {
    switch (statusStr.toLowerCase()) {
      case 'abierta':
      case 'open':
        return IncidentStatus.open;
      case 'cerrada':
      case 'closed':
        return IncidentStatus.closed;
      default:
        return IncidentStatus.open; // Default
    }
  }

  // ============================================================================
  // Helpers de Títulos y Descripción
  // ============================================================================

  /// Obtiene el prefijo del título basado en el tipo
  static String getTitlePrefix(IncidentType type) {
    return getTypeLabel(type);
  }

  /// Genera título completo con formato estándar
  static String generateTitle(IncidentType type, String customTitle) {
    final prefix = getTitlePrefix(type);
    return customTitle.isEmpty ? prefix : '$prefix - $customTitle';
  }

  // ============================================================================
  // Validaciones Comunes
  // ============================================================================

  /// Valida si una incidencia está cerrada
  static bool isClosed(IncidentEntity incident) {
    return incident.status == IncidentStatus.closed;
  }

  /// Valida si una incidencia es crítica
  static bool isCritical(IncidentEntity incident) {
    return incident.priority == IncidentPriority.critical;
  }

  /// Valida si un título es válido
  static bool isValidTitle(String title) {
    return title.trim().isNotEmpty && title.trim().length >= 3;
  }

  /// Valida si una descripción es válida
  static bool isValidDescription(String description) {
    return description.trim().isNotEmpty && description.trim().length >= 10;
  }

  // ============================================================================
  // Validadores de Formularios Reutilizables
  // ============================================================================

  /// Validador genérico para campos de texto requeridos con longitud mínima
  /// Retorna null si es válido, o un mensaje de error si no lo es
  static String? validateTextField({
    required String? value,
    required String fieldName,
    int minLength = 10,
  }) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    if (value.trim().length < minLength) {
      return '$fieldName debe tener al menos $minLength caracteres';
    }
    return null;
  }

  /// Validador específico para descripciones (min 10 caracteres)
  static String? validateDescription(String? value) {
    return validateTextField(
      value: value,
      fieldName: 'La descripción',
      minLength: 10,
    );
  }

  /// Validador específico para notas de cierre (min 10 caracteres)
  static String? validateCloseNote(String? value) {
    return validateTextField(
      value: value,
      fieldName: 'La nota de cierre',
      minLength: 10,
    );
  }

  /// Validador específico para explicaciones/correcciones (min 10 caracteres)
  static String? validateExplanation(String? value) {
    return validateTextField(
      value: value,
      fieldName: 'La explicación',
      minLength: 10,
    );
  }

  /// Validador específico para notas (min 5 caracteres)
  static String? validateNote(String? value) {
    return validateTextField(
      value: value,
      fieldName: 'La nota',
      minLength: 5,
    );
  }

  /// Validador para campos numéricos
  static String? validateNumericField(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName es obligatorio';
    }
    final number = int.tryParse(value);
    if (number == null || number <= 0) {
      return '$fieldName debe ser un número mayor a 0';
    }
    return null;
  }

  // ============================================================================
  // Helpers de UI
  // ============================================================================

  /// Mensaje de error por defecto cuando no hay usuario autenticado
  static const String noAuthUserError = 'Error: No se encontró usuario autenticado';

  /// Obtiene el texto de un estado inicial genérico
  static const String loadingInitialText = 'Cargando...';

  /// Obtiene el texto de un estado vacío genérico
  static const String emptyStateText = 'No hay elementos para mostrar';
}
