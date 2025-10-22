# 🔄 Guía: Cambiar de FakeDataSource a API Real

## 📋 Resumen Ejecutivo

Esta guía explica cómo migrar de **datos simulados (FakeDataSource)** a **API real (RemoteDataSource)** en la app Mobile Strop.

La arquitectura está diseñada para que este cambio sea **FÁCIL y RÁPIDO** gracias a:
- ✅ Inversión de Dependencias (SOLID)
- ✅ Contratos bien definidos (Repositories)
- ✅ Configuración centralizada en archivos `*_di.dart`

---

## 🎯 Paso a Paso

### Feature: Auth

**Archivo a modificar**: `lib/src/features/auth/auth_di.dart`

#### Paso 1: Cambiar el Import

```dart
// ❌ ANTES (Fake)
import 'data/datasources/auth_fake_datasource.dart';

// ✅ DESPUÉS (Real)
import 'data/datasources/auth_remote_datasource.dart';
```

#### Paso 2: Cambiar el Registro del DataSource

```dart
// ❌ ANTES (Fake)
void setupAuthModule() {
  getIt.registerLazySingleton(() => AuthFakeDataSource());
  
  // ...
}

// ✅ DESPUÉS (Real)
void setupAuthModule() {
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()), // Inyecta Dio
  );
  
  // ...
}
```

#### Paso 3: Cambiar el Constructor del Repository

```dart
// ❌ ANTES (Fake)
getIt.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    fakeDataSource: getIt(),
  ),
);

// ✅ DESPUÉS (Real)
getIt.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: getIt(),
    networkInfo: getIt(), // Verifica conectividad
  ),
);
```

#### Paso 4: Verificar el RepositoryImpl

Asegúrate de que `AuthRepositoryImpl` tenga ambos constructores:

```dart
// lib/src/features/auth/data/repositories_impl/auth_repository_impl.dart

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource? remoteDataSource;
  final AuthFakeDataSource? fakeDataSource;
  final NetworkInfo? networkInfo;

  AuthRepositoryImpl({
    this.remoteDataSource,
    this.fakeDataSource,
    this.networkInfo,
  }) : assert(
          remoteDataSource != null || fakeDataSource != null,
          'Debe proporcionar al menos un DataSource',
        );

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    // Si hay remoteDataSource, usar API
    if (remoteDataSource != null) {
      try {
        // Verificar conectividad
        if (networkInfo != null && !await networkInfo!.isConnected) {
          return Left(NetworkFailure('Sin conexión a internet'));
        }

        final userModel = await remoteDataSource!.login(email, password);
        return Right(userModel.toEntity());
      } on ServerException catch (e) {
        return Left(ServerFailure(e.message));
      }
    }

    // Fallback a fakeDataSource (para desarrollo)
    final userModel = await fakeDataSource!.login(email, password);
    return Right(userModel.toEntity());
  }
}
```

#### Paso 5: Configurar el RemoteDataSource

```dart
// lib/src/features/auth/data/datasources/auth_remote_datasource.dart

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel> getCurrentUser();
  Future<void> resetPassword(String email);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post(
        '/api/auth/login',
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data['user']);
      } else {
        throw ServerException('Error al iniciar sesión');
      }
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Error de red');
    }
  }

  @override
  Future<void> logout() async {
    await dio.post('/api/auth/logout');
  }

  @override
  Future<UserModel> getCurrentUser() async {
    final response = await dio.get('/api/auth/me');
    return UserModel.fromJson(response.data['user']);
  }

  @override
  Future<void> resetPassword(String email) async {
    await dio.post('/api/auth/reset-password', data: {'email': email});
  }
}
```

---

### Feature: Home (Proyectos)

**Archivo a modificar**: `lib/src/features/home/home_di.dart`

#### Paso 1: Cambiar Import

```dart
// ❌ ANTES
import 'data/datasources/projects_fake_datasource.dart';

// ✅ DESPUÉS
import 'data/datasources/projects_remote_datasource.dart';
```

#### Paso 2: Cambiar Registro

```dart
// ❌ ANTES
void setupHomeModule() {
  getIt.registerLazySingleton(() => ProjectsFakeDataSource());
  
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectsRepositoryImpl(fakeDataSource: getIt()),
  );
}

// ✅ DESPUÉS
void setupHomeModule() {
  getIt.registerLazySingleton<ProjectsRemoteDataSource>(
    () => ProjectsRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<ProjectRepository>(
    () => ProjectsRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
}
```

#### Paso 3: Implementar RemoteDataSource

```dart
// lib/src/features/home/data/datasources/projects_remote_datasource.dart

class ProjectsRemoteDataSourceImpl implements ProjectsRemoteDataSource {
  final Dio dio;

  ProjectsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ProjectModel>> getActiveProjects(String userId) async {
    final response = await dio.get('/api/projects/active', queryParameters: {
      'userId': userId,
    });

    final List<dynamic> projectsJson = response.data['projects'];
    return projectsJson.map((json) => ProjectModel.fromJson(json)).toList();
  }

  @override
  Future<List<ProjectModel>> getArchivedProjects(String userId) async {
    final response = await dio.get('/api/projects/archived', queryParameters: {
      'userId': userId,
    });

    final List<dynamic> projectsJson = response.data['projects'];
    return projectsJson.map((json) => ProjectModel.fromJson(json)).toList();
  }

  @override
  Future<ProjectModel> getProjectById(String projectId) async {
    final response = await dio.get('/api/projects/$projectId');
    return ProjectModel.fromJson(response.data['project']);
  }
}
```

---

### Feature: Incidents

**Archivo a modificar**: `lib/src/features/incidents/incidents_di.dart`

#### Paso 1: Cambiar Import

```dart
// ❌ ANTES
import 'data/datasources/incidents_fake_datasource.dart';

// ✅ DESPUÉS
import 'data/datasources/incidents_remote_datasource.dart';
```

#### Paso 2: Cambiar Registro

```dart
// ❌ ANTES
void setupIncidentsModule() {
  getIt.registerLazySingleton(() => IncidentsFakeDataSource());
  
  getIt.registerLazySingleton<IncidentRepository>(
    () => IncidentsRepositoryImpl(fakeDataSource: getIt()),
  );
}

// ✅ DESPUÉS
void setupIncidentsModule() {
  getIt.registerLazySingleton<IncidentsRemoteDataSource>(
    () => IncidentsRemoteDataSourceImpl(getIt()),
  );
  
  getIt.registerLazySingleton<IncidentRepository>(
    () => IncidentsRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
}
```

#### Paso 3: Implementar RemoteDataSource

```dart
// lib/src/features/incidents/data/datasources/incidents_remote_datasource.dart

class IncidentsRemoteDataSourceImpl implements IncidentsRemoteDataSource {
  final Dio dio;

  IncidentsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<IncidentModel>> getMyTasks(String userId) async {
    final response = await dio.get('/api/incidents/my-tasks', queryParameters: {
      'userId': userId,
    });

    final List<dynamic> incidents = response.data['incidents'];
    return incidents.map((json) => IncidentModel.fromJson(json)).toList();
  }

  @override
  Future<List<IncidentModel>> getMyReports(String userId) async {
    final response = await dio.get('/api/incidents/my-reports', queryParameters: {
      'userId': userId,
    });

    final List<dynamic> incidents = response.data['incidents'];
    return incidents.map((json) => IncidentModel.fromJson(json)).toList();
  }

  @override
  Future<List<IncidentModel>> getBitacora(String projectId) async {
    final response = await dio.get('/api/projects/$projectId/incidents');

    final List<dynamic> incidents = response.data['incidents'];
    return incidents.map((json) => IncidentModel.fromJson(json)).toList();
  }

  @override
  Future<IncidentModel> createIncident(IncidentModel incident) async {
    final response = await dio.post(
      '/api/incidents',
      data: incident.toJson(),
    );

    return IncidentModel.fromJson(response.data['incident']);
  }

  @override
  Future<void> assignIncident(String incidentId, String userId) async {
    await dio.put('/api/incidents/$incidentId/assign', data: {
      'userId': userId,
    });
  }

  @override
  Future<void> closeIncident(String incidentId, String closeNote) async {
    await dio.put('/api/incidents/$incidentId/close', data: {
      'closeNote': closeNote,
    });
  }

  @override
  Future<void> addComment(String incidentId, String comment) async {
    await dio.post('/api/incidents/$incidentId/comments', data: {
      'comment': comment,
    });
  }

  @override
  Future<void> addCorrection(String incidentId, String explanation) async {
    await dio.post('/api/incidents/$incidentId/corrections', data: {
      'explanation': explanation,
    });
  }
}
```

---

## 🔧 Configuración de Dio (Core)

Asegúrate de que el cliente HTTP esté bien configurado.

**Archivo**: `lib/src/core/core_network/dio_client.dart`

```dart
import 'package:dio/dio.dart';

class DioClient {
  late final Dio dio;

  DioClient({required String baseUrl}) {
    dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Interceptor para logs (solo en desarrollo)
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));

    // Interceptor para autenticación (agregar token)
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          // Obtener token guardado (ej. de flutter_secure_storage)
          final token = await _getToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Manejo de errores (ej. 401 = logout)
          if (error.response?.statusCode == 401) {
            // Token expirado, hacer logout
            await _handleUnauthorized();
          }
          return handler.next(error);
        },
      ),
    );
  }

  Future<String?> _getToken() async {
    // TODO: Implementar con flutter_secure_storage
    return null;
  }

  Future<void> _handleUnauthorized() async {
    // TODO: Implementar logout y navegación a login
  }
}
```

**Configuración en DI**:

```dart
// lib/src/core/core_di.dart

import 'core_network/dio_client.dart';

void setupCoreModules() {
  // Configurar base URL (desde environment)
  const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:3000', // Para desarrollo
  );

  getIt.registerLazySingleton(() => DioClient(baseUrl: baseUrl));
  getIt.registerLazySingleton(() => getIt<DioClient>().dio);

  // NetworkInfo
  getIt.registerLazySingleton(() => NetworkInfo());
}
```

**Ejecutar con variable de entorno**:

```powershell
# Desarrollo
flutter run --dart-define=API_BASE_URL=http://localhost:3000

# Producción
flutter run --dart-define=API_BASE_URL=https://api.strop.com
```

---

## 🎯 Estrategia de Migración Gradual

No es necesario cambiar TODAS las features a la vez. Puedes hacerlo gradualmente:

### Fase 1: Solo Auth con API Real
```dart
// auth_di.dart → API Real
// home_di.dart → Fake
// incidents_di.dart → Fake
```

### Fase 2: Auth + Home con API Real
```dart
// auth_di.dart → API Real ✅
// home_di.dart → API Real ✅
// incidents_di.dart → Fake
```

### Fase 3: Todo con API Real
```dart
// auth_di.dart → API Real ✅
// home_di.dart → API Real ✅
// incidents_di.dart → API Real ✅
```

---

## 🧪 Testing durante la Migración

### Opción 1: Usar Mock Server
```dart
// tests/mocks/mock_server.dart
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';

class MockDio extends Mock implements Dio {}

void main() {
  test('Login con API mockeada', () async {
    final mockDio = MockDio();
    
    when(mockDio.post('/api/auth/login', data: anyNamed('data')))
      .thenAnswer((_) async => Response(
        data: {
          'user': {
            'id': '1',
            'name': 'Test User',
            'email': 'test@test.com',
          },
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/auth/login'),
      ));

    final dataSource = AuthRemoteDataSourceImpl(mockDio);
    final user = await dataSource.login('test@test.com', 'password');
    
    expect(user.email, 'test@test.com');
  });
}
```

### Opción 2: Usar Variables de Entorno para Alternar
```dart
// lib/src/features/auth/auth_di.dart

void setupAuthModule() {
  const useFake = bool.fromEnvironment('USE_FAKE_DATA', defaultValue: true);

  if (useFake) {
    getIt.registerLazySingleton(() => AuthFakeDataSource());
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(fakeDataSource: getIt()),
    );
  } else {
    getIt.registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(getIt()),
    );
    getIt.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(
        remoteDataSource: getIt(),
        networkInfo: getIt(),
      ),
    );
  }
}
```

**Ejecutar con fake data**:
```powershell
flutter run --dart-define=USE_FAKE_DATA=true
```

**Ejecutar con API real**:
```powershell
flutter run --dart-define=USE_FAKE_DATA=false --dart-define=API_BASE_URL=https://api.strop.com
```

---

## 📋 Checklist de Migración

Por cada feature:

- [ ] Crear archivo `*_remote_datasource.dart`
- [ ] Implementar todos los métodos del contrato
- [ ] Manejar errores (try-catch con DioException)
- [ ] Cambiar import en `*_di.dart`
- [ ] Cambiar registro del DataSource
- [ ] Cambiar constructor del Repository
- [ ] Verificar que RepositoryImpl soporte ambos (fake y remote)
- [ ] Configurar base URL en core_di.dart
- [ ] Agregar interceptores (auth token, logs)
- [ ] Probar endpoints con Postman/Insomnia
- [ ] Crear tests unitarios para RemoteDataSource
- [ ] Probar app end-to-end con API real

---

## 🚨 Errores Comunes

### Error 1: "No se encontró implementación de RemoteDataSource"
**Causa**: Olvidaste registrar en DI.
**Solución**: Verificar `*_di.dart` tiene el registro correcto.

### Error 2: "DioException: Connection refused"
**Causa**: API no está corriendo o baseUrl incorrecto.
**Solución**: Verificar que el servidor backend esté activo.

### Error 3: "401 Unauthorized"
**Causa**: Token no está llegando en headers.
**Solución**: Verificar interceptor de Dio está agregando el token.

### Error 4: "Type mismatch en fromJson"
**Causa**: Estructura de respuesta API diferente a modelo.
**Solución**: Ajustar `Model.fromJson()` o coordinar con backend.

---

## 🎉 Beneficios de esta Arquitectura

✅ **Cambio en UN SOLO LUGAR** (`*_di.dart`)  
✅ **Ningún cambio en UseCases, Providers o UI**  
✅ **Migración gradual** (feature por feature)  
✅ **Testing fácil** (puedes usar fake o mock)  
✅ **Rollback rápido** (si hay problemas, vuelve a fake)  
✅ **Código limpio** (SOLID, Inversión de Dependencias)  

---

**Última actualización**: Octubre 2025  
**Autor**: Arquitectura V5 - Mobile Strop App
