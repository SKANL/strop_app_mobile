// lib/src/core/core_domain/contracts/data_provider.dart
import '../entities/incident_entity.dart';

/// Contrato agnóstico para proveedores de datos
/// 
/// Define interfaz que permite cambiar entre:
/// - FakeDataProvider (desarrollo)
/// - ApiDataProvider (producción)
/// 
/// Sin cambios en la capa de presentación
abstract class DataProvider<T> {
  /// Obtener un item por ID
  Future<T> fetch(String id);

  /// Obtener todos los items
  Future<List<T>> fetchAll();

  /// Obtener items con filtros opcionales
  Future<List<T>> fetchFiltered({
    Map<String, dynamic>? filters,
  });
}

/// Implementación Fake para desarrollo
class FakeIncidentDataProvider implements DataProvider<IncidentEntity> {
  // Aquí iría la lógica de IncidentsFakeDataSource
  // Implementar cuando se requiera abstracción real

  @override
  Future<IncidentEntity> fetch(String id) async {
    // TODO: Implementar usando IncidentsFakeDataSource
    throw UnimplementedError('Use IncidentsRepositoryImpl for now');
  }

  @override
  Future<List<IncidentEntity>> fetchAll() async {
    // TODO: Implementar usando IncidentsFakeDataSource
    throw UnimplementedError('Use IncidentsRepositoryImpl for now');
  }

  @override
  Future<List<IncidentEntity>> fetchFiltered({
    Map<String, dynamic>? filters,
  }) async {
    // TODO: Implementar usando IncidentsFakeDataSource
    throw UnimplementedError('Use IncidentsRepositoryImpl for now');
  }
}

/// Implementación API para producción (futuro)
class ApiIncidentDataProvider implements DataProvider<IncidentEntity> {
  // Aquí iría la integración con API real

  @override
  Future<IncidentEntity> fetch(String id) async {
    // TODO: GET /incidents/{id}
    throw UnimplementedError('API integration pending');
  }

  @override
  Future<List<IncidentEntity>> fetchAll() async {
    // TODO: GET /incidents
    throw UnimplementedError('API integration pending');
  }

  @override
  Future<List<IncidentEntity>> fetchFiltered({
    Map<String, dynamic>? filters,
  }) async {
    // TODO: GET /incidents with query params
    throw UnimplementedError('API integration pending');
  }
}
