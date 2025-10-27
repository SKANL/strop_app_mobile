// lib/src/features/incidents/data/repositories_impl/incidents_repository_impl.dart
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../core/core_domain/repositories/incident_repository.dart';
import '../datasources/incidents_fake_datasource.dart';
import '../../../../core/core_di.dart';
import '../../../auth/presentation/manager/auth_provider.dart';
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
          await fakeDataSource.getBitacora(projectId);
      
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
          await fakeDataSource.getIncidentDetail(incidentId);
      
      return IncidentModel.fromJson(incidentData).toEntity();
    } catch (e) {
      throw Exception('Error al obtener incidente $incidentId: $e');
    }
  }

  @override
  Future<IncidentEntity> createIncident(IncidentEntity incident) async {
    try {
      // Obtener datos del usuario actual desde AuthProvider si está disponible
      String userName = 'Cabo López';
      String userRole = 'cabo';
      try {
        final auth = getIt<AuthProvider>();
        final user = auth.user;
        if (user != null) {
          userName = user.name;
          userRole = user.role.name;
        }
      } catch (_) {
        // si GetIt no tiene AuthProvider aún, usar valores por defecto
      }
      
      final newId = await fakeDataSource.createIncident({
        'projectId': incident.projectId,
        'type': _mapTypeToString(incident.type),
        'title': incident.title,
        'description': incident.description,
        'authorId': incident.createdBy,
        'authorName': userName,
        'authorRole': userRole,
        'isCritical': incident.isCritical,
        'gpsLocation': incident.gpsData?['location'] ?? '',
        'photos': incident.photoUrls,
      });
      
      // Obtener la incidencia recién creada para devolverla completa
      final createdData = await fakeDataSource.getIncidentDetail(newId);
      return IncidentModel.fromJson(createdData).toEntity();
    } catch (e) {
      throw Exception('Error al crear incidente: $e');
    }
  }

  @override
  Future<IncidentEntity> assignIncident(String incidentId, String userId) async {
    try {
      String userName = 'Usuario Asignado';
      try {
        final auth = getIt<AuthProvider>();
        final user = auth.user;
        if (user != null) userName = user.name;
      } catch (_) {}
      
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
      await fakeDataSource.closeIncident(incidentId, closeNote);
      
      // Retornar incidente actualizado
      return await getIncidentById(incidentId);
    } catch (e) {
      throw Exception('Error al cerrar incidente $incidentId: $e');
    }
  }

  @override
  Future<void> addComment(String incidentId, String comment) async {
    try {
      String userName = 'Cabo López';
      try {
        final auth = getIt<AuthProvider>();
        final user = auth.user;
        if (user != null) {
          userName = user.name;
        }
      } catch (_) {}
      
      await fakeDataSource.addComment(incidentId, comment, userName);
    } catch (e) {
      throw Exception('Error al agregar comentario al incidente $incidentId: $e');
    }
  }

  @override
  Future<void> addCorrection(String incidentId, String correction) async {
    try {
      String userName = 'Cabo López';
      try {
        final auth = getIt<AuthProvider>();
        final user = auth.user;
        if (user != null) {
          userName = user.name;
        }
      } catch (_) {}

      // El datasource refactorizado usa addComment para ambos casos
      // La diferencia se puede manejar con un prefijo en el mensaje
      await fakeDataSource.addComment(
        incidentId, 
        '**ACLARACIÓN**: $correction', 
        userName,
      );
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
