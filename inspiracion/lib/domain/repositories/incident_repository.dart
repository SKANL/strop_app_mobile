import 'package:strop_app_v2/domain/entities/user_entity.dart';
import '../entities/incident_entity.dart';

abstract class IncidentRepository {
  /// Obtiene una lista de incidencias para un proyecto específico.
  Future<List<Incident>> getIncidentsForProject(String projectId);

  /// Crea una nueva incidencia.
  Future<void> createIncident(Incident incident);

  /// Obtiene una única incidencia por su ID.
  Future<Incident> getIncidentById(String incidentId);

  /// Asigna una incidencia a un usuario específico.
  Future<Incident> assignIncident(String incidentId, User user);

  /// Cierra una incidencia, añadiendo una nota de cierre.
  Future<Incident> closeIncident(String incidentId, String closingNote);

  // ============================================================
  // Métodos atómicos para composición en UseCases
  // ============================================================

  /// Obtiene incidencias remotamente desde el servidor.
  Future<List<Incident>> getRemoteIncidentsForProject(String projectId);

  /// Obtiene incidencias desde la base de datos local.
  Future<List<Incident>> getLocalIncidentsForProject(String projectId);

  /// Guarda incidencias localmente.
  Future<void> saveIncidentsLocally(List<Incident> incidents);

  /// Verifica si hay conexión.
  Future<bool> isOnline();

  /// Crea una incidencia localmente.
  Future<void> createIncidentLocal(Incident incident, {bool pendingSync = true});

  /// Crea una incidencia remotamente en el servidor.
  Future<void> createIncidentRemote(String projectId, Incident incident);

  /// Marca una incidencia como sincronizada en la base de datos local.
  Future<void> markIncidentAsSynced(String incidentId);
}