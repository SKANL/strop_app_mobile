// lib/src/core/core_ui/widgets/selectable_card.dart

import 'package:flutter/material.dart';

/// Widget reutilizable para Cards seleccionables.
/// 
/// Muestra un Card con estado seleccionado/no seleccionado, con animación
/// de borde y elevación. Ideal para listas de opciones.
/// 
/// Ejemplo de uso:
/// ```dart
/// SelectableCard(
///   isSelected: _selectedId == item.id,
///   onTap: () => setState(() => _selectedId = item.id),
///   child: ListTile(title: Text(item.name)),
/// )
/// ```
class SelectableCard extends StatelessWidget {
  /// Si el card está seleccionado
  final bool isSelected;
  
  /// Callback al hacer tap en el card
  final VoidCallback? onTap;
  
  /// Contenido del card
  final Widget child;
  
  /// Margen externo del card
  final EdgeInsetsGeometry? margin;
  
  /// Padding interno del card
  final EdgeInsetsGeometry? padding;
  
  /// Radio del borde
  final double borderRadius;
  
  /// Elevación cuando NO está seleccionado
  final double elevation;
  
  /// Elevación cuando SÍ está seleccionado
  final double selectedElevation;
  
  /// Color del borde cuando está seleccionado (por defecto usa el primary del theme)
  final Color? selectedBorderColor;
  
  /// Ancho del borde cuando está seleccionado
  final double selectedBorderWidth;

  const SelectableCard({
    super.key,
    required this.isSelected,
    required this.child,
    this.onTap,
    this.margin,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = 12,
    this.elevation = 1,
    this.selectedElevation = 4,
    this.selectedBorderColor,
    this.selectedBorderWidth = 2,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderColor = selectedBorderColor ?? theme.colorScheme.primary;

    return Card(
      margin: margin,
      elevation: isSelected ? selectedElevation : elevation,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
        side: BorderSide(
          color: isSelected ? effectiveBorderColor : Colors.transparent,
          width: selectedBorderWidth,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: Padding(
          padding: padding!,
          child: child,
        ),
      ),
    );
  }
}
