import 'package:flutter/material.dart';
import '../utils/app_logger.dart';

/// Estado interno usado para telemetría / callbacks.
enum DataState { loading, error, empty, data }

/// Widget flexible para manejar estados de datos (cargando, error, vacío, contenido).
class DataStateHandler<T> extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final T? data;
  final Widget Function(T data) contentBuilder;
  final Widget Function()? loadingBuilder;
  final Widget Function(String error)? errorBuilder;
  final Widget Function()? emptyBuilder;
  final bool Function(T? data)? isEmpty;
  /// Callback opcional que notifica el estado actual para telemetría o logs.
  final void Function(DataState state, String? error)? onStateChange;

  const DataStateHandler({
    super.key,
    required this.isLoading,
    required this.error,
    required this.data,
    required this.contentBuilder,
    this.loadingBuilder,
    this.errorBuilder,
    this.emptyBuilder,
    this.isEmpty,
    this.onStateChange,
  });

  @override
  Widget build(BuildContext context) {
    // Cargando
    if (isLoading) {
      _notifyState(DataState.loading, null);
      return loadingBuilder?.call() ?? const Center(child: CircularProgressIndicator());
    }

    // Error
    if (error != null) {
      _notifyState(DataState.error, error);
      return errorBuilder?.call(error!) ?? _defaultErrorWidget(context, error!);
    }

    // Vacío
    final checkEmpty = isEmpty ?? _defaultIsEmpty;
    if (checkEmpty(data)) {
      _notifyState(DataState.empty, null);
      return emptyBuilder?.call() ?? _defaultEmptyWidget(context);
    }

    // Contenido
    _notifyState(DataState.data, null);
    return contentBuilder(data as T);
  }

  void _notifyState(DataState state, String? errorMsg) {
    // Log via AppLogger
    switch (state) {
      case DataState.loading:
        AppLogger.debug('DataStateHandler: loading', category: AppLogger.categoryUI);
        break;
      case DataState.error:
        AppLogger.error('DataStateHandler: error - $errorMsg', category: AppLogger.categoryUI, error: errorMsg);
        break;
      case DataState.empty:
        AppLogger.info('DataStateHandler: empty', category: AppLogger.categoryUI);
        break;
      case DataState.data:
        AppLogger.debug('DataStateHandler: data', category: AppLogger.categoryUI);
        break;
    }

    // Also call the optional callback
    try {
      onStateChange?.call(state, errorMsg);
    } catch (e, st) {
      AppLogger.error('onStateChange handler threw', category: AppLogger.categoryUI, error: e, stackTrace: st);
    }
  }

  bool _defaultIsEmpty(T? data) {
    if (data == null) return true;
    if (data is List) return (data as List).isEmpty;
    return false;
  }

  Widget _defaultErrorWidget(BuildContext context, String error) {
    return Semantics(
      label: 'Error: $error',
      hint: 'Mensaje de error, desplegado en pantalla',
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Theme.of(context).colorScheme.error),
              const SizedBox(height: 16),
              Text(
                'Ocurrió un error',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _defaultEmptyWidget(BuildContext context) {
    return Semantics(
      label: 'No hay datos disponibles',
      hint: 'Pantalla vacía indicando que no hay elementos',
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No hay datos disponibles',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
