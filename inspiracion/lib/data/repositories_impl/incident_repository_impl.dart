import 'package:flutter/foundation.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/network_info.dart';
import '../../domain/entities/incident_entity.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/incident_repository.dart';
import '../datasources/local/incident_local_datasource.dart';
import '../datasources/remote/incident_remote_datasource.dart';
import '../models/incident_model.dart';
import '../models/user_model.dart';

class IncidentRepositoryImpl implements IncidentRepository {
  final IncidentRemoteDataSource remoteDataSource;
  final IncidentLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  IncidentRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Incident>> getIncidentsForProject(String projectId) async {
    // Delegamos al datasource local. La orquestación de sincronización
    // se realiza en UseCases para respetar Separation of Concerns.
    return await localDataSource.getIncidentsForProject(projectId);
  }

  @override
  Future<void> createIncident(Incident incident) async {
    // Método simple que guarda local. La orquestación está en UseCases.
    return await localDataSource.saveIncident(incident, pendingSync: true);
  }

  @override
  Future<Incident> getIncidentById(String incidentId) async {
    // Primero intentar local
    final localIncident = await localDataSource.getIncidentById(incidentId);
    if (localIncident != null) {
      return localIncident;
    }
    
    // Si no está local y hay conexión, obtener del servidor
    final isOnline = await networkInfo.checkConnection();
    if (isOnline) {
      return await remoteDataSource.getIncidentById(incidentId);
    }

    throw Exception('Incidencia no encontrada');
  }

  @override
  Future<Incident> assignIncident(String incidentId, User user) async {
    AppLogger.repository('═══ assignIncident($incidentId) iniciado ═══');

    final userModel = UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      role: user.role,
    );

    // Para Web, solo API
    if (kIsWeb) {
      try {
        final incident = await remoteDataSource.assignIncident(incidentId, userModel);
        AppLogger.repository('✓ Incidencia asignada exitosamente (Web)');
        return incident;
      } catch (e) {
        AppLogger.repository('Error al asignar incidencia en Web: $e', isError: true);
        rethrow;
      }
    }

    // Offline-First: Guardar cambio localmente primero
    final localIncident = await localDataSource.getIncidentById(incidentId);
    if (localIncident != null) {
      final updatedIncident = IncidentModel(
        id: localIncident.id,
        projectId: localIncident.projectId,
        description: localIncident.description,
        author: localIncident.author,
        reportedDate: localIncident.reportedDate,
        status: IncidentStatus.assigned,
        imageUrls: localIncident.imageUrls,
        assignedTo: user.name,
        assignedToId: user.id,
        closingNote: localIncident.closingNote ?? '',
      );

      await localDataSource.updateIncident(updatedIncident, pendingSync: true);
      AppLogger.repository('✓ Incidencia actualizada localmente');

      // Intentar sincronizar si hay conexión
      final isOnline = await networkInfo.checkConnection();
      if (isOnline) {
        try {
          final remoteIncident = await remoteDataSource.assignIncident(incidentId, userModel);
          await localDataSource.markAsSynced(incidentId);
          AppLogger.repository('✓ Asignación sincronizada con servidor');
          return remoteIncident;
        } catch (e) {
          AppLogger.repository('Error al sincronizar asignación. Quedará pendiente.', isError: true);
          return updatedIncident;
        }
      }

      return updatedIncident;
    }

    throw Exception('Incidencia no encontrada localmente');
  }

  @override
  Future<Incident> closeIncident(String incidentId, String closingNote) async {
    AppLogger.repository('═══ closeIncident($incidentId) iniciado ═══');

    // Para Web, solo API
    if (kIsWeb) {
      try {
        final incident = await remoteDataSource.closeIncident(incidentId, closingNote);
        AppLogger.repository('✓ Incidencia cerrada exitosamente (Web)');
        return incident;
      } catch (e) {
        AppLogger.repository('Error al cerrar incidencia en Web: $e', isError: true);
        rethrow;
      }
    }

    // Offline-First: Guardar cambio localmente primero
    final localIncident = await localDataSource.getIncidentById(incidentId);
    if (localIncident != null) {
      final closedIncident = IncidentModel(
        id: localIncident.id,
        projectId: localIncident.projectId,
        description: localIncident.description,
        author: localIncident.author,
        reportedDate: localIncident.reportedDate,
        status: IncidentStatus.closed,
        imageUrls: localIncident.imageUrls,
        assignedTo: localIncident.assignedTo ?? '',
        assignedToId: localIncident.assignedToId ?? '',
        closingNote: closingNote,
      );

      await localDataSource.updateIncident(closedIncident, pendingSync: true);
      AppLogger.repository('✓ Incidencia cerrada localmente');

      // Intentar sincronizar si hay conexión
      final isOnline = await networkInfo.checkConnection();
      if (isOnline) {
        try {
          final remoteIncident = await remoteDataSource.closeIncident(incidentId, closingNote);
          await localDataSource.markAsSynced(incidentId);
          AppLogger.repository('✓ Cierre sincronizado con servidor');
          return remoteIncident;
        } catch (e) {
          AppLogger.repository('Error al sincronizar cierre. Quedará pendiente.', isError: true);
          return closedIncident;
        }
      }

      return closedIncident;
    }

    throw Exception('Incidencia no encontrada localmente');
  }

  // ============================================================
  // Métodos atómicos para composición en UseCases
  // ============================================================

  @override
  Future<List<Incident>> getRemoteIncidentsForProject(String projectId) async {
    return await remoteDataSource.getIncidentsForProject(projectId);
  }

  @override
  Future<List<Incident>> getLocalIncidentsForProject(String projectId) async {
    return await localDataSource.getIncidentsForProject(projectId);
  }

  @override
  Future<void> saveIncidentsLocally(List<Incident> incidents) async {
    final models = incidents.map((inc) => IncidentModel(
      id: inc.id,
      projectId: inc.projectId,
      description: inc.description,
      author: inc.author,
      reportedDate: inc.reportedDate,
      status: inc.status,
      imageUrls: inc.imageUrls,
      assignedTo: inc.assignedTo ?? '',
      assignedToId: inc.assignedToId ?? '',
      closingNote: inc.closingNote ?? '',
    )).toList();
    
    await localDataSource.cacheIncidents(models, fromRemote: true);
  }

  @override
  Future<bool> isOnline() async => await networkInfo.checkConnection();

  @override
  Future<void> createIncidentLocal(Incident incident, {bool pendingSync = true}) async {
    await localDataSource.saveIncident(incident, pendingSync: pendingSync);
  }

  @override
  Future<void> createIncidentRemote(String projectId, Incident incident) async {
    final incidentModel = IncidentModel(
      id: incident.id,
      projectId: incident.projectId,
      description: incident.description,
      author: incident.author,
      reportedDate: incident.reportedDate,
      status: incident.status,
      imageUrls: incident.imageUrls,
      assignedTo: incident.assignedTo ?? '',
      assignedToId: incident.assignedToId ?? '',
      closingNote: incident.closingNote ?? '',
    );

    await remoteDataSource.createIncident(projectId, incidentModel);
  }

  @override
  Future<void> markIncidentAsSynced(String incidentId) async {
    await localDataSource.markAsSynced(incidentId);
  }
}
