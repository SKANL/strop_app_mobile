// lib/src/core/core_ui/widgets/layouts/responsive_container.dart
import 'package:flutter/material.dart';

/// Un contenedor que limita el ancho del contenido en pantallas grandes
/// para mantener la legibilidad y evitar líneas de texto demasiado largas.
///
/// Úsalo como wrapper principal en tus Scaffolds o ListViews.
class ResponsiveContainer extends StatelessWidget {
  final Widget child;
  final double maxWidth;
  final EdgeInsetsGeometry padding;

  const ResponsiveContainer({
    super.key,
    required this.child,
    this.maxWidth = 800, // Ancho máximo razonable para contenido tipo app
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}
