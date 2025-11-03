// lib/src/core/core_ui/widgets/empty_state.dart
import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/theme/app_colors.dart';

/// Widget reutilizable para estados vacíos
/// Usado en: Listas vacías, sin datos, sin resultados
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? customAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.message,
    this.actionLabel,
    this.onAction,
    this.customAction,
  });

  /// Constructor para listas vacías genéricas
  factory EmptyState.noData({
    required String title,
    String? message,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      icon: Icons.inbox_outlined,
      title: title,
      message: message,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Constructor para sin resultados de búsqueda
  factory EmptyState.noResults({
    String? query,
  }) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'Sin resultados',
      message: query != null 
        ? 'No encontramos resultados para "$query"'
        : 'No se encontraron resultados para tu búsqueda',
    );
  }

  /// Constructor para sin proyectos asignados
  factory EmptyState.noProjects() {
    return const EmptyState(
      icon: Icons.folder_open,
      title: 'Aún no tienes proyectos asignados',
      message: 'Los proyectos asignados aparecerán aquí',
    );
  }

  /// Constructor para sin tareas
  factory EmptyState.noTasks() {
    return const EmptyState(
      icon: Icons.task_alt,
      title: 'No tienes tareas pendientes',
      message: '¡Buen trabajo! Todas tus tareas están completadas',
    );
  }

  /// Constructor para sin reportes
  factory EmptyState.noReports({
    VoidCallback? onCreateReport,
  }) {
    return EmptyState(
      icon: Icons.description_outlined,
      title: 'No has creado reportes aún',
      message: 'Comienza creando tu primer reporte',
      actionLabel: 'Crear Reporte',
      onAction: onCreateReport,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icono
            Icon(
              icon,
              size: 80,
              color: AppColors.textMuted,
            ),
            const SizedBox(height: 24),

            // Título
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            // Mensaje opcional
            if (message != null) ...[
              const SizedBox(height: 8),
              Text(
                message!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMuted,
                ),
                textAlign: TextAlign.center,
              ),
            ],

            // Acción opcional
            if (customAction != null) ...[
              const SizedBox(height: 24),
              customAction!,
            ] else if (onAction != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.add),
                label: Text(actionLabel!),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Variante compacta para usar en Slivers
class SliverEmptyState extends StatelessWidget {
  final EmptyState emptyState;

  const SliverEmptyState({
    super.key,
    required this.emptyState,
  });

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      hasScrollBody: false,
      child: emptyState,
    );
  }
}
