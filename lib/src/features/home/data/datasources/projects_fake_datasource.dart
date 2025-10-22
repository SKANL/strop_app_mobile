// lib/src/features/home/data/datasources/projects_fake_datasource.dart

/// DataSource FAKE para Projects
/// 
/// Provee lista de proyectos activos y archivados con datos mockeados
/// 
/// Para cambiar a API real:
/// 1. Crear ProjectsRemoteDataSource
/// 2. Actualizar home_di.dart para registrar RemoteDataSource
/// 3. Actualizar ProjectsRepositoryImpl
library;


class ProjectsFakeDataSource {
  /// Lista de proyectos fake
  final List<Map<String, dynamic>> _fakeProjects = [
    {
      'id': '1',
      'name': 'Torre Reforma Centro',
      'description': 'Construcción de edificio corporativo de 25 pisos en zona centro',
      'address': 'Av. Paseo de la Reforma 250, Juárez, CDMX',
      'location': '19.4326° N, 99.1332° W',
      'status': 'active', // active, paused, completed, archived
      'startDate': '2024-01-15T00:00:00Z',
      'estimatedEndDate': '2025-12-31T00:00:00Z',
      'progress': 45.5,
      'clientName': 'Grupo Constructor SA',
      'superintendent': {
        'id': '2',
        'name': 'Superintendente García',
        'email': 'super@strop.com',
        'phone': '+52 55 2345 6789',
      },
      'teamCount': 24,
      'openIncidents': 12,
      'pendingApprovals': 3,
    },
    {
      'id': '2',
      'name': 'Casa Residencial Bosques',
      'description': 'Remodelación integral de casa residencial de 500m²',
      'address': 'Paseo de los Laureles 458, Bosques de las Lomas, CDMX',
      'location': '19.3969° N, 99.2310° W',
      'status': 'active',
      'startDate': '2024-03-01T00:00:00Z',
      'estimatedEndDate': '2024-11-30T00:00:00Z',
      'progress': 67.8,
      'clientName': 'Familia Martínez',
      'superintendent': {
        'id': '2',
        'name': 'Superintendente García',
        'email': 'super@strop.com',
        'phone': '+52 55 2345 6789',
      },
      'teamCount': 8,
      'openIncidents': 5,
      'pendingApprovals': 1,
    },
    {
      'id': '3',
      'name': 'Plaza Comercial Santa Fe',
      'description': 'Centro comercial con 80 locales y estacionamiento subterráneo',
      'address': 'Av. Vasco de Quiroga 3800, Santa Fe, CDMX',
      'location': '19.3575° N, 99.2708° W',
      'status': 'paused',
      'startDate': '2023-09-01T00:00:00Z',
      'estimatedEndDate': '2025-06-30T00:00:00Z',
      'progress': 32.0,
      'clientName': 'Inmobiliaria del Valle',
      'superintendent': {
        'id': '2',
        'name': 'Superintendente García',
        'email': 'super@strop.com',
        'phone': '+52 55 2345 6789',
      },
      'teamCount': 45,
      'openIncidents': 0,
      'pendingApprovals': 0,
    },
    {
      'id': '4',
      'name': 'Complejo Habitacional Del Valle',
      'description': 'Desarrollo de 12 departamentos de lujo con amenidades',
      'address': 'Av. Insurgentes Sur 1234, Del Valle, CDMX',
      'location': '19.3736° N, 99.1668° W',
      'status': 'completed',
      'startDate': '2022-06-01T00:00:00Z',
      'estimatedEndDate': '2023-12-31T00:00:00Z',
      'progress': 100.0,
      'clientName': 'Desarrollos Premium',
      'superintendent': {
        'id': '2',
        'name': 'Superintendente García',
        'email': 'super@strop.com',
        'phone': '+52 55 2345 6789',
      },
      'teamCount': 0,
      'openIncidents': 0,
      'pendingApprovals': 0,
    },
    {
      'id': '5',
      'name': 'Oficinas Corporativas Polanco',
      'description': 'Renovación completa de espacios de oficina en edificio existente',
      'address': 'Homero 1500, Polanco, CDMX',
      'location': '19.4355° N, 99.1917° W',
      'status': 'completed',
      'startDate': '2023-01-15T00:00:00Z',
      'estimatedEndDate': '2023-10-31T00:00:00Z',
      'progress': 100.0,
      'clientName': 'Tech Solutions MX',
      'superintendent': {
        'id': '2',
        'name': 'Superintendente García',
        'email': 'super@strop.com',
        'phone': '+52 55 2345 6789',
      },
      'teamCount': 0,
      'openIncidents': 0,
      'pendingApprovals': 0,
    },
  ];

  /// Obtener proyectos activos del usuario
  Future<List<Map<String, dynamic>>> getActiveProjects(String userId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 600));

    // Filtrar solo proyectos activos y pausados
    return _fakeProjects
        .where((p) => p['status'] == 'active' || p['status'] == 'paused')
        .toList();
  }

  /// Obtener proyectos archivados del usuario
  Future<List<Map<String, dynamic>>> getArchivedProjects(String userId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 500));

    // Filtrar solo proyectos completados
    return _fakeProjects
        .where((p) => p['status'] == 'completed')
        .toList();
  }

  /// Obtener detalle de un proyecto
  Future<Map<String, dynamic>> getProjectById(String projectId) async {
    // Simular delay de red
    await Future.delayed(const Duration(milliseconds: 400));

    final project = _fakeProjects.firstWhere(
      (p) => p['id'] == projectId,
      orElse: () => throw Exception('Proyecto no encontrado'),
    );

    return project;
  }

  /// Obtener equipo de un proyecto
  Future<Map<String, List<Map<String, String>>>> getProjectTeam(String projectId) async {
    // Simular delay
    await Future.delayed(const Duration(milliseconds: 400));

    // Datos fake del equipo
    return {
      'superintendents': [
        {
          'name': 'Superintendente García',
          'email': 'super@strop.com',
          'phone': '+52 55 2345 6789',
        },
      ],
      'residents': [
        {
          'name': 'Residente González',
          'email': 'residente@strop.com',
          'phone': '+52 55 3456 7890',
        },
        {
          'name': 'Residente Martínez',
          'email': 'residente2@strop.com',
          'phone': '+52 55 3456 7891',
        },
      ],
      'cabos': [
        {
          'name': 'Cabo López',
          'email': 'cabo@strop.com',
          'phone': '+52 55 4567 8901',
        },
        {
          'name': 'Cabo Ramírez',
          'email': 'cabo2@strop.com',
          'phone': '+52 55 4567 8902',
        },
        {
          'name': 'Cabo Sánchez',
          'email': 'cabo3@strop.com',
          'phone': '+52 55 4567 8903',
        },
      ],
    };
  }

  /// Obtener programa (ruta crítica) de un proyecto
  Future<List<Map<String, dynamic>>> getProjectProgram(String projectId) async {
    // Simular delay
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      {
        'id': '1',
        'activity': 'Cimentación',
        'startDate': '2024-01-15',
        'endDate': '2024-03-15',
        'progress': 100.0,
        'status': 'completed',
      },
      {
        'id': '2',
        'activity': 'Estructura metálica',
        'startDate': '2024-03-16',
        'endDate': '2024-07-30',
        'progress': 85.0,
        'status': 'in_progress',
      },
      {
        'id': '3',
        'activity': 'Instalaciones eléctricas',
        'startDate': '2024-06-01',
        'endDate': '2024-10-15',
        'progress': 45.0,
        'status': 'in_progress',
      },
      {
        'id': '4',
        'activity': 'Acabados interiores',
        'startDate': '2024-09-01',
        'endDate': '2024-12-31',
        'progress': 0.0,
        'status': 'pending',
      },
    ];
  }

  /// Obtener explosión de insumos de un proyecto
  Future<Map<String, List<Map<String, dynamic>>>> getProjectMaterials(String projectId) async {
    // Simular delay
    await Future.delayed(const Duration(milliseconds: 500));

    return {
      'Cemento y Agregados': [
        {'name': 'Cemento Portland', 'quantity': 500.0, 'unit': 'bultos'},
        {'name': 'Arena', 'quantity': 150.0, 'unit': 'm³'},
        {'name': 'Grava', 'quantity': 200.0, 'unit': 'm³'},
      ],
      'Acero': [
        {'name': 'Varilla 3/8"', 'quantity': 8000.0, 'unit': 'kg'},
        {'name': 'Varilla 1/2"', 'quantity': 12000.0, 'unit': 'kg'},
        {'name': 'Alambre recocido', 'quantity': 200.0, 'unit': 'kg'},
      ],
      'Instalaciones': [
        {'name': 'Tubería PVC 4"', 'quantity': 500.0, 'unit': 'mts'},
        {'name': 'Cable calibre 12', 'quantity': 1500.0, 'unit': 'mts'},
        {'name': 'Contactos dobles', 'quantity': 120.0, 'unit': 'pzas'},
      ],
      'Acabados': [
        {'name': 'Ladrillo rojo recocido', 'quantity': 15000.0, 'unit': 'pzas'},
        {'name': 'Block de concreto', 'quantity': 8000.0, 'unit': 'pzas'},
        {'name': 'Pintura vinílica blanca', 'quantity': 150.0, 'unit': 'lts'},
      ],
    };
  }

  /// Obtener notificaciones del usuario
  Future<List<Map<String, dynamic>>> getNotifications(String userId) async {
    // Simular delay
    await Future.delayed(const Duration(milliseconds: 400));

    return [
      {
        'id': '1',
        'projectId': '1',
        'projectName': 'Torre Reforma Centro',
        'type': 'assignment',
        'title': 'Nueva tarea asignada',
        'message': 'El Residente González te asignó la tarea: "Reparar fuga en tubería P3"',
        'timestamp': DateTime.now().subtract(const Duration(minutes: 15)).toIso8601String(),
        'read': false,
        'relatedIncidentId': '5',
      },
      {
        'id': '2',
        'projectId': '2',
        'projectName': 'Casa Residencial Bosques',
        'type': 'approval',
        'title': 'Solicitud aprobada',
        'message': 'Tu solicitud de cemento Portland (50 bultos) ha sido APROBADA',
        'timestamp': DateTime.now().subtract(const Duration(hours: 2)).toIso8601String(),
        'read': false,
        'relatedIncidentId': '8',
      },
      {
        'id': '3',
        'projectId': '1',
        'projectName': 'Torre Reforma Centro',
        'type': 'comment',
        'title': 'Nuevo comentario',
        'message': 'Residente González comentó en tu reporte de avance',
        'timestamp': DateTime.now().subtract(const Duration(hours: 5)).toIso8601String(),
        'read': true,
        'relatedIncidentId': '3',
      },
      {
        'id': '4',
        'projectId': '1',
        'projectName': 'Torre Reforma Centro',
        'type': 'incident',
        'title': 'Incidente crítico reportado',
        'message': 'Se reportó un incidente de seguridad en el área de trabajo',
        'timestamp': DateTime.now().subtract(const Duration(days: 1)).toIso8601String(),
        'read': true,
        'relatedIncidentId': '12',
      },
    ];
  }
}
