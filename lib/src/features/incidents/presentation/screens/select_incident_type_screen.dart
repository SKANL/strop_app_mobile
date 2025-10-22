// lib/src/features/incidents/presentation/screens/select_incident_type_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/manager/auth_provider.dart';

/// Screen 16: Selector de Tipo de Reporte con lógica de rol
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
                      color: Colors.grey[600],
                    ),
                textAlign: TextAlign.center,
              ),
              
              const SizedBox(height: 32),
              
              // Grid de opciones
              _buildIncidentTypeCard(
                context,
                icon: Icons.trending_up,
                iconColor: Colors.blue,
                title: 'Reporte de Avance',
                description: 'Documenta el progreso de una actividad',
                onTap: () {
                  context.push('/project/$projectId/create-incident?type=avance');
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildIncidentTypeCard(
                context,
                icon: Icons.error_outline,
                iconColor: Colors.orange,
                title: 'Problema / Falla',
                description: 'Reporta un problema técnico o falla',
                onTap: () {
                  context.push('/project/$projectId/create-incident?type=problema');
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildIncidentTypeCard(
                context,
                icon: Icons.help_outline,
                iconColor: Colors.purple,
                title: 'Consulta',
                description: 'Realiza una pregunta sobre especificaciones',
                onTap: () {
                  context.push('/project/$projectId/create-incident?type=consulta');
                },
              ),
              
              const SizedBox(height: 16),
              
              _buildIncidentTypeCard(
                context,
                icon: Icons.shield_outlined,
                iconColor: Colors.red,
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
                    Expanded(child: Divider(color: Colors.grey[300])),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'REQUIERE APROBACIÓN',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey[300])),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                _buildIncidentTypeCard(
                  context,
                  icon: Icons.inventory_2_outlined,
                  iconColor: Colors.teal,
                  title: 'Solicitud de Material',
                  description: 'Solicita materiales adicionales (requiere aprobación del Dueño)',
                  onTap: () {
                    context.push('/project/$projectId/create-material-request');
                  },
                  badge: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.amber[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.amber[700]!),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.admin_panel_settings, size: 14, color: Colors.amber[900]),
                        const SizedBox(width: 4),
                        Text(
                          'Requiere aprobación',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[900],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _buildIncidentTypeCard(
    BuildContext context, {
    required IconData icon,
    required Color iconColor,
    required String title,
    required String description,
    required VoidCallback onTap,
    Widget? badge,
  }) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  // Icono
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: iconColor.withValues(alpha: 0.15),
                    child: Icon(icon, color: iconColor, size: 28),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Título
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  
                  // Flecha
                  Icon(Icons.arrow_forward_ios, size: 18, color: Colors.grey[400]),
                ],
              ),
              
              const SizedBox(height: 12),
              
              // Descripción
              Padding(
                padding: const EdgeInsets.only(left: 72),
                child: Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
              ),
              
              // Badge opcional
              if (badge != null) ...[
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.only(left: 72),
                  child: badge,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
