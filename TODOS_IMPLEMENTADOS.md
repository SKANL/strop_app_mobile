# TODOs Implementados - Modo Demo con FakeDataSources

## ✅ Flujos Implementados (Usando Arquitectura V5)

### 1. Crear Incidencia
- **Archivo**: `lib/src/features/incidents/presentation/screens/create_incident_form_screen.dart`
- **Cambio**: Conectado a `IncidentsProvider.createIncident()`
- **Flujo**: UI → Provider → Repository → FakeDataSource
- **Funcionalidad**:
  - Formulario valida descripción (mínimo 10 caracteres)
  - Captura fotos desde cámara/galería
  - Marca como crítica opcional
  - Genera título automático basado en tipo y descripción
  - Muestra loading mientras crea
  - Navega de vuelta al éxito con feedback visual

### 2. Asignar Incidencia
- **Archivo**: `lib/src/features/incidents/presentation/screens/assign_user_screen.dart`
- **Cambio**: Conectado a `IncidentsProvider.assignIncident()`
- **Flujo**: UI → Provider → Repository → FakeDataSource
- **Funcionalidad**:
  - Lista de usuarios placeholder (cabos)
  - Selección de usuario con radio buttons
  - Muestra loading durante asignación
  - Actualiza estado de incidencia y timeline
  - Feedback con SnackBar

### 3. Cerrar Incidencia
- **Archivo**: `lib/src/features/incidents/presentation/screens/close_incident_screen.dart`
- **Cambio**: Conectado a `IncidentsProvider.closeIncident()`
- **Flujo**: UI → Provider → Repository → FakeDataSource
- **Funcionalidad**:
  - Campo de nota de cierre (obligatorio)
  - Captura fotos del trabajo terminado (opcional)
  - Muestra loading durante cierre
  - Actualiza estado a 'cerrada' y agrega evento al timeline
  - Feedback con SnackBar

### 4. Agregar Comentario
- **Archivo**: `lib/src/features/incidents/presentation/screens/incident_detail_screen.dart`
- **Cambio**: Ya estaba implementado con `IncidentsProvider.addComment()`
- **Flujo**: UI → Provider → Repository → FakeDataSource
- **Funcionalidad**:
  - Campo de texto flotante en detalle
  - Botón de envío
  - Recarga timeline después de agregar
  - Feedback con SnackBar

### 5. Registrar Aclaración
- **Archivo**: `lib/src/features/incidents/presentation/screens/create_correction_screen.dart`
- **Cambio**: Conectado a `IncidentsProvider.addCorrection()`
- **Flujo**: UI → Provider → Repository → FakeDataSource
- **Funcionalidad**:
  - Formulario de explicación (obligatorio)
  - Banner informativo sobre inalterabilidad
  - Muestra loading durante registro
  - Agrega evento de corrección al timeline
  - Feedback con SnackBar

---

## 🏗️ Arquitectura Implementada

Todos los cambios respetan **Arquitectura V5**:

```
UI (Screen)
  ↓ context.read<Provider>().method()
ChangeNotifier Provider (IncidentsProvider)
  ↓ repository.method()
Repository Contract (IncidentRepository en core_domain)
  ↓ DI resuelve implementación
Repository Implementation (IncidentsRepositoryImpl)
  ↓ fakeDataSource.method()
FakeDataSource (IncidentsFakeDataSource)
  ↓ Retorna datos simulados con delay
```

### Ventajas de esta implementación:
- ✅ **Sin API real necesaria**: Todos los flujos usan `IncidentsFakeDataSource`
- ✅ **Cambio a API real es trivial**: Basta crear `IncidentsRemoteDataSource` y cambiar el registro en `incidents_di.dart`
- ✅ **Desacoplamiento total**: UI no conoce repositorios, repositorios no conocen datasources concretos
- ✅ **Testeable**: Provider puede probarse con mock repository, Repository con mock datasource

---

## 📋 TODOs Pendientes (No Bloqueantes para Demo)

### Prioridad Media
1. **Reemplazar imágenes placeholder externas**
   - Crear `lib/assets/images/` con 3-6 PNGs
   - Actualizar `pubspec.yaml` para incluir assets
   - Cambiar URLs de `via.placeholder.com` por `assets/images/...` en `IncidentsFakeDataSource`
   - **Beneficio**: Demo 100% offline sin errores DNS

2. **Solicitud de Material**
   - `create_material_request_form_screen.dart` usa placeholder
   - **TODO**: Conectar a `IncidentsProvider.createMaterialRequest()` (método por crear)

3. **Obtener datos de equipo del proyecto**
   - `project_team_screen.dart` usa lista hardcoded
   - **TODO**: Crear método en `ProjectsProvider.getTeamMembers(projectId)`

### Prioridad Baja
4. **Notificaciones**
   - `notifications_screen.dart` usa lista placeholder
   - **TODO**: Crear `NotificationsProvider` con FakeDataSource

5. **Configuración de usuario**
   - `settings_screen.dart` tiene toggles sin implementar
   - **TODO**: Guardar preferencias en SharedPreferences o Drift

6. **Sincronización offline**
   - `sync_queue_screen.dart` y `sync_conflict_screen.dart` son pantallas vacías
   - **TODO**: Implementar cuando se agregue Drift para persistencia local

---

## 🚀 Cómo Probar la App (Demo con FakeDataSources)

### 1. Ejecutar la app
```bash
cd mobile_strop_app
flutter pub get
flutter run
```

### 2. Flujo de prueba sugerido
1. **Login**: Usar credenciales de `auth_fake_datasource.dart`
   - Email: `cabo@empresa.com` / Pass: `123456`
   - O cualquier otro usuario fake

2. **Home**: Ver lista de proyectos (de `projects_fake_datasource.dart`)

3. **Mis Tareas**: Ver incidencias asignadas
   - Tap en una incidencia → Ver detalle con timeline
   - Agregar comentario desde el campo inferior
   - Cerrar incidencia (botón flotante verde)

4. **Mis Reportes**: Ver incidencias creadas por el usuario
   - Tap en una → Ver detalle
   - Registrar aclaración (botón naranja)

5. **Bitácora del Proyecto**:
   - Ver todas las incidencias del proyecto
   - Aplicar filtros (tipo, estado, fechas)
   - Crear nueva incidencia (botón '+')
   - Asignar tarea (botón morado en detalle, solo R/S)

6. **Timeline**: Todos los cambios (crear, asignar, comentar, cerrar, aclaración) aparecen en el timeline de la incidencia

### 3. Validar que los datos persisten en memoria
- Crear incidencia → Aparece en Bitácora
- Asignar → Aparece en Mis Tareas del usuario asignado
- Cerrar → Estado cambia a "Cerrada" en todas las vistas
- Comentar → Nuevo evento en Timeline
- **Nota**: Al hacer hot-restart, los datos se resetean (porque están en memoria del FakeDataSource)

---

## 📝 Próximos Pasos Recomendados

1. **Ejecutar la app** con hot-restart completo y probar todos los flujos
2. **Agregar assets locales** para eliminar errores de red en imágenes
3. **Crear tests unitarios** para `IncidentsProvider` (verificar que llama al repositorio correctamente)
4. **Documentar en README.md** cómo cambiar de FakeDataSource a RemoteDataSource cuando tengas API

---

## 🔄 Cambio Futuro a API Real

Cuando tengas una API backend, solo necesitas:

1. **Crear** `lib/src/features/incidents/data/datasources/incidents_remote_datasource.dart`
   ```dart
   class IncidentsRemoteDataSource {
     final DioClient client;
     
     Future<List<Map<String, dynamic>>> getMyTasks(String userId) async {
       final response = await client.get('/incidents/my-tasks?userId=$userId');
       return List<Map<String, dynamic>>.from(response.data['data']);
     }
     // ... otros métodos
   }
   ```

2. **Actualizar** `lib/src/features/incidents/incidents_di.dart`
   ```dart
   // Antes:
   getIt.registerLazySingleton<IncidentsFakeDataSource>(() => IncidentsFakeDataSource());
   
   // Después:
   getIt.registerLazySingleton<IncidentsRemoteDataSource>(
     () => IncidentsRemoteDataSource(getIt<DioClient>())
   );
   ```

3. **Actualizar** `IncidentsRepositoryImpl` para usar `remoteDataSource` en lugar de `fakeDataSource`

**Resultado**: La UI, el Provider y los contratos no cambian. Solo la implementación del DataSource.

---

## ✨ Resumen de Cambios

| Archivo Modificado | Cambio Principal | Estado |
|---|---|---|
| `create_incident_form_screen.dart` | Llamar a `provider.createIncident()` | ✅ |
| `assign_user_screen.dart` | Llamar a `provider.assignIncident()` | ✅ |
| `close_incident_screen.dart` | Llamar a `provider.closeIncident()` | ✅ |
| `create_correction_screen.dart` | Llamar a `provider.addCorrection()` | ✅ |
| `incident_detail_screen.dart` | Ya implementado `provider.addComment()` | ✅ |
| `incidents_provider.dart` | Todos los métodos CRUD ya existían | ✅ |
| `incidents_repository_impl.dart` | Ya usa FakeDataSource | ✅ |
| `incidents_fake_datasource.dart` | Implementación completa de todos los métodos | ✅ |

**Total**: 4 pantallas conectadas + 1 ya funcional = 5 flujos end-to-end funcionales con FakeDataSources 🎉
