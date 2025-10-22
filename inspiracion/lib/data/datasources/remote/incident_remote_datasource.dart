import '../../../core/api/api_client.dart';
import '../../../core/utils/app_logger.dart';
import '../../../domain/entities/incident_entity.dart';
import '../../models/incident_model.dart';
import '../../models/user_model.dart';

/// Interfaz para la fuente de datos remota de incidencias
abstract class IncidentRemoteDataSource {
  Future<List<IncidentModel>> getIncidentsForProject(String projectId);
  Future<IncidentModel> createIncident(String projectId, IncidentModel incident);
  Future<IncidentModel> getIncidentById(String incidentId);
  Future<IncidentModel> assignIncident(String incidentId, UserModel user);
  Future<IncidentModel> closeIncident(String incidentId, String closingNote);
}

/// Implementación real de IncidentRemoteDataSource usando la API REST
/// 
/// Endpoints:
/// - GET /projects/{projectId}/incidents
/// - POST /projects/{projectId}/incidents
/// - GET /incidents/{incidentId}
/// - PATCH /incidents/{incidentId}/assign
/// - PATCH /incidents/{incidentId}/close
class IncidentRemoteDataSourceImpl implements IncidentRemoteDataSource {
  final ApiClient _apiClient;

  IncidentRemoteDataSourceImpl(this._apiClient);

  @override
  Future<List<IncidentModel>> getIncidentsForProject(String projectId) async {
    AppLogger.info('═══ IncidentRemoteDataSource.getIncidentsForProject() ═══',
        category: AppLogger.categoryNetwork);
    AppLogger.info('ProjectId: $projectId', category: AppLogger.categoryNetwork);

    try {
      // GET /projects/{projectId}/incidents
      final response = await _apiClient.get(
        '/projects/$projectId/incidents',
        queryParameters: {'limit': 100},
      );

      // Extraer array de incidencias
      final incidentsData = response.data['data']['incidents'] as List;

      // Convertir a modelos
      final incidents = incidentsData
          .map((json) => _incidentFromJson(json))
          .toList();

      AppLogger.info('✓ ${incidents.length} incidencias obtenidas desde servidor',
          category: AppLogger.categoryNetwork);

      return incidents;
    } on ApiException catch (e) {
      AppLogger.error('Error al obtener incidencias (API)',
          category: AppLogger.categoryNetwork, error: e);

      if (e is ConnectionException) {
        throw ConnectionException(e.message);
      }

      throw ServerException(e.message);
    } catch (e) {
      AppLogger.error('Error inesperado al obtener incidencias',
          category: AppLogger.categoryNetwork, error: e);
      rethrow;
    }
  }

  @override
  Future<IncidentModel> createIncident(String projectId, IncidentModel incident) async {
    AppLogger.info('═══ IncidentRemoteDataSource.createIncident() ═══',
        category: AppLogger.categoryNetwork);
    AppLogger.info('ProjectId: $projectId | Incident: ${incident.description}',
        category: AppLogger.categoryNetwork);

    try {
      // POST /projects/{projectId}/incidents
      final response = await _apiClient.post(
        '/projects/$projectId/incidents',
        data: {
          'id': incident.id,
          'description': incident.description,
          'author': incident.author,
          'reportedDate': incident.reportedDate.toUtc().toIso8601String(),
          'imageUrls': incident.imageUrls,
        },
      );

      final incidentData = response.data['data'];
      final createdIncident = _incidentFromJson(incidentData);

      AppLogger.info('✓ Incidencia creada en servidor: ${createdIncident.id}',
          category: AppLogger.categoryNetwork);

      return createdIncident;
    } on ApiException catch (e) {
      AppLogger.error('Error al crear incidencia (API)',
          category: AppLogger.categoryNetwork, error: e);

      if (e is ConnectionException) {
        throw ConnectionException(e.message);
      }

      throw ServerException(e.message);
    } catch (e) {
      AppLogger.error('Error inesperado al crear incidencia',
          category: AppLogger.categoryNetwork, error: e);
      rethrow;
    }
  }

  @override
  Future<IncidentModel> getIncidentById(String incidentId) async {
    AppLogger.info('═══ IncidentRemoteDataSource.getIncidentById() ═══',
        category: AppLogger.categoryNetwork);
    AppLogger.info('IncidentId: $incidentId', category: AppLogger.categoryNetwork);

    try {
      // GET /incidents/{incidentId}
      final response = await _apiClient.get('/incidents/$incidentId');

      final incidentData = response.data['data'];
      final incident = _incidentFromJson(incidentData);

      AppLogger.info('✓ Incidencia obtenida desde servidor',
          category: AppLogger.categoryNetwork);

      return incident;
    } on ApiException catch (e) {
      AppLogger.error('Error al obtener incidencia por ID (API)',
          category: AppLogger.categoryNetwork, error: e);

      if (e is NotFoundException) {
        throw NotFoundException('Incidencia no encontrada');
      }

      if (e is ConnectionException) {
        throw ConnectionException(e.message);
      }

      throw ServerException(e.message);
    } catch (e) {
      AppLogger.error('Error inesperado al obtener incidencia',
          category: AppLogger.categoryNetwork, error: e);
      rethrow;
    }
  }

  @override
  Future<IncidentModel> assignIncident(String incidentId, UserModel user) async {
    AppLogger.info('═══ IncidentRemoteDataSource.assignIncident() ═══',
        category: AppLogger.categoryNetwork);
    AppLogger.info('IncidentId: $incidentId | UserId: ${user.id}',
        category: AppLogger.categoryNetwork);

    try {
      // PATCH /incidents/{incidentId}/assign
      final response = await _apiClient.patch(
        '/incidents/$incidentId/assign',
        data: {
          'assignedToId': user.id,
        },
      );

      final incidentData = response.data['data'];
      final updatedIncident = _incidentFromJson(incidentData);

      AppLogger.info('✓ Incidencia asignada exitosamente',
          category: AppLogger.categoryNetwork);

      return updatedIncident;
    } on ApiException catch (e) {
      AppLogger.error('Error al asignar incidencia (API)',
          category: AppLogger.categoryNetwork, error: e);

      if (e is NotFoundException) {
        throw NotFoundException('Incidencia no encontrada');
      }

      if (e is ConnectionException) {
        throw ConnectionException(e.message);
      }

      throw ServerException(e.message);
    } catch (e) {
      AppLogger.error('Error inesperado al asignar incidencia',
          category: AppLogger.categoryNetwork, error: e);
      rethrow;
    }
  }

  @override
  Future<IncidentModel> closeIncident(String incidentId, String closingNote) async {
    AppLogger.info('═══ IncidentRemoteDataSource.closeIncident() ═══',
        category: AppLogger.categoryNetwork);
    AppLogger.info('IncidentId: $incidentId', category: AppLogger.categoryNetwork);

    try {
      // PATCH /incidents/{incidentId}/close
      final response = await _apiClient.patch(
        '/incidents/$incidentId/close',
        data: {
          'closingNote': closingNote,
        },
      );

      final incidentData = response.data['data'];
      final closedIncident = _incidentFromJson(incidentData);

      AppLogger.info('✓ Incidencia cerrada exitosamente',
          category: AppLogger.categoryNetwork);

      return closedIncident;
    } on ApiException catch (e) {
      AppLogger.error('Error al cerrar incidencia (API)',
          category: AppLogger.categoryNetwork, error: e);

      if (e is NotFoundException) {
        throw NotFoundException('Incidencia no encontrada');
      }

      if (e is ConnectionException) {
        throw ConnectionException(e.message);
      }

      throw ServerException(e.message);
    } catch (e) {
      AppLogger.error('Error inesperado al cerrar incidencia',
          category: AppLogger.categoryNetwork, error: e);
      rethrow;
    }
  }

  /// Convierte JSON del servidor a IncidentModel
  IncidentModel _incidentFromJson(Map<String, dynamic> json) {
    return IncidentModel(
      id: json['id'],
      projectId: json['projectId'],
      description: json['description'],
      author: json['author'],
      reportedDate: DateTime.parse(json['reportedDate']),
      status: _parseStatus(json['status']),
      imageUrls: (json['imageUrls'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      assignedTo: json['assignedTo'] ?? '',
      assignedToId: json['assignedToId'] ?? '',
      closingNote: json['closingNote'] ?? '',
    );
  }

  /// Convierte string de status a enum
  IncidentStatus _parseStatus(String status) {
    switch (status.toLowerCase()) {
      case 'open':
        return IncidentStatus.open;
      case 'assigned':
        return IncidentStatus.assigned;
      case 'closed':
        return IncidentStatus.closed;
      default:
        return IncidentStatus.open;
    }
  }
}
