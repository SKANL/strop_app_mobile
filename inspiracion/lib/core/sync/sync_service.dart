import 'dart:async';
import 'package:flutter/foundation.dart';
import '../utils/app_logger.dart';
import '../utils/network_info.dart';
import '../../domain/entities/project_entity.dart';
import '../../domain/entities/incident_entity.dart';
import '../../domain/repositories/project_repository.dart';
import '../../domain/repositories/incident_repository.dart';
import '../../data/datasources/local/project_local_datasource.dart';
import '../../data/datasources/local/incident_local_datasource.dart';

/// Estado de sincronización para un item individual
enum SyncItemStatus {
  pending,
  syncing,
  synced,
  conflict,
  error,
}

/// Representa un item pendiente de sincronización con su estado
class SyncItem {
  final String id;
  final String type; // 'project', 'incident', etc.
  final String displayName;
  final DateTime createdAt;
  final DateTime lastModifiedAt;
  SyncItemStatus status;
  String? errorMessage;
  Project? localProjectData;
  Project? serverProjectData;
  Incident? localIncidentData;
  Incident? serverIncidentData;

  SyncItem({
    required this.id,
    required this.type,
    required this.displayName,
    required this.createdAt,
    required this.lastModifiedAt,
    this.status = SyncItemStatus.pending,
    this.errorMessage,
    this.localProjectData,
    this.serverProjectData,
    this.localIncidentData,
    this.serverIncidentData,
  });
}

/// Resultado de una operación de sincronización
class SyncResult {
  final int totalItems;
  final int syncedItems;
  final int failedItems;
  final int conflictItems;
  final List<SyncItem> conflicts;
  final Duration duration;

  SyncResult({
    required this.totalItems,
    required this.syncedItems,
    required this.failedItems,
    required this.conflictItems,
    required this.conflicts,
    required this.duration,
  });

  bool get hasConflicts => conflictItems > 0;
  bool get isFullySuccessful => failedItems == 0 && conflictItems == 0;
  String get summary => 
      'Sincronizados: $syncedItems/$totalItems | Fallos: $failedItems | Conflictos: $conflictItems';
}

/// Servicio central para manejar la sincronización offline/online.
/// 
/// Características:
/// - Sincronización automática cuando se detecta conexión
/// - Sincronización manual bajo demanda
/// - Detección y gestión de conflictos
/// - Notificaciones en tiempo real del estado de sincronización
class SyncService extends ChangeNotifier {
  final NetworkInfo _networkInfo;
  final ProjectLocalDataSource _projectLocalDataSource;
  final ProjectRepository _projectRepository;
  final IncidentLocalDataSource _incidentLocalDataSource;
  final IncidentRepository _incidentRepository;

  StreamSubscription<bool>? _networkSubscription;
  bool _isSyncing = false;
  DateTime? _lastSyncTime;
  List<SyncItem> _pendingItems = [];
  SyncResult? _lastSyncResult;

  SyncService({
    required NetworkInfo networkInfo,
    required ProjectLocalDataSource projectLocalDataSource,
    required ProjectRepository projectRepository,
    required IncidentLocalDataSource incidentLocalDataSource,
    required IncidentRepository incidentRepository,
  })  : _networkInfo = networkInfo,
        _projectLocalDataSource = projectLocalDataSource,
        _projectRepository = projectRepository,
        _incidentLocalDataSource = incidentLocalDataSource,
        _incidentRepository = incidentRepository {
    _initialize();
  }

  // Getters públicos
  bool get isSyncing => _isSyncing;
  DateTime? get lastSyncTime => _lastSyncTime;
  List<SyncItem> get pendingItems => List.unmodifiable(_pendingItems);
  int get pendingCount => _pendingItems.length;
  bool get hasPendingItems => _pendingItems.isNotEmpty;
  SyncResult? get lastSyncResult => _lastSyncResult;

  /// Inicializa el servicio y configura la sincronización automática
  void _initialize() {
    AppLogger.sync('Inicializando SyncService...');

    // Cargar items pendientes al inicio
    _loadPendingItems();

    // Escuchar cambios de conectividad para sincronización automática
    _networkSubscription = _networkInfo.onConnectivityChanged.listen((isConnected) {
      if (isConnected && hasPendingItems) {
        AppLogger.sync('Conexión detectada. Iniciando sincronización automática...');
        syncAll();
      }
    });
  }

  /// Carga los items pendientes de sincronización desde la base de datos local
  Future<void> _loadPendingItems() async {
    try {
      AppLogger.sync('Cargando items pendientes de sincronización...');

      final pendingProjectsWithMetadata = await _projectLocalDataSource.getPendingProjectsWithMetadata();
      final pendingIncidents = await _incidentLocalDataSource.getPendingIncidents();

      final projectItems = pendingProjectsWithMetadata.map((data) {
        return SyncItem(
          id: data.project.id,
          type: 'project',
          displayName: data.project.name,
          createdAt: data.createdAt,
          lastModifiedAt: data.lastModifiedAt,
          status: SyncItemStatus.pending,
          localProjectData: data.project,
        );
      }).toList();

      final incidentItems = pendingIncidents.map((incident) {
        return SyncItem(
          id: incident.id,
          type: 'incident',
          displayName: incident.description.length > 50
              ? '${incident.description.substring(0, 50)}...'
              : incident.description,
          createdAt: incident.reportedDate, // Usar reportedDate como createdAt
          lastModifiedAt: incident.reportedDate,
          status: SyncItemStatus.pending,
          localIncidentData: incident,
        );
      }).toList();

      _pendingItems = [...projectItems, ...incidentItems];

      AppLogger.sync('✓ ${_pendingItems.length} items pendientes cargados (${projectItems.length} proyectos, ${incidentItems.length} incidencias)');
      notifyListeners();
    } catch (e, stackTrace) {
      AppLogger.sync('Error al cargar items pendientes: $e', isError: true);
      AppLogger.error('', error: e, stackTrace: stackTrace);
    }
  }

  /// Sincroniza todos los items pendientes
  Future<SyncResult> syncAll() async {
    if (_isSyncing) {
      AppLogger.warning('Ya hay una sincronización en progreso', 
          category: AppLogger.categorySync);
      return _lastSyncResult ?? SyncResult(
        totalItems: 0,
        syncedItems: 0,
        failedItems: 0,
        conflictItems: 0,
        conflicts: [],
        duration: Duration.zero,
      );
    }

    // Verificar conectividad
    final isConnected = await _networkInfo.checkConnection();
    if (!isConnected) {
      AppLogger.warning('No hay conexión a internet. Sincronización cancelada.', 
          category: AppLogger.categorySync);
      return SyncResult(
        totalItems: _pendingItems.length,
        syncedItems: 0,
        failedItems: _pendingItems.length,
        conflictItems: 0,
        conflicts: [],
        duration: Duration.zero,
      );
    }

    _isSyncing = true;
    notifyListeners();

    final startTime = DateTime.now();
    int syncedCount = 0;
    int failedCount = 0;
    int conflictCount = 0;
    final conflicts = <SyncItem>[];

    AppLogger.sync('═══════════════════════════════════════════════');
    AppLogger.sync('Iniciando sincronización de ${_pendingItems.length} items...');
    AppLogger.sync('═══════════════════════════════════════════════');

    try {
      // Recargar items pendientes por si hay cambios
      await _loadPendingItems();

      for (var item in _pendingItems) {
        try {
          item.status = SyncItemStatus.syncing;
          notifyListeners();

          if (item.type == 'project' && item.localProjectData != null) {
            final result = await _syncProject(item.localProjectData!);

            if (result == SyncItemStatus.synced) {
              syncedCount++;
              item.status = SyncItemStatus.synced;
            } else if (result == SyncItemStatus.conflict) {
              conflictCount++;
              item.status = SyncItemStatus.conflict;
              conflicts.add(item);
            } else {
              failedCount++;
              item.status = SyncItemStatus.error;
            }
          } else if (item.type == 'incident' && item.localIncidentData != null) {
            final result = await _syncIncident(item.localIncidentData!);

            if (result == SyncItemStatus.synced) {
              syncedCount++;
              item.status = SyncItemStatus.synced;
            } else if (result == SyncItemStatus.conflict) {
              conflictCount++;
              item.status = SyncItemStatus.conflict;
              conflicts.add(item);
            } else {
              failedCount++;
              item.status = SyncItemStatus.error;
            }
          }

          notifyListeners();
        } catch (e) {
          AppLogger.sync('Error al sincronizar item ${item.id}: $e', isError: true);
          failedCount++;
          item.status = SyncItemStatus.error;
          item.errorMessage = e.toString();
          notifyListeners();
        }
      }

      _lastSyncTime = DateTime.now();
      final duration = _lastSyncTime!.difference(startTime);

      _lastSyncResult = SyncResult(
        totalItems: _pendingItems.length,
        syncedItems: syncedCount,
        failedItems: failedCount,
        conflictItems: conflictCount,
        conflicts: conflicts,
        duration: duration,
      );

      AppLogger.sync('═══════════════════════════════════════════════');
      AppLogger.sync('Sincronización completada: ${_lastSyncResult!.summary}');
      AppLogger.sync('Duración: ${duration.inSeconds}s');
      AppLogger.sync('═══════════════════════════════════════════════');

      // Recargar items pendientes después de la sincronización
      await _loadPendingItems();

      return _lastSyncResult!;
    } finally {
      _isSyncing = false;
      notifyListeners();
    }
  }

  /// Sincroniza un proyecto individual
  Future<SyncItemStatus> _syncProject(Project project) async {
    AppLogger.sync('Sincronizando proyecto: ${project.name}');

    try {
      // Enviar al servidor usando el repositorio
      await _projectRepository.createProjectRemote(project);

      // Marcar como sincronizado en la base de datos local
      await _projectRepository.markProjectAsSynced(project.id);

      AppLogger.sync('✓ Proyecto sincronizado: ${project.name}');
      return SyncItemStatus.synced;
    } catch (e) {
      AppLogger.sync('✗ Error al sincronizar proyecto ${project.name}: $e', isError: true);
      return SyncItemStatus.error;
    }
  }

  /// Sincroniza una incidencia individual
  Future<SyncItemStatus> _syncIncident(Incident incident) async {
    AppLogger.sync('Sincronizando incidencia: ${incident.description.substring(0, incident.description.length > 50 ? 50 : incident.description.length)}...');

    try {
      // Enviar al servidor usando el repositorio
      await _incidentRepository.createIncidentRemote(incident.projectId, incident);

      // Marcar como sincronizado en la base de datos local
      await _incidentRepository.markIncidentAsSynced(incident.id);

      AppLogger.sync('✓ Incidencia sincronizada: ${incident.id}');
      return SyncItemStatus.synced;
    } catch (e) {
      AppLogger.sync('✗ Error al sincronizar incidencia ${incident.id}: $e', isError: true);
      return SyncItemStatus.error;
    }
  }

  /// Resuelve un conflicto eligiendo la versión local
  Future<void> resolveConflictWithLocal(SyncItem item) async {
    AppLogger.sync('Resolviendo conflicto con datos locales: ${item.id}');
    // La implementación dependerá de cómo manejes los conflictos
    // Por ahora, simplemente reintentamos la sincronización
    if (item.localProjectData != null) {
      final result = await _syncProject(item.localProjectData!);
      item.status = result;
      await _loadPendingItems();
      notifyListeners();
    }
  }

  /// Resuelve un conflicto eligiendo la versión del servidor
  Future<void> resolveConflictWithServer(SyncItem item) async {
    AppLogger.sync('Resolviendo conflicto con datos del servidor: ${item.id}');
    // Marcar como sincronizado sin enviar cambios
    await _projectLocalDataSource.markAsSynced(item.id);
    await _loadPendingItems();
    notifyListeners();
  }

  @override
  void dispose() {
    AppLogger.debug('Disposing SyncService', category: AppLogger.categorySync);
    _networkSubscription?.cancel();
    super.dispose();
  }
}
