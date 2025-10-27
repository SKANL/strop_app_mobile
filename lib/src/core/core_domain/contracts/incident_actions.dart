// lib/src/core/core_domain/contracts/incident_actions.dart

/// Interface Segregada - Acciones sobre incidencias (ISP)
/// 
/// Define SOLO las operaciones de acciones/workflow sobre incidencias
/// 
/// Usada por:
/// - IncidentActionsProvider
abstract class IIncidentActions {
  /// Asignar una incidencia a un usuario
  Future<void> assignIncident(String incidentId, String userId);

  /// Cerrar una incidencia
  Future<void> closeIncident(String incidentId, String closeNote);
}
