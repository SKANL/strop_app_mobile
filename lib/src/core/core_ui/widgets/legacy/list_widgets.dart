import 'package:flutter/material.dart';

/// Tipo de dato para representar estado asíncrono
/// Similar a AsyncValue de Riverpod pero sin dependencias externas
sealed class AsyncValue<T> {
  const AsyncValue();
  
  /// Estado de carga
  const factory AsyncValue.loading() = AsyncLoading<T>;
  
  /// Estado de error
  const factory AsyncValue.error(Object error, [StackTrace? stackTrace]) = AsyncError<T>;
  
  /// Estado con datos
  const factory AsyncValue.data(T value) = AsyncData<T>;
  
  /// Pattern matching para los estados
  R when<R>({
    required R Function() loading,
    required R Function(Object error, StackTrace? stackTrace) error,
    required R Function(T data) data,
  });
  
  /// Pattern matching con default
  R maybeWhen<R>({
    R Function()? loading,
    R Function(Object error, StackTrace? stackTrace)? error,
    R Function(T data)? data,
    required R Function() orElse,
  });
}

/// Estado de carga
class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading();
  
  @override
  R when<R>({
    required R Function() loading,
    required R Function(Object error, StackTrace? stackTrace) error,
    required R Function(T data) data,
  }) {
    return loading();
  }
  
  @override
  R maybeWhen<R>({
    R Function()? loading,
    R Function(Object error, StackTrace? stackTrace)? error,
    R Function(T data)? data,
    required R Function() orElse,
  }) {
    return loading?.call() ?? orElse();
  }
}

/// Estado de error
class AsyncError<T> extends AsyncValue<T> {
  const AsyncError(this.errorValue, [this.stackTrace]);
  
  final Object errorValue;
  final StackTrace? stackTrace;
  
  @override
  R when<R>({
    required R Function() loading,
    required R Function(Object error, StackTrace? stackTrace) error,
    required R Function(T data) data,
  }) {
    return error(errorValue, stackTrace);
  }
  
  @override
  R maybeWhen<R>({
    R Function()? loading,
    R Function(Object error, StackTrace? stackTrace)? error,
    R Function(T data)? data,
    required R Function() orElse,
  }) {
    return error?.call(errorValue, stackTrace) ?? orElse();
  }
}

/// Estado con datos
class AsyncData<T> extends AsyncValue<T> {
  const AsyncData(this.value);
  
  final T value;
  
  @override
  R when<R>({
    required R Function() loading,
    required R Function(Object error, StackTrace? stackTrace) error,
    required R Function(T data) data,
  }) {
    return data(value);
  }
  
  @override
  R maybeWhen<R>({
    R Function()? loading,
    R Function(Object error, StackTrace? stackTrace)? error,
    R Function(T data)? data,
    required R Function() orElse,
  }) {
    return data?.call(value) ?? orElse();
  }
}

/// Widget reutilizable para listas con manejo de estados async
/// 
/// Elimina duplicación en 6+ screens con listas.
/// Maneja automáticamente loading, error, empty y data states.
/// 
/// Ejemplo de uso:
/// ```dart
/// AsyncListView<IncidentEntity>(
///   asyncValue: provider.incidentsState,
///   itemBuilder: (context, incident, index) => IncidentListItem(incident: incident),
///   emptyMessage: 'No hay incidentes',
///   onRefresh: () => provider.loadIncidents(),
///   onRetry: () => provider.retryLoad(),
/// )
/// ```
class AsyncListView<T> extends StatelessWidget {
  const AsyncListView({
    super.key,
    required this.asyncValue,
    required this.itemBuilder,
    this.emptyMessage = 'No hay elementos',
    this.emptyIcon,
    this.onRetry,
    this.onRefresh,
    this.separatorBuilder,
    this.padding,
    this.shrinkWrap = false,
    this.physics,
  });

  final AsyncValue<List<T>> asyncValue;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final String emptyMessage;
  final IconData? emptyIcon;
  final VoidCallback? onRetry;
  final Future<void> Function()? onRefresh;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;
  final ScrollPhysics? physics;

  @override
  Widget build(BuildContext context) {
    return asyncValue.when(
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stackTrace) => Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              'Error al cargar',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Reintentar'),
              ),
            ],
          ],
        ),
      ),
      data: (items) {
        if (items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  emptyIcon ?? Icons.inbox_outlined,
                  size: 64,
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
                const SizedBox(height: 16),
                Text(
                  emptyMessage,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        final listView = separatorBuilder != null
            ? ListView.separated(
                padding: padding,
                shrinkWrap: shrinkWrap,
                physics: physics,
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    itemBuilder(context, items[index], index),
                separatorBuilder: separatorBuilder!,
              )
            : ListView.builder(
                padding: padding,
                shrinkWrap: shrinkWrap,
                physics: physics,
                itemCount: items.length,
                itemBuilder: (context, index) =>
                    itemBuilder(context, items[index], index),
              );

        if (onRefresh != null) {
          return RefreshIndicator(
            onRefresh: onRefresh!,
            child: listView,
          );
        }

        return listView;
      },
    );
  }
}

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

/// Widget reutilizable para tabs con listas
/// 
/// Combina TabBar con listas filtradas por categoría.
/// 
/// Ejemplo de uso:
/// ```dart
/// TabbedListView<IncidentEntity>(
///   tabs: ['Mis Tareas', 'Mis Reportes', 'Bitácora'],
///   tabContents: [
///     provider.myTasks,
///     provider.myReports,
///     provider.bitacora,
///   ],
///   itemBuilder: (context, incident) => IncidentListItem(incident: incident),
/// )
/// ```
class TabbedListView<T> extends StatelessWidget {
  const TabbedListView({
    super.key,
    required this.tabs,
    required this.tabContents,
    required this.itemBuilder,
    this.emptyMessages,
    this.onRefresh,
    this.separatorBuilder,
    this.padding,
  });

  final List<String> tabs;
  final List<List<T>> tabContents;
  final Widget Function(BuildContext context, T item) itemBuilder;
  final List<String>? emptyMessages;
  final List<Future<void> Function()?>? onRefresh;
  final Widget Function(BuildContext, int)? separatorBuilder;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    assert(tabs.length == tabContents.length);
    
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        children: [
          TabBar(
            tabs: tabs.map((tab) => Tab(text: tab)).toList(),
            isScrollable: tabs.length > 3,
          ),
          Expanded(
            child: TabBarView(
              children: List.generate(
                tabs.length,
                (index) {
                  final items = tabContents[index];
                  final emptyMessage = emptyMessages?[index] ?? 'No hay elementos';
                  final refresh = onRefresh?[index];

                  if (items.isEmpty) {
                    return Center(
                      child: Text(
                        emptyMessage,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    );
                  }

                  final listView = separatorBuilder != null
                      ? ListView.separated(
                          padding: padding,
                          itemCount: items.length,
                          itemBuilder: (context, idx) =>
                              itemBuilder(context, items[idx]),
                          separatorBuilder: separatorBuilder!,
                        )
                      : ListView.builder(
                          padding: padding,
                          itemCount: items.length,
                          itemBuilder: (context, idx) =>
                              itemBuilder(context, items[idx]),
                        );

                  if (refresh != null) {
                    return RefreshIndicator(
                      onRefresh: refresh,
                      child: listView,
                    );
                  }

                  return listView;
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
