// lib/src/core/core_navigation/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get_it/get_it.dart';

/// Configuración del router de la aplicación
/// 
/// Este router se construye dinámicamente desde las rutas
/// registradas por cada feature en GetIt.
class AppRouter {
  static GoRouter createRouter() {
    final getIt = GetIt.instance;
    
    // Obtener rutas registradas por las features
    final authRoutes = getIt<List<GoRoute>>(instanceName: 'authRoutes');
    final homeRoutes = getIt<List<GoRoute>>(instanceName: 'homeRoutes');
    final incidentRoutes = getIt<List<GoRoute>>(instanceName: 'incidentRoutes');
    final settingsRoutes = getIt<List<GoRoute>>(instanceName: 'settingsRoutes');
    
    return GoRouter(
      initialLocation: '/',
      debugLogDiagnostics: true,
      routes: [
        ...authRoutes,
        ...homeRoutes,
        ...incidentRoutes,
        ...settingsRoutes,
      ],
      errorBuilder: (context, state) => _ErrorScreen(error: state.error),
    );
  }
}

/// Pantalla de error de navegación
class _ErrorScreen extends StatelessWidget {
  final Exception? error;
  
  const _ErrorScreen({this.error});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Página no encontrada',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(error?.toString() ?? 'Error desconocido'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
