import 'base_incidents_provider.dart';

/// Provider especializado en gestionar la lista de tareas asignadas al usuario.
///
/// Solo maneja:
/// - Cargar y refrescar tareas asignadas
/// - Estadísticas y contadores de tareas
class MyTasksProvider extends BaseIncidentsProvider {
  MyTasksProvider({required super.repository});

  /// Cargar tareas asignadas al usuario
  Future<void> loadMyTasks(String userId, {String projectId = ''}) async {
    await loadList(
      loadFunction: () => repository.getMyTasks(userId, projectId),
      errorMessage: 'Error al cargar tareas',
    );
  }

  /// Refrescar tareas
  Future<void> refreshTasks(String userId, {String projectId = ''}) async {
    await loadMyTasks(userId, projectId: projectId);
  }
}