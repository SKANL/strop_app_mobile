import '../entities/incident_entity.dart';
import '../repositories/incident_repository.dart';

class CloseIncident {
  final IncidentRepository repository;

  CloseIncident(this.repository);

  Future<Incident> call({required String incidentId, required String closingNote}) async {
    if (closingNote.trim().isEmpty) {
      throw ArgumentError('La nota de cierre no puede estar vacía.');
    }
    return await repository.closeIncident(incidentId, closingNote);
  }
}