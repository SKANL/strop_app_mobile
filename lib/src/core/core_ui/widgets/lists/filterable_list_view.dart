import 'package:flutter/material.dart';

/// Widget reutilizable para listas con filtros
/// 
/// Proporciona interfaz consistente para listas con múltiples filtros.
/// 
/// Ejemplo de uso:
/// ```dart
/// FilterableListView<IncidentEntity>(
///   items: provider.incidents,
///   filters: _buildFilters(),
///   itemBuilder: (context, incident) => IncidentListItem(incident: incident),
///   onRefresh: () => provider.loadIncidents(),
/// )
/// ```
class FilterableListView<T> extends StatelessWidget {
  const FilterableListView({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.filters = const [],
    this.searchHint = 'Buscar...',
    this.onSearchChanged,
    this.emptyMessage = 'No hay resultados',
    this.onRefresh,
    this.separatorBuilder,
    this.padding,
  });

  final List<T> items;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final List<Widget> filters;
  final String searchHint;
  final ValueChanged<String>? onSearchChanged;
  final String emptyMessage;
  final Future<void> Function()? onRefresh;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de búsqueda y filtros
        if (onSearchChanged != null || filters.isNotEmpty)
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: Column(
              children: [
                // Barra de búsqueda
                if (onSearchChanged != null)
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: searchHint,
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      ),
                      onChanged: onSearchChanged,
                    ),
                  ),
                
                // Chips de filtros
                if (filters.isNotEmpty)
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      children: filters
                          .expand((filter) => [filter, const SizedBox(width: 8)])
                          .toList()
                        ..removeLast(),
                    ),
                  ),
              ],
            ),
          ),
        
        // Lista de items
        Expanded(
          child: items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.search_off,
                        size: 64,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        emptyMessage,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ],
                  ),
                )
              : _buildList(context),
        ),
      ],
    );
  }

  Widget _buildList(BuildContext context) {
    final listView = separatorBuilder != null
        ? ListView.separated(
            padding: padding,
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(context, items[index]),
            separatorBuilder: separatorBuilder!,
          )
        : ListView.builder(
            padding: padding,
            itemCount: items.length,
            itemBuilder: (context, index) => itemBuilder(context, items[index]),
          );

    if (onRefresh != null) {
      return RefreshIndicator(
        onRefresh: onRefresh!,
        child: listView,
      );
    }

    return listView;
  }
}
