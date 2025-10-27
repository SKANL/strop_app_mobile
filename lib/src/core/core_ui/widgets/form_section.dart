// lib/src/core/core_ui/widgets/form_section.dart

import 'package:flutter/material.dart';

/// Widget reutilizable para secciones de formulario con título.
/// 
/// Agrupa campos de formulario bajo un título y opcionalmente un subtítulo.
/// 
/// Ejemplo de uso:
/// ```dart
/// FormSection(
///   title: 'Información General',
///   subtitle: 'Completa los datos básicos',
///   isRequired: true,
///   children: [
///     AppTextField(label: 'Nombre'),
///     AppTextField(label: 'Email'),
///   ],
/// )
/// ```
class FormSection extends StatelessWidget {
  /// Título de la sección
  final String title;
  
  /// Subtítulo opcional
  final String? subtitle;
  
  /// Si la sección es obligatoria (muestra asterisco rojo)
  final bool isRequired;
  
  /// Widgets hijos (campos del formulario)
  final List<Widget> children;
  
  /// Espaciado entre campos
  final double spacing;
  
  /// Padding de la sección
  final EdgeInsetsGeometry? padding;

  const FormSection({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.isRequired = false,
    this.spacing = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: padding ?? const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Título de la sección
          Row(
            children: [
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              if (isRequired) ...[
                const SizedBox(width: 4),
                const Text(
                  '*',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ],
          ),

          // Subtítulo opcional
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(
              subtitle!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],

          const SizedBox(height: 12),

          // Campos del formulario
          ...children.expand((child) => [
                child,
                SizedBox(height: spacing),
              ]).toList()
            ..removeLast(), // Quitar el último spacing
        ],
      ),
    );
  }
}

/// Widget para separador visual entre secciones
class FormSectionDivider extends StatelessWidget {
  final double height;
  final Color? color;

  const FormSectionDivider({
    super.key,
    this.height = 24,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: height / 2),
        Divider(color: color ?? Colors.grey[300], thickness: 1),
        SizedBox(height: height / 2),
      ],
    );
  }
}
