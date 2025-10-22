import '../../../domain/entities/project_entity.dart';
import '../../models/pending_project_data.dart';

abstract class ProjectLocalDataSource {
  /// Obtiene la lista de proyectos cacheados desde la base de datos local.
  Future<List<Project>> getProjects();
  
  /// Obtiene solo los proyectos que están pendientes de sincronización.
  Future<List<Project>> getPendingProjects();
  
  /// Obtiene proyectos pendientes con metadata de sincronización (fechas).
  Future<List<PendingProjectData>> getPendingProjectsWithMetadata();

  /// Guarda una lista de proyectos en la base de datos local.
  /// [fromRemote] indica si los datos vienen del servidor (ya sincronizados)
  Future<void> cacheProjects(List<Project> projects, {bool fromRemote = false});
  
  /// Guarda o actualiza un proyecto individual en la base de datos local.
  /// [pendingSync] indica si debe marcarse como pendiente de sincronización
  Future<void> saveProject(Project project, {bool pendingSync = true});
  
  /// Marca un proyecto como sincronizado con el servidor.
  Future<void> markAsSynced(String projectId);
  
  /// Actualiza la fecha de última modificación de un proyecto.
  Future<void> updateLastModified(String projectId);
  
  /// Obtiene un proyecto por su ID.
  Future<Project?> getProjectById(String projectId);
  
  /// Elimina todos los proyectos (útil para reset).
  Future<void> clearAll();
}