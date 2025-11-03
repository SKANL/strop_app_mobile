import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';

/// Un banner informativo reutilizable que muestra un mensaje con un ícono.
///
/// Usado para mostrar información contextual al usuario en la parte superior de las pantallas.
/// 
/// Example:
/// ```dart
/// InfoBanner(
///   message: 'Este es un mensaje informativo',
///   icon: Icons.info,
///   type: InfoBannerType.info,
/// )
/// ```
class InfoBanner extends StatelessWidget {
  /// Crea un nuevo [InfoBanner].
  const InfoBanner({
    super.key,
    // Backwards-compatible API: older tests/widgets may pass `title` instead of `message`.
    this.title,
    required this.message,
    this.titleStyle,
    this.onClose,
    this.icon,
    this.type = InfoBannerType.info,
  });

  /// El mensaje a mostrar en el banner.
  final String message;

  /// Título opcional (compatibilidad con API anterior de tests/widgets)
  final String? title;

  /// Estilo del título opcional
  final TextStyle? titleStyle;

  /// Callback para cerrar el banner (opcional)
  final VoidCallback? onClose;

  /// El ícono a mostrar junto al mensaje.
  /// Si no se proporciona, se usará un ícono por defecto según el [type].
  final IconData? icon;

  /// El tipo de banner que determina los colores y el ícono por defecto.
  final InfoBannerType type;

  @override
  Widget build(BuildContext context) {
    final colors = _getBannerColors(type);
    final defaultIcon = _getDefaultIcon(type);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.backgroundColor,
        border: Border(
          bottom: BorderSide(color: colors.borderColor),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon ?? defaultIcon,
            color: colors.iconColor,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (title != null) ...[
                  Text(
                    title!,
                    style: titleStyle ?? TextStyle(
                      color: colors.textColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  message,
                  style: TextStyle(
                    color: colors.textColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          if (onClose != null) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.close, color: colors.iconColor),
              onPressed: onClose,
            ),
          ],
        ],
      ),
    );
  }

  /// Obtiene los colores para el banner según su tipo.
  _BannerColors _getBannerColors(InfoBannerType type) {
    switch (type) {
      case InfoBannerType.info:
        return _BannerColors(
          backgroundColor: AppColors.infoLight,
          borderColor: AppColors.info,
          iconColor: AppColors.infoDark,
          textColor: AppColors.infoText,
        );
      case InfoBannerType.warning:
        return _BannerColors(
          backgroundColor: AppColors.warningLight,
          borderColor: AppColors.warningBorder,
          iconColor: AppColors.warningIcon,
          textColor: AppColors.warningText,
        );
      case InfoBannerType.error:
        return _BannerColors(
          backgroundColor: AppColors.dangerLight,
          borderColor: AppColors.dangerBorder,
          iconColor: AppColors.dangerIcon,
          textColor: AppColors.dangerText,
        );
      case InfoBannerType.success:
        return _BannerColors(
          backgroundColor: AppColors.successLight,
          borderColor: AppColors.successBorder,
          iconColor: AppColors.successIcon,
          textColor: AppColors.successText,
        );
    }
  }

  /// Obtiene el ícono por defecto según el tipo de banner.
  IconData _getDefaultIcon(InfoBannerType type) {
    switch (type) {
      case InfoBannerType.info:
        return Icons.info_outline;
      case InfoBannerType.warning:
        return Icons.warning_amber_outlined;
      case InfoBannerType.error:
        return Icons.error_outline;
      case InfoBannerType.success:
        return Icons.check_circle_outline;
    }
  }
}

/// Los tipos de banner disponibles.
enum InfoBannerType {
  /// Un banner informativo (azul).
  info,

  /// Un banner de advertencia (naranja).
  warning,

  /// Un banner de error (rojo).
  error,

  /// Un banner de éxito (verde).
  success,
}

/// Colores para un banner según su tipo.
class _BannerColors {
  const _BannerColors({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
  });

  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
}