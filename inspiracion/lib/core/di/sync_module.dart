import '../../data/datasources/local/incident_local_datasource.dart';
import '../../data/datasources/local/project_local_datasource.dart';
import '../../domain/repositories/incident_repository.dart';
import '../../domain/repositories/project_repository.dart';
import '../sync/sync_service.dart';
import '../utils/network_info.dart';
import '../utils/platform_helper.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

/// Registra el servicio de sincronización SOLO para Mobile.
/// 
/// Web y Desktop NO necesitan SyncService porque usan solo API remota.
void setupSyncDependencies() {
  // SyncService (SOLO para plataformas móviles)
  if (PlatformHelper.isMobile) {
    sl.registerLazySingleton<SyncService>(
      () => SyncService(
        networkInfo: sl<NetworkInfo>(),
        projectLocalDataSource: sl<ProjectLocalDataSource>(),
        projectRepository: sl<ProjectRepository>(),
        incidentLocalDataSource: sl<IncidentLocalDataSource>(),
        incidentRepository: sl<IncidentRepository>(),
      ),
    );
  }
}