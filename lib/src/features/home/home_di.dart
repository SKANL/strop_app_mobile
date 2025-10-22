// lib/src/features/home/home_di.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/core_domain/repositories/project_repository.dart';
import 'data/datasources/projects_fake_datasource.dart';
import 'data/repositories_impl/projects_repository_impl.dart';
import 'presentation/providers/projects_provider.dart';
import 'presentation/screens/archived_projects_screen.dart';
import 'presentation/screens/home_screen.dart';
import 'presentation/screens/notifications_screen.dart';
import 'presentation/screens/settings_screen.dart';
import 'presentation/screens/sync_conflict_screen.dart';
import 'presentation/screens/sync_queue_screen.dart';
import 'presentation/screens/user_profile_screen.dart';

final getIt = GetIt.instance;

/// Configuración del módulo home (proyectos)
void setupHomeModule() {
  // DataSource - Usar FakeDataSource (para cambiar a API real, cambiar aquí)
  getIt.registerLazySingleton(() => ProjectsFakeDataSource());
  
  // Repository - Implementación con FakeDataSource
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectsRepositoryImpl(fakeDataSource: getIt()),
  );
  
  // Provider - Estado de proyectos
  getIt.registerLazySingleton(
    () => ProjectsProvider(repository: getIt<ProjectRepository>()),
  );
  
  // Registrar rutas
  getIt.registerLazySingleton<List<GoRoute>>(
    () => homeRoutes,
    instanceName: 'homeRoutes',
  );
}

/// Rutas de home/proyectos
/// 
/// NOTA: AuthProvider ahora se provee globalmente en app.dart
/// Solo necesitamos proveer ProjectsProvider en las rutas que lo necesiten
final homeRoutes = <GoRoute>[
  // Pantalla principal
  GoRoute(
    path: '/home',
    builder: (context, state) => ChangeNotifierProvider.value(
      value: getIt<ProjectsProvider>(),
      child: const HomeScreen(),
    ),
  ),
  
  // Notificaciones
  GoRoute(
    path: '/notifications',
    builder: (context, state) => const NotificationsScreen(),
  ),
  
  // Configuración
  GoRoute(
    path: '/settings',
    builder: (context, state) => const SettingsScreen(),
  ),
  
  // Perfil de usuario
  GoRoute(
    path: '/user-profile',
    builder: (context, state) => const UserProfileScreen(),
  ),
  
  // Cola de sincronización
  GoRoute(
    path: '/sync-queue',
    builder: (context, state) => const SyncQueueScreen(),
  ),
  
  // Modal de conflicto de sincronización (se usa con showDialog)
  GoRoute(
    path: '/sync-conflict',
    builder: (context, state) => const SyncConflictScreen(),
  ),
  
  // Proyectos archivados
  GoRoute(
    path: '/archived-projects',
    builder: (context, state) => const ArchivedProjectsScreen(),
  ),
  
  // Proyecto individual (placeholder para ProjectTabs)
  GoRoute(
    path: '/project/:id',
    builder: (context, state) {
      final projectId = state.pathParameters['id']!;
      return _PlaceholderScreen(title: 'Proyecto $projectId');
    },
  ),
  
  // Info del proyecto (placeholder)
  GoRoute(
    path: '/project/:id/info',
    builder: (context, state) => const _PlaceholderScreen(title: 'Info del Proyecto'),
  ),
];

class _PlaceholderScreen extends StatelessWidget {
  final String title;
  
  const _PlaceholderScreen({required this.title});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.construction, size: 64),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text('En construcción...'),
          ],
        ),
      ),
    );
  }
}
