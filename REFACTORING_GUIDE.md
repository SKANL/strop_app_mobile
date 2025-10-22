# 📦 Widgets Reutilizables - Mobile Strop App

## ✅ Widgets Creados y Refactorizados

Esta guía documenta todos los widgets reutilizables creados para maximizar la reutilización de código y mantener la app DRY (Don't Repeat Yourself).

---

## 🎨 Core UI Widgets (Globales)

Ubicación: `lib/src/core/core_ui/widgets/`

### 1. **StatusBadge** ✅
**Archivo**: `status_badge.dart`

Widget para mostrar badges de estado con colores e iconos.

**Uso**:
```dart
// Estado de incidencia
StatusBadge.incidentStatus('Abierta', isCritical: true)

// Estado de aprobación
StatusBadge.approvalStatus('Pendiente')

// Tipo de incidencia
StatusBadge.incidentType('Avance')

// Custom
StatusBadge(
  label: 'Custom',
  backgroundColor: Colors.blue,
  textColor: Colors.white,
  icon: Icons.star,
)
```

**Variantes**:
- `incidentStatus()` - Abierta, En Progreso, Cerrada
- `approvalStatus()` - Pendiente, Aprobada, Rechazada, Asignada
- `incidentType()` - Avance, Problema, Consulta, Seguridad, Material

---

### 2. **InfoRow** ✅
**Archivo**: `info_row.dart`

Widget para mostrar filas de información con icono + label + valor.

**Uso**:
```dart
InfoRow(
  icon: Icons.person_outline,
  label: 'Nombre',
  value: 'Juan Pérez',
  isValueBold: true,
  onTap: () {}, // Opcional
)

// Variante compacta (horizontal)
InfoRowCompact(
  icon: Icons.location_on,
  text: 'Ciudad de México',
  iconColor: Colors.blue,
)
```

**Dónde se usa**: Perfiles, Detalles, Configuración

---

### 3. **SectionCard** ✅
**Archivo**: `section_card.dart`

Widget para secciones con título y contenido en Card.

**Uso**:
```dart
SectionCard(
  title: 'Información Personal',
  icon: Icons.person,
  child: Column(
    children: [
      InfoRow(...),
      Divider(),
      InfoRow(...),
    ],
  ),
)

// Variante para listas
SectionCardList(
  title: 'Historial',
  icon: Icons.history,
  items: [
    ListTile(...),
    ListTile(...),
  ],
  emptyWidget: Text('Sin historial'),
)
```

**Dónde se usa**: Detalles, Perfiles, Configuración

---

### 4. **EmptyState** ✅
**Archivo**: `empty_state.dart`

Widget para estados vacíos con mensaje y acción opcional.

**Uso**:
```dart
// Genérico
EmptyState.noData(
  title: 'No hay datos',
  message: 'Los datos aparecerán aquí',
)

// Sin resultados de búsqueda
EmptyState.noResults(query: 'texto buscado')

// Específicos
EmptyState.noProjects()
EmptyState.noTasks()
EmptyState.noReports(
  onCreateReport: () => context.push('/create-report'),
)

// Para usar en Slivers
SliverEmptyState(
  emptyState: EmptyState.noTasks(),
)
```

**Variantes preconstruidas**:
- `noData()` - Listas vacías genéricas
- `noResults()` - Sin resultados de búsqueda
- `noProjects()` - Sin proyectos asignados
- `noTasks()` - Sin tareas pendientes
- `noReports()` - Sin reportes creados

---

### 5. **AvatarWithInitials** ✅
**Archivo**: `avatar_with_initials.dart`

Widget para avatares con iniciales o imagen.

**Uso**:
```dart
// Con iniciales
AvatarWithInitials(
  name: 'Juan Pérez',
  radius: 24,
  backgroundColor: Colors.blue,
)

// Con rol (color automático)
AvatarWithInitials.forRole(
  name: 'Juan Pérez',
  role: 'Residente', // Aplica color según rol
  imageUrl: 'https://...',
)

// Grupo de avatares
AvatarGroup(
  names: ['Juan', 'María', 'Pedro', 'Ana'],
  maxVisible: 3, // Muestra +1 si hay más
  overlap: 0.6,
)
```

**Colores por rol**:
- Superintendente → Morado
- Residente → Azul
- Cabo → Verde

**Dónde se usa**: Listas de usuarios, Equipos, Asignaciones

---

### 6. **AppLoading** ✅
**Archivo**: `app_loading.dart`

Widget para estados de carga.

**Uso**:
```dart
// Simple
AppLoading(message: 'Cargando proyectos...')

// Como overlay
AppLoadingOverlay(
  isLoading: isLoading,
  message: 'Guardando...',
  child: YourContent(),
)
```

---

### 7. **AppError** ✅
**Archivo**: `app_error.dart`

Widget para mostrar errores con retry.

**Uso**:
```dart
AppError(
  message: 'No se pudo cargar los datos',
  onRetry: () => provider.reload(),
)
```

---

### 8. **ResponsiveLayout** ✅ (Refactorizado - Solo Móvil)
**Archivo**: `responsive_layout.dart`

Widget para layouts responsivos **SOLO MÓVIL** (eliminado código web/desktop).

**Uso**:
```dart
ResponsiveLayout(
  mobileBody: MobileLayout(),
  tabletBody: TabletLayout(), // Opcional
)

// Helpers
final deviceType = getMobileDeviceType(context); // phone o tablet
final isLandscape = isLandscape(context);

// Tamaños responsivos
ResponsiveSize.text(
  context,
  phone: 14,
  tablet: 16,
)
```

**Cambios**:
- ✅ Eliminado soporte para `desktopBody`
- ✅ Enum cambió de `DeviceType` a `MobileDeviceType` (phone, tablet)
- ✅ Breakpoint: 600dp (estándar Material Design)

---

## 🎯 Incidents Feature Widgets

Ubicación: `lib/src/features/incidents/presentation/widgets/`

### 9. **IncidentHeader** ✅
**Archivo**: `incident_header.dart`

Header completo para mostrar información inalterable de una incidencia.

**Uso**:
```dart
IncidentHeader(
  type: 'Avance',
  title: 'Avance de Obra',
  description: 'Se completó el 80% del piso 3',
  authorName: 'Juan Pérez',
  reportedDate: DateTime.now(),
  location: 'Piso 3, Sector A',
  isCritical: false,
)
```

**Incluye**:
- Badge de tipo
- Título y descripción
- Metadata (autor, fecha, ubicación)
- Banner de crítica (si aplica)

---

### 10. **TimelineEvent** ✅
**Archivo**: `timeline_event.dart`

Eventos de timeline con iconos y líneas conectoras.

**Uso**:
```dart
// Constructores específicos
TimelineEvent.assignment(
  assignedBy: 'Residente G.',
  assignedTo: 'Cabo P.',
  timestamp: DateTime.now(),
)

TimelineEvent.comment(
  author: 'Juan',
  comment: 'Todo listo',
  timestamp: DateTime.now(),
)

TimelineEvent.closed(
  closedBy: 'Cabo P.',
  closeNote: 'Trabajo completado',
  timestamp: DateTime.now(),
)

TimelineEvent.approval(
  approver: 'D/A',
  status: 'Aprobada',
  reason: 'Cumple especificaciones',
  timestamp: DateTime.now(),
)

TimelineEvent.correction(
  author: 'Cabo P.',
  explanation: 'Corrección en cantidad',
  timestamp: DateTime.now(),
)

// Timeline completa
Timeline(
  events: [
    TimelineEvent.assignment(...),
    TimelineEvent.comment(...),
    TimelineEvent.closed(...),
  ],
  emptyWidget: Text('Sin actividad'),
)
```

**Dónde se usa**: Historial de incidencias, Actividad del proyecto

---

### 11. **TeamMemberCard** ✅
**Archivo**: `team_member_card.dart`

Card para mostrar miembros del equipo.

**Uso**:
```dart
TeamMemberCard(
  name: 'Juan Pérez',
  email: 'juan@strop.com',
  role: 'Residente',
  phone: '+52 123 456 7890',
  imageUrl: 'https://...',
  onCall: () => _makeCall(phone),
)
```

---

### 12. **RoleSection** ✅
**Archivo**: `team_member_card.dart`

Sección de roles con header coloreado.

**Uso**:
```dart
RoleSection(
  roleTitle: 'Residentes',
  roleColor: Colors.blue,
  members: [
    TeamMemberCard(...),
    TeamMemberCard(...),
  ],
)
```

**Dónde se usa**: ProjectTeamScreen

---

### 13. **IncidentListItem** ✅ (Ya existía)
**Archivo**: `incident_list_item.dart`

Card para listas de incidencias.

**Uso**:
```dart
IncidentListItem(
  title: 'Reparar fuga',
  type: 'Problema',
  author: 'Juan Pérez',
  assignedTo: 'Pedro López',
  reportedDate: DateTime.now(),
  status: 'Abierta',
  isCritical: true,
  onTap: () => context.push('/incident/123'),
)
```

---

## 📊 Home Feature Widgets

### 14. **ProjectCard** ✅ (Ya existía)
**Archivo**: `project_card.dart`

Card para mostrar proyectos.

**Uso**:
```dart
ProjectCard(
  project: projectEntity,
  onTap: () => context.push('/project/${project.id}'),
  isArchived: false,
)
```

---

## 🎯 Patrones de Uso

### Patrón 1: Estados de Lista
```dart
Consumer<DataProvider>(
  builder: (context, provider, _) {
    // Loading
    if (provider.isLoading) {
      return AppLoading(message: 'Cargando...');
    }

    // Error
    if (provider.error != null) {
      return AppError(
        message: provider.error!,
        onRetry: () => provider.reload(),
      );
    }

    // Empty
    if (provider.data.isEmpty) {
      return EmptyState.noData(
        title: 'No hay datos',
        onAction: () => provider.create(),
      );
    }

    // Data
    return ListView.builder(
      itemCount: provider.data.length,
      itemBuilder: (context, index) {
        return DataCard(data: provider.data[index]);
      },
    );
  },
)
```

### Patrón 2: Detalles con Secciones
```dart
SingleChildScrollView(
  child: Column(
    children: [
      // Header inalterable
      IncidentHeader(...),

      SizedBox(height: 24),

      // Estado
      StatusBadge.incidentStatus(status),

      SizedBox(height: 24),

      // Secciones
      SectionCard(
        title: 'Evidencia',
        icon: Icons.photo,
        child: PhotoGallery(...),
      ),

      SectionCard(
        title: 'Historial',
        icon: Icons.history,
        child: Timeline(events: events),
      ),
    ],
  ),
)
```

### Patrón 3: Responsive Layout
```dart
ResponsiveLayout(
  mobileBody: SingleChildScrollView(
    child: Column(children: [...]),
  ),
  tabletBody: Row(
    children: [
      Expanded(child: LeftPanel()),
      Expanded(child: RightPanel()),
    ],
  ),
)
```

---

## 📝 Guía de Migración

### Antes (Código repetido)
```dart
// En incident_detail_screen.dart
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text('Abierta'),
)

// En my_tasks_screen.dart
Container(
  padding: EdgeInsets.all(12),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(20),
  ),
  child: Text('Abierta'),
)
```

### Después (Reutilizable)
```dart
// En ambos screens
StatusBadge.incidentStatus('Abierta')
```

---

## ✅ Checklist de Refactorización

- [x] Crear StatusBadge (estados, tipos, aprobaciones)
- [x] Crear InfoRow (filas de información)
- [x] Crear SectionCard (secciones con título)
- [x] Crear EmptyState (con variantes preconstruidas)
- [x] Crear AvatarWithInitials (con grupos)
- [x] Crear IncidentHeader (header completo)
- [x] Crear TimelineEvent (con constructores específicos)
- [x] Crear TeamMemberCard (miembros de equipo)
- [x] Crear RoleSection (secciones de roles)
- [x] Refactorizar ResponsiveLayout (eliminar web/desktop)
- [x] Eliminar código no-móvil
- [x] Exportar en barrel file (widgets.dart)
- [x] Documentar patrones de uso

---

## 🚀 Próximos Pasos

1. **Aplicar widgets en screens existentes** ⏳
   - Refactorizar incident_detail_screen.dart
   - Refactorizar project_team_screen.dart
   - Refactorizar my_tasks_screen.dart
   - Refactorizar my_reports_screen.dart

2. **Crear tests unitarios** ⏳
   - Tests para cada widget
   - Golden tests para visuales

3. **Optimizar performance** ⏳
   - Const constructors donde sea posible
   - Memoización de widgets complejos

---

## 📚 Importaciones

Para usar los widgets:

```dart
// Core UI widgets
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';

// Incidents widgets
import 'package:mobile_strop_app/src/features/incidents/presentation/widgets/incident_header.dart';
import 'package:mobile_strop_app/src/features/incidents/presentation/widgets/timeline_event.dart';
import 'package:mobile_strop_app/src/features/incidents/presentation/widgets/team_member_card.dart';
```

---

## 🎯 Beneficios

✅ **DRY**: No más código duplicado  
✅ **Consistencia**: UI uniforme en toda la app  
✅ **Mantenibilidad**: Cambios en un solo lugar  
✅ **Testabilidad**: Widgets aislados y testeables  
✅ **Documentación**: Patrones claros de uso  
✅ **Performance**: Widgets optimizados con const  
✅ **Escalabilidad**: Fácil agregar nuevas variantes  

---

**Última actualización**: Octubre 2025  
**Autor**: Refactorización Arquitectura V5
