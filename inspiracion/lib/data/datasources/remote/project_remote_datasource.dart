import '../../../core/api/api_client.dart';
import '../../../core/utils/app_logger.dart';
import '../../models/project_model.dart';

/// Interfaz para la fuente de datos remota de proyectos
abstract class ProjectRemoteDataSource {
  Future<List<ProjectModel>> getProjects();
  Future<void> createProject(ProjectModel project);
}

/// Implementación real de ProjectRemoteDataSource usando la API REST
/// 
/// Endpoints:
/// - GET /projects
/// - POST /projects
class ProjectRemoteDataSourceImpl implements ProjectRemoteDataSource {
  final ApiClient _apiClient;
  
  ProjectRemoteDataSourceImpl(this._apiClient);
  
  @override
  Future<List<ProjectModel>> getProjects() async {
    AppLogger.info('═══ ProjectRemoteDataSource.getProjects() ═══', 
      category: AppLogger.categoryNetwork);
    
    try {
      // GET /projects?limit=100
      final response = await _apiClient.get(
        '/projects',
        queryParameters: {'limit': 100},
      );
      
      // Extraer array de proyectos
      final projectsData = response.data['data']['projects'] as List;
      
      // Convertir a modelos
      final projects = projectsData
          .map((json) => ProjectModel.fromJson(json))
          .toList();
      
      AppLogger.info('✓ ${projects.length} proyectos obtenidos desde servidor', 
        category: AppLogger.categoryNetwork);
      
      return projects;
      
    } on ApiException catch (e) {
      AppLogger.error('Error al obtener proyectos (API)', 
        category: AppLogger.categoryNetwork, error: e);
      
      if (e is ConnectionException) {
        throw Exception('No hay conexión a internet');
      } else if (e is TimeoutException) {
        throw Exception('La conexión tardó demasiado tiempo');
      } else if (e is UnauthorizedException) {
        throw Exception('Sesión expirada. Por favor inicia sesión nuevamente');
      } else {
        throw Exception('Error al obtener proyectos: ${e.message}');
      }
    } catch (e) {
      AppLogger.error('Error inesperado al obtener proyectos', 
        category: AppLogger.categoryNetwork, error: e);
      throw Exception('Error inesperado al obtener proyectos');
    }
  }
  
  @override
  Future<void> createProject(ProjectModel project) async {
    AppLogger.info('═══ ProjectRemoteDataSource.createProject() ═══', 
      category: AppLogger.categoryNetwork);
    AppLogger.info('Proyecto: ${project.name} (ID: ${project.id})', 
      category: AppLogger.categoryNetwork);
    
    try {
      // POST /projects
      await _apiClient.post(
        '/projects',
        data: {
          'id': project.id, // ✅ UUID generado por el cliente
          'name': project.name,
          'location': project.location,
          // 🔧 CRÍTICO: PostgreSQL requiere DateTime en UTC explícito
          'startDate': project.startDate.toUtc().toIso8601String(),
          'endDate': project.endDate.toUtc().toIso8601String(),
          // NO enviamos: createdAt, updatedAt, status (auto-generados por BD)
        },
      );
      
      AppLogger.info('✓ Proyecto creado exitosamente en servidor', 
        category: AppLogger.categoryNetwork);
      
    } on ConflictException {
      // 409 Conflict - El UUID ya existe en el servidor
      AppLogger.warning('Proyecto con ID ${project.id} ya existe en servidor (409). '
        'Probablemente ya fue sincronizado.', 
        category: AppLogger.categoryNetwork);
      
      // No lanzamos excepción - esto es esperado en flujo offline-first
      // El caller (repository) debe marcar como sincronizado
      
    } on ApiException catch (e) {
      AppLogger.error('Error al crear proyecto (API)', 
        category: AppLogger.categoryNetwork, error: e);
      
      if (e is ConnectionException) {
        throw Exception('No hay conexión a internet');
      } else if (e is TimeoutException) {
        throw Exception('La conexión tardó demasiado tiempo');
      } else if (e is UnauthorizedException) {
        throw Exception('Sesión expirada. Por favor inicia sesión nuevamente');
      } else if (e is BadRequestException) {
        throw Exception('Datos del proyecto inválidos: ${e.message}');
      } else {
        throw Exception('Error al crear proyecto: ${e.message}');
      }
    } catch (e) {
      AppLogger.error('Error inesperado al crear proyecto', 
        category: AppLogger.categoryNetwork, error: e);
      throw Exception('Error inesperado al crear proyecto');
    }
  }
}
