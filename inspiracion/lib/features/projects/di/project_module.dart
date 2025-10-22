import 'package:get_it/get_it.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/utils/platform_helper.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../data/datasources/local/project_local_datasource.dart';
import '../../../data/datasources/local/project_local_datasource_impl.dart';
import '../../../data/datasources/remote/project_remote_datasource.dart';
import '../../../data/models/pending_project_data.dart';
import '../../../data/repositories_impl/project_repository_impl.dart';
import '../../../domain/entities/project_entity.dart';
import '../../../domain/repositories/project_repository.dart';
import '../../../domain/usecases/create_project.dart';
import '../../../domain/usecases/get_projects.dart';
import '../../../domain/usecases/sync_projects.dart';
import '../presentation/providers/project_provider.dart';

final sl = GetIt.instance;

/// Registra las dependencias relacionadas con los proyectos.
/// 
/// Mobile: Registra datasources locales (Drift) y remotas (API)
/// Web/Desktop: Solo registra datasources remotas (API)
void setupProjectDependencies() {
  // DataSources Remote (todas las plataformas)
  sl.registerLazySingleton<ProjectRemoteDataSource>(
    () => ProjectRemoteDataSourceImpl(sl()),
  );

  // DataSources Local (SOLO Mobile)
  if (PlatformHelper.isMobile) {
    sl.registerLazySingleton<ProjectLocalDataSource>(
      () => ProjectLocalDataSourceImpl(sl<AppDatabase>()),
    );
  } else {
    // Implementación "falsa" para Web/Desktop (no tienen persistencia local)
    sl.registerLazySingleton<ProjectLocalDataSource>(() => _FakeProjectLocalDataSource());
  }

  // Repository
  sl.registerLazySingleton<ProjectRepository>(
    () => ProjectRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // UseCases
  // Register Sync use case then expose GetProjects facade which delegates to it
  sl.registerFactory(() => SyncProjectsUseCase(sl()));
  sl.registerFactory(() => GetProjects(sl<SyncProjectsUseCase>()));
  sl.registerFactory(() => CreateProject(sl()));

  // Provider
  sl.registerFactory(
    () => ProjectProvider(
      sl<GetProjects>(),
      sl<CreateProject>(),
      syncService: PlatformHelper.isMobile ? sl<SyncService>() : null,
    ),
  );
}

/// Implementación de DataSource local para web, que no tiene persistencia.
class _FakeProjectLocalDataSource implements ProjectLocalDataSource {
  @override
  Future<void> cacheProjects(List<Project> projects, {bool fromRemote = false}) async {}
  @override
  Future<List<Project>> getProjects() async => [];
  @override
  Future<List<Project>> getPendingProjects() async => [];
  @override
  Future<List<PendingProjectData>> getPendingProjectsWithMetadata() async => [];
  @override
  Future<void> saveProject(Project project, {bool pendingSync = true}) async {}
  @override
  Future<void> markAsSynced(String projectId) async {}
  @override
  Future<void> updateLastModified(String projectId) async {}
  @override
  Future<Project?> getProjectById(String projectId) async => null;
  @override
  Future<void> clearAll() async {}
}