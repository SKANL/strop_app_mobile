import 'package:get_it/get_it.dart';

import '../../features/auth/di/auth_module.dart';
import '../../features/dashboard/di/dashboard_module.dart';
import '../../features/incidents/di/incident_module.dart';
import '../../features/projects/di/project_module.dart';
import 'core_module.dart';
import 'sync_module.dart';

// Instancia global de GetIt
final sl = GetIt.instance;

/// Función principal para configurar e inicializar todas las dependencias de la aplicación.
Future<void> setupDependencies() async {
  // 1. Configurar dependencias del Core (API, DB, Storage, etc.)
  await setupCoreDependencies();

  // 2. Configurar dependencias por feature
  setupAuthDependencies();
  setupProjectDependencies();
  setupIncidentDependencies();
  setupDashboardDependencies();

  // 3. Configurar servicios transversales (ej. Sincronización)
  setupSyncDependencies();
}