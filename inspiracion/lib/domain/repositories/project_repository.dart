import '../entities/project_entity.dart'; // 1. Importamos nuestra entidad Project.

// 2. 'abstract class' significa que esto es un contrato, no una clase real que se pueda usar directamente.
//    Es una plantilla que otras clases deberán seguir.
abstract class ProjectRepository {

  // 3. Definimos una función llamada 'getProjects'.
  //    - 'Future<List<Project>>' significa: "Esta función tomará tiempo en completarse (Future)
  //      y, cuando termine, devolverá una lista de objetos Project".
  Future<List<Project>> getProjects();

  /// Métodos atómicos para permitir orquestación de sincronización fuera del repositorio
  Future<List<Project>> getRemoteProjects();
  Future<List<Project>> getLocalProjects();
  Future<void> saveProjectsLocally(List<Project> projects);
  Future<bool> isOnline();

  /// Métodos atómicos para crear proyectos (orquestados desde UseCase)
  Future<void> createProjectLocal(Project project, {bool pendingSync = true});
  Future<void> createProjectRemote(Project project);
  Future<void> markProjectAsSynced(String projectId);
}