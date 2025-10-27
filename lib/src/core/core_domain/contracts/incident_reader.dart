// lib/src/core/core_domain/contracts/incident_reader.dart
import '../entities/incident_entity.dart';

/// Interface Segregada - Lectura de incidencias (ISP)
/// 
/// Define SOLO las operaciones de lectura de incidencias
/// 
/// Usada por:
/// - MyTasksProvider
/// - MyReportsProvider
/// - BitacoraProvider
/// - IncidentDetailProvider
abstract class IIncidentReader {
  /// Obtener todas las incidencias de un proyecto
  Future<List<IncidentEntity>> getIncidentsByProject(String projectId);

  /// Obtener incidencias asignadas al usuario (Mis Tareas)
  Future<List<IncidentEntity>> getMyTasks(String userId, String projectId);

  /// Obtener incidencias creadas por el usuario (Mis Reportes)
  Future<List<IncidentEntity>> getMyReports(String userId, String projectId);

  /// Obtener una incidencia por ID
  Future<IncidentEntity> getIncidentById(String incidentId);
}
