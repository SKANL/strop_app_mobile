// lib/src/core/core_ui/widgets/cards/app_card.dart

import 'package:flutter/material.dart';
import '../widgets.dart';

/// Widget reutilizable para Cards con comportamiento y estilo consistente.
///
/// Elimina la duplicación de ~18 cards en la app con márgenes/padding inconsistentes.
/// Proporciona variantes para casos comunes (clickable, compact, info).
///
/// **Usado en**: Listas de incidencias, reportes, configuraciones, detalles
///
/// **Ejemplo básico**:
/// ```dart
/// AppCard(
///   child: Text('Contenido del card'),
/// )
/// ```
///
/// **Card clickable**:
/// ```dart
/// AppCard.clickable(
///   onTap: () => showDetails(),
///   child: IncidentInfo(),
/// )
/// ```
///
/// **Card compacto**:
/// ```dart
/// AppCard.compact(
///   child: SmallInfo(),
/// )
/// ```
class AppCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final double? elevation;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(16),
    this.color,
    this.elevation,
    this.borderRadius,
  });

  /// Card con tap interaction y efecto ripple
  const AppCard.clickable({
    super.key,
    required this.child,
    required this.onTap,
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.padding = const EdgeInsets.all(16),
    this.color,
  })  : elevation = null,
        borderRadius = null;

  /// Card con espaciado reducido
  const AppCard.compact({
    super.key,
    required this.child,
    this.onTap,
    this.color,
  })  : margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding = const EdgeInsets.all(12),
        elevation = null,
        borderRadius = null;

  /// Card sin margen (para uso en listas con separadores)
  const AppCard.noMargin({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.color,
  })  : margin = EdgeInsets.zero,
        elevation = null,
        borderRadius = null;

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = borderRadius ?? BorderRadius.circular(12);

    final card = Card(
      margin: margin,
      color: color,
      elevation: elevation,
      shape: RoundedRectangleBorder(borderRadius: cardBorderRadius),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: child,
      ),
    );

    // Si tiene onTap, envolver en InkWell
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: cardBorderRadius,
        child: card,
      );
    }

    return card;
  }
}

/// Card especializado para mostrar información con icono y texto
///
/// **Ejemplo**:
/// ```dart
/// InfoCard(
///   icon: Icons.sync,
///   title: 'Sincronización',
///   subtitle: 'Sincronizado hace 5 minutos',
///   onTap: () => showSyncDetails(),
/// )
/// ```
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color? iconColor;
  final Widget? trailing;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
    this.iconColor,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.clickable(
      onTap: onTap ?? () {},
      child: Row(
        children: [
          Icon(
            icon,
            color: iconColor ?? Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                ),
              ],
            ),
          ),
          if (trailing != null)
            trailing!
          else if (onTap != null)
            Icon(
              Icons.chevron_right,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
        ],
      ),
    );
  }
}

/// Card especializado para mostrar estadísticas
///
/// **Ejemplo**:
/// ```dart
/// StatsCard(
///   icon: Icons.assessment,
///   label: 'Reportes',
///   value: '24',
///   color: Colors.blue,
/// )
/// ```
class StatsCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;
  final VoidCallback? onTap;

  const StatsCard({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard.compact(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.withOpacity(color, 0.1),
            radius: 28,
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Card especializado para elementos de lista con header y contenido
///
/// **Ejemplo**:
/// ```dart
/// ListItemCard(
///   leading: Icon(Icons.work),
///   title: 'Tarea pendiente',
///   subtitle: 'Descripción de la tarea',
///   trailing: StatusBadge(status: 'Pendiente'),
///   onTap: () => showDetails(),
/// )
/// ```
class ListItemCard extends StatelessWidget {
  final Widget? leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? margin;

  const ListItemCard({
    super.key,
    this.leading,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      margin: margin ?? const EdgeInsets.only(bottom: 8),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (leading != null) ...[
            leading!,
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: 12),
            trailing!,
          ],
        ],
      ),
    );
  }
}

// =============================================================================
// COMPARACIÓN: ANTES vs DESPUÉS
// =============================================================================

/// ANTES (código duplicado en my_reports_screen.dart - 45 líneas):
/// ```dart
/// Widget _buildReportCard(BuildContext context, IncidentEntity report) {
///   return Card(
///     margin: const EdgeInsets.only(bottom: 8),
///     child: InkWell(
///       onTap: () => context.push('/incidents/${report.id}'),
///       child: Padding(
///         padding: const EdgeInsets.all(16.0),
///         child: Column(
///           crossAxisAlignment: CrossAxisAlignment.start,
///           children: [
///             Row(
///               children: [
///                 Icon(_getTypeIcon(report.type), color: _getTypeColor(report.type)),
///                 SizedBox(width: 8),
///                 Expanded(child: Text(report.title, ...)),
///                 StatusBadge.incidentStatus(report.status, ...),
///               ],
///             ),
///             SizedBox(height: 8),
///             Text(report.description, ...),
///             // ... más código
///           ],
///         ),
///       ),
///     ),
///   );
/// }
/// ```
///
/// DESPUÉS (usando AppCard - 3 líneas):
/// ```dart
/// ListItemCard(
///   leading: IncidentTypeIcon(type: report.type),
///   title: report.title,
///   subtitle: report.description,
///   trailing: StatusBadge.incidentStatus(report.status),
///   onTap: () => context.push('/incidents/${report.id}'),
/// )
/// ```
///
/// AHORRO: 45 líneas → 7 líneas (-85%)
/// BENEFICIOS:
/// - Estilo consistente automático
/// - Ripple effect incluido
/// - Responsive a tema
/// - Accesible por defecto
