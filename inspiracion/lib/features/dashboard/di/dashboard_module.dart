import 'package:get_it/get_it.dart';
import '../../../data/datasources/remote/dashboard_remote_datasource.dart';
import '../../../data/repositories_impl/dashboard_repository_impl.dart';
import '../../../domain/repositories/dashboard_repository.dart';
import '../../../domain/usecases/get_dashboard_summary.dart';
import '../presentation/providers/dashboard_provider.dart';

final sl = GetIt.instance;

/// Registra las dependencias relacionadas con el dashboard.
void setupDashboardDependencies() {
  // DataSource
  sl.registerLazySingleton<DashboardDataSource>(
    () => DashboardRemoteDataSourceImpl(sl()),
  );

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerFactory(() => GetDashboardSummary(sl()));

  // Provider
  sl.registerFactory(() => DashboardProvider(sl()));
}