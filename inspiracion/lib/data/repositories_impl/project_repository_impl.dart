import '../../core/utils/network_info.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../datasources/local/project_local_datasource.dart';
import '../datasources/remote/project_remote_datasource.dart';
import '../models/project_model.dart';

class ProjectRepositoryImpl implements ProjectRepository {
  final ProjectRemoteDataSource remoteDataSource;
  final ProjectLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  ProjectRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<List<Project>> getProjects() async {
    // Delegamos al datasource local por defecto. La orquestación de sincronización
    // se realiza en un UseCase/SyncService para respetar Separation of Concerns.
    return await localDataSource.getProjects();
  }

  // ============================================================
  // Métodos atómicos para composición en UseCases
  // ============================================================

  @override
  Future<List<Project>> getRemoteProjects() async {
    final models = await remoteDataSource.getProjects();
    // ProjectModel extends Project, por lo que el cast es válido
    return models.cast<Project>();
  }

  @override
  Future<List<Project>> getLocalProjects() async => await localDataSource.getProjects();

  @override
  Future<void> saveProjectsLocally(List<Project> projects) async {
    await localDataSource.cacheProjects(projects, fromRemote: true);
  }

  @override
  Future<bool> isOnline() async => await networkInfo.checkConnection();

  @override
  Future<void> createProjectLocal(Project project, {bool pendingSync = true}) async {
    await localDataSource.saveProject(project, pendingSync: pendingSync);
  }

  @override
  Future<void> createProjectRemote(Project project) async {
    final projectModel = ProjectModel(
      id: project.id,
      name: project.name,
      location: project.location,
      startDate: project.startDate,
      endDate: project.endDate,
    );
    await remoteDataSource.createProject(projectModel);
  }

  @override
  Future<void> markProjectAsSynced(String projectId) async {
    await localDataSource.markAsSynced(projectId);
  }
}
