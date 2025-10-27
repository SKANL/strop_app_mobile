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

import 'package:mobile_strop_app/src/core/core_testing/fake_data_factory.dart';

class IncidentsFakeDataSource {
  /// Tipos de incidentes disponibles
  static const _incidentTypes = ['avance', 'problema', 'consulta', 'seguridad', 'calidad'];
  
  /// Estados disponibles
  static const _statuses = ['abierta', 'pendiente', 'cerrada'];
  
  /// Lista de autores predefinidos
  static const _authors = [
    {'id': '3', 'name': 'Residente González', 'role': 'resident'},
    {'id': '4', 'name': 'Cabo López', 'role': 'cabo'},
    {'id': '5', 'name': 'Ingeniero Ramírez', 'role': 'engineer'},
    {'id': '6', 'name': 'Supervisor Martínez', 'role': 'supervisor'},
  ];

  /// Genera una incidencia fake aleatoria
  Map<String, dynamic> _generateIncident(String id) {
    final author = FakeDataFactory.selectRandom(_authors);
    final type = FakeDataFactory.selectRandom(_incidentTypes);
    final status = FakeDataFactory.selectRandom(_statuses);
    final isCritical = FakeDataFactory.generateBool(probabilidadTrue: 0.2);
    final createdAt = FakeDataFactory.generateFechaReciente(maxDiasAtras: 30);
    final hasAssigned = status != 'abierta' || FakeDataFactory.generateBool(probabilidadTrue: 0.7);
    final assignedTo = hasAssigned ? FakeDataFactory.selectRandom(_authors) : null;
    final isClosed = status == 'cerrada';
    final photoCount = FakeDataFactory.generateInt(min: 0, max: 4);
    
    return {
      'id': id,
      'projectId': '1',
      'type': type,
      'title': _generateTitle(type),
      'description': FakeDataFactory.generateDescripcion(_getTitleComplement(type)),
      'authorId': author['id'],
      'authorName': author['name'],
      'authorRole': author['role'],
      'assignedToId': assignedTo?['id'],
      'assignedToName': assignedTo?['name'],
      'status': status,
      'isCritical': isCritical,
      'createdAt': createdAt.toIso8601String(),
      'closedAt': isClosed ? createdAt.add(Duration(days: FakeDataFactory.generateInt(min: 1, max: 7))).toIso8601String() : null,
      'gpsLocation': '19.4326, -99.1332',
      'photos': photoCount > 0 ? FakeDataFactory.generateImageUrls(count: photoCount) : [],
      'approvalStatus': isCritical && isClosed ? 'approved' : null,
    };
  }

  String _generateTitle(String type) {
    final titles = {
      'avance': [
        'Avance en cimentación',
        'Progreso estructura metálica',
        'Completado levantamiento de muros',
        'Instalación de ventanas sector',
      ],
      'problema': [
        'Fuga de agua detectada',
        'Grieta en estructura',
        'Material defectuoso',
        'Retraso en entrega',
      ],
      'consulta': [
        'Duda sobre especificaciones',
        'Revisión de planos',
        'Consulta técnica',
        'Aclaración procedimiento',
      ],
      'seguridad': [
        'Falta equipo de protección',
        'Zona insegura detectada',
        'Incidente menor reportado',
        'Condición peligrosa',
      ],
      'calidad': [
        'Inspección de calidad',
        'No conformidad detectada',
        'Revisión acabados',
        'Control de materiales',
      ],
    };
    
    return FakeDataFactory.selectRandom(titles[type] ?? titles['problema']!);
  }

  String _getTitleComplement(String type) {
    final complements = {
      'avance': 'sector A',
      'problema': 'tubería principal',
      'consulta': 'planos',
      'seguridad': 'zona de trabajo',
      'calidad': 'acabados',
    };
    
    return complements[type] ?? 'proyecto';
  }

  /// Base de datos fake de incidencias (generada dinámicamente)
  late final List<Map<String, dynamic>> _fakeIncidents = 
    List.generate(25, (index) => _generateIncident('${index + 1}'));

  /// Obtener todas las incidencias
  Future<List<Map<String, dynamic>>> getIncidents() async {
    await FakeDataFactory.simulateNetworkDelay();
    return List.from(_fakeIncidents);
  }

  /// Obtener incidencias del proyecto
  Future<List<Map<String, dynamic>>> getProjectIncidents(String projectId) async {
    await FakeDataFactory.simulateNetworkDelay();
    return _fakeIncidents.where((i) => i['projectId'] == projectId).toList();
  }

  /// Obtener mis tareas (asignadas a mí)
  Future<List<Map<String, dynamic>>> getMyTasks(String userId) async {
    await FakeDataFactory.simulateNetworkDelay();
    return _fakeIncidents
        .where((i) => i['assignedToId'] == userId && i['status'] != 'cerrada')
        .toList();
  }

  /// Obtener mis reportes (creados por mí)
  Future<List<Map<String, dynamic>>> getMyReports(String userId) async {
    await FakeDataFactory.simulateNetworkDelay();
    return _fakeIncidents
        .where((i) => i['authorId'] == userId)
        .toList();
  }

  /// Obtener bitácora (todas las incidencias)
  Future<List<Map<String, dynamic>>> getBitacora(String projectId) async {
    await FakeDataFactory.simulateNetworkDelay();
    return getProjectIncidents(projectId);
  }

  /// Obtener detalle de incidencia
  Future<Map<String, dynamic>> getIncidentDetail(String id) async {
    await FakeDataFactory.simulateNetworkDelay();
    final incident = _fakeIncidents.firstWhere(
      (i) => i['id'] == id,
      orElse: () => _generateIncident(id),
    );
    
    // Agregar timeline fake
    incident['timeline'] = _generateTimeline(incident);
    
    return incident;
  }

  List<Map<String, dynamic>> _generateTimeline(Map<String, dynamic> incident) {
    final timeline = <Map<String, dynamic>>[];
    final createdAt = DateTime.parse(incident['createdAt'] as String);
    
    // Evento de creación
    timeline.add({
      'id': '1',
      'type': 'created',
      'message': 'Incidencia creada',
      'authorName': incident['authorName'],
      'timestamp': createdAt.toIso8601String(),
    });
    
    // Evento de asignación (si existe)
    if (incident['assignedToId'] != null) {
      timeline.add({
        'id': '2',
        'type': 'assigned',
        'message': 'Asignado a ${incident['assignedToName']}',
        'authorName': incident['authorName'],
        'timestamp': createdAt.add(const Duration(minutes: 30)).toIso8601String(),
      });
    }
    
    // Eventos de comentarios aleatorios
    if (FakeDataFactory.generateBool(probabilidadTrue: 0.6)) {
      timeline.add({
        'id': '3',
        'type': 'comment',
        'message': FakeDataFactory.generateDescripcion('actualización'),
        'authorName': FakeDataFactory.selectRandom(_authors)['name'],
        'timestamp': createdAt.add(Duration(hours: FakeDataFactory.generateInt(min: 1, max: 24))).toIso8601String(),
      });
    }
    
    // Evento de cierre (si está cerrada)
    if (incident['status'] == 'cerrada' && incident['closedAt'] != null) {
      timeline.add({
        'id': '${timeline.length + 1}',
        'type': 'closed',
        'message': 'Incidencia cerrada',
        'authorName': incident['assignedToName'] ?? incident['authorName'],
        'timestamp': incident['closedAt'],
      });
    }
    
    return timeline;
  }

  /// Crear nueva incidencia
  Future<String> createIncident(Map<String, dynamic> data) async {
    await FakeDataFactory.simulateNetworkDelay(milliseconds: 800);
    
    final newId = '${_fakeIncidents.length + 1}';
    final newIncident = {
      'id': newId,
      'projectId': data['projectId'] ?? '1',
      'type': data['type'],
      'title': data['title'],
      'description': data['description'],
      'authorId': data['authorId'],
      'authorName': data['authorName'] ?? 'Usuario',
      'authorRole': data['authorRole'] ?? 'user',
      'assignedToId': data['assignedToId'],
      'assignedToName': data['assignedToName'],
      'status': 'abierta',
      'isCritical': data['isCritical'] ?? false,
      'createdAt': DateTime.now().toIso8601String(),
      'closedAt': null,
      'gpsLocation': data['gpsLocation'] ?? '19.4326, -99.1332',
      'photos': data['photos'] ?? [],
      'approvalStatus': null,
    };
    
    _fakeIncidents.add(newIncident);
    return newId;
  }

  /// Asignar incidencia
  Future<void> assignIncident(String id, String userId, String userName) async {
    await FakeDataFactory.simulateNetworkDelay(milliseconds: 500);
    
    final incident = _fakeIncidents.firstWhere((i) => i['id'] == id);
    incident['assignedToId'] = userId;
    incident['assignedToName'] = userName;
    incident['status'] = 'pendiente';
  }

  /// Cerrar incidencia
  Future<void> closeIncident(String id, String resolution) async {
    await FakeDataFactory.simulateNetworkDelay(milliseconds: 600);
    
    final incident = _fakeIncidents.firstWhere((i) => i['id'] == id);
    incident['status'] = 'cerrada';
    incident['closedAt'] = DateTime.now().toIso8601String();
    incident['resolution'] = resolution;
  }

  /// Agregar comentario
  Future<void> addComment(String incidentId, String comment, String authorName) async {
    await FakeDataFactory.simulateNetworkDelay(milliseconds: 400);
    // En implementación real, esto agregaría al timeline
  }

  /// Buscar incidencias
  Future<List<Map<String, dynamic>>> searchIncidents(String query) async {
    await FakeDataFactory.simulateNetworkDelay();
    
    return FakeDataFactory.search(
      _fakeIncidents,
      query,
      (incident) => '${incident['title']} ${incident['description']}',
    );
  }
}
