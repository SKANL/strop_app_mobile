// lib/src/core/core_ui/widgets/section_card.dart
import 'package:flutter/material.dart';

/// Widget reutilizable para secciones con título y contenido en Card
/// Usado en: Detalles, Perfiles, Configuración
class SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final IconData? icon;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final List<Widget>? actions;

  const SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.padding,
    this.margin,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header de la sección
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (actions != null) ...actions!,
              ],
            ),
            const SizedBox(height: 16),

            // Contenido
            child,
          ],
        ),
      ),
    );
  }
}

/// Variante con lista de items
class SectionCardList extends StatelessWidget {
  final String title;
  final List<Widget> items;
  final IconData? icon;
  final EdgeInsetsGeometry? margin;
  final Widget? emptyWidget;

  const SectionCardList({
    super.key,
    required this.title,
    required this.items,
    this.icon,
    this.margin,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty && emptyWidget != null) {
      return SectionCard(
        title: title,
        icon: icon,
        margin: margin,
        child: emptyWidget!,
      );
    }

    return Card(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Items
          ...items.map((item) => item),
        ],
      ),
    );
  }
}
