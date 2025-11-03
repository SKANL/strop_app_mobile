// lib/src/features/incidents/presentation/widgets/dialogs/quick_incident_type_selector.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../../core/core_ui/theme/app_colors.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';

/// BottomSheet para selección rápida de tipo de incidencia
/// 
/// Reemplaza la pantalla completa SelectIncidentTypeScreen
/// Permite al usuario seleccionar el tipo de reporte en 2 segundos
/// sin navegar a una nueva pantalla completa.
class QuickIncidentTypeSelector extends StatelessWidget {
  final String projectId;

  const QuickIncidentTypeSelector({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final user = authProvider.user;
        final userRole = user?.role.toString().split('.').last ?? '';
        
        // Determinar si el usuario puede solicitar materiales
        final canRequestMaterials = userRole == 'resident' || 
                                   userRole == 'superintendent' ||
                                   userRole == 'superadmin' ||
                                   userRole == 'owner';

        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle indicator
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.borderColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Título
              Text(
                '¿Qué deseas reportar?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Selecciona el tipo de reporte',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.iconColor,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 24),
              
              // Opciones de tipo
              _buildTypeOption(
                context,
                icon: Icons.trending_up,
                iconColor: AppColors.progressReportColor,
                title: 'Reporte de Avance',
                subtitle: 'Documenta el progreso',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/project/$projectId/create-incident?type=avance');
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildTypeOption(
                context,
                icon: Icons.error_outline,
                iconColor: AppColors.problemColor,
                title: 'Problema / Falla',
                subtitle: 'Reporta un problema',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/project/$projectId/create-incident?type=problema');
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildTypeOption(
                context,
                icon: Icons.help_outline,
                iconColor: AppColors.consultationColor,
                title: 'Consulta',
                subtitle: 'Realiza una pregunta',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/project/$projectId/create-incident?type=consulta');
                },
              ),
              
              const SizedBox(height: 12),
              
              _buildTypeOption(
                context,
                icon: Icons.shield_outlined,
                iconColor: AppColors.safetyIncidentColor,
                title: 'Incidente de Seguridad',
                subtitle: 'Reporta un riesgo',
                onTap: () {
                  Navigator.pop(context);
                  context.push('/project/$projectId/create-incident?type=seguridad');
                },
              ),
              
              // Solicitud de Material (solo para roles autorizados)
              if (canRequestMaterials) ...[
                const SizedBox(height: 16),
                
                Divider(color: AppColors.borderColor),
                
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'REQUIERE APROBACIÓN',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: AppColors.iconColor,
                      letterSpacing: 0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                
                _buildTypeOption(
                  context,
                  icon: Icons.inventory_2_outlined,
                  iconColor: AppColors.materialRequestColor,
                  title: 'Solicitud de Material',
                  subtitle: 'Solicita materiales',
                  showBadge: true,
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/project/$projectId/create-material-request');
                  },
                ),
              ],
              
              const SizedBox(height: 16),
              
              // Botón cancelar
              OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('Cancelar'),
              ),
              
              // Espacio para safe area
              SizedBox(height: MediaQuery.of(context).padding.bottom),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTypeOption(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool showBadge = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.borderColor),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // Icono
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 24,
              ),
            ),
            
            const SizedBox(width: 16),
            
            // Texto
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      if (showBadge)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Aprobación',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange.shade700,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.iconColor,
                        ),
                  ),
                ],
              ),
            ),
            
            // Arrow
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.iconColor,
            ),
          ],
        ),
      ),
    );
  }
}
