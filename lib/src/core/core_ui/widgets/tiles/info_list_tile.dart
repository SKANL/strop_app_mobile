// lib/src/core/core_ui/widgets/tiles/info_list_tile.dart
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// ListTile reutilizable para mostrar información en formato label-value.
///
/// Elimina ~10 líneas duplicadas en múltiples pantallas de información.
/// Proporciona un formato consistente para mostrar datos.
///
/// **Ejemplo básico**:
/// ```dart
/// InfoListTile(
///   label: 'Correo',
///   value: 'user@example.com',
/// )
/// ```
///
/// **Con icono**:
/// ```dart
/// InfoListTile(
///   icon: Icons.location_on,
///   label: 'Ubicación',
///   value: 'Calle Principal #123',
/// )
/// ```
///
/// **Con acción**:
/// ```dart
/// InfoListTile(
///   label: 'Teléfono',
///   value: '+52 123 456 7890',
///   trailing: IconButton(
///     icon: const Icon(Icons.copy),
///     onPressed: () => _copy(),
///   ),
/// )
/// ```
class InfoListTile extends StatelessWidget {
  /// Label o título del campo
  final String label;

  /// Valor a mostrar
  final String value;

  /// Icono opcional a la izquierda
  final IconData? icon;

  /// Color del icono
  final Color? iconColor;

  /// Widget a la derecha del tile
  final Widget? trailing;

  /// Si se puede hacer tap en el tile
  final VoidCallback? onTap;

  /// Si mostrar un divider debajo
  final bool showDivider;

  /// Padding del tile
  final EdgeInsets? contentPadding;

  /// Si el valor es multilínea
  final bool isMultiline;

  /// Número máximo de líneas para el valor
  final int? maxLines;

  const InfoListTile({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.trailing,
    this.onTap,
    this.showDivider = true,
    this.contentPadding,
    this.isMultiline = false,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        ListTile(
          leading: icon != null
              ? Icon(
                  icon,
                  color: iconColor ?? AppColors.iconColor,
                  size: 24,
                )
              : null,
          title: isMultiline
              ? Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.iconColor,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.iconColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    if (trailing == null && onTap == null)
                      Flexible(
                        child: Text(
                          value,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                  ],
                ),
          subtitle: isMultiline
              ? Text(
                  value,
                  style: theme.textTheme.bodyLarge,
                  maxLines: maxLines,
                  overflow: maxLines != null ? TextOverflow.ellipsis : null,
                )
              : null,
          trailing: trailing ??
              (onTap != null
                  ? const Icon(Icons.chevron_right, size: 20)
                  : null),
          onTap: onTap,
          contentPadding: contentPadding ??
              const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        if (showDivider)
          const Divider(
            height: 1,
            indent: 16,
            endIndent: 16,
          ),
      ],
    );
  }
}
