import 'package:get_it/get_it.dart';
import '../../../core/sync/sync_service.dart';
import '../../../core/utils/platform_helper.dart';
import '../../../data/datasources/local/app_database.dart';
import '../../../data/datasources/local/incident_local_datasource.dart';
import '../../../data/datasources/local/incident_local_datasource_impl.dart';
import '../../../data/datasources/remote/incident_remote_datasource.dart';
import '../../../data/repositories_impl/incident_repository_impl.dart';
import '../../../domain/entities/incident_entity.dart';
import '../../../data/models/incident_model.dart';
import '../../../domain/repositories/incident_repository.dart';
import '../../../domain/usecases/assign_incident.dart';
import '../../../domain/usecases/close_incident.dart';
import '../../../domain/usecases/create_incident.dart';
import '../../../domain/usecases/get_incident_by_id.dart';
import '../../../domain/usecases/get_incidents_for_project.dart';
import '../../../domain/usecases/sync_incidents.dart';
import '../presentation/providers/incident_provider.dart';

final sl = GetIt.instance;

/// Registra las dependencias relacionadas con las incidencias.
/// 
/// Mobile: Registra datasources locales (Drift) y remotas (API)
/// Web/Desktop: Solo registra datasources remotas (API)
void setupIncidentDependencies() {
  // DataSources Remote (todas las plataformas)
  sl.registerLazySingleton<IncidentRemoteDataSource>(
    () => IncidentRemoteDataSourceImpl(sl()),
  );

  // DataSources Local (SOLO Mobile)
  if (PlatformHelper.isMobile) {
    sl.registerLazySingleton<IncidentLocalDataSource>(
      () => IncidentLocalDataSourceImpl(sl<AppDatabase>()),
    );
  } else {
    // Implementación "falsa" para Web/Desktop (no tienen persistencia local)
    sl.registerLazySingleton<IncidentLocalDataSource>(() => _FakeIncidentLocalDataSource());
  }

  // Repository
  sl.registerLazySingleton<IncidentRepository>(
    () => IncidentRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // UseCases
  sl.registerFactory(() => SyncIncidentsUseCase(sl()));
  sl.registerFactory(() => GetIncidentsForProject(sl<SyncIncidentsUseCase>()));
  sl.registerFactory(() => CreateIncident(sl()));
  sl.registerFactory(() => GetIncidentById(sl()));
  sl.registerFactory(() => AssignIncident(sl()));
  sl.registerFactory(() => CloseIncident(sl()));

  // Provider
  sl.registerFactory(
    () => IncidentProvider(
      sl<GetIncidentsForProject>(),
      sl<CreateIncident>(),
      sl<GetIncidentById>(),
      sl<AssignIncident>(),
      sl<CloseIncident>(),
      syncService: PlatformHelper.isMobile ? sl<SyncService>() : null,
    ),
  );
}

/// Implementación de DataSource local para web, que no tiene persistencia.
class _FakeIncidentLocalDataSource implements IncidentLocalDataSource {
  @override
  Future<void> cacheIncidents(List<IncidentModel> incidents, {bool fromRemote = false}) async {}

  @override
  Future<List<Incident>> getIncidentsForProject(String projectId) async => [];

  @override
  Future<void> saveIncident(Incident incident, {bool pendingSync = true}) async {}

  @override
  Future<List<Incident>> getPendingIncidents() async => [];

  @override
  Future<void> markAsSynced(String incidentId) async {}

  @override
  Future<void> updateIncident(Incident incident, {bool pendingSync = true}) async {}

  @override
  Future<Incident?> getIncidentById(String incidentId) async => null;
}