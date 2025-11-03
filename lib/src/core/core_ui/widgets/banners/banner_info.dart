// lib/src/core/core_ui/widgets/banners/banner_info.dart

import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Widget reutilizable para banners informativos con diferentes tipos/severidades.
///
/// Elimina la duplicación de ~8 banners en la app con estilos inconsistentes.
/// Proporciona tipos predefinidos (info, warning, success, error) con colores correctos.
///
/// **Usado en**: Formularios, pantallas de confirmación, mensajes de estado
///
/// **Ejemplo básico**:
/// ```dart
/// BannerInfo.warning(
///   message: 'Esta acción requiere aprobación',
/// )
/// ```
///
/// **Con acciones**:
/// ```dart
/// BannerInfo.info(
///   message: 'Nueva versión disponible',
///   actions: [
///     TextButton(
///       onPressed: () => update(),
///       child: Text('Actualizar'),
///     ),
///   ],
/// )
/// ```
///
/// **Con ícono personalizado**:
/// ```dart
/// BannerInfo(
///   message: 'Mensaje personalizado',
///   type: BannerType.info,
///   customIcon: Icons.star,
/// )
/// ```
class BannerInfo extends StatelessWidget {
  final String message;
  final BannerType type;
  final IconData? customIcon;
  final List<Widget>? actions;
  final bool isDismissible;
  final VoidCallback? onDismiss;

  const BannerInfo({
    super.key,
    required this.message,
    this.type = BannerType.info,
    this.customIcon,
    this.actions,
    this.isDismissible = false,
    this.onDismiss,
  });

  /// Constructor para banner informativo (azul)
  const BannerInfo.info({
    super.key,
    required this.message,
    this.customIcon,
    this.actions,
    this.isDismissible = false,
    this.onDismiss,
  }) : type = BannerType.info;

  /// Constructor para banner de advertencia (naranja)
  const BannerInfo.warning({
    super.key,
    required this.message,
    this.customIcon,
    this.actions,
    this.isDismissible = false,
    this.onDismiss,
  }) : type = BannerType.warning;

  /// Constructor para banner de éxito (verde)
  const BannerInfo.success({
    super.key,
    required this.message,
    this.customIcon,
    this.actions,
    this.isDismissible = false,
    this.onDismiss,
  }) : type = BannerType.success;

  /// Constructor para banner de error (rojo)
  const BannerInfo.error({
    super.key,
    required this.message,
    this.customIcon,
    this.actions,
    this.isDismissible = false,
    this.onDismiss,
  }) : type = BannerType.error;

  @override
  Widget build(BuildContext context) {
    final config = type.config;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: config.backgroundColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: config.borderColor, width: 1.5),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícono
          Icon(
            customIcon ?? config.icon,
            color: config.iconColor,
            size: 24,
          ),
          const SizedBox(width: 12),

          // Contenido
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Mensaje
                Text(
                  message,
                  style: TextStyle(
                    color: config.textColor,
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),

                // Acciones (si existen)
                if (actions != null && actions!.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: actions!,
                  ),
                ],
              ],
            ),
          ),

          // Botón de cerrar (si es dismissible)
          if (isDismissible) ...[
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.close, size: 20),
              color: config.iconColor,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: onDismiss,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ],
      ),
    );
  }
}

/// Tipos de banner con configuraciones predefinidas
enum BannerType {
  /// Banner informativo (azul)
  info(BannerConfig(
    backgroundColor: AppColors.infoLight,
    borderColor: AppColors.info,
    iconColor: AppColors.infoDark,
    textColor: AppColors.infoText,
    icon: Icons.info_outline,
  )),

  /// Banner de advertencia (naranja)
  warning(BannerConfig(
    backgroundColor: AppColors.warningLight,
    borderColor: AppColors.warningBorder,
    iconColor: AppColors.warningIcon,
    textColor: AppColors.warningText,
    icon: Icons.warning_amber,
  )),

  /// Banner de éxito (verde)
  success(BannerConfig(
    backgroundColor: AppColors.successLight,
    borderColor: AppColors.successBorder,
    iconColor: AppColors.successIcon,
    textColor: AppColors.successText,
    icon: Icons.check_circle_outline,
  )),

  /// Banner de error (rojo)
  error(BannerConfig(
    backgroundColor: AppColors.dangerLight,
    borderColor: AppColors.dangerBorder,
    iconColor: AppColors.dangerIcon,
    textColor: AppColors.dangerText,
    icon: Icons.error_outline,
  ));

  const BannerType(this.config);

  /// Configuración del banner
  final BannerConfig config;
}

/// Configuración visual de un banner
class BannerConfig {
  final Color backgroundColor;
  final Color borderColor;
  final Color iconColor;
  final Color textColor;
  final IconData icon;

  const BannerConfig({
    required this.backgroundColor,
    required this.borderColor,
    required this.iconColor,
    required this.textColor,
    required this.icon,
  });
}
