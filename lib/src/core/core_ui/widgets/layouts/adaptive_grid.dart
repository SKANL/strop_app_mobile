// lib/src/core/core_ui/widgets/adaptive_grid.dart

import 'package:flutter/material.dart';
import 'responsive_layout.dart';

/// Widget reutilizable para grids adaptativos según tipo de dispositivo.
/// 
/// Ajusta automáticamente el número de columnas según el ancho de pantalla:
/// - Phones: 2 columnas por defecto
/// - Tablets: 3-4 columnas por defecto
/// - Landscape: +1 columna
/// 
/// Ejemplo de uso:
/// ```dart
/// AdaptiveGrid(
///   items: myItems,
///   itemBuilder: (context, item) => MyCard(item),
/// )
/// ```
class AdaptiveGrid<T> extends StatelessWidget {
  /// Lista de items a mostrar
  final List<T> items;
  
  /// Constructor del widget para cada item
  final Widget Function(BuildContext, T) itemBuilder;
  
  /// Columnas para phone portrait (por defecto: 2)
  final int phoneColumns;
  
  /// Columnas para phone landscape (por defecto: phoneColumns + 1)
  final int? phoneLandscapeColumns;
  
  /// Columnas para tablet portrait (por defecto: 3)
  final int tabletColumns;
  
  /// Columnas para tablet landscape (por defecto: tabletColumns + 1)
  final int? tabletLandscapeColumns;
  
  /// Espaciado entre items
  final double spacing;
  
  /// Aspect ratio de cada item (ancho/alto)
  final double childAspectRatio;
  
  /// Padding del grid
  final EdgeInsetsGeometry? padding;
  
  /// Si el grid debe ser shrinkwrap
  final bool shrinkWrap;
  
  /// ScrollPhysics del grid
  final ScrollPhysics? physics;

  const AdaptiveGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.phoneColumns = 2,
    this.phoneLandscapeColumns,
    this.tabletColumns = 3,
    this.tabletLandscapeColumns,
    this.spacing = 16,
    this.childAspectRatio = 1.0,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  @override
  Widget build(BuildContext context) {
    final deviceType = getMobileDeviceType(context);
    final isLand = isLandscape(context);

    int columns;
    if (deviceType == MobileDeviceType.tablet) {
      columns = isLand 
          ? (tabletLandscapeColumns ?? tabletColumns + 1)
          : tabletColumns;
    } else {
      columns = isLand 
          ? (phoneLandscapeColumns ?? phoneColumns + 1)
          : phoneColumns;
    }

    return GridView.builder(
      shrinkWrap: shrinkWrap,
      physics: physics,
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        return itemBuilder(context, items[index]);
      },
    );
  }
}

/// Widget similar pero con ancho máximo de items en vez de columnas fijas.
/// 
/// Útil cuando quieres que los items tengan un ancho mínimo y el grid
/// se adapte automáticamente.
class AdaptiveStaggeredGrid<T> extends StatelessWidget {
  final List<T> items;
  final Widget Function(BuildContext, T) itemBuilder;
  
  /// Ancho mínimo de cada item
  final double minItemWidth;
  
  /// Espaciado entre items
  final double spacing;
  
  /// Padding del grid
  final EdgeInsetsGeometry? padding;

  const AdaptiveStaggeredGrid({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.minItemWidth = 150,
    this.spacing = 16,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth - (padding?.horizontal ?? 0);
        final columns = (width / minItemWidth).floor().clamp(1, 6);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
            childAspectRatio: 1.0,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemBuilder(context, items[index]);
          },
        );
      },
    );
  }
}
