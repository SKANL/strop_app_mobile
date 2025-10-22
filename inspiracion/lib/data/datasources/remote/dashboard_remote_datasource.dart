import '../../../core/api/api_client.dart';
import '../../../core/utils/app_logger.dart';
import '../../../domain/entities/dashboard_summary_entity.dart';

abstract class DashboardDataSource {
  Future<DashboardSummary> getDashboardSummary();
}

class DashboardRemoteDataSourceImpl implements DashboardDataSource {
  final ApiClient _apiClient;

  DashboardRemoteDataSourceImpl(this._apiClient);

  @override
  Future<DashboardSummary> getDashboardSummary() async {
    AppLogger.info('═══ DashboardRemoteDataSource.getDashboardSummary() ═══', 
      category: AppLogger.categoryNetwork);
    
    try {
      // GET /dashboard/summary
      final response = await _apiClient.get('/dashboard/summary');
      
      // Extraer data del response
      final data = response.data['data'] as Map<String, dynamic>;
      
      final summary = DashboardSummary(
        activeProjects: data['activeProjects'] ?? 0,
        openIncidents: data['openIncidents'] ?? 0,
        closedIncidents: data['closedIncidents'] ?? 0,
        totalUsers: data['totalUsers'] ?? 0,
      );
      
      AppLogger.info('✓ Dashboard summary obtenido: ${summary.activeProjects} proyectos, ${summary.openIncidents} incidentes', 
        category: AppLogger.categoryNetwork);
      
      return summary;
      
    } on ApiException catch (e) {
      AppLogger.error('Error al obtener dashboard summary (API)', 
        category: AppLogger.categoryNetwork, error: e);
      
      if (e is ConnectionException) {
        throw ConnectionException(e.message);
      }
      
      throw ServerException(e.message);
    } catch (e) {
      AppLogger.error('Error inesperado al obtener dashboard summary', 
        category: AppLogger.categoryNetwork, error: e);
      rethrow;
    }
  }
}
