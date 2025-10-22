// lib/src/core/core_domain/repositories/project_repository.dart
import '../entities/project_entity.dart';
import '../entities/user_entity.dart';

/// Contrato de repositorio de proyectos - Core Domain
abstract class ProjectRepository {
  /// Obtener todos los proyectos activos del usuario
  Future<List<ProjectEntity>> getActiveProjects();
  
  /// Obtener proyectos archivados
  Future<List<ProjectEntity>> getArchivedProjects();
  
  /// Obtener un proyecto por ID
  Future<ProjectEntity> getProjectById(String projectId);
  
  /// Obtener el equipo de un proyecto
  Future<List<UserEntity>> getProjectTeam(String projectId);
  
  /// Crear un nuevo proyecto (solo admin)
  Future<ProjectEntity> createProject(ProjectEntity project);
  
  /// Actualizar un proyecto
  Future<ProjectEntity> updateProject(ProjectEntity project);
}
