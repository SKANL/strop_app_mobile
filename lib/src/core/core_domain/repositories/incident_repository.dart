// lib/src/core/core_domain/repositories/incident_repository.dart
import '../entities/incident_entity.dart';

/// Contrato de repositorio de incidencias - Core Domain
abstract class IncidentRepository {
  /// Obtener todas las incidencias de un proyecto
  Future<List<IncidentEntity>> getIncidentsByProject(String projectId);
  
  /// Obtener incidencias asignadas al usuario (Mis Tareas)
  Future<List<IncidentEntity>> getMyTasks(String userId, String projectId);
  
  /// Obtener incidencias creadas por el usuario (Mis Reportes)
  Future<List<IncidentEntity>> getMyReports(String userId, String projectId);
  
  /// Obtener una incidencia por ID
  Future<IncidentEntity> getIncidentById(String incidentId);
  
  /// Crear una nueva incidencia/reporte
  Future<IncidentEntity> createIncident(IncidentEntity incident);
  
  /// Asignar una incidencia a un usuario
  Future<IncidentEntity> assignIncident(String incidentId, String userId);
  
  /// Cerrar una incidencia
  Future<IncidentEntity> closeIncident(String incidentId, String closeNote);
  
  /// Agregar comentario a una incidencia
  Future<void> addComment(String incidentId, String comment);
  
  /// Registrar aclaración
  Future<void> addCorrection(String incidentId, String correction);
  
  /// Aprobar/Rechazar una incidencia
  Future<IncidentEntity> reviewIncident(
    String incidentId,
    bool approved,
    String note,
  );
}
