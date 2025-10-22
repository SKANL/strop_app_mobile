import 'package:flutter/material.dart';
import 'data_state_handler.dart';

/// Wrapper de compatibilidad para la API existente `DataStateView`.
/// Mantiene la misma firma antigua (lista de datos y contentBuilder que recibe List<T),
/// pero delega la lógica a `DataStateHandler` que es más flexible.
class DataStateView<T> extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<T> data;
  final Widget Function(List<T> data) contentBuilder;
  final String emptyMessage;

  const DataStateView({
    super.key,
    required this.isLoading,
    required this.error,
    required this.data,
    required this.contentBuilder,
    this.emptyMessage = 'No hay datos disponibles.',
  });

  @override
  Widget build(BuildContext context) {
    return DataStateHandler<List<T>>(
      isLoading: isLoading,
      error: error,
      data: data,
      contentBuilder: (list) => contentBuilder(list),
      emptyBuilder: () => Center(child: Text(emptyMessage)),
      isEmpty: (d) => d == null || d.isEmpty,
    );
  }
}