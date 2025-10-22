import '../../domain/entities/dashboard_summary_entity.dart';
import '../../domain/repositories/dashboard_repository.dart';
import '../datasources/remote/dashboard_remote_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  final DashboardDataSource dataSource;

  DashboardRepositoryImpl(this.dataSource);

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    return await dataSource.getDashboardSummary();
  }
}