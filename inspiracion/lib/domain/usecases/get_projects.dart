import '../entities/project_entity.dart';
import 'sync_projects.dart';

/// UseCase "fachada" que preserva el nombre antiguo pero delega en SyncProjectsUseCase.
class GetProjects {
  final SyncProjectsUseCase _syncProjects;

  GetProjects(this._syncProjects);

  Future<List<Project>> call() async {
    return await _syncProjects.call();
  }
}