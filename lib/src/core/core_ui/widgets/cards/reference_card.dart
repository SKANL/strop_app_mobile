import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar referencia de un elemento
/// 
/// Se usa en formularios modales para mostrar a qué elemento se refiere la acción
/// (ej: "Aclaración para:", "Cerrando:", "Material para:")
/// 
/// Elimina duplicación en 5+ screens (create_correction_screen, close_incident_screen, etc.)
/// 
/// Ejemplo de uso:
/// ```dart
/// ReferenceCard(
///   label: 'Aclaración para:',
///   title: 'Incidencia #INC-12345',
///   icon: Icons.description,
///   backgroundColor: Colors.grey.shade100,
/// )
/// ```
class ReferenceCard extends StatelessWidget {
  /// Etiqueta superior (ej: "Aclaración para:")
  final String label;
  
  /// Título principal (ej: "Incidencia #INC-12345")
  final String title;
  
  /// Ícono a mostrar
  final IconData icon;
  
  /// Subtítulo opcional
  final String? subtitle;
  
  /// Color de fondo
  final Color? backgroundColor;
  
  /// Color del ícono
  final Color? iconColor;
  
  /// Padding
  final EdgeInsetsGeometry padding;
  
  /// Acción al tocar (opcional)
  final VoidCallback? onTap;

  const ReferenceCard({
    super.key,
    required this.label,
    required this.title,
    required this.icon,
    this.subtitle,
    this.backgroundColor,
    this.iconColor,
    this.padding = const EdgeInsets.all(12),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? Colors.grey.shade100;
    final ic = iconColor ?? Colors.grey.shade600;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.labelLarge,
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(icon, color: ic),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
