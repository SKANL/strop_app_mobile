// lib/src/features/settings/settings_di.dart
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final getIt = GetIt.instance;

/// Configuración del módulo de configuración
void setupSettingsModule() {
  // TODO: Implementar registros
  
  // Registrar rutas
  getIt.registerLazySingleton<List<GoRoute>>(
    () => settingsRoutes,
    instanceName: 'settingsRoutes',
  );
}

/// Rutas de configuración
final settingsRoutes = <GoRoute>[
  GoRoute(
    path: '/settings',
    builder: (context, state) => const _PlaceholderScreen(title: 'Configuración'),
  ),
  GoRoute(
    path: '/profile',
    builder: (context, state) => const _PlaceholderScreen(title: 'Perfil de Usuario'),
  ),
  GoRoute(
    path: '/sync-queue',
    builder: (context, state) => const _PlaceholderScreen(title: 'Cola de Sincronización'),
  ),
  GoRoute(
    path: '/sync-conflict',
    builder: (context, state) => const _PlaceholderScreen(title: 'Conflicto de Sync'),
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
            ),
            const SizedBox(height: 8),
            const Text('En construcción...'),
          ],
        ),
      ),
    );
  }
}
