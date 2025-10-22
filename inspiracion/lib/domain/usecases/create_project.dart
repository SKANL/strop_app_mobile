import '../entities/project_entity.dart';
import '../repositories/project_repository.dart';
import '../../core/utils/app_logger.dart';
import '../../core/utils/platform_helper.dart';

/// Caso de uso específico para la acción de crear un nuevo proyecto.
/// 
/// Estrategia multiplataforma:
/// - Web/Desktop: Solo API remota (sin persistencia local)
/// - Móvil: Offline-first con Drift + sincronización
class CreateProject {
  final ProjectRepository repository;

  CreateProject(this.repository);

  /// Ejecuta el caso de uso.
  /// 
  /// Validaciones:
  /// - Nombre no vacío
  /// - Fechas coherentes
  Future<void> call(Project project) async {
    AppLogger.info('═══ CreateProject UseCase iniciado ═══', category: AppLogger.categoryRepository);
    AppLogger.info('Proyecto: ${project.name}', category: AppLogger.categoryRepository);
    AppLogger.info('Plataforma: ${PlatformHelper.platformName}', category: AppLogger.categoryRepository);

    // Validaciones de negocio
    if (project.name.isEmpty) {
      throw ArgumentError('El nombre del proyecto no puede estar vacío.');
    }
    if (project.endDate.isBefore(project.startDate)) {
      throw ArgumentError('La fecha de fin no puede ser anterior a la de inicio.');
    }

    // Web/Desktop: Solo API remota
    if (PlatformHelper.useOnlyApi) {
      AppLogger.info('Creando proyecto en API...', category: AppLogger.categoryRepository);
      try {
        await repository.createProjectRemote(project);
        AppLogger.info('✓ Proyecto creado en servidor', category: AppLogger.categoryRepository);
      } catch (e) {
        AppLogger.error('Error al crear proyecto en servidor', error: e, category: AppLogger.categoryRepository);
        rethrow;
      }
      return;
    }

    // Móvil: Estrategia Offline-First
    // PASO 1: SIEMPRE guardar en local primero
    try {
      await repository.createProjectLocal(project, pendingSync: true);
      AppLogger.info('✓ Proyecto guardado localmente (pendingSync: true)', category: AppLogger.categoryRepository);
    } catch (e) {
      AppLogger.error('Error crítico al guardar en local', error: e, category: AppLogger.categoryRepository);
      throw Exception('No se pudo guardar el proyecto localmente: $e');
    }

    // PASO 2: Intentar sincronizar con el servidor si hay conexión
    final isOnline = await repository.isOnline();
    
    if (isOnline) {
      AppLogger.info('Conexión disponible. Intentando sincronizar con servidor...', category: AppLogger.categoryRepository);
      try {
        await repository.createProjectRemote(project);
        AppLogger.info('✓ Proyecto sincronizado con servidor', category: AppLogger.categoryRepository);

        // Marcar como sincronizado en local
        await repository.markProjectAsSynced(project.id);
        AppLogger.info('✓ Proyecto marcado como sincronizado', category: AppLogger.categoryRepository);
      } catch (e) {
        // Si la API falla estando online, el proyecto queda pendiente
        // NO lanzamos la excepción porque el guardado local fue exitoso
        AppLogger.warning(
          '⚠️ API falló. Proyecto guardado localmente, sincronización pendiente: $e',
          category: AppLogger.categoryRepository,
        );
      }
    } else {
      AppLogger.info('Sin conexión. Proyecto quedará pendiente de sincronización.', category: AppLogger.categoryRepository);
    }

    AppLogger.info('═══ CreateProject UseCase completado ═══', category: AppLogger.categoryRepository);
  }
}
