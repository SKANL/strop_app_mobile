// lib/di.dart
import 'src/core/core_di.dart';
import 'src/features/auth/auth_di.dart';
import 'src/features/home/home_di.dart';
import 'src/features/incidents/incidents_di.dart';
import 'src/features/settings/settings_di.dart';

/// Orquestador central de Inyección de Dependencias
/// 
/// Este archivo no registra nada por sí mismo.
/// Su trabajo es llamar a los métodos de inicialización
/// de todos los módulos de la aplicación en el orden correcto.
Future<void> setupDependencies() async {
  // 1. Inicializar módulos core (foundation)
  await setupCoreModule();
  
  // 2. Inicializar features
  setupAuthModule();
  setupHomeModule();
  setupIncidentsModule();
  setupSettingsModule();
  
  // 3. Configurar rutas (debe ser último)
  setupRoutes();
}
