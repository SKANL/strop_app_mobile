import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../domain/entities/incident_entity.dart';
import '../../../core/utils/app_logger.dart';
import '../../models/incident_model.dart';
import 'app_database.dart';
import 'incident_local_datasource.dart';

/// Implementación de IncidentLocalDataSource usando Drift (SQLite)
class IncidentLocalDataSourceImpl implements IncidentLocalDataSource {
  final AppDatabase _database;

  IncidentLocalDataSourceImpl(this._database);

  @override
  Future<List<Incident>> getIncidentsForProject(String projectId) async {
    AppLogger.info('Obteniendo incidencias para proyecto $projectId desde local DB',
        category: AppLogger.categoryDatabase);

    final query = _database.select(_database.incidents)
      ..where((incident) => incident.projectId.equals(projectId))
      ..orderBy([
        (incident) => OrderingTerm(
          expression: incident.reportedDate,
          mode: OrderingMode.desc,
        )
      ]);

    final results = await query.get();

    AppLogger.info('✓ ${results.length} incidencias obtenidas desde local DB',
        category: AppLogger.categoryDatabase);

    return results.map(_convertToIncident).toList();
  }

  @override
  Future<Incident?> getIncidentById(String incidentId) async {
    AppLogger.info('Obteniendo incidencia $incidentId desde local DB',
        category: AppLogger.categoryDatabase);

    final query = _database.select(_database.incidents)
      ..where((incident) => incident.id.equals(incidentId));

    final result = await query.getSingleOrNull();

    if (result == null) {
      AppLogger.info('Incidencia $incidentId no encontrada en local DB',
          category: AppLogger.categoryDatabase);
      return null;
    }

    return _convertToIncident(result);
  }

  @override
  Future<void> saveIncident(Incident incident, {bool pendingSync = true}) async {
    AppLogger.info('Guardando incidencia ${incident.id} en local DB (pendingSync: $pendingSync)',
        category: AppLogger.categoryDatabase);

    final companion = IncidentsCompanion(
      id: Value(incident.id),
      projectId: Value(incident.projectId),
      description: Value(incident.description),
      author: Value(incident.author),
      reportedDate: Value(incident.reportedDate),
      status: Value(incident.status.name),
      imageUrls: Value(jsonEncode(incident.imageUrls)),
      assignedTo: Value(incident.assignedTo),
      assignedToId: Value(incident.assignedToId),
      closingNote: Value(incident.closingNote),
      pendingSync: Value(pendingSync),
      lastModifiedAt: Value(DateTime.now()),
    );

    await _database.into(_database.incidents).insertOnConflictUpdate(companion);

    AppLogger.info('✓ Incidencia guardada exitosamente',
        category: AppLogger.categoryDatabase);
  }

  @override
  Future<void> updateIncident(Incident incident, {bool pendingSync = true}) async {
    AppLogger.info('Actualizando incidencia ${incident.id} en local DB (pendingSync: $pendingSync)',
        category: AppLogger.categoryDatabase);

    final companion = IncidentsCompanion(
      id: Value(incident.id),
      projectId: Value(incident.projectId),
      description: Value(incident.description),
      author: Value(incident.author),
      reportedDate: Value(incident.reportedDate),
      status: Value(incident.status.name),
      imageUrls: Value(jsonEncode(incident.imageUrls)),
      assignedTo: Value(incident.assignedTo),
      assignedToId: Value(incident.assignedToId),
      closingNote: Value(incident.closingNote),
      pendingSync: Value(pendingSync),
      lastModifiedAt: Value(DateTime.now()),
    );

    await _database.into(_database.incidents).insertOnConflictUpdate(companion);

    AppLogger.info('✓ Incidencia actualizada exitosamente',
        category: AppLogger.categoryDatabase);
  }

  @override
  Future<List<Incident>> getPendingIncidents() async {
    AppLogger.info('Obteniendo incidencias pendientes de sincronización',
        category: AppLogger.categoryDatabase);

    final query = _database.select(_database.incidents)
      ..where((incident) => incident.pendingSync.equals(true))
      ..orderBy([
        (incident) => OrderingTerm(
          expression: incident.createdAt,
          mode: OrderingMode.asc,
        )
      ]);

    final results = await query.get();

    AppLogger.info('✓ ${results.length} incidencias pendientes encontradas',
        category: AppLogger.categoryDatabase);

    return results.map(_convertToIncident).toList();
  }

  @override
  Future<void> markAsSynced(String incidentId) async {
    AppLogger.info('Marcando incidencia $incidentId como sincronizada',
        category: AppLogger.categoryDatabase);

    await (_database.update(_database.incidents)
          ..where((incident) => incident.id.equals(incidentId)))
        .write(
      IncidentsCompanion(
        pendingSync: const Value(false),
        syncedAt: Value(DateTime.now()),
        lastModifiedAt: Value(DateTime.now()),
      ),
    );

    AppLogger.info('✓ Incidencia marcada como sincronizada',
        category: AppLogger.categoryDatabase);
  }

  @override
  Future<void> cacheIncidents(List<IncidentModel> incidents, {bool fromRemote = false}) async {
    AppLogger.info('Cacheando ${incidents.length} incidencias en local DB (fromRemote: $fromRemote)',
        category: AppLogger.categoryDatabase);

    for (final incident in incidents) {
      // Si viene del servidor, marcar como sincronizado
      final companion = IncidentsCompanion(
        id: Value(incident.id),
        projectId: Value(incident.projectId),
        description: Value(incident.description),
        author: Value(incident.author),
        reportedDate: Value(incident.reportedDate),
        status: Value(incident.status.name),
        imageUrls: Value(jsonEncode(incident.imageUrls)),
        assignedTo: Value(incident.assignedTo),
        assignedToId: Value(incident.assignedToId),
        closingNote: Value(incident.closingNote),
        pendingSync: Value(!fromRemote),
        syncedAt: fromRemote ? Value(DateTime.now()) : const Value.absent(),
        lastModifiedAt: Value(DateTime.now()),
      );

      await _database.into(_database.incidents).insertOnConflictUpdate(companion);
    }

    AppLogger.info('✓ Incidencias cacheadas exitosamente',
        category: AppLogger.categoryDatabase);
  }

  /// Convierte IncidentData (generado por Drift) a Incident (entidad de dominio)
  Incident _convertToIncident(IncidentData data) {
    final imageUrlsList = (jsonDecode(data.imageUrls) as List<dynamic>)
        .map((e) => e.toString())
        .toList();

    return IncidentModel(
      id: data.id,
      projectId: data.projectId,
      description: data.description,
      author: data.author,
      reportedDate: data.reportedDate,
      status: IncidentStatus.values.firstWhere(
        (s) => s.name == data.status,
        orElse: () => IncidentStatus.open,
      ),
      imageUrls: imageUrlsList,
      assignedTo: data.assignedTo ?? '',
      assignedToId: data.assignedToId ?? '',
      closingNote: data.closingNote ?? '',
    );
  }
}
