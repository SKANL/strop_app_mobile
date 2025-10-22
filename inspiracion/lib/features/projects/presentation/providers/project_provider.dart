import 'package:flutter/foundation.dart';
import '../../../../core/sync/sync_service.dart';
import '../../../../domain/entities/project_entity.dart';
import '../../../../domain/usecases/get_projects.dart';
import '../../../../domain/usecases/create_project.dart';

/// Gestiona el estado de la pantalla que muestra la lista de proyectos.
class ProjectProvider extends ChangeNotifier {
  final GetProjects _getProjects;
  final CreateProject _createProject;
  final SyncService? _syncService;

  // Constructor que recibe el caso de uso y opcionalmente SyncService
  ProjectProvider(
    this._getProjects,
    this._createProject, {
    SyncService? syncService,
  }) : _syncService = syncService {
    // Escuchar cambios en SyncService para auto-refrescar
    _syncService?.addListener(_onSyncCompleted);
  }

  // --- ESTADO DE LA UI ---
  bool _isLoading = false;
  bool _isCreating = false;
  List<Project> _projects = [];
  String? _error;

  // --- GETTERS PÚBLICOS ---
  // Los widgets escucharán estos getters para reconstruirse.
  bool get isLoading => _isLoading;
  bool get isCreating => _isCreating;
  List<Project> get projects => _projects;
  String? get error => _error;

  /// Callback que se ejecuta cuando SyncService completa una sincronización
  void _onSyncCompleted() {
    final syncResult = _syncService?.lastSyncResult;
    
    // Solo refrescar si hubo sincronización exitosa de proyectos
    if (syncResult != null && 
        syncResult.syncedItems > 0 && 
        !_isLoading) {
      
      // Verificar si se sincronizaron proyectos
      final syncedProjects = _syncService?.pendingItems
          .where((item) => item.type == 'project')
          .length ?? 0;
      
      if (syncedProjects > 0 || syncResult.syncedItems > 0) {
        // Auto-refrescar datos sin mostrar indicador de carga
        _silentRefresh();
      }
    }
  }

  /// Refresca datos sin mostrar spinner de carga (para sincronización en background)
  Future<void> _silentRefresh() async {
    try {
      final updatedProjects = await _getProjects.call();
      _projects = updatedProjects;
      notifyListeners(); // Actualiza UI automáticamente
    } catch (e) {
      // Error silencioso, no afecta la UX
      debugPrint('🔄 Error en refresh silencioso: $e');
    }
  }

  /// Método para obtener la lista de proyectos.
  Future<void> fetchProjects() async {
    // 1. Inicia el estado de carga y notifica a los widgets.
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // 2. Llama al caso de uso para obtener los datos.
      _projects = await _getProjects.call();
    } catch (e) {
      // 3. Si hay un error, lo guarda en el estado.
      _error = e.toString();
    } finally {
      // 4. Finaliza el estado de carga y notifica a los widgets para que se actualicen.
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Método para crear un nuevo proyecto.
  Future<bool> createProject(Project project) async {
    _isCreating = true;
    _error = null;
    notifyListeners();

    try {
      // Llamar al caso de uso para crear el proyecto
      await _createProject.call(project);
      
      // Agregar el proyecto a la lista local inmediatamente
      // (ya está guardado en la DB, solo actualizamos la UI)
      _projects = [..._projects, project];
      
      // Notificar para actualizar la UI sin esperar a fetchProjects
      _isCreating = false;
      notifyListeners();
      
      // Opcionalmente, refrescar en background para obtener datos del servidor
      // Esto no bloqueará la UI y el merge inteligente protegerá el proyecto local
      fetchProjects().then((_) {
        // Refresh completado en background
      }).catchError((e) {
        // Si falla, no importa, ya tenemos el proyecto local
      });
      
      return true;
    } catch (e) {
      _error = e.toString();
      _isCreating = false;
      notifyListeners();
      return false;
    }
  }

  Project? _selectedProject;
  Project? get selectedProject => _selectedProject;

  void selectProject(Project project) {
    _selectedProject = project;
    notifyListeners();
  }

  @override
  void dispose() {
    // Remover listener de SyncService al destruir el provider
    _syncService?.removeListener(_onSyncCompleted);
    super.dispose();
  }
}
