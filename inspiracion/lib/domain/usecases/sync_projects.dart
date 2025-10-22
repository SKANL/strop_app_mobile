import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/platform_helper.dart';

class SyncProjectsUseCase {
  final ProjectRepository repository;

  SyncProjectsUseCase(this.repository);

  Future<List<Project>> call() async {
    AppLogger.info('═══ SyncProjectsUseCase iniciado ═══', category: AppLogger.categoryRepository);
    AppLogger.info('Plataforma: ${PlatformHelper.platformName}', category: AppLogger.categoryRepository);
    AppLogger.info('Estrategia: ${PlatformHelper.persistenceStrategy}', category: AppLogger.categoryRepository);

    // Web y Desktop: solo API remota (no hay persistencia local)
    if (PlatformHelper.useOnlyApi) {
      AppLogger.info('Obteniendo proyectos desde API remota...', category: AppLogger.categoryRepository);
      try {
        final remoteProjects = await repository.getRemoteProjects();
        AppLogger.info('✓ ${remoteProjects.length} proyectos obtenidos', category: AppLogger.categoryRepository);
        return remoteProjects;
      } catch (e) {
        AppLogger.error('Error al obtener proyectos remotos', error: e, category: AppLogger.categoryRepository);
        rethrow;
      }
    }

    // Móvil: Estrategia Offline-First con Drift
    final isOnline = await repository.isOnline();
    AppLogger.info('Móvil - Estado: ${isOnline ? "ONLINE" : "OFFLINE"}', category: AppLogger.categoryRepository);

    if (isOnline) {
      try {
        AppLogger.info('Sincronizando desde servidor...', category: AppLogger.categoryRepository);
        final remoteProjects = await repository.getRemoteProjects();
        AppLogger.info('✓ ${remoteProjects.length} proyectos obtenidos del servidor', category: AppLogger.categoryRepository);

        await repository.saveProjectsLocally(remoteProjects);
        AppLogger.info('✓ Caché local actualizada', category: AppLogger.categoryRepository);

        return await repository.getLocalProjects();
      } catch (e) {
        AppLogger.warning('Error al sincronizar. Usando caché local...', category: AppLogger.categoryRepository);
        return await repository.getLocalProjects();
      }
    } else {
      AppLogger.info('Modo OFFLINE: usando caché local...', category: AppLogger.categoryRepository);
      return await repository.getLocalProjects();
    }
  }
}
