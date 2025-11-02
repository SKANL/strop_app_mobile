// lib/src/features/incidents/presentation/screens/forms/select_incident_type_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Screen 16: Selector de Tipo de Reporte con lógica de rol
/// 
/// Refactorizado para usar ActionTypeCard del core_ui y AppColors.
class SelectIncidentTypeScreen extends StatelessWidget {
  final String projectId;

  const SelectIncidentTypeScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seleccionar Tipo de Reporte'),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;
          final userRole = user?.role.toString().split('.').last ?? '';
          
          // Determinar si el usuario puede solicitar materiales
          final canRequestMaterials = userRole == 'resident' || 
                                     userRole == 'superintendent' ||
                                     userRole == 'superadmin' ||
                                     userRole == 'owner';

          return ListView(
            padding: const EdgeInsets.all(24.0),
            children: [
              // Encabezado
              Text(
                '¿Qué deseas reportar?',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 8),
              
              Text(
                'Selecciona el tipo de reporte que deseas crear',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.iconColor,
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Grid de opciones (usando ActionTypeCard)
              ActionTypeCard(
                icon: Icons.trending_up,
                iconColor: AppColors.progressReportColor,
                title: 'Reporte de Avance',
                description: 'Documenta el progreso de una actividad',
                onTap: () {
                  context.push('/project/$projectId/create-incident?type=avance');
                },
              ),
              
              const SizedBox(height: 16),
              
              ActionTypeCard(
                icon: Icons.error_outline,
                iconColor: AppColors.problemColor,
                title: 'Problema / Falla',
                description: 'Reporta un problema técnico o falla',
                onTap: () {
                  context.push('/project/$projectId/create-incident?type=problema');
                },
              ),
              
              const SizedBox(height: 16),
              
              ActionTypeCard(
                icon: Icons.help_outline,
                iconColor: AppColors.consultationColor,
                title: 'Consulta',
                description: 'Realiza una pregunta sobre especificaciones',
                onTap: () {
                  context.push('/project/$projectId/create-incident?type=consulta');
                },
              ),
              
              const SizedBox(height: 16),
              
              ActionTypeCard(
                icon: Icons.shield_outlined,
                iconColor: AppColors.safetyIncidentColor,
                title: 'Incidente de Seguridad',
                description: 'Reporta un riesgo o incidente de seguridad',
                onTap: () {
                  context.push('/project/$projectId/create-incident?type=seguridad');
                },
              ),
              
              // Solicitud de Material (solo para Residentes/Superintendentes)
              if (canRequestMaterials) ...[
                const SizedBox(height: 24),
                
                // Separador
                Row(
                  children: [
                    Expanded(child: Divider(color: AppColors.borderColor)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'REQUIERE APROBACIÓN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: AppColors.iconColor,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: AppColors.borderColor)),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                ActionTypeCard(
                  icon: Icons.inventory_2_outlined,
                  iconColor: AppColors.materialRequestColor,
                  title: 'Solicitud de Material',
                  description: 'Solicita materiales adicionales',
                  showRequiresApproval: true,
                  onTap: () {
                    context.push('/project/$projectId/create-material-request');
                  },
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}
