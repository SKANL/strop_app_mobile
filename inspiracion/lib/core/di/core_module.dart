import 'package:connectivity_plus/connectivity_plus.dart';

import '../../data/datasources/local/app_database.dart';
import '../api/api_client.dart';
import '../storage/secure_storage_factory.dart';
import '../storage/secure_storage_interface.dart';
import '../storage/token_storage.dart';
import '../utils/network_info.dart';
import '../utils/platform_helper.dart';
import 'package:get_it/get_it.dart';

// Usamos una referencia local a la instancia global de GetIt para evitar
// importaciones circulares desde el archivo principal `injector.dart`.
final sl = GetIt.instance;

/// Registra las dependencias del núcleo de la aplicación.
Future<void> setupCoreDependencies() async {
  // Connectivity
  sl.registerLazySingleton(() => Connectivity());

  // Network Info
  sl.registerLazySingleton<NetworkInfo>(
    () => NetworkInfo(sl<Connectivity>()),
  );

  // Secure Storage (multiplataforma)
  sl.registerLazySingleton<SecureStorageInterface>(() => createSecureStorage());

  // Token Storage (usa la implementación multiplataforma)
  sl.registerLazySingleton<TokenStorage>(
    () => TokenStorage(sl<SecureStorageInterface>()),
  );

  // API Client
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(sl<TokenStorage>()),
  );

  // Base de datos (SOLO para plataformas móviles)
  // Web y Desktop usan solo API remota, no necesitan Drift
  if (PlatformHelper.isMobile) {
    final db = await AppDatabase.create();
    sl.registerSingleton<AppDatabase>(db);
  }
}