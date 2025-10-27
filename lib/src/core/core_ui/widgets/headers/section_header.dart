// lib/src/core/core_ui/widgets/headers/section_header.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Widget reutilizable para headers de secciones.
///
/// Elimina ~15 líneas duplicadas en 20+ secciones del proyecto.
/// Proporciona un estilo consistente para títulos de secciones.
///
/// **Ejemplo básico**:
/// ```dart
/// SectionHeader(
///   title: 'Información General',
/// )
/// ```
///
/// **Con subtítulo**:
/// ```dart
/// SectionHeader(
///   title: 'Fotos',
///   subtitle: 'Máximo 5 imágenes',
/// )
/// ```
///
/// **Con acción**:
/// ```dart
/// SectionHeader(
///   title: 'Comentarios',
///   trailing: TextButton(
///     onPressed: () => _addComment(),
///     child: const Text('Agregar'),
///   ),
/// )
/// ```
///
/// **Con badge**:
/// ```dart
/// SectionHeader(
///   title: 'Notificaciones',
///   badge: _unreadCount > 0 ? Badge(label: Text('$_unreadCount')) : null,
/// )
/// ```
class SectionHeader extends StatelessWidget {
  /// Título principal de la sección
  final String title;

  /// Subtítulo opcional (texto secundario)
  final String? subtitle;

  /// Widget que aparece a la derecha del título
  final Widget? trailing;

  /// Badge que aparece junto al título
  final Widget? badge;

  /// Si la sección es obligatoria (muestra asterisco)
  final bool isRequired;

  /// Padding del header
  final EdgeInsets? padding;

  /// Color del título
  final Color? titleColor;

  /// Tamaño del título
  final double? titleSize;

  /// Peso de la fuente del título
  final FontWeight? titleWeight;

  /// Si mostrar un divider debajo del header
  final bool showDivider;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.badge,
    this.isRequired = false,
    this.padding,
    this.titleColor,
    this.titleSize,
    this.titleWeight,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: padding ?? const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: titleWeight ?? FontWeight.w600,
                            fontSize: titleSize ?? 16,
                            color: titleColor ?? theme.textTheme.titleMedium?.color,
                          ),
                        ),
                        if (isRequired) ...[
                          const SizedBox(width: 4),
                          Text(
                            '*',
                            style: TextStyle(
                              color: theme.colorScheme.error,
                              fontSize: (titleSize ?? 16) + 2,
                            ),
                          ),
                        ],
                        if (badge != null) ...[
                          const SizedBox(width: 8),
                          badge!,
                        ],
                      ],
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.iconColor,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) trailing!,
            ],
          ),
        ),
        if (showDivider)
          Divider(
            height: 1,
            color: AppColors.borderColor,
          ),
      ],
    );
  }
}
