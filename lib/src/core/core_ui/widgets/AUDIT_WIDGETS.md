# Auditoría rápida de widgets (core_ui/widgets)

Fecha: 2025-11-01

Resumen rápido
- Objetivo: detectar widgets que no se usan, duplicados y candidatos a mover a `legacy/`.
- Exclusión: los archivos bajo `lib/src/core/core_ui/widgets/legacy/` ya están en `legacy/` y no los reviso como candidatos (tal y como pediste).

Hallazgos confirmados (duplicados / definiciones múltiples)
- StatusBadge
  - Definiciones en:
    - `lib/src/core/core_ui/widgets/badges/status_badge.dart`
    - `lib/src/core/core_ui/widgets/status_badge.dart`
  - Acción sugerida: elegir una implementación canonical (recomiendo la que esté en `badges/`) y eliminar la otra.

- SectionHeader
  - Definiciones en:
    - `lib/src/core/core_ui/widgets/section_header.dart`
    - `lib/src/core/core_ui/widgets/headers/section_header.dart`
  - Acción sugerida: consolidar en `headers/` o en raíz según la convención del proyecto.

- StatsCard
  - Definiciones en:
    - `lib/src/core/core_ui/widgets/stats_card.dart`
    - `lib/src/core/core_ui/widgets/cards/app_card.dart` (define también `StatsCard`)
  - Nota: el barrel ya hace `export 'stats_card.dart' hide StatsCard;` — está mitigado temporalmente.

- PhotoGrid
  - Definiciones en:
    - `lib/src/core/core_ui/widgets/photos/photo_grid.dart`
    - `lib/src/core/core_ui/widgets/legacy/photo_grid.dart`
  - Acción: mantener la versión en `photos/` y conservar `legacy/` hasta QA; eliminar legacy si no hay regresiones.

- FormFieldWithLabel
  - Definiciones en:
    - `lib/src/core/core_ui/widgets/forms/form_field_with_label.dart`
    - `lib/src/core/core_ui/widgets/legacy/form_widgets.dart`

- FormActionButtons
  - Definiciones en:
    - `lib/src/core/core_ui/widgets/forms/form_action_buttons.dart`
    - `lib/src/core/core_ui/widgets/legacy/form_widgets.dart`

Widgets en `legacy/` (ya movidos — están inactivos / no referenciados o duplicados):
- `lib/src/core/core_ui/widgets/legacy/detail_card.dart`
- `lib/src/core/core_ui/widgets/legacy/form_widgets.dart` (contiene `FormFieldWithLabel`, `FormActionButtons`)
- `lib/src/core/core_ui/widgets/legacy/list_widgets.dart`
- `lib/src/core/core_ui/widgets/legacy/photo_grid.dart`

Observaciones sobre uso/`no usado` (evidencia parcial)
- `DetailCard` (en legacy): no encontré referencias externas — candidato seguro para eliminar después de QA.
- `legacy/form_widgets.dart` (FormFieldWithLabel / FormActionButtons): pantallas usan las versiones en `forms/` — las versiones en `legacy/` son duplicadas y ya movidas.
- `PhotoGrid` aparece en `photos/photo_grid.dart` (implementación actual). Hay un `TODO` que menciona `PhotoGrid` en `close_incident_screen.dart` — actualmente no hay instanciaciones que apunten a la versión `legacy/`.

Recomendación inmediata (procedimiento seguro)
1. Mantener los archivos en `legacy/` durante 1 sprint de QA. No eliminarlos aún.
2. Elegir una convención y consolidar duplicados (por ejemplo: mantener componentes por categoría dentro de subcarpetas `photos/`, `forms/`, `headers/`, `badges/`).
3. Después de consenso, eliminar versiones antiguas/duplicadas y actualizar `widgets.dart` (barrel).

Comando PowerShell para generar un reporte automático completo (ejecuta en la raíz del repo, PowerShell):

```powershell
# 1) Listar definiciones de widgets (en core_ui/widgets, excluyendo legacy si quieres):
Get-ChildItem -Path .\lib\src\core\core_ui\widgets -Recurse -Filter *.dart |
  Select-String -Pattern 'class\s+([A-Za-z0-9_]+)\s+extends\s+(StatelessWidget|StatefulWidget)' -AllMatches |
  ForEach-Object { $_.Matches } |
  ForEach-Object { "{0}|{1}" -f $_.Groups[1].Value, $_.Path } |
  Sort-Object -Unique | Out-File widget_definitions.txt -Encoding utf8

# 2) Contar usos en todo lib/** para cada widget (ignora legacy si filtras paths):
Get-Content widget_definitions.txt | ForEach-Object {
  $parts = $_ -split '\|';
  $name = $parts[0];
  # contar coincidencias en todo el lib (puedes excluir legacy con -NotMatch '\\\\legacy\\')
  $matches = Select-String -Path .\lib\**\*.dart -Pattern "\b$name\b" -CaseSensitive | Measure-Object;
  "{0}|{1}|{2}" -f $name, $matches.Count, $parts[1]
} | Out-File widget_usage_summary.txt -Encoding utf8

# 3) Revisa widget_usage_summary.txt: las entradas con count == 1 son probablemente no usadas (solo la definición).
```

Si quieres, hago esto por ti y genero `widget_usage_summary.txt` y un `AUDIT_WIDGETS_FULL.md` con resultados. Puedo también:
- mover automáticamente los candidatos seguros a `legacy/` (usar `git mv` para preservar historial),
- actualizar `widgets.dart` para eliminar exports redundantes,
- ejecutar `flutter analyze` y `flutter test` para validar.

Siguiente paso que propongo ahora
- Crear un `widget_usage_summary.txt` y `AUDIT_WIDGETS_FULL.md` automáticamente con la lista completa de widgets y conteos de uso, excluyendo `legacy/`, y abrir un PR en una rama nueva con los cambios mínimos (solo reporte). ¿Quieres que lo haga ahora? Indica "Sí — generar reporte" o "No — sólo listar duplicados".
