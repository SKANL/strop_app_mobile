// lib/src/features/incidents/data/repositories_impl/incidents_repository_impl.dart
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../core/core_domain/repositories/incident_repository.dart';
import '../datasources/incidents_fake_datasource.dart';
import '../models/incident_model.dart';

/// Implementación del repositorio de incidencias usando FakeDataSource
/// 
/// Para cambiar a API real:
/// 1. Crear IncidentsRemoteDataSource con llamadas HTTP
/// 2. En incidents_di.dart cambiar registro de:
///    IncidentsFakeDataSource() → IncidentsRemoteDataSource(apiClient: getIt())
/// 3. Este RepositoryImpl funciona con ambos (solo cambia el datasource)
class IncidentsRepositoryImpl implements IncidentRepository {
  final IncidentsFakeDataSource fakeDataSource;

  IncidentsRepositoryImpl({required this.fakeDataSource});

  @override
  Future<List<IncidentEntity>> getIncidentsByProject(String projectId) async {
    try {
      final List<Map<String, dynamic>> incidentsData = 
          await fakeDataSource.getProjectBitacora(projectId);
      
      return incidentsData
          .map((json) => IncidentModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener incidencias del proyecto $projectId: $e');
    }
  }

  @override
  Future<List<IncidentEntity>> getMyTasks(String userId, String projectId) async {
    try {
      final List<Map<String, dynamic>> tasksData = 
          await fakeDataSource.getMyTasks(userId);
      
      // Filtrar por projectId si se proporciona
      final filtered = projectId.isNotEmpty
          ? tasksData.where((t) => t['projectId'] == projectId).toList()
          : tasksData;
      
      return filtered
          .map((json) => IncidentModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener mis tareas: $e');
    }
  }

  @override
  Future<List<IncidentEntity>> getMyReports(String userId, String projectId) async {
    try {
      final List<Map<String, dynamic>> reportsData = 
          await fakeDataSource.getMyReports(userId);
      
      // Filtrar por projectId si se proporciona
      final filtered = projectId.isNotEmpty
          ? reportsData.where((r) => r['projectId'] == projectId).toList()
          : reportsData;
      
      return filtered
          .map((json) => IncidentModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener mis reportes: $e');
    }
  }

  @override
  Future<IncidentEntity> getIncidentById(String incidentId) async {
    try {
      final Map<String, dynamic> incidentData = 
          await fakeDataSource.getIncidentById(incidentId);
      
      return IncidentModel.fromJson(incidentData).toEntity();
    } catch (e) {
      throw Exception('Error al obtener incidente $incidentId: $e');
    }
  }

  @override
  Future<IncidentEntity> createIncident(IncidentEntity incident) async {
    try {
      // TODO: Obtener datos del usuario actual de la session
      const userName = 'Cabo López';
      const userRole = 'cabo';
      
      final Map<String, dynamic> createdData = 
          await fakeDataSource.createIncident(
            projectId: incident.projectId,
            type: _mapTypeToString(incident.type),
            title: incident.title,
            description: incident.description,
            authorId: incident.createdBy,
            authorName: userName,
            authorRole: userRole,
            isCritical: incident.isCritical,
            gpsLocation: incident.gpsData?['location'] ?? '',
            photos: incident.photoUrls,
          );
      
      return IncidentModel.fromJson(createdData).toEntity();
    } catch (e) {
      throw Exception('Error al crear incidente: $e');
    }
  }

  @override
  Future<IncidentEntity> assignIncident(String incidentId, String userId) async {
    try {
      // TODO: Obtener nombre de usuario de la session
      const userName = 'Usuario Asignado';
      
      await fakeDataSource.assignIncident(incidentId, userId, userName);
      
      // Retornar incidente actualizado
      return await getIncidentById(incidentId);
    } catch (e) {
      throw Exception('Error al asignar incidente $incidentId: $e');
    }
  }

  @override
  Future<IncidentEntity> closeIncident(String incidentId, String closeNote) async {
    try {
      // TODO: Obtener datos del usuario actual
      const userId = 'user-cabo-001';
      const userName = 'Cabo López';
      
      await fakeDataSource.closeIncident(
        incidentId, 
        userId, 
        userName, 
        closeNote, 
        [],
      );
      
      // Retornar incidente actualizado
      return await getIncidentById(incidentId);
    } catch (e) {
      throw Exception('Error al cerrar incidente $incidentId: $e');
    }
  }

  @override
  Future<void> addComment(String incidentId, String comment) async {
    try {
      // TODO: Obtener datos del usuario actual
      const userId = 'user-cabo-001';
      const userName = 'Cabo López';
      
      await fakeDataSource.addComment(incidentId, userId, userName, comment);
    } catch (e) {
      throw Exception('Error al agregar comentario al incidente $incidentId: $e');
    }
  }

  @override
  Future<void> addCorrection(String incidentId, String correction) async {
    try {
      // TODO: Obtener datos del usuario actual
      const userId = 'user-cabo-001';
      const userName = 'Cabo López';
      
      await fakeDataSource.addCorrection(incidentId, userId, userName, correction);
    } catch (e) {
      throw Exception('Error al agregar aclaración al incidente $incidentId: $e');
    }
  }

  @override
  Future<IncidentEntity> reviewIncident(
    String incidentId,
    bool approved,
    String note,
  ) async {
    // No implementado en FakeDataSource
    throw UnimplementedError('reviewIncident no disponible en datos fake');
  }

  /// Helper: Convertir IncidentType enum a String para FakeDataSource
  String _mapTypeToString(IncidentType type) {
    switch (type) {
      case IncidentType.progressReport:
        return 'avance';
      case IncidentType.problem:
        return 'problema';
      case IncidentType.consultation:
        return 'consulta';
      case IncidentType.safetyIncident:
        return 'seguridad';
      case IncidentType.materialRequest:
        return 'material';
    }
  }
}
