// lib/src/features/home/presentation/providers/projects_provider.dart
import 'package:flutter/foundation.dart';
import '../../../../core/core_domain/entities/project_entity.dart';
import '../../../../core/core_domain/repositories/project_repository.dart';

/// Provider para gestionar el estado de proyectos
/// 
/// Responsabilidades:
/// - Cargar proyectos activos y archivados
/// - Gestionar estados de loading y error
/// - Notificar cambios a los widgets Consumer
class ProjectsProvider extends ChangeNotifier {
  final ProjectRepository repository;

  ProjectsProvider({required this.repository});

  // Estado de proyectos activos
  List<ProjectEntity> _activeProjects = [];
  bool _isLoadingActive = false;
  String? _activeError;

  // Estado de proyectos archivados
  List<ProjectEntity> _archivedProjects = [];
  bool _isLoadingArchived = false;
  String? _archivedError;

  // Proyecto seleccionado actualmente
  ProjectEntity? _selectedProject;
  bool _isLoadingDetail = false;
  String? _detailError;

  // Getters públicos
  List<ProjectEntity> get activeProjects => _activeProjects;
  bool get isLoadingActive => _isLoadingActive;
  String? get activeError => _activeError;

  List<ProjectEntity> get archivedProjects => _archivedProjects;
  bool get isLoadingArchived => _isLoadingArchived;
  String? get archivedError => _archivedError;

  ProjectEntity? get selectedProject => _selectedProject;
  bool get isLoadingDetail => _isLoadingDetail;
  String? get detailError => _detailError;

  /// Cargar proyectos activos
  Future<void> loadActiveProjects() async {
    _isLoadingActive = true;
    _activeError = null;
    notifyListeners();

    try {
      _activeProjects = await repository.getActiveProjects();
      _isLoadingActive = false;
      notifyListeners();
    } catch (e) {
      _activeError = e.toString();
      _isLoadingActive = false;
      notifyListeners();
    }
  }

  /// Cargar proyectos archivados
  Future<void> loadArchivedProjects() async {
    _isLoadingArchived = true;
    _archivedError = null;
    notifyListeners();

    try {
      _archivedProjects = await repository.getArchivedProjects();
      _isLoadingArchived = false;
      notifyListeners();
    } catch (e) {
      _archivedError = e.toString();
      _isLoadingArchived = false;
      notifyListeners();
    }
  }

  /// Cargar detalle de un proyecto por ID
  Future<void> loadProjectDetail(String projectId) async {
    _isLoadingDetail = true;
    _detailError = null;
    notifyListeners();

    try {
      _selectedProject = await repository.getProjectById(projectId);
      _isLoadingDetail = false;
      notifyListeners();
    } catch (e) {
      _detailError = e.toString();
      _isLoadingDetail = false;
      notifyListeners();
    }
  }

  /// Seleccionar un proyecto de la lista ya cargada
  void selectProject(ProjectEntity project) {
    _selectedProject = project;
    notifyListeners();
  }

  /// Limpiar proyecto seleccionado
  void clearSelectedProject() {
    _selectedProject = null;
    _detailError = null;
    notifyListeners();
  }

  /// Refrescar proyectos activos
  Future<void> refreshActiveProjects() async {
    await loadActiveProjects();
  }

  /// Refrescar proyectos archivados
  Future<void> refreshArchivedProjects() async {
    await loadArchivedProjects();
  }

  /// Limpiar todos los datos
  void clear() {
    _activeProjects = [];
    _archivedProjects = [];
    _selectedProject = null;
    _activeError = null;
    _archivedError = null;
    _detailError = null;
    notifyListeners();
  }
}
