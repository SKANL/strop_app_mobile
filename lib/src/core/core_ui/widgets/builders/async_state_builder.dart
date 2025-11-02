// lib/src/core/core_ui/widgets/builders/async_state_builder.dart
import 'package:flutter/material.dart';
import '../../../core_domain/entities/data_state.dart';
import '../states/app_loading.dart';
import '../states/app_error.dart';
import '../states/empty_state.dart';

/// Builder widget para manejar estados asíncronos con DataState.
///
/// Elimina ~30 líneas de código duplicado en 15+ screens que manejan
/// estados de loading, error y success de manera repetitiva.
///
/// **Beneficios**:
/// - Manejo consistente de estados en toda la app
/// - Menos código boilerplate
/// - Mejor UX con estados predeterminados
///
/// **Ejemplo básico**:
/// ```dart
/// AsyncStateBuilder<List<Incident>>(
///   state: provider.incidentsState,
///   builder: (context, incidents) => ListView.builder(
///     itemCount: incidents.length,
///     itemBuilder: (context, index) => IncidentTile(incidents[index]),
///   ),
/// )
/// ```
///
/// **Con customización**:
/// ```dart
/// AsyncStateBuilder<Project>(
///   state: provider.projectState,
///   loadingWidget: const CustomLoader(),
///   errorMessage: 'No se pudo cargar el proyecto',
///   onRetry: () => provider.loadProject(id),
///   emptyMessage: 'Proyecto no encontrado',
///   builder: (context, project) => ProjectDetails(project),
/// )
/// ```
class AsyncStateBuilder<T> extends StatelessWidget {
  /// El estado asíncrono a renderizar
  final DataState<T> state;

  /// Builder que recibe los datos cuando el estado es success
  final Widget Function(BuildContext context, T data) builder;

  /// Widget personalizado para el estado de loading (opcional)
  final Widget? loadingWidget;
  // Backwards-compatible: builder-style loading widget: (context) => Widget
  final Widget Function(BuildContext context)? loadingBuilder;
  // Backwards-compatible: builder-style error widget: (context, failure) => Widget
  final Widget Function(BuildContext context, Object failure)? errorBuilder;

  /// Mensaje de error personalizado (opcional)
  final String? errorMessage;

  /// Callback para reintentar cuando hay error (opcional)
  final VoidCallback? onRetry;

  /// Widget personalizado para estado vacío (opcional)
  /// Se muestra cuando T es una lista y está vacía
  final Widget? emptyWidget;
  // Backwards-compatible: builder-style empty widget: (context) => Widget
  final Widget Function(BuildContext context)? emptyBuilder;

  /// Mensaje para estado vacío
  final String? emptyMessage;

  /// Subtítulo para estado vacío
  final String? emptySubtitle;

  /// Icono para estado vacío
  final IconData? emptyIcon;

  /// Si debe verificar si la data está vacía (solo para listas)
  final bool checkEmpty;

  const AsyncStateBuilder({
    super.key,
    required this.state,
    required this.builder,
    this.loadingWidget,
    this.loadingBuilder,
  this.errorMessage,
  this.errorBuilder,
    this.onRetry,
    this.emptyWidget,
    this.emptyBuilder,
    this.emptyMessage,
    this.emptySubtitle,
    this.emptyIcon,
    this.checkEmpty = true,
  });

  @override
  Widget build(BuildContext context) {
    return state.when(
      initial: () => loadingBuilder != null
          ? loadingBuilder!(context)
          : (loadingWidget ?? const Center(child: AppLoading())),
      loading: () => loadingBuilder != null
          ? loadingBuilder!(context)
          : (loadingWidget ?? const Center(child: AppLoading())),
      error: (failure) => Center(
        child: errorBuilder != null
            ? errorBuilder!(context, failure)
            : AppError(
                message: errorMessage ?? failure.message,
                onRetry: onRetry,
              ),
      ),
      success: (data) {
        // Verificar si es una lista vacía y checkEmpty está habilitado
        if (checkEmpty && data is List && (data as List).isEmpty) {
          return _buildEmptyState(context);
        }

        // Construir el widget con los datos
        return builder(context, data);
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    if (emptyBuilder != null) {
      return Center(child: emptyBuilder!(context));
    }

    if (emptyWidget != null) {
      return Center(child: emptyWidget);
    }

    return Center(
      child: EmptyState(
        icon: emptyIcon ?? Icons.inbox_outlined,
        title: emptyMessage ?? 'No hay datos disponibles',
        message: emptySubtitle,
      ),
    );
  }
}
