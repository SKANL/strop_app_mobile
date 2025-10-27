import 'package:flutter/material.dart';

/// Widget reutilizable para mostrar ejemplos o tips
/// 
/// Se usa en formularios para mostrar ejemplos de cómo completar campos
/// o tips de uso. Tiene estilo informativo (fondo azul).
/// 
/// Elimina duplicación en 4+ screens (create_correction_screen, etc.)
/// 
/// Ejemplo de uso:
/// ```dart
/// ExampleCard(
///   title: 'Ejemplos de uso:',
///   examples: [
///     'Corrección de ubicación',
///     'Actualización de cantidades',
///     'Información adicional',
///   ],
/// )
/// ```
class ExampleCard extends StatelessWidget {
  /// Título del card
  final String title;
  
  /// Lista de ejemplos a mostrar
  final List<String> examples;
  
  /// Ícono a mostrar (por defecto: lightbulb)
  final IconData icon;
  
  /// Color de fondo
  final Color? backgroundColor;
  
  /// Color del ícono
  final Color? iconColor;
  
  /// Color del texto
  final Color? textColor;
  
  /// Padding del card
  final EdgeInsetsGeometry padding;

  const ExampleCard({
    super.key,
    required this.title,
    required this.examples,
    this.icon = Icons.lightbulb_outline,
    this.backgroundColor,
    this.iconColor,
    this.textColor,
    this.padding = const EdgeInsets.all(12),
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? Colors.blue.shade50;
    final ic = iconColor ?? Colors.blue.shade700;
    final txt = textColor ?? Colors.blue.shade800;

    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: ic, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: Colors.blue.shade900,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...examples.map(
            (example) => Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Text(
                example,
                style: TextStyle(
                  color: txt,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
