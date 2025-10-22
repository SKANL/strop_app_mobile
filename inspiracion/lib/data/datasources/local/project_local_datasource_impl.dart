import 'package:drift/drift.dart';
import 'package:strop_app_v2/core/utils/app_logger.dart';
import 'package:strop_app_v2/data/datasources/local/app_database.dart';
import 'package:strop_app_v2/data/datasources/local/project_local_datasource.dart';
import 'package:strop_app_v2/domain/entities/project_entity.dart';
import 'package:strop_app_v2/data/models/pending_project_data.dart';

class ProjectLocalDataSourceImpl implements ProjectLocalDataSource {
  final AppDatabase database;

  ProjectLocalDataSourceImpl(this.database);

  @override
  Future<void> cacheProjects(List<Project> projects, {bool fromRemote = false}) async {
    await database.transaction(() async {
      AppLogger.database('═══ cacheProjects() iniciado ═══');
      AppLogger.database('Proyectos a cachear: ${projects.length} (fromRemote: $fromRemote)');

      if (fromRemote) {
        // MERGE INTELIGENTE: Proteger proyectos pendientes de sincronización
        // 1. Obtener proyectos locales pendientes de sincronización
        final pendingQuery = database.select(database.projects)
          ..where((tbl) => tbl.pendingSync.equals(true));
        final pendingProjects = await pendingQuery.get();
        
        AppLogger.database('Proyectos pendientes locales encontrados: ${pendingProjects.length}');
        
        // 2. Crear un Set de IDs de proyectos del servidor
        final remoteIds = projects.map((p) => p.id).toSet();
        
        // 3. Identificar proyectos locales que NO están en el servidor
        final localOnlyProjects = pendingProjects.where(
          (local) => !remoteIds.contains(local.id)
        ).toList();
        
        AppLogger.database('Proyectos solo locales (a proteger): ${localOnlyProjects.length}');
        
        // 4. Borrar SOLO los proyectos que NO están pendientes de sincronización
        // O que YA están en el servidor (para actualizarlos)
        await (database.delete(database.projects)
              ..where((tbl) => 
                tbl.pendingSync.equals(false) | 
                tbl.id.isIn(remoteIds)
              )
        ).go();
        
        AppLogger.database('✓ Proyectos sincronizados eliminados para actualización');
        
        // 5. Insertar/Actualizar proyectos del servidor
        final now = DateTime.now();
        final projectEntries = projects.map((entity) {
          return ProjectsCompanion.insert(
            id: entity.id,
            name: entity.name,
            location: entity.location,
            startDate: entity.startDate,
            endDate: entity.endDate,
            pendingSync: const Value(false), // Vienen del servidor, están sincronizados
            createdAt: Value(now),
            lastModifiedAt: Value(now),
            syncedAt: Value(now),
          );
        }).toList();
        
        await database.batch((batch) {
          batch.insertAll(
            database.projects, 
            projectEntries,
            mode: InsertMode.insertOrReplace, // Actualizar si existe
          );
        });
        
        AppLogger.database('✓ ${projects.length} proyectos del servidor cacheados');
        AppLogger.database('✓ ${localOnlyProjects.length} proyectos locales protegidos');
        
      } else {
        // Si NO viene del servidor, es un cache local simple (sin borrado)
        final now = DateTime.now();
        final projectEntries = projects.map((entity) {
          return ProjectsCompanion.insert(
            id: entity.id,
            name: entity.name,
            location: entity.location,
            startDate: entity.startDate,
            endDate: entity.endDate,
            pendingSync: const Value(true), // Cache local, pendiente
            createdAt: Value(now),
            lastModifiedAt: Value(now),
            syncedAt: const Value(null),
          );
        }).toList();
        
        await database.batch((batch) {
          batch.insertAll(
            database.projects, 
            projectEntries,
            mode: InsertMode.insertOrReplace,
          );
        });
        
        AppLogger.database('✓ ${projects.length} proyectos cacheados localmente');
      }
      
      AppLogger.database('═══ cacheProjects() completado ═══');
    });
  }

  @override
  Future<List<Project>> getProjects() async {
    AppLogger.database('Leyendo todos los proyectos desde la base de datos...');
    final result = await database.select(database.projects).get();
    AppLogger.database('✓ Se encontraron ${result.length} proyectos en la DB');

    return result.map(_mapToEntity).toList();
  }

  @override
  Future<List<Project>> getPendingProjects() async {
    AppLogger.database('Leyendo proyectos pendientes de sincronización...');
    final query = database.select(database.projects)
      ..where((tbl) => tbl.pendingSync.equals(true));
    
    final result = await query.get();
    AppLogger.database('✓ Se encontraron ${result.length} proyectos pendientes');

    return result.map(_mapToEntity).toList();
  }

  @override
  Future<List<PendingProjectData>> getPendingProjectsWithMetadata() async {
    AppLogger.database('Leyendo proyectos pendientes con metadata...');
    final query = database.select(database.projects)
      ..where((tbl) => tbl.pendingSync.equals(true));
    
    final result = await query.get();
    AppLogger.database('✓ Se encontraron ${result.length} proyectos pendientes con metadata');

    return result.map((row) {
      return PendingProjectData(
        project: _mapToEntity(row),
        createdAt: row.createdAt,
        lastModifiedAt: row.lastModifiedAt,
      );
    }).toList();
  }

  @override
  Future<void> saveProject(Project project, {bool pendingSync = true}) async {
    AppLogger.database('Guardando proyecto: ${project.name} (pendingSync: $pendingSync)');
    
    final now = DateTime.now();
    final companion = ProjectsCompanion.insert(
      id: project.id,
      name: project.name,
      location: project.location,
      startDate: project.startDate,
      endDate: project.endDate,
      pendingSync: Value(pendingSync),
      createdAt: Value(now),
      lastModifiedAt: Value(now),
      syncedAt: Value(pendingSync ? null : now),
    );

    await database.into(database.projects).insertOnConflictUpdate(companion);
    AppLogger.database('✓ Proyecto guardado: ${project.id}');
  }

  @override
  Future<void> markAsSynced(String projectId) async {
    AppLogger.database('Marcando proyecto como sincronizado: $projectId');
    
    final now = DateTime.now();
    await (database.update(database.projects)
          ..where((tbl) => tbl.id.equals(projectId)))
        .write(
      ProjectsCompanion(
        pendingSync: const Value(false),
        syncedAt: Value(now),
      ),
    );
    
    AppLogger.database('✓ Proyecto marcado como sincronizado: $projectId');
  }

  @override
  Future<void> updateLastModified(String projectId) async {
    AppLogger.debug('Actualizando lastModified para proyecto: $projectId', 
        category: AppLogger.categoryDatabase);
    
    await (database.update(database.projects)
          ..where((tbl) => tbl.id.equals(projectId)))
        .write(
      ProjectsCompanion(
        lastModifiedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<Project?> getProjectById(String projectId) async {
    AppLogger.debug('Buscando proyecto por ID: $projectId', 
        category: AppLogger.categoryDatabase);
    
    final query = database.select(database.projects)
      ..where((tbl) => tbl.id.equals(projectId));
    
    final result = await query.getSingleOrNull();
    
    if (result == null) {
      AppLogger.debug('Proyecto no encontrado: $projectId', 
          category: AppLogger.categoryDatabase);
      return null;
    }
    
    return _mapToEntity(result);
  }

  @override
  Future<void> clearAll() async {
    AppLogger.warning('Eliminando todos los proyectos de la base de datos', 
        category: AppLogger.categoryDatabase);
    await database.delete(database.projects).go();
    AppLogger.warning('✓ Todos los proyectos eliminados', 
        category: AppLogger.categoryDatabase);
  }

  /// Mapea un ProjectData de Drift a una entidad Project del dominio
  Project _mapToEntity(ProjectData row) {
    return Project(
      id: row.id,
      name: row.name,
      location: row.location,
      startDate: row.startDate,
      endDate: row.endDate,
    );
  }
}
