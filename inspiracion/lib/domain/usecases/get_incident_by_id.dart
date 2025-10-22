import '../entities/incident_entity.dart';
import '../repositories/incident_repository.dart';

class GetIncidentById {
  final IncidentRepository repository;

  GetIncidentById(this.repository);

  Future<Incident> call(String incidentId) async {
    if (incidentId.isEmpty) {
      throw ArgumentError('El ID de la incidencia no puede estar vacío.');
    }
    return await repository.getIncidentById(incidentId);
  }
}