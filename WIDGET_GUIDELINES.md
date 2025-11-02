# 📚 GUÍA DE WIDGETS REUTILIZABLES

**Proyecto:** Mobile Strop App  
**Versión:** 1.0  
**Última actualización:** 1 de Noviembre, 2025

---

## 🎯 PROPÓSITO DE ESTA GUÍA

Esta guía ayuda a desarrolladores a:
1. ✅ **Encontrar** el widget correcto para cada necesidad
2. ✅ **Evitar** duplicar código creando widgets nuevos innecesarios
3. ✅ **Mantener** consistencia visual en toda la app
4. ✅ **Acelerar** el desarrollo reutilizando componentes existentes

---

## 📋 ÍNDICE RÁPIDO

### Por Categoría
- [Badges y Estado](#-badges-y-estado)
- [Cards y Contenedores](#-cards-y-contenedores)
- [Banners y Alertas](#-banners-y-alertas)
- [Headers y Títulos](#-headers-y-títulos)
- [Buttons](#-buttons)
- [Forms](#-forms)
- [Lists](#-lists)
- [Scaffolds](#-scaffolds)
- [Otros Widgets](#-otros-widgets)

### Por Caso de Uso
- [¿Qué widget uso para...?](#-qué-widget-uso-para)

---

## 🏷️ BADGES Y ESTADO

### StatusBadge

**Ubicación:** `core/widgets/badges/status_badge.dart`

**Cuándo usar:**
- ✅ Mostrar estado de incidentes (abierta, cerrada, en progreso)
- ✅ Mostrar estado de aprobación (pendiente, aprobada, rechazada)
- ✅ Mostrar cualquier estado con color + icono + texto

**Ejemplos:**

```dart
// Estado de incidente
StatusBadge.incidentStatus(
  status: 'abierta',
  isCritical: false,
)

// Estado de incidente crítico
StatusBadge.incidentStatus(
  status: 'abierta',
  isCritical: true,
)

// Estado de aprobación
StatusBadge.approvalStatus(
  status: 'pendiente', // o 'aprobada', 'rechazada'
)

// Badge personalizado
StatusBadge(
  label: 'Custom',
  backgroundColor: Colors.blue,
  textColor: Colors.white,
  icon: Icons.star,
)

// Badge con estilo outlined
StatusBadge(
  label: 'Outlined',
  backgroundColor: Colors.blue,
  isOutlined: true,
)
```

**Factories disponibles:**
- `StatusBadge.incidentStatus()` - Para estados de incidentes
- `StatusBadge.approvalStatus()` - Para estados de aprobación
- `StatusBadge()` - Constructor genérico

**Colores automáticos:**
- Abierta → Azul
- En Progreso → Naranja
- Cerrada → Verde
- Pendiente → Amarillo
- Aprobada → Verde
- Rechazada → Rojo
- Crítica → Rojo con icono de warning

---

### ApprovalBadge

**Ubicación:** `core/widgets/approval_badge.dart`

**Cuándo usar:**
- ✅ Mostrar específicamente estados de aprobación
- ⚠️ Preferir StatusBadge.approvalStatus() para consistencia

**Ejemplo:**

```dart
ApprovalBadge(
  status: ApprovalStatus.pending,
)
```

---

### RoleBadge

**Ubicación:** `core/widgets/role_badge.dart`

**Cuándo usar:**
- ✅ Mostrar roles de usuarios (Admin, Supervisor, Trabajador, etc.)

**Ejemplo:**

```dart
RoleBadge(
  role: 'Supervisor',
  color: Colors.purple,
)
```

---

### TypeChip

**Ubicación:** `core/widgets/type_chip.dart`

**Cuándo usar:**
- ✅ Mostrar tipos de incidentes (Incidente, Corrección, Material Request)
- ✅ Chips pequeños para categorías

**Ejemplo:**

```dart
TypeChip(
  type: IncidentType.incident,
)

TypeChip(
  type: IncidentType.correction,
)
```

---

## 🃏 CARDS Y CONTENEDORES

### AppCard

**Ubicación:** `core/widgets/cards/app_card.dart`

**Cuándo usar:**
- ✅ Cualquier contenedor de contenido con elevación
- ✅ Reemplazar Card() manual para consistencia
- ✅ Cards clickeables con ripple effect
- ✅ Cards compactos

**Ejemplos:**

```dart
// Card básico
AppCard(
  child: Column(
    children: [
      Text('Título'),
      Text('Descripción'),
    ],
  ),
)

// Card clickeable (con InkWell automático)
AppCard.clickable(
  onTap: () => print('Tapped!'),
  child: Text('Click me'),
)

// Card compacto (padding reducido)
AppCard.compact(
  child: Text('Small card'),
)

// Card sin margen (para listas)
AppCard.noMargin(
  child: Text('No margin'),
)
```

**Parámetros principales:**
- `margin` - Margen exterior (default: 16h, 8v)
- `padding` - Padding interno (default: 16)
- `color` - Color de fondo
- `elevation` - Elevación (sombra)
- `borderRadius` - Radio de bordes

---

### InfoCard

**Ubicación:** `core/widgets/cards/app_card.dart`

**Cuándo usar:**
- ✅ Mostrar información con icono + título + subtítulo
- ✅ Cards de configuración
- ✅ Cards informativos en listas

**Ejemplo:**

```dart
InfoCard(
  icon: Icons.sync,
  title: 'Sincronización',
  subtitle: 'Última sincronización: Hace 5 minutos',
  onTap: () => _showSyncDetails(),
  iconColor: Colors.blue,
  trailing: Icon(Icons.chevron_right),
)
```

---

### StatsCard

**Ubicación:** `core/widgets/cards/app_card.dart`

**Cuándo usar:**
- ✅ Mostrar estadísticas numéricas
- ✅ KPIs
- ✅ Métricas con icono

**Ejemplo:**

```dart
StatsCard(
  title: 'Incidentes Abiertos',
  value: '23',
  icon: Icons.warning,
  trend: '+5',
  trendIsPositive: false,
)
```

---

### ListItemCard

**Ubicación:** `core/widgets/cards/app_card.dart`

**Cuándo usar:**
- ✅ Items en listas con estructura consistente
- ✅ Cards de lista con leading/title/subtitle/trailing

**Ejemplo:**

```dart
ListItemCard(
  leading: Icon(Icons.person),
  title: 'Juan Pérez',
  subtitle: 'Supervisor',
  trailing: Icon(Icons.chevron_right),
  onTap: () => _showDetails(),
)
```

---

### SelectableCard

**Ubicación:** `core/widgets/selectable_card.dart`

**Cuándo usar:**
- ✅ Cards que pueden seleccionarse (checkbox/radio visual)
- ✅ Formularios con opciones múltiples

**Ejemplo:**

```dart
SelectableCard(
  title: 'Opción A',
  subtitle: 'Descripción de la opción',
  isSelected: selectedOption == 'A',
  onTap: () => setState(() => selectedOption = 'A'),
)
```

---

### SectionCard

**Ubicación:** `core/widgets/section_card.dart`

**Cuándo usar:**
- ✅ Agrupar contenido relacionado en secciones
- ✅ Cards con header y contenido

**Ejemplo:**

```dart
SectionCard(
  title: 'Información General',
  child: Column(
    children: [
      InfoRow(label: 'Nombre', value: project.name),
      InfoRow(label: 'Código', value: project.code),
    ],
  ),
)
```

---

## 🎗️ BANNERS Y ALERTAS

### InfoBanner

**Ubicación:** `core/widgets/banners/info_banner.dart`

**Cuándo usar:**
- ✅ Mensajes informativos en la parte superior de pantallas
- ✅ Warnings no críticos
- ✅ Mensajes de éxito
- ✅ Errores contextuales

**Ejemplos:**

```dart
// Banner informativo
InfoBanner(
  message: 'Los cambios se guardarán automáticamente',
  type: InfoBannerType.info,
)

// Banner de warning
InfoBanner(
  message: 'Esta acción no se puede deshacer',
  type: InfoBannerType.warning,
)

// Banner de error
InfoBanner(
  message: 'Error al cargar los datos',
  type: InfoBannerType.error,
  onClose: () => setState(() => showBanner = false),
)

// Banner de éxito
InfoBanner(
  message: '¡Cambios guardados exitosamente!',
  type: InfoBannerType.success,
)

// Con título e icono custom
InfoBanner(
  title: 'Importante',
  message: 'Detalles del mensaje',
  icon: Icons.star,
  type: InfoBannerType.info,
)
```

**Tipos disponibles:**
- `InfoBannerType.info` - Azul
- `InfoBannerType.warning` - Naranja/Amarillo
- `InfoBannerType.error` - Rojo
- `InfoBannerType.success` - Verde

---

### CriticalBanner

**Ubicación:** `core/widgets/critical_banner.dart`

**Cuándo usar:**
- ✅ Advertencias críticas
- ✅ Acciones irreversibles
- ⚠️ Preferir InfoBanner.warning para consistencia

**Ejemplo:**

```dart
CriticalBanner(
  message: 'Esta acción eliminará todos los datos',
  type: CriticalBannerType.error,
)
```

---

### ActionConfirmationBanner

**Ubicación:** `core/widgets/banners/action_confirmation_banner.dart`

**Cuándo usar:**
- ✅ Confirmar acciones antes de ejecutarlas
- ✅ Banners con botones de acción

**Ejemplo:**

```dart
ActionConfirmationBanner(
  message: '¿Deseas eliminar este item?',
  confirmText: 'Eliminar',
  cancelText: 'Cancelar',
  onConfirm: () => _deleteItem(),
  onCancel: () => _closeBanner(),
)
```

---

## 🏷️ HEADERS Y TÍTULOS

### SectionHeader

**Ubicación:** `core/widgets/headers/section_header.dart`

**Cuándo usar:**
- ✅ Títulos de secciones en pantallas
- ✅ Headers con botones de acción
- ✅ Headers con subtítulos
- ✅ Separadores visuales entre secciones

**Ejemplos:**

```dart
// Header simple
SectionHeader(
  title: 'Información General',
)

// Con subtítulo
SectionHeader(
  title: 'Fotos',
  subtitle: 'Máximo 5 imágenes',
)

// Con botón de acción
SectionHeader(
  title: 'Comentarios',
  trailing: TextButton(
    onPressed: () => _addComment(),
    child: Text('Agregar'),
  ),
)

// Con badge
SectionHeader(
  title: 'Notificaciones',
  badge: Badge(
    label: Text('3'),
  ),
)

// Requerido (muestra asterisco)
SectionHeader(
  title: 'Descripción',
  isRequired: true,
)

// Con divider
SectionHeader(
  title: 'Sección',
  showDivider: true,
)
```

---

### DetailHeader

**Ubicación:** `core/widgets/detail_header.dart`

**Cuándo usar:**
- ✅ Headers de páginas de detalle (detalle de incidente, proyecto, etc.)
- ✅ Headers con información compleja (ícono + título + subtítulos + badges)

**Ejemplo:**

```dart
DetailHeader(
  icon: Icons.warning,
  title: incident.title,
  subtitle: 'Reportado por ${incident.author}',
  badge: StatusBadge.incidentStatus(status: incident.status),
  trailing: PopupMenuButton(/* ... */),
)
```

---

## 🔘 BUTTONS

### AppButton

**Ubicación:** `core/widgets/buttons/app_button.dart`

**Cuándo usar:**
- ✅ Botones principales de la app
- ✅ Mantener consistencia en estilos de botones

**Ejemplos:**

```dart
// Botón primario
AppButton(
  text: 'Guardar',
  onPressed: () => _save(),
)

// Botón secundario
AppButton.secondary(
  text: 'Cancelar',
  onPressed: () => Navigator.pop(context),
)

// Botón outlined
AppButton.outlined(
  text: 'Ver más',
  onPressed: () => _viewMore(),
)

// Con icono
AppButton(
  text: 'Agregar',
  icon: Icons.add,
  onPressed: () => _add(),
)

// Full width
AppButton(
  text: 'Continuar',
  fullWidth: true,
  onPressed: () => _continue(),
)
```

---

### LoadingButton

**Ubicación:** `core/widgets/buttons/loading_button.dart`

**Cuándo usar:**
- ✅ Botones que ejecutan operaciones asíncronas
- ✅ Mostrar loading automáticamente durante la operación

**Ejemplo:**

```dart
LoadingButton(
  text: 'Guardar',
  onPressed: () async {
    await _saveData();
    // El loading se muestra automáticamente
  },
)
```

---

## 📝 FORMS

### FormFieldWithLabel

**Ubicación:** `core/widgets/forms/form_field_with_label.dart`

**Cuándo usar:**
- ✅ Campos de formulario con etiqueta consistente
- ✅ Reemplazar TextFormField manual

**Ejemplo:**

```dart
FormFieldWithLabel(
  label: 'Nombre',
  isRequired: true,
  child: TextFormField(
    controller: nameController,
    validator: FormValidators.required,
  ),
)
```

---

### DateTimePickerField

**Ubicación:** `core/widgets/forms/datetime_picker_field.dart`

**Cuándo usar:**
- ✅ Selección de fechas
- ✅ Selección de fechas con hora

**Ejemplo:**

```dart
DateTimePickerField(
  label: 'Fecha de inicio',
  value: startDate,
  onChanged: (date) => setState(() => startDate = date),
)

DateTimePickerField(
  label: 'Fecha y hora',
  value: dateTime,
  onChanged: (dt) => setState(() => dateTime = dt),
  showTime: true,
)
```

---

### MultiImagePicker

**Ubicación:** `core/widgets/forms/multi_image_picker.dart`

**Cuándo usar:**
- ✅ Selección de múltiples imágenes
- ✅ Formularios con fotos

**Ejemplo:**

```dart
MultiImagePicker(
  images: selectedImages,
  onImagesChanged: (images) => setState(() => selectedImages = images),
  maxImages: 5,
)
```

---

### FormActionButtons

**Ubicación:** `core/widgets/forms/form_action_buttons.dart`

**Cuándo usar:**
- ✅ Botones de guardar/cancelar al final de formularios
- ✅ Mantener consistencia en layout de botones

**Ejemplo:**

```dart
FormActionButtons(
  onSave: () => _saveForm(),
  onCancel: () => Navigator.pop(context),
  saveText: 'Guardar',
  isLoading: isSubmitting,
)
```

---

## 📃 LISTS

### AsyncListView

**Ubicación:** `core/widgets/lists/async_list_view.dart`

**Cuándo usar:**
- ✅ Listas que cargan datos de forma asíncrona
- ✅ Manejo automático de estados (loading, error, empty, success)

**Ejemplo:**

```dart
AsyncListView<Incident>(
  future: incidentsRepository.getIncidents(),
  itemBuilder: (context, incident) {
    return IncidentListItem(incident: incident);
  },
  emptyMessage: 'No hay incidentes',
)
```

---

### FilterableListView

**Ubicación:** `core/widgets/lists/filterable_list_view.dart`

**Cuándo usar:**
- ✅ Listas con filtros
- ✅ Búsqueda en listas

**Ejemplo:**

```dart
FilterableListView<Incident>(
  items: incidents,
  itemBuilder: (context, incident) {
    return IncidentListItem(incident: incident);
  },
  filterBuilder: (context, onFilterChanged) {
    return FilterChips(/* ... */);
  },
)
```

---

### TabbedListView

**Ubicación:** `core/widgets/lists/tabbed_list_view.dart`

**Cuándo usar:**
- ✅ Listas con tabs (múltiples categorías)

**Ejemplo:**

```dart
TabbedListView(
  tabs: ['Todos', 'Abiertos', 'Cerrados'],
  builders: [
    (context) => _buildAllList(),
    (context) => _buildOpenList(),
    (context) => _buildClosedList(),
  ],
)
```

---

## 🏗️ SCAFFOLDS

### StropScaffold

**Ubicación:** `core/widgets/scaffolds/strop_scaffold.dart`

**Cuándo usar:**
- ✅ TODAS las pantallas de la app
- ✅ Mantener consistencia en AppBar y estilos

**Ejemplo:**

```dart
StropScaffold(
  title: 'Título de la pantalla',
  body: Column(
    children: [/* contenido */],
  ),
)

// Con acciones en AppBar
StropScaffold(
  title: 'Detalle',
  actions: [
    IconButton(
      icon: Icon(Icons.share),
      onPressed: () => _share(),
    ),
  ],
  body: /* ... */,
)

// Con FAB
StropScaffold(
  title: 'Lista',
  body: /* ... */,
  floatingActionButton: FloatingActionButton(
    onPressed: () => _add(),
    child: Icon(Icons.add),
  ),
)
```

---

### FormScaffold

**Ubicación:** `core/widgets/scaffolds/form_scaffold.dart`

**Cuándo usar:**
- ✅ Pantallas de formularios
- ✅ Manejo automático de teclado y scroll

**Ejemplo:**

```dart
FormScaffold(
  title: 'Nueva Incidencia',
  body: Column(
    children: [
      FormFieldWithLabel(/* ... */),
      FormFieldWithLabel(/* ... */),
    ],
  ),
  actions: FormActionButtons(
    onSave: () => _save(),
    onCancel: () => Navigator.pop(context),
  ),
)
```

---

## 🔧 OTROS WIDGETS

### EmptyState

**Ubicación:** `core/widgets/empty_state.dart`

**Cuándo usar:**
- ✅ Mostrar cuando no hay datos
- ✅ Estados vacíos con mensaje e icono

**Ejemplo:**

```dart
EmptyState(
  icon: Icons.inbox,
  message: 'No hay incidentes',
  description: 'Crea tu primer incidente para comenzar',
  actionLabel: 'Crear Incidente',
  onAction: () => _createIncident(),
)
```

---

### AppLoading

**Ubicación:** `core/widgets/app_loading.dart`

**Cuándo usar:**
- ✅ Indicadores de carga consistentes

**Ejemplo:**

```dart
AppLoading()

// Con mensaje
AppLoading(message: 'Cargando datos...')
```

---

### AppError

**Ubicación:** `core/widgets/app_error.dart`

**Cuándo usar:**
- ✅ Mostrar errores con opción de reintentar

**Ejemplo:**

```dart
AppError(
  message: 'Error al cargar datos',
  onRetry: () => _loadData(),
)
```

---

### LoadingDialog

**Ubicación:** `core/widgets/loading_dialog.dart`

**Cuándo usar:**
- ✅ Diálogos de carga que bloquean la UI

**Ejemplo:**

```dart
LoadingDialog.show(
  context: context,
  message: 'Guardando...',
);

// Cerrar cuando termine
LoadingDialog.hide(context);
```

---

### ConfirmDialog

**Ubicación:** `core/widgets/dialogs/confirm_dialog.dart`

**Cuándo usar:**
- ✅ Confirmaciones de acciones destructivas

**Ejemplo:**

```dart
final confirmed = await ConfirmDialog.show(
  context: context,
  title: '¿Eliminar incidente?',
  message: 'Esta acción no se puede deshacer',
  confirmText: 'Eliminar',
  cancelText: 'Cancelar',
  isDangerous: true,
);

if (confirmed) {
  _deleteIncident();
}
```

---

### UserSelectorWidget

**Ubicación:** `core/widgets/user_selector_widget.dart`

**Cuándo usar:**
- ✅ Selección de usuarios de una lista
- ✅ Asignación de tareas/incidentes

**Ejemplo:**

```dart
UserSelectorWidget(
  users: availableUsers,
  selectedUser: assignedUser,
  onUserSelected: (user) => setState(() => assignedUser = user),
  showSearch: true,
  showRoles: true,
)
```

---

### FilterBottomSheet

**Ubicación:** `core/widgets/filter_bottom_sheet.dart`

**Cuándo usar:**
- ✅ Filtros en listas
- ✅ Bottom sheets de filtrado

**Ejemplo:**

```dart
FilterBottomSheet.show(
  context: context,
  filters: [
    FilterOption(
      label: 'Estado',
      options: ['Abierta', 'Cerrada'],
      selectedOptions: selectedStatuses,
    ),
  ],
  onApply: (filters) => _applyFilters(filters),
)
```

---

### TeamList

**Ubicación:** `core/widgets/team_list.dart`

**Cuándo usar:**
- ✅ Mostrar lista de miembros de equipo

**Ejemplo:**

```dart
TeamList(
  members: project.team,
  onMemberTap: (member) => _showMemberDetails(member),
)
```

---

### TeamMemberCard

**Ubicación:** `core/widgets/team_member_card.dart`

**Cuándo usar:**
- ✅ Card individual de miembro de equipo

**Ejemplo:**

```dart
TeamMemberCard(
  member: teamMember,
  onTap: () => _showDetails(teamMember),
  showRole: true,
  showContact: true,
)
```

---

### TimelineEvent

**Ubicación:** `core/widgets/timeline_event.dart`

**Cuándo usar:**
- ✅ Eventos en timeline
- ✅ Bitácora de cambios

**Ejemplo:**

```dart
TimelineEvent(
  title: 'Incidente creado',
  subtitle: 'por Juan Pérez',
  date: DateTime.now(),
  icon: Icons.add_circle,
)
```

---

### AvatarWithInitials

**Ubicación:** `core/widgets/avatar_with_initials.dart`

**Cuándo usar:**
- ✅ Avatares de usuario con iniciales

**Ejemplo:**

```dart
AvatarWithInitials(
  name: 'Juan Pérez',
  size: 40,
  backgroundColor: Colors.blue,
)
```

---

### PhotoGrid

**Ubicación:** `core/widgets/photos/photo_grid.dart`

**Cuándo usar:**
- ✅ Mostrar grid de fotos
- ✅ Galerías de imágenes

**Ejemplo:**

```dart
PhotoGrid(
  photos: incident.photos,
  onPhotoTap: (index) => _viewPhoto(index),
  maxPhotosToShow: 4,
)
```

---

## ❓ ¿QUÉ WIDGET USO PARA...?

### Mostrar el estado de algo

| Necesidad | Widget |
|-----------|--------|
| Estado de incidente | `StatusBadge.incidentStatus()` |
| Estado de aprobación | `StatusBadge.approvalStatus()` |
| Rol de usuario | `RoleBadge` |
| Tipo de incidente | `TypeChip` |

---

### Mostrar contenido en un card

| Necesidad | Widget |
|-----------|--------|
| Card básico | `AppCard` |
| Card clickeable | `AppCard.clickable()` |
| Card con info + icono | `InfoCard` |
| Card de estadística | `StatsCard` |
| Card de lista | `ListItemCard` |
| Card seleccionable | `SelectableCard` |

---

### Mostrar mensajes al usuario

| Necesidad | Widget |
|-----------|--------|
| Mensaje informativo | `InfoBanner` con tipo info |
| Warning | `InfoBanner` con tipo warning |
| Error | `InfoBanner` con tipo error |
| Éxito | `InfoBanner` con tipo success |
| Advertencia crítica | `CriticalBanner` |
| Confirmación de acción | `ActionConfirmationBanner` |

---

### Organizar una pantalla

| Necesidad | Widget |
|-----------|--------|
| Pantalla básica | `StropScaffold` |
| Pantalla de formulario | `FormScaffold` |
| Título de sección | `SectionHeader` |
| Header de detalle | `DetailHeader` |

---

### Trabajar con formularios

| Necesidad | Widget |
|-----------|--------|
| Campo de texto con label | `FormFieldWithLabel` |
| Selector de fecha | `DateTimePickerField` |
| Selector de imágenes | `MultiImagePicker` |
| Botones de guardar/cancelar | `FormActionButtons` |
| Botón con loading | `LoadingButton` |

---

### Trabajar con listas

| Necesidad | Widget |
|-----------|--------|
| Lista básica | `ListView.builder` con `AppCard` |
| Lista asíncrona | `AsyncListView` |
| Lista con filtros | `FilterableListView` |
| Lista con tabs | `TabbedListView` |
| Lista de equipo | `TeamList` |

---

### Manejar estados

| Necesidad | Widget |
|-----------|--------|
| Loading | `AppLoading` |
| Error | `AppError` |
| Estado vacío | `EmptyState` |
| Loading en diálogo | `LoadingDialog` |

---

### Selección y confirmación

| Necesidad | Widget |
|-----------|--------|
| Seleccionar usuario | `UserSelectorWidget` |
| Filtrar lista | `FilterBottomSheet` |
| Confirmar acción | `ConfirmDialog` |

---

## 📏 MEJORES PRÁCTICAS

### 1. Usar const constructors siempre que sea posible

```dart
// ✅ BIEN
const SectionHeader(title: 'Título')

// ❌ MAL
SectionHeader(title: 'Título')
```

### 2. Preferir widgets de core sobre código manual

```dart
// ✅ BIEN
AppCard.clickable(
  onTap: () => _action(),
  child: Text('Content'),
)

// ❌ MAL
Card(
  child: InkWell(
    onTap: () => _action(),
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text('Content'),
    ),
  ),
)
```

### 3. Usar factory constructors para casos específicos

```dart
// ✅ BIEN
StatusBadge.incidentStatus(status: 'abierta')

// ❌ MAL (aunque funcional)
StatusBadge(
  label: 'ABIERTA',
  backgroundColor: Colors.blue,
  icon: Icons.radio_button_checked,
)
```

### 4. Aprovechar los parámetros opcionales

```dart
// ✅ BIEN - Solo especificar lo necesario
SectionHeader(
  title: 'Título',
  trailing: TextButton(/* ... */),
)

// ❌ MAL - Especificar valores default innecesarios
SectionHeader(
  title: 'Título',
  subtitle: null,
  badge: null,
  isRequired: false,
  showDivider: false,
  padding: null,
  trailing: TextButton(/* ... */),
)
```

### 5. Documentar cuando creas widgets específicos de features

```dart
/// Widget específico para mostrar actividades del programa de proyecto.
/// 
/// Usa [StatsCard] de core pero agrega lógica específica de actividades.
/// 
/// **Cuándo usar:** Solo para mostrar actividades de programa de proyecto.
/// **No usar para:** Otras métricas (usar StatsCard directamente).
class ProjectActivityCard extends StatelessWidget {
  // ...
}
```

---

## 🚫 ANTI-PATRONES A EVITAR

### ❌ Crear widgets nuevos sin revisar primero qué existe

```dart
// ❌ MAL
class MyCustomCard extends StatelessWidget {
  // Reimplementa AppCard
}

// ✅ BIEN
// Usar AppCard directamente o componerlo
```

### ❌ Duplicar lógica de colores/estilos

```dart
// ❌ MAL
Container(
  color: status == 'abierta' ? Colors.blue : Colors.green,
  // ...
)

// ✅ BIEN
StatusBadge.incidentStatus(status: status)
```

### ❌ No usar StropScaffold en pantallas

```dart
// ❌ MAL
Scaffold(
  appBar: AppBar(title: Text('Título')),
  body: /* ... */,
)

// ✅ BIEN
StropScaffold(
  title: 'Título',
  body: /* ... */,
)
```

### ❌ Hardcodear padding/margins inconsistentes

```dart
// ❌ MAL
Padding(
  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 7),
  child: /* ... */,
)

// ✅ BIEN - Usar spacing del sistema
Padding(
  padding: EdgeInsets.all(16), // o usar AdaptiveSpacing
  child: /* ... */,
)
```

---

## 🔍 CÓMO ENCONTRAR UN WIDGET

### 1. Revisa esta guía por categoría

### 2. Busca en el barrel file

```dart
// lib/src/core/core_ui/widgets/widgets.dart
// Todos los widgets están exportados aquí
```

### 3. Busca por nombre en el proyecto

```bash
# Buscar un widget
grep -r "class.*Widget.*extends" lib/src/core/core_ui/widgets/
```

### 4. Pregunta al equipo

- Canal de Slack: #mobile-dev
- Revisar PRs recientes
- Revisar CHANGELOG.md

---

## 📚 RECURSOS ADICIONALES

- **Análisis de widgets:** `ANALISIS_WIDGETS_Y_OPTIMIZACION.md`
- **Plan de refactorización:** `PLAN_REFACTORIZACION_WIDGETS.md`
- **Arquitectura del proyecto:** `docs/ARCHITECTURE.md`
- **Convenciones de código:** `docs/CODE_CONVENTIONS.md`

---

## 🔄 MANTENER ESTA GUÍA ACTUALIZADA

Cuando crees un nuevo widget en core:

1. ✅ Agrégalo a esta guía
2. ✅ Especifica cuándo usarlo
3. ✅ Proporciona ejemplos
4. ✅ Actualiza la sección "¿Qué widget uso para...?"

Cuando elimines o modifiques un widget:

1. ✅ Actualiza esta guía
2. ✅ Actualiza el CHANGELOG.md
3. ✅ Notifica al equipo

---

**Última actualización:** 1 de Noviembre, 2025  
**Mantenedor:** Equipo Mobile  
**Próxima revisión:** Mensual
