// lib/src/features/incidents/data/datasources/incidents_fake_datasource.dart

/// DataSource FAKE para Incidents
/// 
/// Provee datos completos para:
/// - Tareas asignadas (MyTasks)
/// - Reportes creados (MyReports)
/// - Bitácora completa del proyecto
/// - Detalle de incidencias con timeline
/// - Creación, asignación y cierre de incidencias
/// 
/// Para cambiar a API real:
/// 1. Crear IncidentsRemoteDataSource
/// 2. Actualizar incidents_di.dart
/// 3. Actualizar IncidentsRepositoryImpl
library;


class IncidentsFakeDataSource {
  /// Base de datos fake de incidencias
  final List<Map<String, dynamic>> _fakeIncidents = [
    {
      'id': '1',
      'projectId': '1',
      'type': 'avance',
      'title': 'Avance en cimentación sector A',
      'description': 'Se completó el 80% de la cimentación en el sector A',
      'authorId': '3',
      'authorName': 'Residente González',
      'authorRole': 'resident',
      'assignedToId': null,
      'assignedToName': null,
      'status': 'cerrada', // abierta, pendiente, cerrada
      'isCritical': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'closedAt': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
      'gpsLocation': '19.4326, -99.1332',
      'photos': [
        'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Avance+1',
        'https://via.placeholder.com/300x200/2196F3/FFFFFF?text=Avance+2',
      ],
      'approvalStatus': null,
    },
    {
      'id': '2',
      'projectId': '1',
      'type': 'problema',
      'title': 'Fuga de agua en tubería principal',
      'description': 'Se detectó fuga considerable en tubería del piso 3. Requiere atención inmediata.',
      'authorId': '4',
      'authorName': 'Cabo López',
      'authorRole': 'cabo',
      'assignedToId': '4',
      'assignedToName': 'Cabo López',
      'status': 'abierta',
      'isCritical': true,
      'createdAt': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
      'closedAt': null,
      'gpsLocation': '19.4326, -99.1332',
      'photos': [
        'https://via.placeholder.com/300x200/FF9800/FFFFFF?text=Fuga+1',
      ],
      'approvalStatus': null,
    },
    {
      'id': '3',
      'projectId': '1',
      'type': 'consulta',
      'title': 'Duda sobre especificaciones eléctricas',
      'description': 'Revisar planos de instalación eléctrica piso 5',
      'authorId': '4',
      'authorName': 'Cabo López',
      'authorRole': 'cabo',
      'assignedToId': '3',
      'assignedToName': 'Residente González',
      'status': 'abierta',
      'isCritical': false,
      'createdAt': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
      'closedAt': null,
      'gpsLocation': '19.4326, -99.1332',
      'photos': [],
      'approvalStatus': null,
    },
    {
      'id': '4',
      'projectId': '1',
      'type': 'seguridad',
      'title': 'Falta equipo de protección',
      'description': 'Trabajador sin casco de seguridad en zona de riesgo',
      'authorId': '3',
      'authorName': 'Residente González',
      'authorRole': 'resident',
      'assignedToId': '4',
      'assignedToName': 'Cabo López',
      'status': 'cerrada',
      'isCritical': true,
      'createdAt': DateTime.now().subtract(const Duration(days: 1, hours: 5)).toIso8601String(),
      'closedAt': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
      'gpsLocation': '19.4326, -99.1332',
      'photos': [
        'https://via.placeholder.com/300x200/F44336/FFFFFF?text=Seguridad',
      ],
      'approvalStatus': null,
    },
    {
      'id': '5',
      'projectId': '1',
      'type': 'material',
      'title': 'Solicitud de cemento Portland',
      'description': 'Requiero 50 bultos adicionales para continuar obra',
      'authorId': '3',
      'authorName': 'Residente González',
      'authorRole': 'resident',
      'assignedToId': null,
      'assignedToName': null,
      'status': 'pendiente',
      'isCritical': false,
      'createdAt': DateTime.now().subtract(const Duration(hours: 8)).toIso8601String(),
      'closedAt': null,
      'gpsLocation': '19.4326, -99.1332',
      'photos': [],
      'approvalStatus': 'pendiente', // pendiente, aprobada, rechazada
      'materialDetails': {
        'material': 'Cemento Portland',
        'quantity': 50.0,
        'unit': 'bultos',
        'justification': 'Consumo mayor al previsto debido a correcciones en cimentación',
        'isUrgent': false,
      },
    },
    {
      'id': '6',
      'projectId': '2',
      'type': 'avance',
      'title': 'Terminado acabados sala principal',
      'description': 'Se completaron acabados de pintura y pisos',
      'authorId': '4',
      'authorName': 'Cabo López',
      'authorRole': 'cabo',
      'assignedToId': null,
      'assignedToName': null,
      'status': 'cerrada',
      'isCritical': false,
      'createdAt': DateTime.now().subtract(const Duration(days: 3)).toIso8601String(),
      'closedAt': DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
      'gpsLocation': '19.3969, -99.2310',
      'photos': [
        'https://via.placeholder.com/300x200/4CAF50/FFFFFF?text=Acabado+Final',
      ],
      'approvalStatus': null,
    },
  ];

  /// Timeline de eventos de una incidencia
  final Map<String, List<Map<String, dynamic>>> _fakeTimelines = {
    '2': [
      {
        'type': 'created',
        'timestamp': DateTime.now().subtract(const Duration(hours: 3)).toIso8601String(),
        'actor': 'Cabo López',
        'description': 'creó esta incidencia',
      },
      {
        'type': 'assigned',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2, minutes: 45)).toIso8601String(),
        'actor': 'Residente González',
        'description': 'asignó esta tarea a Cabo López',
      },
      {
        'type': 'comment',
        'timestamp': DateTime.now().subtract(const Duration(hours: 1, minutes: 30)).toIso8601String(),
        'actor': 'Cabo López',
        'description': 'Ya localicé la fuga. Necesito materiales para repararla.',
      },
    ],
    '3': [
      {
        'type': 'created',
        'timestamp': DateTime.now().subtract(const Duration(hours: 12)).toIso8601String(),
        'actor': 'Cabo López',
        'description': 'creó esta consulta',
      },
      {
        'type': 'assigned',
        'timestamp': DateTime.now().subtract(const Duration(hours: 11)).toIso8601String(),
        'actor': 'Superintendente García',
        'description': 'asignó esta consulta a Residente González',
      },
      {
        'type': 'comment',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
        'actor': 'Residente González',
        'description': 'Revisando planos, te respondo en 2 horas',
      },
    ],
  };

  /// Obtener tareas asignadas al usuario (Top-Down)
  Future<List<Map<String, dynamic>>> getMyTasks(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _fakeIncidents
        .where((i) => i['assignedToId'] == userId && i['status'] == 'abierta')
        .toList();
  }

  /// Obtener reportes creados por el usuario (Bottom-Up)
  Future<List<Map<String, dynamic>>> getMyReports(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    return _fakeIncidents
        .where((i) => i['authorId'] == userId)
        .toList();
  }

  /// Obtener bitácora completa del proyecto
  Future<List<Map<String, dynamic>>> getProjectBitacora(
    String projectId, {
    String? type,
    String? status,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    var filtered = _fakeIncidents.where((i) => i['projectId'] == projectId);

    if (type != null && type != 'todos') {
      filtered = filtered.where((i) => i['type'] == type);
    }

    if (status != null && status != 'todos') {
      filtered = filtered.where((i) => i['status'] == status);
    }

    // Filtro de fecha (simplificado)
    if (startDate != null) {
      filtered = filtered.where((i) {
        final createdAt = DateTime.parse(i['createdAt']);
        return createdAt.isAfter(startDate);
      });
    }

    if (endDate != null) {
      filtered = filtered.where((i) {
        final createdAt = DateTime.parse(i['createdAt']);
        return createdAt.isBefore(endDate);
      });
    }

    return filtered.toList();
  }

  /// Obtener detalle de una incidencia
  Future<Map<String, dynamic>> getIncidentById(String incidentId) async {
    await Future.delayed(const Duration(milliseconds: 400));

    final incident = _fakeIncidents.firstWhere(
      (i) => i['id'] == incidentId,
      orElse: () => throw Exception('Incidencia no encontrada'),
    );

    return incident;
  }

  /// Obtener timeline de una incidencia
  Future<List<Map<String, dynamic>>> getIncidentTimeline(String incidentId) async {
    await Future.delayed(const Duration(milliseconds: 300));

    return _fakeTimelines[incidentId] ?? [];
  }

  /// Crear incidencia básica
  Future<Map<String, dynamic>> createIncident({
    required String projectId,
    required String type,
    required String title,
    required String description,
    required String authorId,
    required String authorName,
    required String authorRole,
    required bool isCritical,
    required String gpsLocation,
    required List<String> photos,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final newIncident = {
      'id': '${_fakeIncidents.length + 1}',
      'projectId': projectId,
      'type': type,
      'title': title,
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'assignedToId': null,
      'assignedToName': null,
      'status': 'pendiente',
      'isCritical': isCritical,
      'createdAt': DateTime.now().toIso8601String(),
      'closedAt': null,
      'gpsLocation': gpsLocation,
      'photos': photos,
      'approvalStatus': null,
    };

    _fakeIncidents.add(newIncident);
    return newIncident;
  }

  /// Crear solicitud de material
  Future<Map<String, dynamic>> createMaterialRequest({
    required String projectId,
    required String authorId,
    required String authorName,
    required String authorRole,
    required String material,
    required double quantity,
    required String unit,
    required String description,
    required String justification,
    required bool isUrgent,
    required String gpsLocation,
    required List<String> photos,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    final newRequest = {
      'id': '${_fakeIncidents.length + 1}',
      'projectId': projectId,
      'type': 'material',
      'title': 'Solicitud de $material',
      'description': description,
      'authorId': authorId,
      'authorName': authorName,
      'authorRole': authorRole,
      'assignedToId': null,
      'assignedToName': null,
      'status': 'pendiente',
      'isCritical': isUrgent,
      'createdAt': DateTime.now().toIso8601String(),
      'closedAt': null,
      'gpsLocation': gpsLocation,
      'photos': photos,
      'approvalStatus': 'pendiente',
      'materialDetails': {
        'material': material,
        'quantity': quantity,
        'unit': unit,
        'justification': justification,
        'isUrgent': isUrgent,
      },
    };

    _fakeIncidents.add(newRequest);
    return newRequest;
  }

  /// Agregar comentario a incidencia
  Future<void> addComment(String incidentId, String userId, String userName, String comment) async {
    await Future.delayed(const Duration(milliseconds: 400));

    // Agregar al timeline
    if (!_fakeTimelines.containsKey(incidentId)) {
      _fakeTimelines[incidentId] = [];
    }

    _fakeTimelines[incidentId]!.add({
      'type': 'comment',
      'timestamp': DateTime.now().toIso8601String(),
      'actor': userName,
      'description': comment,
    });
  }

  /// Registrar aclaración
  Future<void> addCorrection(String incidentId, String userId, String userName, String explanation) async {
    await Future.delayed(const Duration(milliseconds: 500));

    if (!_fakeTimelines.containsKey(incidentId)) {
      _fakeTimelines[incidentId] = [];
    }

    _fakeTimelines[incidentId]!.add({
      'type': 'correction',
      'timestamp': DateTime.now().toIso8601String(),
      'actor': userName,
      'description': 'Aclaración: $explanation',
    });
  }

  /// Asignar incidencia a usuario
  Future<void> assignIncident(String incidentId, String targetUserId, String targetUserName) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final incident = _fakeIncidents.firstWhere((i) => i['id'] == incidentId);
    incident['assignedToId'] = targetUserId;
    incident['assignedToName'] = targetUserName;
    incident['status'] = 'abierta';

    // Agregar al timeline
    if (!_fakeTimelines.containsKey(incidentId)) {
      _fakeTimelines[incidentId] = [];
    }

    _fakeTimelines[incidentId]!.add({
      'type': 'assigned',
      'timestamp': DateTime.now().toIso8601String(),
      'actor': 'Sistema',
      'description': 'asignó esta tarea a $targetUserName',
    });
  }

  /// Cerrar incidencia
  Future<void> closeIncident(String incidentId, String userId, String userName, String note, List<String> photos) async {
    await Future.delayed(const Duration(milliseconds: 600));

    final incident = _fakeIncidents.firstWhere((i) => i['id'] == incidentId);
    incident['status'] = 'cerrada';
    incident['closedAt'] = DateTime.now().toIso8601String();

    // Agregar fotos de cierre si existen
    if (photos.isNotEmpty) {
      (incident['photos'] as List).addAll(photos);
    }

    // Agregar al timeline
    if (!_fakeTimelines.containsKey(incidentId)) {
      _fakeTimelines[incidentId] = [];
    }

    _fakeTimelines[incidentId]!.add({
      'type': 'closed',
      'timestamp': DateTime.now().toIso8601String(),
      'actor': userName,
      'description': 'cerró esta incidencia. Nota: $note',
    });
  }
}
