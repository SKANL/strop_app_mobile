# Mobile Strop App - Arquitectura V5

## 📱 Aplicación de Reportes de Campo para Construcción

Esta es una aplicación Flutter moderna construida con **Arquitectura V5** (Feature-First + Clean Architecture + SOLID).

## 🏗️ Arquitectura Implementada

### Estructura de Carpetas

```
lib/
├── main.dart                 # Punto de entrada
├── app.dart                  # Widget raíz (MaterialApp.router)
├── di.dart                   # Orquestador de DI
└── src/
    ├── core/                 # Módulos transversales
    │   ├── core_domain/      # ⭐ CONTRATOS COMPARTIDOS
    │   │   ├── entities/     # User, Project, Incident
    │   │   ├── repositories/ # Contratos de repositorios
    │   │   ├── errors/       # Failures y Exceptions
    │   │   └── usecases/     # UseCase base
    │   ├── core_network/     # Dio, NetworkInfo
    │   ├── core_navigation/  # AppRouter (GoRouter)
    │   ├── core_ui/          # Theme, widgets genéricos
    │   └── core_di.dart      # DI de módulos core
    └── features/             # Módulos de funcionalidad
        ├── auth/             # Autenticación
        ├── home/             # Home y proyectos
        ├── incidents/        # Incidencias/Reportes
        └── settings/         # Configuración
```

### ✅ Lo que ya está implementado:

#### 1. **Core Domain** (Contratos Compartidos)
- ✅ Entidades:
  - `UserEntity` (con roles: SuperAdmin, Owner, Superintendent, Resident, Cabo)
  - `ProjectEntity` (estados: planning, active, paused, completed, cancelled)
  - `IncidentEntity` (tipos: progressReport, problem, consultation, safetyIncident, materialRequest)
- ✅ Repositorios abstractos:
  - `AuthRepository`
  - `ProjectRepository`
  - `IncidentRepository`
- ✅ Sistema de errores:
  - `Failure` (base)
  - `AppException` (base)
  - Implementaciones específicas
- ✅ `UseCase<T, P>` genérico

#### 2. **Core Modules**
- ✅ **core_network**:
  - `DioClient` configurado con interceptores
  - `NetworkInfo` para verificar conectividad
- ✅ **core_ui**:
  - `AppTheme` con Material 3
  - Widgets genéricos: `AppLoading`, `AppError`, `AppTextField`, `ResponsiveLayout`
- ✅ **core_navigation**:
  - `AppRouter` dinámico (carga rutas desde features)
- ✅ **core_di**:
  - Configuración de GetIt para módulos core

#### 3. **Archivos Raíz**
- ✅ `main.dart` - Punto de entrada limpio
- ✅ `app.dart` - Widget raíz agnóstico
- ✅ `di.dart` - Orquestador central de DI
- ✅ `pubspec.yaml` - Con todas las dependencias necesarias

## 📱 Flujo de Pantallas (24 Screens)

### Fase 0: Autenticación
1. ✅ `SplashScreen` - *Pendiente de implementar*
2. ✅ `LoginScreen` - *Pendiente de implementar*
3. ✅ `ForgotPasswordScreen` - *Pendiente de implementar*

### Fase 1: Asignación y Selección
4. ⏳ `HomeScreen` (Mis Proyectos)
5. ⏳ `NotificationsScreen`
6. ⏳ `SettingsScreen`
7. ⏳ `UserProfileScreen`
8. ⏳ `SyncQueueScreen`
9. ⏳ `SyncConflictScreen`

### Fase 2: Durante el Proyecto
10. ⏳ `ProjectTabs` (Contenedor principal)
11. ⏳ `MyTasksScreen` (Tareas asignadas ⬇️)
12. ⏳ `MyReportsScreen` (Reportes creados ⬆️)
13. ⏳ `ProjectBitacoraScreen` (Historial completo)
14. ⏳ `ProjectTeamScreen` (Equipo)
15. ⏳ `ProjectInfoScreen` (Programa + Insumos)

### Fase 2 (Continuación): Flujos de Acción
16. ⏳ `SelectIncidentTypeScreen`
17. ⏳ `CreateIncidentFormScreen`
18. ⏳ `CreateMaterialRequestFormScreen`
19. ⏳ `IncidentDetailScreen` ⭐ (Pantalla más compleja)
20. ⏳ `CreateCorrectionScreen`
21. ⏳ `AssignUserScreen`
22. ⏳ `CloseIncidentScreen`

### Fase 3: Archivo
23. ⏳ `ArchivedProjectsScreen`
24. ⏳ `ProjectTabs` (Modo archivo - solo lectura)

## 🚀 Próximos Pasos

### 1. Instalar Dependencias

```powershell
cd c:\code\Flutter\strop\clon-continue\nueva_arquitectura_movil\mobile_strop_app
flutter pub get
```

### 2. Copiar Assets

Copiar los archivos de `inspiracion/lib/assets/` a `assets/`:
- `animations/login_animation.json`
- `icons/helmet.png` (y otros iconos)

### 3. Implementar Feature Auth

Crear la siguiente estructura:

```
src/features/auth/
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart
│   ├── models/
│   │   └── user_model.dart
│   └── repositories_impl/
│       └── auth_repository_impl.dart
├── domain/
│   └── usecases/
│       ├── login_usecase.dart
│       ├── logout_usecase.dart
│       └── get_current_user_usecase.dart
├── presentation/
│   ├── manager/
│   │   └── auth_provider.dart
│   ├── screens/
│   │   ├── splash_screen.dart
│   │   ├── login_screen.dart
│   │   └── forgot_password_screen.dart
│   └── widgets/
│       └── login_form.dart
├── auth_routes.dart
└── auth_di.dart
```

### 4. Implementar Features Restantes

Siguiendo el mismo patrón:
- `features/home/` - HomeScreen, NotificationsScreen, ArchivedProjectsScreen
- `features/incidents/` - ProjectTabs, MyTasksScreen, MyReportsScreen, etc.
- `features/settings/` - SettingsScreen, UserProfileScreen, SyncQueueScreen

### 5. Configurar Drift (Database)

```dart
// lib/src/core/core_persistence/database.dart
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

part 'database.g.dart';

@DriftDatabase(
  tables: [Users, Projects, Incidents],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static LazyDatabase _openConnection() {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'strop.db'));
      return NativeDatabase(file);
    });
  }
}

// Definir las tablas
class Users extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get email => text()();
  TextColumn get role => text()();
  
  @override
  Set<Column> get primaryKey => {id};
}

// ... más tablas
```

Luego ejecutar:
```powershell
dart run build_runner build
```

## 📚 Patrones de Implementación

### Implementar un UseCase

```dart
// domain/usecases/login_usecase.dart
class LoginUseCase extends UseCase<UserEntity, LoginParams> {
  final AuthRepository repository;
  
  LoginUseCase(this.repository);
  
  @override
  Future<UserEntity> call(LoginParams params) async {
    return await repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;
  
  LoginParams(this.email, this.password);
}
```

### Implementar un Provider

```dart
// presentation/manager/auth_provider.dart
class AuthProvider extends ChangeNotifier {
  final LoginUseCase loginUseCase;
  final GetCurrentUserUseCase getCurrentUserUseCase;
  
  UserEntity? _user;
  bool _isLoading = false;
  String? _error;
  
  // Getters
  UserEntity? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  
  AuthProvider({
    required this.loginUseCase,
    required this.getCurrentUserUseCase,
  });
  
  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    
    try {
      _user = await loginUseCase(LoginParams(email, password));
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
```

### Definir Rutas

```dart
// auth_routes.dart
import 'package:go_router/go_router.dart';
import 'presentation/screens/splash_screen.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/forgot_password_screen.dart';

final authRoutes = [
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
```

### Registrar en DI

```dart
// auth_di.dart
import 'package:get_it/get_it.dart';
import '../core/core_di.dart';

void setupAuthModule() {
  // DataSources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(getIt()),
  );
  
  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt(),
      networkInfo: getIt(),
    ),
  );
  
  // UseCases
  getIt.registerLazySingleton(() => LoginUseCase(getIt()));
  getIt.registerLazySingleton(() => GetCurrentUserUseCase(getIt()));
  
  // Providers
  getIt.registerFactory(
    () => AuthProvider(
      loginUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
    ),
  );
  
  // Rutas
  getIt.registerLazySingleton(
    () => authRoutes,
    instanceName: 'authRoutes',
  );
}
```

## 🎯 Características Clave de la Arquitectura

1. **Desacoplamiento Total**: Las features no se importan entre sí
2. **Comunicación por Contratos**: Todo pasa por `core_domain`
3. **Inyección de Dependencias**: GetIt maneja todas las instancias
4. **Rutas Dinámicas**: GoRouter se construye desde las features
5. **Clean Architecture**: Capas data, domain, presentation separadas
6. **SOLID**: Especialmente Inversión de Dependencias
7. **Escalabilidad**: Agregar nuevas features no afecta las existentes
8. **Mantenibilidad**: Cada feature es una "caja negra"

## 📝 Notas Importantes

- **Versión Flutter**: 3.35.6 (Dart 3.9.2)
- **Material Design**: Material 3 habilitado
- **State Management**: Provider (simple y eficiente)
- **Routing**: GoRouter (declarativo)
- **HTTP**: Dio (con interceptores)
- **Database**: Drift (ORM sobre SQLite)
- **Code Generation**: freezed, json_serializable, drift_dev

## 🔗 Recursos de Referencia

La carpeta `inspiracion/` contiene la implementación de referencia. Los patrones de:
- Pantallas responsivas (`ResponsiveLayout`)
- Widgets reutilizables (`CustomTextFormField`, `MainAppBar`)
- Providers con estado (`AuthProvider`, `ProjectProvider`)
- Navegación con GoRouter

Se pueden adaptar a la nueva arquitectura V5.

---

**Estado Actual**: ✅ Fundamentos completados (core + estructura)
**Siguiente**: 🔨 Implementar feature auth + home + incidents

¿Listo para continuar con la implementación de las 24 pantallas? 🚀
