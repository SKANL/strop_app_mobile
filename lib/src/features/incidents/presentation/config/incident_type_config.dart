// lib/src/features/incidents/presentation/config/incident_type_config.dart
import 'package:flutter/material.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';

/// Configuración centralizada para los tipos de incidencia
/// 
/// Define el color, icono y label para cada tipo de incidencia.
/// Evita duplicación de lógica en múltiples widgets.
class IncidentTypeConfig {
  IncidentTypeConfig._(); // Constructor privado para clase estática

  /// Obtiene el color asociado a un tipo de incidencia
  static Color getColor(IncidentType type) {
    switch (type) {
      case IncidentType.problem:
        return Colors.red;
      case IncidentType.progressReport:
        return Colors.blue;
      case IncidentType.consultation:
        return Colors.orange;
      case IncidentType.safetyIncident:
        return Colors.purple;
      case IncidentType.materialRequest:
        return Colors.green;
    }
  }

  /// Obtiene el icono asociado a un tipo de incidencia
  static IconData getIcon(IncidentType type) {
    switch (type) {
      case IncidentType.problem:
        return Icons.warning;
      case IncidentType.progressReport:
        return Icons.trending_up;
      case IncidentType.consultation:
        return Icons.help_outline;
      case IncidentType.safetyIncident:
        return Icons.security;
      case IncidentType.materialRequest:
        return Icons.build;
    }
  }

  /// Obtiene el label legible asociado a un tipo de incidencia
  static String getLabel(IncidentType type) {
    switch (type) {
      case IncidentType.problem:
        return 'Problema';
      case IncidentType.progressReport:
        return 'Avance';
      case IncidentType.consultation:
        return 'Consulta';
      case IncidentType.safetyIncident:
        return 'Seguridad';
      case IncidentType.materialRequest:
        return 'Material';
    }
  }

  /// Obtiene toda la configuración de un tipo en un solo objeto
  static IncidentTypeData getData(IncidentType type) {
    return IncidentTypeData(
      color: getColor(type),
      icon: getIcon(type),
      label: getLabel(type),
    );
  }
}

/// Clase de datos que agrupa color, icono y label de un tipo de incidencia
class IncidentTypeData {
  final Color color;
  final IconData icon;
  final String label;

  const IncidentTypeData({
    required this.color,
    required this.icon,
    required this.label,
  });
}
