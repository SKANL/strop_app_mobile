import '../../../domain/entities/incident_entity.dart';
import '../../models/incident_model.dart';

/// Interfaz abstracta para el datasource local de incidencias
abstract class IncidentLocalDataSource {
  Future<List<Incident>> getIncidentsForProject(String projectId);
  Future<void> saveIncident(Incident incident, {bool pendingSync = true});
  Future<List<Incident>> getPendingIncidents();
  Future<void> markAsSynced(String incidentId);
  Future<void> cacheIncidents(List<IncidentModel> incidents, {bool fromRemote = false});
  Future<void> updateIncident(Incident incident, {bool pendingSync = true});
  Future<Incident?> getIncidentById(String incidentId);
}

/// Implementación fake para plataformas web (sin persistencia local)
class FakeIncidentLocalDataSource implements IncidentLocalDataSource {
  @override
  Future<List<Incident>> getIncidentsForProject(String projectId) async {
    return [];
  }

  @override
  Future<void> saveIncident(Incident incident, {bool pendingSync = true}) async {
    // No-op en web
  }

  @override
  Future<List<Incident>> getPendingIncidents() async {
    return [];
  }

  @override
  Future<void> markAsSynced(String incidentId) async {
    // No-op en web
  }

  @override
  Future<void> cacheIncidents(List<IncidentModel> incidents, {bool fromRemote = false}) async {
    // No-op en web
  }

  @override
  Future<void> updateIncident(Incident incident, {bool pendingSync = true}) async {
    // No-op en web
  }

  @override
  Future<Incident?> getIncidentById(String incidentId) async {
    return null;
  }
}
