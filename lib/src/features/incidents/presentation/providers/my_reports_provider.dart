import 'base_incidents_provider.dart';

/// Provider especializado en gestionar la lista de reportes creados por el usuario.
///
/// Solo maneja:
/// - Cargar y refrescar reportes creados
/// - Estadísticas y contadores de reportes
class MyReportsProvider extends BaseIncidentsProvider {
  MyReportsProvider({required super.repository});

  /// Cargar reportes creados por el usuario
  Future<void> loadMyReports(String userId, {String projectId = ''}) async {
    await loadList(
      loadFunction: () => repository.getMyReports(userId, projectId),
      errorMessage: 'Error al cargar reportes',
    );
  }

  /// Refrescar reportes
  Future<void> refreshReports(String userId, {String projectId = ''}) async {
    await loadMyReports(userId, projectId: projectId);
  }
}