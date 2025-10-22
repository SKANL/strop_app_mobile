// lib/src/features/home/data/repositories_impl/projects_repository_impl.dart
import '../../../../core/core_domain/entities/project_entity.dart';
import '../../../../core/core_domain/entities/user_entity.dart';
import '../../../../core/core_domain/repositories/project_repository.dart';
import '../datasources/projects_fake_datasource.dart';
import '../models/project_model.dart';

/// Implementación del repositorio de proyectos usando FakeDataSource
/// 
/// Para cambiar a API real:
/// 1. Crear ProjectsRemoteDataSource con llamadas HTTP
/// 2. En home_di.dart cambiar registro de:
///    ProjectsFakeDataSource() → ProjectsRemoteDataSource(apiClient: getIt())
/// 3. Este RepositoryImpl funciona con ambos (solo cambia el datasource)
class ProjectsRepositoryImpl implements ProjectRepository {
  final ProjectsFakeDataSource fakeDataSource;

  ProjectsRepositoryImpl({required this.fakeDataSource});

  @override
  Future<List<ProjectEntity>> getActiveProjects() async {
    try {
      // Obtener userId del usuario actual (por ahora hardcoded, debe venir de AuthProvider)
      const userId = 'user-cabo-001'; // TODO: Obtener de session actual
      
      final List<Map<String, dynamic>> projectsData = 
          await fakeDataSource.getActiveProjects(userId);
      
      return projectsData
          .map((json) => ProjectModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener proyectos activos: $e');
    }
  }

  @override
  Future<List<ProjectEntity>> getArchivedProjects() async {
    try {
      const userId = 'user-cabo-001'; // TODO: Obtener de session actual
      
      final List<Map<String, dynamic>> projectsData = 
          await fakeDataSource.getArchivedProjects(userId);
      
      return projectsData
          .map((json) => ProjectModel.fromJson(json).toEntity())
          .toList();
    } catch (e) {
      throw Exception('Error al obtener proyectos archivados: $e');
    }
  }

  @override
  Future<ProjectEntity> getProjectById(String projectId) async {
    try {
      final Map<String, dynamic> projectData = 
          await fakeDataSource.getProjectById(projectId);
      
      return ProjectModel.fromJson(projectData).toEntity();
    } catch (e) {
      throw Exception('Error al obtener proyecto $projectId: $e');
    }
  }

  @override
  Future<List<UserEntity>> getProjectTeam(String projectId) async {
    try {
      await fakeDataSource.getProjectTeam(projectId);
      
      // Convertir a UserEntity (requiere UserModel)
      // TODO: Crear UserModel y mapear superintendents, residents, cabos
      // Por ahora retornamos lista vacía para evitar error
      return [];
    } catch (e) {
      throw Exception('Error al obtener equipo del proyecto $projectId: $e');
    }
  }

  @override
  Future<ProjectEntity> createProject(ProjectEntity project) async {
    // No implementado en FakeDataSource (solo lectura)
    throw UnimplementedError('createProject no disponible en datos fake');
  }

  @override
  Future<ProjectEntity> updateProject(ProjectEntity project) async {
    // No implementado en FakeDataSource (solo lectura)
    throw UnimplementedError('updateProject no disponible en datos fake');
  }
}
