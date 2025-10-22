// lib/src/features/auth/auth_di.dart
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import '../../core/core_domain/repositories/auth_repository.dart';
import 'data/datasources/auth_fake_datasource.dart';
import 'data/repositories_impl/auth_repository_impl.dart';
import 'domain/usecases/get_current_user_usecase.dart';
import 'domain/usecases/login_usecase.dart';
import 'domain/usecases/logout_usecase.dart';
import 'domain/usecases/reset_password_usecase.dart';
import 'presentation/manager/auth_provider.dart';
import 'presentation/screens/forgot_password_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/splash_screen.dart';

final getIt = GetIt.instance;

/// Configuración del módulo de autenticación
/// 
/// IMPORTANTE: Actualmente usa AuthFakeDataSource (datos mockeados)
/// Para cambiar a API real:
/// 1. Importar 'auth_remote_datasource.dart' en lugar de 'auth_fake_datasource.dart'
/// 2. En setupAuthModule(), cambiar:
///    getIt.registerLazySingleton(() => AuthFakeDataSource())
///    por:
///    getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl(getIt()))
/// 3. En AuthRepositoryImpl constructor, cambiar:
///    fakeDataSource: getIt()
///    por:
///    remoteDataSource: getIt(), networkInfo: getIt()
void setupAuthModule() {
  // Registrar FakeDataSource (para pruebas sin API)
  getIt.registerLazySingleton(() => AuthFakeDataSource());
  
  // Registrar Repositories (implementa el contrato de core_domain)
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      fakeDataSource: getIt(),
    ),
  );
  
  // Registrar UseCases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => LogoutUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  
  // Registrar Provider (Singleton para compartir estado entre pantallas)
  getIt.registerLazySingleton(
    () => AuthProvider(
      loginUseCase: getIt(),
      logoutUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
      resetPasswordUseCase: getIt(),
    ),
  );
  
  // Registrar rutas
  getIt.registerLazySingleton<List<GoRoute>>(
    () => authRoutes,
    instanceName: 'authRoutes',
  );
}

/// Rutas de autenticación
/// 
/// NOTA: AuthProvider ahora se provee globalmente en app.dart
/// No es necesario wrappear cada ruta individualmente
final authRoutes = <GoRoute>[
  GoRoute(
    path: '/',
    builder: (context, state) => const SplashScreen(),
  ),
  GoRoute(
    path: '/login',
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: '/forgot-password',
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
];
