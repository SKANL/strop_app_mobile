import 'package:flutter/material.dart';
import 'data_state_handler.dart';
import 'list_skeleton.dart';

/// Reusable list view that usa DataStateHandler para manejar loading/error/empty/data.
class ListDataView<T> extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<T> data;
  final Widget Function(BuildContext, T, int) itemBuilder;
  final Future<void> Function()? onRefresh;
  final VoidCallback? onRetry;
  final Widget Function()? emptyBuilder;

  const ListDataView({
    super.key,
    required this.isLoading,
    required this.error,
    required this.data,
    required this.itemBuilder,
    this.onRefresh,
    this.onRetry,
    this.emptyBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return DataStateHandler<List<T>>(
      isLoading: isLoading,
      error: error,
      data: data,
      loadingBuilder: () => const ListSkeleton(),
      errorBuilder: (err) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Ocurrió un error: $err', textAlign: TextAlign.center),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: onRetry, child: const Text('Reintentar')),
            ],
          ),
        ),
      ),
      emptyBuilder: emptyBuilder,
      contentBuilder: (list) {
        final listView = ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, index) => itemBuilder(context, list[index], index),
        );

        if (onRefresh != null) {
          return RefreshIndicator(onRefresh: onRefresh!, child: listView);
        }
        return listView;
      },
      isEmpty: (d) => d == null || d.isEmpty,
    );
  }
}
