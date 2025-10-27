// lib/src/core/core_domain/contracts/incident_comments.dart

/// Interface Segregada - Gestión de comentarios en incidencias (ISP)
/// 
/// Define SOLO las operaciones relacionadas con comentarios
/// 
/// Usada por:
/// - IncidentCommentsProvider
/// - IncidentDetailProvider
abstract class IIncidentComments {
  /// Agregar comentario a una incidencia
  Future<void> addComment(String incidentId, String comment);

  /// Registrar aclaración/corrección a una incidencia
  Future<void> addCorrection(String incidentId, String correction);
}
