// lib/src/core/core_ui/widgets/section_header.dart
import 'package:flutter/material.dart';

/// Widget reutilizable para headers de secciones
/// 
/// Consolidaaréaslayouts manuales en:
/// - home_screen.dart (3 secciones)
/// - settings_screen.dart (4 secciones)
/// - project_info_screen.dart (2 secciones)
/// - incident_detail_screen.dart (3 secciones)
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onActionTap;
  final Widget? actionWidget;
  final EdgeInsets padding;
  final bool showDivider;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onActionTap,
    this.actionWidget,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    this.showDivider = false,
  });

  /// Factory para sección con botón "Ver más"
  factory SectionHeader.withViewMore({
    required String title,
    String? subtitle,
    required VoidCallback onViewMore,
  }) => SectionHeader(
    title: title,
    subtitle: subtitle,
    actionLabel: 'Ver más',
    onActionTap: onViewMore,
  );

  /// Factory para sección con botón de acción personalizado
  factory SectionHeader.withAction({
    required String title,
    required String actionLabel,
    required VoidCallback onAction,
  }) => SectionHeader(
    title: title,
    actionLabel: actionLabel,
    onActionTap: onAction,
  );

  /// Factory para sección con widget personalizado
  factory SectionHeader.withWidget({
    required String title,
    required Widget actionWidget,
  }) => SectionHeader(
    title: title,
    actionWidget: actionWidget,
  );

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título y subtítulo
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              // Acción
              if (actionWidget != null) ...[
                const SizedBox(width: 12),
                actionWidget!,
              ] else if (onActionTap != null && actionLabel != null) ...[
                const SizedBox(width: 12),
                TextButton(
                  onPressed: onActionTap,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                  ),
                  child: Text(actionLabel!),
                ),
              ],
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: Colors.grey[300],
          ),
      ],
    );
  }
}

/// Variante compacta con menos padding
class CompactSectionHeader extends StatelessWidget {
  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  const CompactSectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return SectionHeader(
      title: title,
      actionLabel: actionLabel,
      onActionTap: onActionTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }
}
