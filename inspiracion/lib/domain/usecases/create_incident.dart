import '../entities/incident_entity.dart';
import '../repositories/incident_repository.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/platform_helper.dart';

/// Caso de uso para crear una incidencia.
/// 
/// Estrategia multiplataforma:
/// - Web/Desktop: Solo API remota
/// - Móvil: Offline-first con Drift + sincronización
class CreateIncident {
  final IncidentRepository repository;

  CreateIncident(this.repository);

  Future<void> call(Incident incident) async {
    AppLogger.info('═══ CreateIncident UseCase iniciado ═══', category: AppLogger.categoryRepository);
    AppLogger.info('Plataforma: ${PlatformHelper.platformName}', category: AppLogger.categoryRepository);

    // Validación de negocio
    if (incident.description.trim().isEmpty) {
      throw ArgumentError('La descripción de la incidencia no puede estar vacía.');
    }

    // Web/Desktop: Solo API remota
    if (PlatformHelper.useOnlyApi) {
      AppLogger.info('Creando incidencia en API...', category: AppLogger.categoryRepository);
      try {
        await repository.createIncidentRemote(incident.projectId, incident);
        AppLogger.info('✓ Incidencia creada en servidor', category: AppLogger.categoryRepository);
      } catch (e) {
        AppLogger.error('Error al crear incidencia en servidor', error: e, category: AppLogger.categoryRepository);
        rethrow;
      }
      return;
    }

    // Móvil: Estrategia Offline-First
    // PASO 1: SIEMPRE guardar en local primero
    try {
      await repository.createIncidentLocal(incident, pendingSync: true);
      AppLogger.info('✓ Incidencia guardada localmente (pendingSync: true)', category: AppLogger.categoryRepository);
    } catch (e) {
      AppLogger.error('Error crítico al guardar en local', error: e, category: AppLogger.categoryRepository);
      throw Exception('No se pudo guardar la incidencia localmente: $e');
    }

    // PASO 2: Intentar sincronizar con el servidor si hay conexión
    final isOnline = await repository.isOnline();
    
    if (isOnline) {
      AppLogger.info('Conexión disponible. Intentando sincronizar con servidor...', category: AppLogger.categoryRepository);
      try {
        await repository.createIncidentRemote(incident.projectId, incident);
        AppLogger.info('✓ Incidencia sincronizada con servidor', category: AppLogger.categoryRepository);

        await repository.markIncidentAsSynced(incident.id);
        AppLogger.info('✓ Incidencia marcada como sincronizada', category: AppLogger.categoryRepository);
      } catch (e) {
        AppLogger.warning(
          '⚠️ API falló. Incidencia guardada localmente, sincronización pendiente: $e',
          category: AppLogger.categoryRepository,
        );
      }
    } else {
      AppLogger.info('Sin conexión. Incidencia quedará pendiente de sincronización.', category: AppLogger.categoryRepository);
    }

    AppLogger.info('═══ CreateIncident UseCase completado ═══', category: AppLogger.categoryRepository);
  }
}
