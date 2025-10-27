import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar badges de estado.
///
/// Soporta todos los tipos de estados del sistema:
/// - Estados de incidentes (abierta, cerrada, en progreso)
/// - Estados de aprobación (pendiente, aprobada, rechazada)
/// - Estados personalizados
/// 
/// Características:
/// - Colores automáticos según el estado
/// - Iconos predefinidos por estado
/// - Soporte para estados críticos
/// - Personalizable completamente
/// - Soporta estilo outlined
/// - Soporte para estados compuestos (ej: "Abierta - Pendiente de Aprobación")
class StatusBadge extends StatelessWidget {
  /// El texto a mostrar en el badge
  final String label;
  
  /// Color de fondo del badge. Si es null, se calcula automáticamente
  final Color? backgroundColor;
  
  /// Color del texto. Si es null, se usa blanco o negro según el contraste
  final Color? textColor;
  
  /// Ícono a mostrar. Si es null y se usa un factory, se usa el ícono predefinido
  final IconData? icon;
  
  /// Padding del badge. Por defecto es horizontal: 16, vertical: 12
  final EdgeInsetsGeometry? padding;
  
  /// Si es true, se muestra con borde y fondo transparente
  final bool isOutlined;
  
  /// El radio del borde. Por defecto es 8
  final double borderRadius;

  /// Si es true, se muestra el texto en mayúsculas
  final bool upperCase;

  /// Si es true, el fondo será un color más suave y el texto más oscuro
  final bool useSoftColors;

  /// Constructor principal
  const StatusBadge({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.icon,
    this.padding,
    this.isOutlined = false,
    this.borderRadius = 8,
    this.upperCase = false,
    this.useSoftColors = false,
  });

  /// Constructor para estados de incidencia
  factory StatusBadge.incidentStatus({
    required String status,
    bool isCritical = false,
    bool upperCase = true,
    bool useSoftColors = false,
  }) {
    final statusLower = status.toLowerCase();
    late Color baseColor;
    late IconData icon;

    if (isCritical) {
      baseColor = Colors.red;
      icon = Icons.warning;
    } else {
      switch (statusLower) {
        case 'abierta':
          baseColor = Colors.blue;
          icon = Icons.radio_button_checked;
        case 'en progreso':
          baseColor = Colors.orange;
          icon = Icons.hourglass_empty;
        case 'cerrada':
          baseColor = Colors.green;
          icon = Icons.check_circle;
        default:
          baseColor = Colors.grey;
          icon = Icons.help_outline;
      }
    }

    Color bgColor = baseColor;
    Color txtColor = Colors.white;

    if (useSoftColors) {
      bgColor = Color.lerp(baseColor, Colors.white, 0.85)!;
      txtColor = Color.lerp(baseColor, Colors.black, 0.2)!;
    }

    final displayText = isCritical 
      ? '🔥 $status (CRÍTICA)' 
      : upperCase ? status.toUpperCase() : status;

    return StatusBadge(
      label: displayText,
      backgroundColor: bgColor,
      textColor: txtColor,
      icon: icon,
      upperCase: false, // Ya lo procesamos aquí
      useSoftColors: false, // Ya lo procesamos aquí
    );
  }

  /// Constructor para estados de aprobación
  factory StatusBadge.approvalStatus({
    required String status,
    bool upperCase = true,
    bool useSoftColors = false,
  }) {
    final statusLower = status.toLowerCase();
    late Color baseColor;
    late IconData icon;
    late String text;

    switch (statusLower) {
      case 'pendiente':
        baseColor = Colors.orange;
        icon = Icons.schedule;
        text = 'Pendiente de Aprobación';
      case 'aprobada':
        baseColor = Colors.green;
        icon = Icons.check_circle;
        text = 'Solicitud Aprobada';
      case 'rechazada':
        baseColor = Colors.red;
        icon = Icons.cancel;
        text = 'Solicitud Rechazada';
      case 'asignada':
        baseColor = Colors.blue;
        icon = Icons.assignment_ind;
        text = 'Asignada';
      default:
        baseColor = Colors.grey;
        icon = Icons.help_outline;
        text = status;
    }

    Color bgColor = baseColor;
    Color txtColor = Colors.white;

    if (useSoftColors) {
      bgColor = Color.lerp(baseColor, Colors.white, 0.85)!;
      txtColor = Color.lerp(baseColor, Colors.black, 0.2)!;
    }

    return StatusBadge(
      label: upperCase ? text.toUpperCase() : text,
      backgroundColor: bgColor,
      textColor: txtColor,
      icon: icon,
      upperCase: false, // Ya lo procesamos aquí
      useSoftColors: false, // Ya lo procesamos aquí
    );
  }

  /// Constructor para estados compuestos (incidente + aprobación)
  factory StatusBadge.composite({
    required String incidentStatus,
    required String approvalStatus,
    bool upperCase = true,
    bool useSoftColors = true,
  }) {
    // Usar el estado de aprobación como principal con colores suaves
    return StatusBadge.approvalStatus(
      status: approvalStatus,
      upperCase: upperCase,
      useSoftColors: useSoftColors,
    );
  }

  /// Constructor para tipos de incidencia
  factory StatusBadge.incidentType({
    required String type,
    bool upperCase = true,
    bool useSoftColors = true,
  }) {
    final typeLower = type.toLowerCase();
    late Color baseColor;
    late IconData icon;

    switch (typeLower) {
      case 'avance':
        baseColor = Colors.blue;
        icon = Icons.trending_up;
      case 'problema':
        baseColor = Colors.orange;
        icon = Icons.warning_amber;
      case 'solicitud':
        baseColor = Colors.purple;
        icon = Icons.request_page;
      case 'material':
        baseColor = Colors.green;
        icon = Icons.shopping_cart;
      default:
        baseColor = Colors.grey;
        icon = Icons.category;
    }

    Color bgColor = baseColor;
    Color txtColor = Colors.white;

    if (useSoftColors) {
      bgColor = Color.lerp(baseColor, Colors.white, 0.85)!;
      txtColor = Color.lerp(baseColor, Colors.black, 0.2)!;
    }

    return StatusBadge(
      label: upperCase ? type.toUpperCase() : type,
      backgroundColor: bgColor,
      textColor: txtColor,
      icon: icon,
      upperCase: false, // Ya lo procesamos aquí
      useSoftColors: false, // Ya lo procesamos aquí
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectivePadding = padding ?? 
      const EdgeInsets.symmetric(horizontal: 16, vertical: 12);
    
    final text = upperCase ? label.toUpperCase() : label;


    // Compute effective background and text colors considering useSoftColors
    Color effectiveBg = backgroundColor ?? theme.colorScheme.primary;
    Color effectiveTextColor = textColor ??
        ((effectiveBg.computeLuminance() > 0.5) ? Colors.black : Colors.white);

    if (useSoftColors && backgroundColor != null) {
      effectiveBg = Color.lerp(backgroundColor!, Colors.white, 0.85)!;
      effectiveTextColor = textColor ?? Color.lerp(backgroundColor!, Colors.black, 0.2)!;
    }

    final decoration = isOutlined
      ? BoxDecoration(
          border: Border.all(
            color: effectiveBg,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        )
      : BoxDecoration(
          color: effectiveBg,
          borderRadius: BorderRadius.circular(borderRadius),
        );

    return Container(
      padding: effectivePadding,
      decoration: decoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: textColor ?? effectiveTextColor,
              size: 20,
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Text(
              text,
              style: theme.textTheme.titleSmall?.copyWith(
                color: textColor ?? effectiveTextColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}