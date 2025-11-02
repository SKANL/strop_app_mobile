# 🔧 PLAN DE REFACTORIZACIÓN DE WIDGETS

**Proyecto:** Mobile Strop App  
**Fecha:** 1 de Noviembre, 2025  
**Versión:** 1.0

---

## 📋 ÍNDICE

1. [Fase 1: Quick Wins](#fase-1-quick-wins)
2. [Fase 2: Consolidación de Badges](#fase-2-consolidación-de-badges)
3. [Fase 3: Consolidación de Headers](#fase-3-consolidación-de-headers)
4. [Fase 4: Consolidación de Cards](#fase-4-consolidación-de-cards)
5. [Fase 5: Consolidación de Banners](#fase-5-consolidación-de-banners)
6. [Fase 6: Refactoring de Screens](#fase-6-refactoring-de-screens)
7. [Testing y Validación](#testing-y-validación)

---

## 🚀 FASE 1: QUICK WINS

**Objetivo:** Eliminar código duplicado obvio  
**Tiempo estimado:** 4-6 horas  
**Líneas eliminadas:** ~600

### 1.1 Eliminar stats_card.dart duplicado

**Archivo a eliminar:**
```
lib/src/core/core_ui/widgets/stats_card.dart
```

**Pasos:**

1. Buscar todos los imports de `stats_card.dart`:
```bash
grep -r "import.*stats_card.dart" lib/
```

2. Reemplazar con import de `cards/app_card.dart`:
```dart
// Antes:
import '../../widgets/stats_card.dart';

// Después:
import '../../widgets/cards/app_card.dart';
```

3. Eliminar el archivo:
```bash
rm lib/src/core/core_ui/widgets/stats_card.dart
```

4. Ejecutar tests:
```bash
flutter test
```

**Validación:**
- ✅ No hay imports rotos
- ✅ Tests pasan
- ✅ App compila sin errores

---

### 1.2 Identificar y eliminar versiones viejas de CreateCorrectionScreen

**Archivos involucrados:**
```
lib/src/features/incidents/presentation/screens/
├── create_correction_screen.dart
├── create_correction_screen_clean.dart
└── create_correction_screen_refactored.dart
```

**Pasos:**

1. Buscar cuál se usa en el router:
```bash
grep -r "CreateCorrectionScreen" lib/src/core/core_navigation/
```

2. Buscar referencias en otros archivos:
```bash
grep -r "create_correction_screen" lib/
```

3. Una vez identificada la versión en uso, eliminar las otras dos:
```bash
# Ejemplo si la versión refactored es la correcta:
rm lib/src/features/incidents/presentation/screens/create_correction_screen.dart
rm lib/src/features/incidents/presentation/screens/create_correction_screen_clean.dart
```

4. Renombrar la versión correcta si tiene sufijo:
```bash
mv create_correction_screen_refactored.dart create_correction_screen.dart
```

**Validación:**
- ✅ Solo existe una versión
- ✅ Router apunta a la versión correcta
- ✅ App navega correctamente a la pantalla

---

## 🎯 FASE 2: CONSOLIDACIÓN DE BADGES

**Objetivo:** Tener un solo StatusBadge canónico  
**Tiempo estimado:** 1 día  
**Líneas eliminadas:** ~400

### 2.1 Mantener badges/status_badge.dart como versión canónica

**Versión a mantener:**
```
lib/src/core/core_ui/widgets/badges/status_badge.dart
```

Esta es la versión más completa (284 líneas) con:
- ✅ Soporte para incident status
- ✅ Soporte para approval status
- ✅ Estilos configurables
- ✅ Factory methods bien diseñados

---

### 2.2 Eliminar status_badge.dart de raíz

**Archivo a eliminar:**
```
lib/src/core/core_ui/widgets/status_badge.dart
```

**Pasos:**

1. Encontrar todos los imports:
```bash
grep -r "import.*widgets/status_badge.dart" lib/
```

2. Reemplazar imports:
```dart
// Antes:
import '../widgets/status_badge.dart';
import '../../core_ui/widgets/status_badge.dart';

// Después:
import '../widgets/badges/status_badge.dart';
import '../../core_ui/widgets/badges/status_badge.dart';
```

3. Actualizar el barrel file `widgets.dart` (verificar que ya apunte a badges/):
```dart
// Debe tener:
export 'badges/status_badge.dart';

// NO debe tener:
// export 'status_badge.dart';
```

4. Eliminar el archivo:
```bash
rm lib/src/core/core_ui/widgets/status_badge.dart
```

---

### 2.3 Refactorizar incident_status_badge.dart

**Archivo a refactorizar:**
```
lib/src/features/incidents/presentation/widgets/incident_status_badge.dart
```

**Estrategia:**

**Opción A: Eliminar completamente (RECOMENDADO)**

Reemplazar todos los usos de `IncidentStatusBadge` con `StatusBadge`:

```dart
// Antes:
IncidentStatusBadge(
  status: incident.status,
  approvalStatus: incident.approvalStatus,
)

// Después:
StatusBadge.incidentStatus(
  status: incident.status,
  approvalStatus: incident.approvalStatus,
)
```

**Opción B: Convertir en wrapper simple**

Si hay lógica específica que no puede moverse:

```dart
class IncidentStatusBadge extends StatelessWidget {
  final String status;
  final String? approvalStatus;

  const IncidentStatusBadge({
    super.key,
    required this.status,
    this.approvalStatus,
  });

  @override
  Widget build(BuildContext context) {
    if (approvalStatus != null) {
      return StatusBadge.approvalStatus(
        status: approvalStatus!,
      );
    }
    return StatusBadge.incidentStatus(
      status: status,
    );
  }
}
```

**Mejoras a StatusBadge core:**

Si falta funcionalidad, agregar a `badges/status_badge.dart`:

```dart
// Agregar si no existe:
factory StatusBadge.approvalStatus({
  required String status,
  bool upperCase = true,
}) {
  // lógica de approval
}

// Y factory compuesto:
factory StatusBadge.incidentWithApproval({
  required String status,
  String? approvalStatus,
}) {
  if (approvalStatus != null) {
    return StatusBadge.approvalStatus(status: approvalStatus);
  }
  return StatusBadge.incidentStatus(status: status);
}
```

**Pasos:**

1. Revisar qué factories faltan en badges/status_badge.dart
2. Agregar factories necesarios
3. Reemplazar usos de IncidentStatusBadge:
```bash
grep -r "IncidentStatusBadge" lib/
```
4. Actualizar cada uso
5. Eliminar incident_status_badge.dart
6. Ejecutar tests

---

## 🏷️ FASE 3: CONSOLIDACIÓN DE HEADERS

**Objetivo:** Tener un solo SectionHeader  
**Tiempo estimado:** 4 horas  
**Líneas eliminadas:** ~150

### 3.1 Mantener headers/section_header.dart

**Versión a mantener:**
```
lib/src/core/core_ui/widgets/headers/section_header.dart
```

Esta versión tiene mejor estructura y más opciones.

---

### 3.2 Eliminar section_header.dart de raíz

**Archivo a eliminar:**
```
lib/src/core/core_ui/widgets/section_header.dart
```

**Pasos:**

1. Encontrar imports:
```bash
grep -r "import.*widgets/section_header.dart" lib/
```

2. Reemplazar:
```dart
// Antes:
import '../widgets/section_header.dart';

// Después:
import '../widgets/headers/section_header.dart';
```

3. Verificar el barrel file `widgets.dart`:
```dart
// Debe tener:
export 'headers/section_header.dart';

// NO debe tener:
// export 'section_header.dart';
```

4. Eliminar archivo:
```bash
rm lib/src/core/core_ui/widgets/section_header.dart
```

5. Eliminar CompactSectionHeader si existe (usar SectionHeader con params):
```dart
// Antes:
CompactSectionHeader(title: 'Título')

// Después:
SectionHeader(
  title: 'Título',
  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
  titleSize: 14,
)
```

---

## 🃏 FASE 4: CONSOLIDACIÓN DE CARDS

**Objetivo:** Unificar APIs de cards  
**Tiempo estimado:** 2 días  
**Líneas eliminadas:** ~300

### 4.1 Consolidar ItemCard<T> en AppCard

**Archivos involucrados:**
```
lib/src/core/core_ui/widgets/cards/app_card.dart       (mantener)
lib/src/core/core_ui/widgets/item_card.dart            (migrar y eliminar)
```

**Estrategia:**

1. Agregar generics a AppCard:

```dart
// Agregar a app_card.dart:

class AppCard<T> extends StatelessWidget {
  final T? item;
  final Widget Function(BuildContext, T)? itemBuilder;
  final Widget? child;
  // ... resto de parámetros

  // Constructor normal (sin generics):
  const AppCard({
    super.key,
    required Widget child,
    // ... parámetros
  }) : item = null,
       itemBuilder = null,
       child = child;

  // Constructor con item builder:
  const AppCard.withItem({
    super.key,
    required T item,
    required Widget Function(BuildContext, T) builder,
    // ... parámetros
  }) : item = item,
       itemBuilder = builder,
       child = null;

  @override
  Widget build(BuildContext context) {
    final content = child ?? itemBuilder!(context, item as T);
    // ... resto de la lógica
  }
}
```

2. Agregar ExpandableAppCard:

```dart
// Agregar a app_card.dart:

class ExpandableAppCard<T> extends StatefulWidget {
  final T item;
  final Widget Function(BuildContext, T) headerBuilder;
  final Widget Function(BuildContext, T) expandedBuilder;
  final bool initiallyExpanded;
  // ... parámetros

  // Implementación similar a ExpandableItemCard
}
```

3. Migrar código de item_card.dart a app_card.dart

4. Actualizar imports:
```bash
grep -r "item_card.dart" lib/
```

5. Eliminar item_card.dart

---

### 4.2 Evaluar y consolidar otros cards

**Cards a revisar:**

1. **SelectableCard** - ¿Puede ser AppCard.selectable()?
2. **SectionCard** - ¿Puede ser AppCard.section()?
3. **ActionTypeCard** - ¿Puede componerse con AppCard + TypeChip?

**Ejemplo de consolidación:**

```dart
// Antes (action_type_card.dart):
ActionTypeCard(
  title: 'Incidente',
  icon: Icons.warning,
  onTap: () {},
)

// Después (usar AppCard + composición):
AppCard.clickable(
  onTap: () {},
  child: Row(
    children: [
      Icon(Icons.warning),
      SizedBox(width: 12),
      Text('Incidente'),
    ],
  ),
)

// O mejor, crear factory:
extension AppCardTypes on AppCard {
  static AppCard actionType({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) => AppCard.clickable(
    onTap: onTap,
    child: Row(/* ... */),
  );
}
```

---

## 🎗️ FASE 5: CONSOLIDACIÓN DE BANNERS

**Objetivo:** Unificar lógica de banners informativos  
**Tiempo estimado:** 1 día  
**Líneas eliminadas:** ~200

### 5.1 Mantener InfoBanner como base

**Versión a mantener:**
```
lib/src/core/core_ui/widgets/banners/info_banner.dart
```

Ya tiene:
- ✅ Sistema de tipos (info, warning, error, success)
- ✅ Soporte para icono customizable
- ✅ Soporte para título + mensaje
- ✅ Botón de cerrar opcional

---

### 5.2 Evaluar CriticalBanner

**Archivo:**
```
lib/src/core/core_ui/widgets/critical_banner.dart
```

**Opción A: Convertir en factory de InfoBanner**

```dart
// Agregar a info_banner.dart:
extension InfoBannerFactories on InfoBanner {
  static InfoBanner critical({
    required String message,
    bool showIcon = true,
  }) => InfoBanner(
    message: message,
    type: InfoBannerType.error,
    icon: showIcon ? Icons.warning_amber_rounded : null,
  );
}

// Y luego:
// rm critical_banner.dart
```

**Opción B: Mantener si tiene lógica única**

Si CriticalBanner tiene características que no se pueden replicar con InfoBanner, mantenerlo pero que use InfoBanner internamente:

```dart
class CriticalBanner extends StatelessWidget {
  // ...
  @override
  Widget build(BuildContext context) {
    return InfoBanner(
      message: message,
      type: _convertType(type),
      // ...
    );
  }
}
```

---

### 5.3 Refactorizar ProjectInfoBanner

**Archivo:**
```
lib/src/features/incidents/presentation/widgets/project_info_banner.dart
```

**Estrategia:** Eliminar y usar InfoBanner

```dart
// Antes:
ProjectInfoBanner(
  message: 'Proyecto activo',
  icon: Icons.info,
  color: Colors.blue,
)

// Después:
InfoBanner(
  message: 'Proyecto activo',
  icon: Icons.info,
  type: InfoBannerType.info,
)
```

**Pasos:**

1. Buscar usos de ProjectInfoBanner:
```bash
grep -r "ProjectInfoBanner" lib/
```

2. Reemplazar cada uso con InfoBanner

3. Eliminar project_info_banner.dart

---

## 🖥️ FASE 6: REFACTORING DE SCREENS

**Objetivo:** Reducir código en screens usando widgets de core  
**Tiempo estimado:** 1 semana  
**Líneas reducidas:** ~300-400

### 6.1 AssignUserScreen - Usar UserSelectorWidget

**Archivo:**
```
lib/src/features/incidents/presentation/screens/assign_user_screen.dart
```

**Antes (código manual):**
```dart
// ~150 líneas de código manual para:
// - Lista de usuarios
// - Search
// - Selección
```

**Después (usar widget de core):**
```dart
class AssignUserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StropScaffold(
      title: 'Asignar Usuario',
      body: UserSelectorWidget(
        users: users,
        onUserSelected: (user) {
          // lógica de asignación
        },
        showSearch: true,
        showRoles: true,
      ),
    );
  }
}
```

**Reducción:** ~100 líneas

---

### 6.2 ProjectTeamScreen - Usar TeamMemberCard + TeamList

**Archivo:**
```
lib/src/features/incidents/presentation/screens/project_team_screen.dart
```

**Antes:**
```dart
// Código manual para cada miembro del equipo
ListView.builder(
  itemBuilder: (context, index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(/* ... */),
        title: Text(/* ... */),
        subtitle: Text(/* ... */),
        // ... más código
      ),
    );
  },
)
```

**Después:**
```dart
TeamList(
  members: project.team,
  onMemberTap: (member) => _showMemberDetails(member),
  showRole: true,
  showContact: true,
)

// O si necesitas más control:
ListView.builder(
  itemBuilder: (context, index) {
    return TeamMemberCard(
      member: project.team[index],
      onTap: () => _showMemberDetails(project.team[index]),
    );
  },
)
```

**Reducción:** ~80 líneas

---

### 6.3 Listas de Incidents - Usar FilterBottomSheet

**Archivos:**
```
lib/src/features/incidents/presentation/screens/my_reports_screen.dart
lib/src/features/incidents/presentation/screens/my_tasks_screen.dart
lib/src/features/incidents/presentation/screens/project_bitacora_screen.dart
```

**Antes:**
```dart
// Código manual de filtros:
showModalBottomSheet(
  context: context,
  builder: (context) => Container(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        // 50+ líneas de código manual para filtros
      ],
    ),
  ),
);
```

**Después:**
```dart
FilterBottomSheet.show(
  context: context,
  filters: [
    FilterOption(
      label: 'Estado',
      options: ['Abierta', 'Cerrada', 'En Progreso'],
      selectedOptions: selectedStatuses,
    ),
    FilterOption(
      label: 'Tipo',
      options: ['Incidente', 'Corrección', 'Material'],
      selectedOptions: selectedTypes,
    ),
  ],
  onApply: (selectedFilters) {
    // aplicar filtros
  },
);
```

**Reducción por pantalla:** ~50 líneas  
**Total (3 screens):** ~150 líneas

---

### 6.4 ProjectActivityCard - Refactorizar con StatsCard

**Archivo:**
```
lib/src/features/incidents/presentation/widgets/project_activity_card.dart
```

**Antes (114 líneas):**
```dart
class ProjectActivityCard extends StatelessWidget {
  // Toda la lógica de UI manual
}
```

**Después (~40 líneas):**
```dart
class ProjectActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatsCard(
      title: title,
      subtitle: '$startDate - $endDate',
      value: '$progress%',
      status: StatusBadge.activityStatus(status),
      footer: LinearProgressIndicator(
        value: progress / 100,
        backgroundColor: Colors.grey[200],
        valueColor: AlwaysStoppedAnimation(_getStatusColor()),
      ),
    );
  }
  
  Color _getStatusColor() {
    // lógica simple de color
  }
}
```

**Reducción:** ~70 líneas

---

## ✅ TESTING Y VALIDACIÓN

### Checklist por Fase

Después de cada fase, ejecutar:

#### Tests Automatizados
```bash
# Tests unitarios
flutter test

# Tests de widgets
flutter test test/widgets/

# Tests de integración
flutter test integration_test/
```

#### Validación Manual

1. **Compilación limpia:**
```bash
flutter clean
flutter pub get
flutter analyze
```

2. **Verificar no hay imports rotos:**
```bash
flutter analyze | grep "import"
```

3. **Probar navegación a todas las pantallas afectadas**

4. **Probar funcionalidad específica:**
   - Badges: verificar colores y textos correctos
   - Headers: verificar layouts y acciones
   - Cards: verificar tap handlers y layouts
   - Banners: verificar estilos y mensajes
   - Screens: verificar funcionalidad completa

---

### Tests Específicos a Agregar

#### Para StatusBadge consolidado:
```dart
test('StatusBadge.incidentStatus muestra colores correctos', () {
  // ...
});

test('StatusBadge.approvalStatus muestra iconos correctos', () {
  // ...
});
```

#### Para AppCard con generics:
```dart
test('AppCard.withItem usa builder correctamente', () {
  // ...
});

test('ExpandableAppCard expande y colapsa', () {
  // ...
});
```

---

## 📊 MÉTRICAS DE ÉXITO

### Por Fase

| Fase | Líneas Eliminadas | Tests Pasando | Warnings Resueltos |
|------|-------------------|---------------|---------------------|
| Fase 1 | ~600 | ✅ | 4-6 |
| Fase 2 | ~400 | ✅ | 8-10 |
| Fase 3 | ~150 | ✅ | 3-5 |
| Fase 4 | ~300 | ✅ | 5-8 |
| Fase 5 | ~200 | ✅ | 3-4 |
| Fase 6 | ~300 | ✅ | 10-15 |
| **TOTAL** | **~1,950** | **✅** | **33-48** |

### Objetivos Globales

- ✅ Reducción de código: >1,500 líneas
- ✅ Eliminación de duplicados: 100%
- ✅ Tests pasando: 100%
- ✅ Cero warnings de imports rotos
- ✅ App funcionando correctamente
- ✅ Performance sin degradación

---

## 🚨 RIESGOS Y MITIGACIONES

### Riesgo 1: Romper funcionalidad existente
**Probabilidad:** Media  
**Impacto:** Alto

**Mitigación:**
- ✅ Hacer cambios incrementales
- ✅ Ejecutar tests después de cada cambio
- ✅ Hacer commits frecuentes
- ✅ Usar feature branches

### Riesgo 2: Tests que fallan por cambios de API
**Probabilidad:** Alta  
**Impacto:** Medio

**Mitigación:**
- ✅ Actualizar tests junto con código
- ✅ Mantener compatibilidad con tests existentes donde sea posible
- ✅ Documentar cambios de API

### Riesgo 3: Performance degradada
**Probabilidad:** Baja  
**Impacto:** Alto

**Mitigación:**
- ✅ Usar const constructors donde sea posible
- ✅ Perfilar antes y después de cambios grandes
- ✅ Monitorear tiempo de build

---

## 📅 CRONOGRAMA SUGERIDO

### Semana 1
- **Día 1:** Fase 1 (Quick Wins) - 4-6h
- **Día 2-3:** Fase 2 (Badges) - 8h
- **Día 4:** Fase 3 (Headers) - 4h
- **Día 5:** Testing y ajustes - 4h

### Semana 2
- **Día 1-2:** Fase 4 (Cards) - 12h
- **Día 3:** Fase 5 (Banners) - 6h
- **Día 4-5:** Testing y documentación - 8h

### Semana 3
- **Día 1-3:** Fase 6 (Screens) - 18h
- **Día 4:** Testing integral - 6h
- **Día 5:** Documentación y training - 4h

**Total:** ~70-80 horas (2-3 semanas de trabajo)

---

## 📝 DOCUMENTACIÓN A ACTUALIZAR

### Durante el proceso:
1. ✅ Actualizar CHANGELOG.md
2. ✅ Actualizar README.md con nueva estructura
3. ✅ Crear WIDGET_GUIDELINES.md
4. ✅ Actualizar comentarios en código

### Al finalizar:
1. ✅ Crear MIGRATION_GUIDE.md para el equipo
2. ✅ Actualizar documentación de arquitectura
3. ✅ Crear ejemplos de uso de widgets consolidados
4. ✅ Presentación para el equipo

---

## 🎯 PRÓXIMOS PASOS

1. **Revisar este plan con el equipo**
2. **Aprobar prioridades y cronograma**
3. **Crear tickets/issues para cada fase**
4. **Asignar responsables**
5. **Crear branch de refactoring**
6. **Comenzar con Fase 1** 🚀

---

**Fecha de Creación:** 1 de Noviembre, 2025  
**Versión:** 1.0  
**Próxima Revisión:** Después de Fase 1-2
