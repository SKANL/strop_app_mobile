# ⚠️ ARCHIVOS A ELIMINAR - Checklist de Refactorización

**Proyecto:** Mobile Strop App  
**Fecha:** 1 de Noviembre, 2025

---

## 🎯 PROPÓSITO

Este documento lista todos los archivos que deben ser eliminados o refactorizados durante el proceso de optimización. Usar como checklist durante la implementación.

---

## 🔴 ARCHIVOS PARA ELIMINAR (Duplicados Completos)

### 1. stats_card.dart
**Ubicación:** `lib/src/core/core_ui/widgets/stats_card.dart`

**Razón:** Duplicado completo de StatsCard en `cards/app_card.dart`

**Acción:**
```bash
# ❌ ELIMINAR
rm lib/src/core/core_ui/widgets/stats_card.dart
```

**Actualizar imports:**
```dart
// Buscar:
import '../widgets/stats_card.dart';
import '../../core_ui/widgets/stats_card.dart';

// Reemplazar por:
import '../widgets/cards/app_card.dart';
import '../../core_ui/widgets/cards/app_card.dart';
```

**Impacto:** -150 líneas

**Prioridad:** 🔴 ALTA - Quick Win

**Status:** [ ] Pendiente

---

### 2. status_badge.dart (versión vieja)
**Ubicación:** `lib/src/core/core_ui/widgets/status_badge.dart`

**Razón:** Versión antigua, reemplazada por `badges/status_badge.dart`

**Acción:**
```bash
# ❌ ELIMINAR
rm lib/src/core/core_ui/widgets/status_badge.dart
```

**Actualizar imports:**
```dart
// Buscar:
import '../widgets/status_badge.dart';

// Reemplazar por:
import '../widgets/badges/status_badge.dart';
```

**Verificar widgets.dart:**
```dart
// Debe tener:
export 'badges/status_badge.dart';

// NO debe tener:
// export 'status_badge.dart';
```

**Impacto:** -169 líneas

**Prioridad:** 🔴 ALTA

**Status:** [ ] Pendiente

---

### 3. section_header.dart (versión vieja)
**Ubicación:** `lib/src/core/core_ui/widgets/section_header.dart`

**Razón:** Duplicado de `headers/section_header.dart`

**Acción:**
```bash
# ❌ ELIMINAR
rm lib/src/core/core_ui/widgets/section_header.dart
```

**Actualizar imports:**
```dart
// Buscar:
import '../widgets/section_header.dart';

// Reemplazar por:
import '../widgets/headers/section_header.dart';
```

**Impacto:** -152 líneas

**Prioridad:** 🔴 ALTA

**Status:** [ ] Pendiente

---

### 4. create_correction_screen.dart (versión 1 - SI NO ES LA ACTUAL)
**Ubicación:** `lib/src/features/incidents/presentation/screens/create_correction_screen.dart`

**Razón:** Código muerto, versión vieja del screen

**Acción:**
```bash
# ⚠️ PRIMERO IDENTIFICAR CUÁL ES LA VERSIÓN EN USO
# Ver app_router.dart o archivos de navegación

# ❌ ELIMINAR (si no es la versión actual)
rm lib/src/features/incidents/presentation/screens/create_correction_screen.dart
```

**Impacto:** ~200 líneas

**Prioridad:** 🔴 CRÍTICA

**Status:** [ ] Identificar versión actual [ ] Eliminar

---

### 5. create_correction_screen_clean.dart (versión 2 - SI NO ES LA ACTUAL)
**Ubicación:** `lib/src/features/incidents/presentation/screens/create_correction_screen_clean.dart`

**Razón:** Código muerto, versión vieja del screen

**Acción:**
```bash
# ❌ ELIMINAR (si no es la versión actual)
rm lib/src/features/incidents/presentation/screens/create_correction_screen_clean.dart
```

**Impacto:** ~200 líneas

**Prioridad:** 🔴 CRÍTICA

**Status:** [ ] Identificar versión actual [ ] Eliminar

---

### 6. create_correction_screen_refactored.dart (versión 3 - SI NO ES LA ACTUAL)
**Ubicación:** `lib/src/features/incidents/presentation/screens/create_correction_screen_refactored.dart`

**Razón:** Código muerto, versión vieja del screen

**Acción:**
```bash
# ❌ ELIMINAR (si no es la versión actual)
rm lib/src/features/incidents/presentation/screens/create_correction_screen_refactored.dart
```

**Acción adicional:** Si esta es la versión actual, renombrar sin sufijo
```bash
# Si es la versión actual:
mv create_correction_screen_refactored.dart create_correction_screen.dart
```

**Impacto:** ~200 líneas (o renombrado)

**Prioridad:** 🔴 CRÍTICA

**Status:** [ ] Identificar versión actual [ ] Eliminar/Renombrar

---

## 🟡 ARCHIVOS PARA REFACTORIZAR (No eliminar, sino simplificar)

### 7. incident_status_badge.dart
**Ubicación:** `lib/src/features/incidents/presentation/widgets/incident_status_badge.dart`

**Razón:** Reimplementa lógica de StatusBadge

**Opciones:**

**Opción A (RECOMENDADO): Eliminar completamente**
```bash
# Reemplazar todos los usos con StatusBadge
# Luego eliminar:
rm lib/src/features/incidents/presentation/widgets/incident_status_badge.dart
```

**Opción B: Convertir en wrapper mínimo**
```dart
// Reducir a ~20 líneas de wrapper simple sobre StatusBadge
class IncidentStatusBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatusBadge.incidentStatus(/* ... */);
  }
}
```

**Impacto:** -134 líneas (Opción A) o -100 líneas (Opción B)

**Prioridad:** 🟡 MEDIA

**Status:** [ ] Decidir opción [ ] Implementar

---

### 8. project_info_banner.dart
**Ubicación:** `lib/src/features/incidents/presentation/widgets/project_info_banner.dart`

**Razón:** Puede ser reemplazado por InfoBanner

**Acción:**
```bash
# 1. Buscar todos los usos
grep -r "ProjectInfoBanner" lib/

# 2. Reemplazar con InfoBanner
# Antes:
# ProjectInfoBanner(message: 'x', icon: Icons.info, color: Colors.blue)
# Después:
# InfoBanner(message: 'x', icon: Icons.info, type: InfoBannerType.info)

# 3. Eliminar archivo
rm lib/src/features/incidents/presentation/widgets/project_info_banner.dart
```

**Impacto:** -43 líneas

**Prioridad:** 🟡 MEDIA

**Status:** [ ] Reemplazar usos [ ] Eliminar

---

### 9. project_activity_card.dart
**Ubicación:** `lib/src/features/incidents/presentation/widgets/project_activity_card.dart`

**Razón:** Puede simplificarse usando StatsCard

**Acción:** NO eliminar, sino refactorizar para usar StatsCard como base

```dart
// Reducir de 114 líneas a ~40 líneas
class ProjectActivityCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StatsCard(/* composición */);
  }
}
```

**Impacto:** -70 líneas

**Prioridad:** 🟢 BAJA

**Status:** [ ] Pendiente

---

## ⚠️ ARCHIVOS A EVALUAR (Decisión pendiente)

### 10. critical_banner.dart
**Ubicación:** `lib/src/core/core_ui/widgets/critical_banner.dart`

**Decisión pendiente:** ¿Eliminar o mantener?

**Opción A:** Convertir en factory de InfoBanner
```dart
// Agregar a InfoBanner:
extension InfoBannerFactories on InfoBanner {
  static InfoBanner critical({required String message}) {
    return InfoBanner(message: message, type: InfoBannerType.error);
  }
}

// Eliminar critical_banner.dart
```

**Opción B:** Mantener si tiene características únicas que no puede manejar InfoBanner

**Acción:**
```bash
# 1. Revisar usos actuales
grep -r "CriticalBanner" lib/

# 2. Decidir basado en:
#    - ¿Tiene lógica única que no puede estar en InfoBanner?
#    - ¿Vale la pena mantener un archivo separado?
```

**Impacto:** ~90 líneas (si se elimina)

**Prioridad:** 🟡 MEDIA

**Status:** [ ] Evaluar [ ] Decidir [ ] Implementar

---

### 11. banner_info.dart
**Ubicación:** `lib/src/core/core_ui/widgets/banners/banner_info.dart`

**Decisión pendiente:** ¿Qué hace este widget?

**Acción:**
```bash
# 1. Revisar el código
cat lib/src/core/core_ui/widgets/banners/banner_info.dart

# 2. Comparar con InfoBanner
# 3. Decidir si es duplicado o tiene propósito único
```

**Status:** [ ] Revisar [ ] Decidir

---

## 🔧 ARCHIVOS RELACIONADOS A ACTUALIZAR

### widgets.dart (barrel file)
**Ubicación:** `lib/src/core/core_ui/widgets/widgets.dart`

**Acción:** Actualizar exports después de cada eliminación

**Verificar que NO exporte:**
- [ ] `status_badge.dart` (solo debe exportar `badges/status_badge.dart`)
- [ ] `section_header.dart` (solo debe exportar `headers/section_header.dart`)
- [ ] `stats_card.dart` (ya está en `cards/app_card.dart`)

**Comando:**
```bash
# Verificar exports actuales
grep "export.*status_badge" lib/src/core/core_ui/widgets/widgets.dart
grep "export.*section_header" lib/src/core/core_ui/widgets/widgets.dart
grep "export.*stats_card" lib/src/core/core_ui/widgets/widgets.dart
```

---

## 📊 RESUMEN DE IMPACTO

| Archivo | Tipo | Líneas | Prioridad | Status |
|---------|------|--------|-----------|--------|
| stats_card.dart | Eliminar | -150 | 🔴 ALTA | [ ] |
| status_badge.dart | Eliminar | -169 | 🔴 ALTA | [ ] |
| section_header.dart | Eliminar | -152 | 🔴 ALTA | [ ] |
| create_correction_screen.dart (v1) | Eliminar | -200 | 🔴 CRÍTICA | [ ] |
| create_correction_screen_clean.dart (v2) | Eliminar | -200 | 🔴 CRÍTICA | [ ] |
| create_correction_screen_refactored.dart (v3) | Eliminar | -200 | 🔴 CRÍTICA | [ ] |
| incident_status_badge.dart | Refactorizar | -100 | 🟡 MEDIA | [ ] |
| project_info_banner.dart | Eliminar | -43 | 🟡 MEDIA | [ ] |
| project_activity_card.dart | Refactorizar | -70 | 🟢 BAJA | [ ] |
| critical_banner.dart | Evaluar | -90 | 🟡 MEDIA | [ ] |
| **TOTAL** | | **~1,374** | | |

---

## ✅ CHECKLIST DE VALIDACIÓN

Después de eliminar cada archivo, verificar:

### Tests
```bash
# Ejecutar todos los tests
flutter test

# Verificar que no hay imports rotos
flutter analyze
```

### Build
```bash
# Build limpio
flutter clean
flutter pub get
flutter build apk --debug
```

### Imports
```bash
# Buscar referencias al archivo eliminado
grep -r "import.*nombre_archivo.dart" lib/
```

### Funcionalidad
- [ ] App compila sin errores
- [ ] App corre sin crashes
- [ ] Navegación a pantallas afectadas funciona
- [ ] UI se ve correcta
- [ ] Tests pasan

---

## 🚨 ORDEN DE ELIMINACIÓN RECOMENDADO

### Semana 1

**Día 1: Quick Wins**
1. [ ] stats_card.dart
2. [ ] 2 versiones viejas de CreateCorrectionScreen

**Día 2-3: Badges**
3. [ ] status_badge.dart (versión vieja)
4. [ ] Evaluar incident_status_badge.dart

**Día 4: Headers**
5. [ ] section_header.dart (versión vieja)

**Día 5: Testing y validación**
- [ ] Validar todo lo de la semana
- [ ] Hacer merge

### Semana 2

**Día 1-2: Features**
6. [ ] project_info_banner.dart
7. [ ] Evaluar critical_banner.dart

**Día 3-4: Refactoring**
8. [ ] project_activity_card.dart

**Día 5: Validación**
- [ ] Testing final
- [ ] Documentación

---

## 📝 COMANDOS ÚTILES

### Buscar referencias a un archivo
```bash
# Buscar imports del archivo
grep -r "import.*archivo.dart" lib/

# Buscar uso de la clase
grep -r "NombreClase" lib/
```

### Ver diferencia después de refactorizar
```bash
# Ver líneas de código antes y después
git diff --stat

# Ver cambios detallados
git diff
```

### Validar que no hay problemas
```bash
# Análisis estático
flutter analyze

# Tests
flutter test

# Ver warnings
flutter analyze 2>&1 | grep -i warning
```

---

## 🔄 MANTENER ESTE DOCUMENTO ACTUALIZADO

Al completar cada eliminación:
1. ✅ Marcar el checkbox de Status
2. ✅ Anotar el commit hash
3. ✅ Documentar cualquier problema encontrado
4. ✅ Actualizar métricas reales

Al final de cada semana:
1. ✅ Revisar progreso
2. ✅ Actualizar CHANGELOG.md
3. ✅ Comunicar al equipo

---

**Fecha de creación:** 1 de Noviembre, 2025  
**Última actualización:** 1 de Noviembre, 2025  
**Próxima revisión:** Viernes de cada semana durante implementación
