import '../../../../../core/core_domain/entities/incident_entity.dart';

/// Generador de datos fake para testing y desarrollo
/// 
/// CREADO EN SEMANA 4:
/// - Extrae lógica de generación de datos de datasources
/// - Proporciona métodos reutilizables para crear datos de prueba
/// - Facilita testing y desarrollo sin backend
/// - Centraliza toda la lógica de datos mock
/// 
/// Usado por:
/// - IncidentsFakeDataSource
/// - Tests unitarios
/// - Storybook/Widget catalog
class FakeIncidentsDataGenerator {
  /// Genera lista de incidencias de prueba
  /// 
  /// [count]: Número de incidencias a generar
  /// [projectId]: ID del proyecto al que pertenecen
  /// [userId]: ID del usuario que las creó (opcional)
  /// 
  /// Returns: Lista de incidencias generadas
  static List<IncidentEntity> generateSampleIncidents({
    int count = 20,
    String projectId = '1',
    String? userId,
  }) {
    return List.generate(count, (index) {
      return _generateIncident(
        index: index,
        projectId: projectId,
        userId: userId,
      );
    });
  }
  
  /// Genera una incidencia individual
  static IncidentEntity _generateIncident({
    required int index,
    required String projectId,
    String? userId,
  }) {
    final types = IncidentType.values;
    final statuses = IncidentStatus.values;
    final priorities = IncidentPriority.values;
    
    final type = types[index % types.length];
    final status = statuses[index % statuses.length];
    final priority = priorities[index % priorities.length];
    
    final daysAgo = index;
    final createdAt = DateTime.now().subtract(Duration(days: daysAgo));
    
    return IncidentEntity(
      id: '${index + 1}',
      projectId: projectId,
      type: type,
      title: _generateTitle(type, index),
      description: _generateDescription(type, index),
      createdBy: userId ?? _generateAuthorName(index),
      assignedTo: status == IncidentStatus.closed ? 'user-${index % 5 + 1}' : null,
      status: status,
      priority: priority,
      createdAt: createdAt,
      photoUrls: _generatePhotoUrls(index),
      gpsData: _generateGpsData(),
    );
  }
  
  /// Genera título según tipo de incidencia
  static String _generateTitle(IncidentType type, int index) {
    final titles = {
      IncidentType.problem: [
        'Fuga de agua en tubería principal',
        'Grieta en muro estructural',
        'Fallo en sistema eléctrico',
        'Problema de humedad en sótano',
        'Desprendimiento de acabados',
      ],
      IncidentType.progressReport: [
        'Avance en cimentación sector A',
        'Instalación eléctrica piso 3 completa',
        'Acabados en área común terminados',
        'Colocación de ventanas finalizada',
        'Plomería instalada en 80%',
      ],
      IncidentType.consultation: [
        'Duda sobre especificaciones eléctricas',
        'Consulta sobre cambio de materiales',
        'Aclaración en planos estructurales',
        'Pregunta sobre procedimiento de seguridad',
        'Verificación de medidas en plano',
      ],
      IncidentType.safetyIncident: [
        'Falta equipo de protección personal',
        'Zona sin señalización de riesgo',
        'Escalera en mal estado',
        'Trabajador sin arnés en altura',
        'Falta de extintor en área de trabajo',
      ],
      IncidentType.materialRequest: [
        'Solicitud de cemento adicional',
        'Requiere varillas de acero',
        'Falta de pintura para acabados',
        'Necesita impermeabilizante',
        'Solicitud de herramientas especializadas',
      ],
    };
    
    final typeList = titles[type] ?? ['Incidencia genérica'];
    return typeList[index % typeList.length];
  }
  
  /// Genera descripción según tipo
  static String _generateDescription(IncidentType type, int index) {
    final descriptions = {
      IncidentType.problem: 'Se detectó un problema que requiere atención. Es necesario evaluar y tomar acciones correctivas lo antes posible.',
      IncidentType.progressReport: 'Se ha completado una etapa importante del proyecto. Todos los trabajos se realizaron conforme a especificaciones.',
      IncidentType.consultation: 'Se requiere aclaración técnica antes de continuar con los trabajos. Favor de revisar y proporcionar indicaciones.',
      IncidentType.safetyIncident: 'Se identificó una situación de riesgo para la seguridad. Es prioritario implementar medidas correctivas inmediatas.',
      IncidentType.materialRequest: 'Se requieren materiales adicionales para continuar con los trabajos programados. Favor de gestionar el suministro.',
    };
    
    return descriptions[type] ?? 'Descripción genérica de incidencia';
  }
  
  /// Genera nombre de autor
  static String _generateAuthorName(int index) {
    final names = [
      'Juan Pérez',
      'María García',
      'Carlos López',
      'Ana Martínez',
      'Pedro Ramírez',
      'Laura Torres',
      'Miguel Sánchez',
      'Sofia Flores',
    ];
    
    return names[index % names.length];
  }
  
  /// Genera URLs de fotos
  static List<String> _generatePhotoUrls(int index) {
    if (index % 3 == 0) {
      return []; // 1/3 sin fotos
    }
    
    final count = (index % 4) + 1; // 1-4 fotos
    return List.generate(
      count,
      (i) => 'https://via.placeholder.com/800x600/4CAF50/FFFFFF?text=Foto+${i + 1}',
    );
  }
  
  /// Genera ubicación GPS
  static Map<String, dynamic> _generateGpsData() {
    return {
      'lat': 19.4326,
      'lng': -99.1332,
      'timestamp': DateTime.now().toIso8601String(),
    };
  }
  
  /// Genera incidencias para un usuario específico (como creador)
  static List<IncidentEntity> generateUserIncidents({
    required String userId,
    int count = 10,
    String projectId = '1',
  }) {
    return List.generate(count, (index) {
      return _generateIncident(
        index: index,
        projectId: projectId,
        userId: userId,
      );
    });
  }
  
  /// Genera incidencias críticas
  static List<IncidentEntity> generateCriticalIncidents({
    int count = 5,
    String projectId = '1',
  }) {
    return List.generate(count, (index) {
      final types = [
        IncidentType.problem,
        IncidentType.safetyIncident,
      ];
      
      final type = types[index % types.length];
      
      return IncidentEntity(
        id: 'critical-${index + 1}',
        projectId: projectId,
        type: type,
        title: _generateTitle(type, index),
        description: 'CRÍTICO: ${_generateDescription(type, index)}',
        createdBy: 'user-1',
        assignedTo: 'user-2',
        status: IncidentStatus.open,
        priority: IncidentPriority.critical,
        createdAt: DateTime.now().subtract(Duration(hours: index + 1)),
        photoUrls: _generatePhotoUrls(index),
        gpsData: _generateGpsData(),
      );
    });
  }
  
  /// Genera incidencias por tipo específico
  static List<IncidentEntity> generateIncidentsByType({
    required IncidentType type,
    int count = 10,
    String projectId = '1',
  }) {
    return List.generate(count, (index) {
      return IncidentEntity(
        id: '${type.name}-${index + 1}',
        projectId: projectId,
        type: type,
        title: _generateTitle(type, index),
        description: _generateDescription(type, index),
        createdBy: _generateAuthorName(index),
        assignedTo: index % 2 == 0 ? 'user-${index % 5 + 1}' : null,
        status: index % 2 == 0 ? IncidentStatus.closed : IncidentStatus.open,
        priority: IncidentPriority.values[index % IncidentPriority.values.length],
        createdAt: DateTime.now().subtract(Duration(days: index)),
        photoUrls: _generatePhotoUrls(index),
        gpsData: _generateGpsData(),
      );
    });
  }
  
  /// Genera incidencias para diferentes rangos de fecha
  static List<IncidentEntity> generateIncidentsByDateRange({
    required DateTime startDate,
    required DateTime endDate,
    String projectId = '1',
  }) {
    final days = endDate.difference(startDate).inDays;
    if (days <= 0) return [];
    
    return List.generate(days, (index) {
      final date = startDate.add(Duration(days: index));
      
      return IncidentEntity(
        id: 'date-${index + 1}',
        projectId: projectId,
        type: IncidentType.values[index % IncidentType.values.length],
        title: 'Incidencia del ${date.day}/${date.month}',
        description: 'Incidencia registrada el día ${date.day}/${date.month}/${date.year}',
        createdBy: _generateAuthorName(index),
        assignedTo: null,
        status: IncidentStatus.open,
        priority: IncidentPriority.normal,
        createdAt: date,
        photoUrls: [],
        gpsData: _generateGpsData(),
      );
    });
  }
  
  /// Genera una incidencia específica para testing
  static IncidentEntity generateSpecificIncident({
    String id = 'test-1',
    String projectId = '1',
    IncidentType type = IncidentType.problem,
    String title = 'Incidencia de prueba',
    String description = 'Descripción de prueba',
    String createdBy = 'test-user',
    String? assignedTo,
    IncidentStatus status = IncidentStatus.open,
    IncidentPriority priority = IncidentPriority.normal,
    List<String>? photoUrls,
  }) {
    return IncidentEntity(
      id: id,
      projectId: projectId,
      type: type,
      title: title,
      description: description,
      createdBy: createdBy,
      assignedTo: assignedTo,
      status: status,
      priority: priority,
      createdAt: DateTime.now(),
      photoUrls: photoUrls ?? [],
      gpsData: _generateGpsData(),
    );
  }
}
