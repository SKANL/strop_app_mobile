// lib/src/core/core_di.dart
import 'package:get_it/get_it.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:go_router/go_router.dart';

import 'core_network/dio_client.dart';
import 'core_network/network_info.dart';
import 'core_navigation/app_router.dart';

final getIt = GetIt.instance;

/// Configuración de módulos core (transversales)
Future<void> setupCoreModule() async {
  // Network
  getIt.registerLazySingleton(() => Connectivity());
  getIt.registerLazySingleton(() => NetworkInfo(getIt()));
  
  // HTTP Client
  getIt.registerLazySingleton(
    () => DioClient(
      baseUrl: 'https://api.strop.com', // TODO: Configurar desde environment
    ),
  );
  
  // TODO: Database (Drift)
  // getIt.registerLazySingleton(() => AppDatabase());
}

/// Configurar el router (debe llamarse después de registrar todas las rutas)
void setupRoutes() {
  getIt.registerLazySingleton<GoRouter>(
    () => AppRouter.createRouter(),
  );
}
