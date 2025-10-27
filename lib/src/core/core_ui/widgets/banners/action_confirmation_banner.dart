import 'package:flutter/material.dart';

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
        backgroundColor = const Color(0xFFC8E6C9),
        iconColor = const Color(0xFF2E7D32),
        textColor = const Color(0xFF1B5E20),
        borderColor = const Color(0xFF81C784);

  /// Constructor para advertencia (naranja)
  const ActionConfirmationBanner.warning({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.all(12),
  })  : icon = Icons.info_outline,
        backgroundColor = const Color(0xFFFFE0B2),
        iconColor = const Color(0xFFE65100),
        textColor = const Color(0xFF3E2723),
        borderColor = const Color(0xFFFFB74D);

  /// Constructor para información (azul)
  const ActionConfirmationBanner.info({
    super.key,
    required this.message,
    this.padding = const EdgeInsets.all(12),
  })  : icon = Icons.info_outline,
        backgroundColor = const Color(0xFFBBDEFB),
        iconColor = const Color(0xFF01579B),
        textColor = const Color(0xFF0D47A1),
        borderColor = const Color(0xFF64B5F6);

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
