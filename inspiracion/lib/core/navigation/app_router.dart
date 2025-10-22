// lib/core/navigation/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:strop_app_v2/core/di/injector.dart';
import 'package:strop_app_v2/features/incidents/presentation/screens/incident_detail_screen.dart';
import 'package:strop_app_v2/features/incidents/presentation/screens/incident_list_screen.dart';
import '../../features/projects/presentation/screens/project_list_screen.dart';
import '../../features/projects/presentation/screens/add_project_screen.dart';
import '../../features/incidents/presentation/screens/add_incident_screen.dart';
import '../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../features/sync/presentation/screens/sync_screen.dart';
import '../../features/auth/presentation/providers/auth_provider.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import 'main_shell.dart';

/// Configuración centralizada de las rutas de la aplicación usando GoRouter.
final GoRouter router = GoRouter(
  initialLocation: '/dashboard',
  refreshListenable: sl<AuthProvider>(),
  // La lista de todas las rutas de la aplicación.
  routes: [
    // Ruta de login, fuera del ShellRoute porque no comparte la UI principal.
    GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),

    // ShellRoute envuelve las rutas que comparten una UI común (ej. un Scaffold con BottomNavigationBar).
    ShellRoute(
      builder: (context, state, child) {
        // El widget MainShell actúa como el "marco" de la UI para las rutas hijas.
        return MainShell(child: child);
      },
      routes: [
        // Todas las rutas dentro de este array se renderizarán dentro del MainShell.
        GoRoute(
          path: '/dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        GoRoute(
          path: '/projects',
          builder: (context, state) => const ProjectListScreen(),
        ),
        GoRoute(
          path: '/sync',
          builder: (context, state) => const SyncScreen(),
        ),
        GoRoute(
          path: '/add-project',
          builder: (context, state) => const AddProjectScreen(),
        ),
        // Ruta para la lista de incidencias.
        GoRoute(
          path: '/project/:projectId',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            final projectName = state.extra as String;
            return IncidentListScreen(
              projectId: projectId,
              projectName: projectName,
            );
          },
        ),
        GoRoute(
          path: '/project/:projectId/add-incident',
          builder: (context, state) {
            final projectId = state.pathParameters['projectId']!;
            return AddIncidentScreen(projectId: projectId);
          },
        ),
        GoRoute(
          path: '/incident/:incidentId',
          builder: (context, state) {
            final incidentId = state.pathParameters['incidentId']!;
            return IncidentDetailScreen(incidentId: incidentId);
          },
        ),
      ],
    ),
  ],

  // Lógica de redirección (se mantiene igual).
  redirect: (BuildContext context, GoRouterState state) {
    final authProvider = sl<AuthProvider>();
    final isLoggedIn = authProvider.status == AuthStatus.authenticated;
    final isLoggingIn = state.matchedLocation == '/login';

    // Si no está logueado y no está en la pantalla de login, redirige a login.
    if (!isLoggedIn && !isLoggingIn) {
      return '/login';
    }
    // Si ya está logueado y trata de ir a login, redirige al dashboard.
    if (isLoggedIn && isLoggingIn) {
      return '/dashboard';
    }
    // En cualquier otro caso, no hagas nada.
    return null;
  },
);