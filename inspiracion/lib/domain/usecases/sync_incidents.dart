import '../entities/incident_entity.dart';
import '../repositories/incident_repository.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/platform_helper.dart';

/// UseCase que sincroniza incidencias de un proyecto.
/// 
/// Estrategia multiplataforma:
/// - Web/Desktop: Solo API remota
/// - Móvil: Offline-first con Drift + sincronización
class SyncIncidentsUseCase {
  final IncidentRepository repository;

  SyncIncidentsUseCase(this.repository);

  Future<List<Incident>> call(String projectId) async {
    AppLogger.info('═══ SyncIncidentsUseCase iniciado para proyecto $projectId ═══', category: AppLogger.categoryRepository);
    AppLogger.info('Plataforma: ${PlatformHelper.platformName}', category: AppLogger.categoryRepository);

    // Web y Desktop: solo API remota (no hay persistencia local)
    if (PlatformHelper.useOnlyApi) {
      AppLogger.info('Obteniendo incidencias desde API remota...', category: AppLogger.categoryRepository);
      try {
        final remoteIncidents = await repository.getRemoteIncidentsForProject(projectId);
        AppLogger.info('✓ ${remoteIncidents.length} incidencias obtenidas', category: AppLogger.categoryRepository);
        return remoteIncidents;
      } catch (e) {
        AppLogger.error('Error al obtener incidencias remotas', error: e, category: AppLogger.categoryRepository);
        rethrow;
      }
    }

    // Móvil: Estrategia Offline-First con Drift
    final isOnline = await repository.isOnline();
    AppLogger.info('Móvil - Estado: ${isOnline ? "ONLINE" : "OFFLINE"}', category: AppLogger.categoryRepository);

    if (isOnline) {
      try {
        AppLogger.info('Sincronizando incidencias desde servidor...', category: AppLogger.categoryRepository);
        final remoteIncidents = await repository.getRemoteIncidentsForProject(projectId);
        AppLogger.info('✓ ${remoteIncidents.length} incidencias obtenidas del servidor', category: AppLogger.categoryRepository);

        await repository.saveIncidentsLocally(remoteIncidents);
        AppLogger.info('✓ Caché local actualizada', category: AppLogger.categoryRepository);

        return await repository.getLocalIncidentsForProject(projectId);
      } catch (e) {
        AppLogger.warning('Error al sincronizar. Usando caché local...', category: AppLogger.categoryRepository);
        return await repository.getLocalIncidentsForProject(projectId);
      }
    } else {
      AppLogger.info('Modo OFFLINE: usando caché local...', category: AppLogger.categoryRepository);
      return await repository.getLocalIncidentsForProject(projectId);
    }
  }
}
