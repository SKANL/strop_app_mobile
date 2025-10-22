import '../entities/dashboard_summary_entity.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardSummary {
  final DashboardRepository repository;

  GetDashboardSummary(this.repository);

  Future<DashboardSummary> call() async {
    return await repository.getDashboardSummary();
  }
}