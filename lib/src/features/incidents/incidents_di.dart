// lib/src/features/incidents/incidents_di.dart
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

// Pantallas
import 'presentation/screens/project_tabs_screen.dart';
import 'presentation/screens/project_team_screen.dart';
import 'presentation/screens/project_info_screen.dart';
import 'presentation/screens/select_incident_type_screen.dart';
import 'presentation/screens/create_incident_form_screen.dart';
import 'presentation/screens/create_material_request_form_screen.dart';
import 'presentation/screens/incident_detail_screen.dart';
import 'presentation/screens/create_correction_screen.dart';
import 'presentation/screens/assign_user_screen.dart';
import 'presentation/screens/close_incident_screen.dart';

final getIt = GetIt.instance;

/// Configuración del módulo de incidencias
void setupIncidentsModule() {
  // TODO: Implementar registros de DataSources, Repositories, UseCases, Providers
  
  // Registrar rutas
  getIt.registerLazySingleton<List<GoRoute>>(
    () => incidentRoutes,
    instanceName: 'incidentRoutes',
  );
}

/// Rutas de incidencias
final incidentRoutes = <GoRoute>[
  // Screen 10: Pantalla principal de trabajo en el proyecto (Tabs)
  GoRoute(
    path: '/project/:projectId/tabs',
    builder: (context, state) {
      final projectId = state.pathParameters['projectId']!;
      final isArchived = state.uri.queryParameters['archived'] == 'true';
      return ProjectTabsScreen(
        projectId: projectId,
        isArchived: isArchived,
      );
    },
  ),

  // Screen 14: Equipo del proyecto
  GoRoute(
    path: '/project/:projectId/team',
    builder: (context, state) {
      final projectId = state.pathParameters['projectId']!;
      return ProjectTeamScreen(projectId: projectId);
    },
  ),

  // Screen 15: Información del proyecto (Programa e Insumos)
  GoRoute(
    path: '/project/:projectId/info',
    builder: (context, state) {
      final projectId = state.pathParameters['projectId']!;
      return ProjectInfoScreen(projectId: projectId);
    },
  ),

  // Screen 16: Seleccionar tipo de incidencia
  GoRoute(
    path: '/project/:projectId/select-incident-type',
    builder: (context, state) {
      final projectId = state.pathParameters['projectId']!;
      return SelectIncidentTypeScreen(projectId: projectId);
    },
  ),

  // Screen 17: Crear incidencia (Avance, Problema, Consulta, Seguridad)
  GoRoute(
    path: '/project/:projectId/create-incident',
    builder: (context, state) {
      final projectId = state.pathParameters['projectId']!;
      final type = state.uri.queryParameters['type'] ?? 'avance';
      return CreateIncidentFormScreen(
        projectId: projectId,
        type: type,
      );
    },
  ),

  // Screen 18: Crear solicitud de material
  GoRoute(
    path: '/project/:projectId/create-material-request',
    builder: (context, state) {
      final projectId = state.pathParameters['projectId']!;
      return CreateMaterialRequestFormScreen(projectId: projectId);
    },
  ),

  // Screen 19: Detalle de incidencia
  GoRoute(
    path: '/incident/:id',
    builder: (context, state) {
      final incidentId = state.pathParameters['id']!;
      return IncidentDetailScreen(incidentId: incidentId);
    },
  ),

  // Screen 20: Registrar aclaración
  GoRoute(
    path: '/incident/:id/correction',
    builder: (context, state) {
      final incidentId = state.pathParameters['id']!;
      return CreateCorrectionScreen(incidentId: incidentId);
    },
  ),

  // Screen 21: Asignar usuario
  GoRoute(
    path: '/incident/:id/assign',
    builder: (context, state) {
      final incidentId = state.pathParameters['id']!;
      final projectId = state.uri.queryParameters['projectId'] ?? '';
      return AssignUserScreen(
        incidentId: incidentId,
        projectId: projectId,
      );
    },
  ),

  // Screen 22: Cerrar incidencia
  GoRoute(
    path: '/incident/:id/close',
    builder: (context, state) {
      final incidentId = state.pathParameters['id']!;
      return CloseIncidentScreen(incidentId: incidentId);
    },
  ),
];
