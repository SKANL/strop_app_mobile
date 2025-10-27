import 'package:flutter/foundation.dart';
import '../../../../core/core_domain/entities/incident_entity.dart';
import '../../../../core/core_domain/entities/data_state.dart';
import '../../../../core/core_domain/errors/failures.dart';
import '../../../../core/core_domain/repositories/incident_repository.dart';
import '../../domain/services/incidents_filter_service.dart';

/// Base provider que proporciona funcionalidad común para todos los providers de incidentes.
///
/// Implementa la funcionalidad base para:
/// - Manejo de estado usando DataState
/// - Carga de datos con manejo de errores
/// - Contador de incidentes por estado y prioridad
abstract class BaseIncidentsProvider extends ChangeNotifier {
  final IncidentRepository repository;

  BaseIncidentsProvider({required this.repository});

  // ============================================================================
  // ESTADO
  // ============================================================================
  
  DataState<List<IncidentEntity>> _state = const DataState.initial();
  
  DataState<List<IncidentEntity>> get state => _state;
  
  List<IncidentEntity> get items => _state.dataOrNull ?? [];
  bool get isLoading => _state.isLoading;
  String? get error => _state.failureOrNull?.message;

  // ============================================================================
  // MÉTODOS PROTEGIDOS - Para usar en subclases
  // ============================================================================

  /// Método genérico para cargar listas y actualizar estado
  @protected
  Future<void> loadList({
    required Future<List<IncidentEntity>> Function() loadFunction,
    required String errorMessage,
  }) async {
    _state = const DataState.loading();
    notifyListeners();

    try {
      final items = await loadFunction();
      _state = DataState.success(items);
      notifyListeners();
    } catch (e) {
      _state = DataState.error(
        UnexpectedFailure(message: '$errorMessage: ${e.toString()}'),
      );
      notifyListeners();
    }
  }

  /// Actualiza el estado directamente (para subclases)
  @protected
  set state(DataState<List<IncidentEntity>> newState) {
    _state = newState;
    notifyListeners();
  }

  // ============================================================================
  // MÉTODOS PÚBLICOS - Estadísticas y contadores
  // ============================================================================

  /// Obtener contadores por estado
  Map<IncidentStatus, int> get countByStatus {
    return IncidentsFilterService.countByStatus(items);
  }
  
  /// Obtener contadores por prioridad
  Map<IncidentPriority, int> get countByPriority {
    return IncidentsFilterService.countByPriority(items);
  }
  
  /// Obtener cantidad total de incidentes
  int get totalCount => items.length;

  /// Obtener cantidad de incidentes pendientes (open status)
  int get pendingCount {
    final statusCounts = countByStatus;
    return statusCounts[IncidentStatus.open] ?? 0;
  }
  
  /// Obtener incidentes críticos
  List<IncidentEntity> get criticalItems {
    return IncidentsFilterService.getCriticalIncidents(items);
  }

  /// Limpiar todos los datos
  void clear() {
    _state = const DataState.initial();
    notifyListeners();
  }
}