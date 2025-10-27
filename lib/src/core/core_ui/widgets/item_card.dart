// lib/src/core/core_ui/widgets/item_card.dart
import 'package:flutter/material.dart';

/// Widget genérico para cards de cualquier tipo de item
/// 
/// Reemplaza layouts de cards manuales en múltiples pantallas
/// Permite que cualquier entidad (Project, Incident, Task, etc.) tenga
/// una representación consistente
class ItemCard<T> extends StatelessWidget {
  final T item;
  final Widget Function(BuildContext, T) builder;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final EdgeInsets padding;
  final double elevation;
  final BorderRadius borderRadius;
  final Color? backgroundColor;
  final Border? border;

  const ItemCard({
    super.key,
    required this.item,
    required this.builder,
    this.onTap,
    this.onLongPress,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 2,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.backgroundColor,
    this.border,
  });

  /// Factory para card clickeable
  factory ItemCard.clickable({
    required T item,
    required Widget Function(BuildContext, T) builder,
    required VoidCallback onTap,
    EdgeInsets padding = const EdgeInsets.all(16),
  }) => ItemCard(
    item: item,
    builder: builder,
    onTap: onTap,
    padding: padding,
  );

  /// Factory para card con efecto hover
  factory ItemCard.interactive({
    required T item,
    required Widget Function(BuildContext, T) builder,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
  }) => ItemCard(
    item: item,
    builder: builder,
    onTap: onTap,
    onLongPress: onLongPress,
  );

  /// Factory para card outline (sin elevación)
  factory ItemCard.outline({
    required T item,
    required Widget Function(BuildContext, T) builder,
    VoidCallback? onTap,
    Color outlineColor = Colors.grey,
  }) => ItemCard(
    item: item,
    builder: builder,
    onTap: onTap,
    elevation: 0,
    border: Border.all(color: outlineColor),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Card(
        elevation: elevation,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius,
          side: border?.top ?? BorderSide.none,
        ),
        color: backgroundColor,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            border: border,
          ),
          padding: padding,
          child: builder(context, item),
        ),
      ),
    );
  }
}

/// Variante expandible que puede mostrar/ocultar contenido
class ExpandableItemCard<T> extends StatefulWidget {
  final T item;
  final Widget Function(BuildContext, T) headerBuilder;
  final Widget Function(BuildContext, T) contentBuilder;
  final EdgeInsets padding;
  final double elevation;
  final BorderRadius borderRadius;
  final bool initiallyExpanded;

  const ExpandableItemCard({
    super.key,
    required this.item,
    required this.headerBuilder,
    required this.contentBuilder,
    this.padding = const EdgeInsets.all(16),
    this.elevation = 2,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
    this.initiallyExpanded = false,
  });

  @override
  State<ExpandableItemCard<T>> createState() => _ExpandableItemCardState<T>();
}

class _ExpandableItemCardState<T> extends State<ExpandableItemCard<T>> {
  late bool _isExpanded = widget.initiallyExpanded;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: widget.elevation,
      shape: RoundedRectangleBorder(
        borderRadius: widget.borderRadius,
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: widget.borderRadius,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              onTap: () => setState(() => _isExpanded = !_isExpanded),
              borderRadius: _isExpanded
                  ? const BorderRadius.vertical(top: Radius.circular(12))
                  : widget.borderRadius,
              child: Padding(
                padding: widget.padding,
                child: Row(
                  children: [
                    Expanded(
                      child: widget.headerBuilder(context, widget.item),
                    ),
                    const SizedBox(width: 8),
                    AnimatedRotation(
                      turns: _isExpanded ? 0.5 : 0,
                      duration: const Duration(milliseconds: 200),
                      child: const Icon(Icons.expand_more),
                    ),
                  ],
                ),
              ),
            ),
            if (_isExpanded) ...[
              Divider(
                height: 1,
                color: Colors.grey[300],
              ),
              Padding(
                padding: widget.padding,
                child: widget.contentBuilder(context, widget.item),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
