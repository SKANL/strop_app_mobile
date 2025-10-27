// lib/src/core/core_domain/contracts/incident_writer.dart
import '../entities/incident_entity.dart';

/// Interface Segregada - Escritura/Mutación de incidencias (ISP)
/// 
/// Define SOLO las operaciones de escritura/mutación de incidencias
/// 
/// Usada por:
/// - IncidentFormProvider
/// - IncidentActionsProvider
abstract class IIncidentWriter {
  /// Crear una nueva incidencia/reporte
  Future<IncidentEntity> createIncident(IncidentEntity incident);

  /// Asignar una incidencia a un usuario
  Future<IncidentEntity> assignIncident(String incidentId, String userId);

  /// Cerrar una incidencia
  Future<IncidentEntity> closeIncident(String incidentId, String closeNote);

  /// Aprobar/Rechazar una incidencia
  Future<IncidentEntity> reviewIncident(
    String incidentId,
    bool approved,
    String note,
  );
}
