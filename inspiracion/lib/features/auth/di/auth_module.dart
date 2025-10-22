import '../../../data/datasources/remote/auth_remote_datasource.dart';
import '../../../data/repositories_impl/auth_repository_impl.dart';
import '../../../domain/repositories/auth_repository.dart';
import '../../../domain/usecases/get_current_user.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/logout.dart';
import '../presentation/providers/auth_provider.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

/// Registra las dependencias relacionadas con la autenticación.
void setupAuthDependencies() {
  // DataSource
  sl.registerLazySingleton<AuthDataSource>(
    () => AuthRemoteDataSource(sl(), sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(sl()),
  );

  // UseCases
  sl.registerFactory(() => Login(sl()));
  sl.registerFactory(() => Logout(sl()));
  sl.registerFactory(() => GetCurrentUser(sl()));

  // Provider
  sl.registerLazySingleton(() => AuthProvider(
    sl<Login>(),
    sl<Logout>(),
    sl<GetCurrentUser>(),
  ));
}