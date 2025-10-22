import '../entities/incident_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/incident_repository.dart';

class AssignIncident {
  final IncidentRepository repository;

  AssignIncident(this.repository);

  Future<Incident> call({required String incidentId, required User userToAssign}) async {
    // Aquí podríamos añadir validaciones, como verificar que el usuario a asignar
    // pertenece al proyecto de la incidencia.
    return await repository.assignIncident(incidentId, userToAssign);
  }
}