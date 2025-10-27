import 'package:flutter/material.dart';

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
