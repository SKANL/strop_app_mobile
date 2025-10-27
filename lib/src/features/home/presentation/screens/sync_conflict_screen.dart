// lib/src/features/home/presentation/screens/sync_conflict_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core_ui/widgets/widgets.dart';

/// Pantalla Modal de Explicación de Conflicto de Sincronización (Fase 1)
class SyncConflictScreen extends StatelessWidget {
  const SyncConflictScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ícono de error
              CircleAvatar(
                radius: 40,
                backgroundColor: AppColors.lighten(AppColors.error, 0.85),
                child: Icon(
                  Icons.sync_problem,
                  size: 48,
                  color: AppColors.darken(AppColors.error, 0.3),
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Título
              Text(
                'Conflicto de Sincronización',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              // Nombre del item
              Text(
                'Error al cerrar Tarea #123',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 16),
              
              // Descripción del error
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.cardBackground,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Razón del conflicto:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'El Residente reasignó esta tarea a otro usuario mientras trabajabas offline. Tu acción de cierre ya no es válida.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Información adicional
              _buildInfoRow(
                context,
                icon: Icons.person_outline,
                label: 'Reasignado a:',
                value: 'Juan Pérez',
              ),
              
              const SizedBox(height: 8),
              
              _buildInfoRow(
                context,
                icon: Icons.access_time,
                label: 'Fecha de cambio:',
                value: 'Hace 2 horas',
              ),
              
              const SizedBox(height: 24),
              
              // Mensaje explicativo
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.lighten(AppColors.pendingStatusColor, 0.9),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.lighten(AppColors.pendingStatusColor, 0.7)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, color: AppColors.darken(AppColors.pendingStatusColor, 0.3)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Debes descartar este cambio local. Los datos del servidor prevalecen.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.darken(AppColors.pendingStatusColor, 0.4),
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Botones de acción
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => context.pop(),
                      child: const Text('Volver'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implementar descarte del cambio local
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cambio local descartado'),
                          ),
                        );
                        context.pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Descartar mi Cambio'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.iconColor),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.iconColor,
              ),
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
