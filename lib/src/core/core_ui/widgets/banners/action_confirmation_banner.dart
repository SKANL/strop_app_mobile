import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

/// Widget reutilizable para banners de confirmación e información
/// 
/// Se usa para mostrar información importante antes de ejecutar acciones
/// (cierre, confirmación, advertencia). Reemplaza 5+ banners duplicados.
/// 
/// Variantes:
/// - `.confirmation`: Para acciones de confirmación (verde)
/// - `.warning`: Para advertencias (naranja)
/// - `.info`: Para información general (azul)
/// 
/// Ejemplo de uso:
/// ```dart
/// ActionConfirmationBanner.confirmation(
///   message: 'Al cerrar esta incidencia, se marcará como completada',
/// )
/// 
/// ActionConfirmationBanner.warning(
///   message: 'Las aclaraciones no modifican el reporte original',
/// )
/// ```
class ActionConfirmationBanner extends StatelessWidget {
  /// Ícono a mostrar
  final IconData icon;
  
  /// Mensaje principal
  final String message;
  
  /// Color de fondo
  final Color backgroundColor;
  
  /// Color del ícono
  final Color iconColor;
  
  /// Color del texto
  final Color textColor;
  
  /// Color del borde
  final Color borderColor;
  
  /// Padding
  final EdgeInsetsGeometry padding;

  const ActionConfirmationBanner({
    super.key,
    required this.icon,
    required this.message,
    required this.backgroundColor,
    required this.iconColor,
    required this.textColor,
    required this.borderColor,
    this.padding = const EdgeInsets.all(12),
  });

  /// Constructor para confirmación (verde)
  const ActionConfirmationBanner.confirmation({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.all(12),
  })  : icon = Icons.check_circle,
        backgroundColor = AppColors.successLight,
        iconColor = AppColors.successIcon,
        textColor = AppColors.successText,
        borderColor = AppColors.successBorder;

  /// Constructor para advertencia (naranja)
  const ActionConfirmationBanner.warning({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.all(12),
  })  : icon = Icons.info_outline,
        backgroundColor = AppColors.warningLight,
        iconColor = AppColors.warningIcon,
        textColor = AppColors.warningText,
        borderColor = AppColors.warningBorder;

  /// Constructor para información (azul)
  const ActionConfirmationBanner.info({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.all(12),
  })  : icon = Icons.info_outline,
        backgroundColor = AppColors.infoLight,
        iconColor = AppColors.infoDark,
        textColor = AppColors.infoText,
        borderColor = AppColors.info;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                color: textColor,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
