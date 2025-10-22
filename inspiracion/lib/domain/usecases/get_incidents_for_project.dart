import '../entities/incident_entity.dart';
import 'sync_incidents.dart';

/// UseCase para obtener incidencias de un proyecto.
/// Delega la sincronización a SyncIncidentsUseCase.
class GetIncidentsForProject {
  final SyncIncidentsUseCase _syncIncidents;

  GetIncidentsForProject(this._syncIncidents);

  Future<List<Incident>> call(String projectId) async {
    // Validaciones de negocio
    if (projectId.isEmpty) {
      throw ArgumentError('El ID del proyecto no puede estar vacío.');
    }
    
    // Delegamos la sincronización al usecase especializado
    return await _syncIncidents.call(projectId);
  }
}
