// lib/src/features/incidents/presentation/screens/project/project_team_screen.dart
import 'package:flutter/material.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/layouts/responsive_container.dart';

/// Screen 14: Equipo del Proyecto - Ver jerarquía de personal asignado
///
/// CAMBIOS (Fase 8):
/// - Uso de ResponsiveContainer
/// - Diseño mejorado de tarjetas de miembros
class ProjectTeamScreen extends StatelessWidget {
  final String projectId;

  const ProjectTeamScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Equipo del Proyecto')),
      body: ResponsiveContainer(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: [
            // Banner informativo
            InfoBanner(
              message:
                  'Contacta a los miembros del equipo directamente desde aquí.',
              icon: Icons.info_outline,
              type: InfoBannerType.info,
            ),

            const SizedBox(height: 24),

            // TODO: Obtener datos reales del Provider
            RoleSection(
              roleTitle: 'Superintendente',
              roleColor: AppColors.superintendentColor,
              members: const [
                TeamMemberCard(
                  name: 'Ing. López Ramírez',
                  email: 'lopez@empresa.com',
                  role: 'superintendent',
                ),
              ],
            ),

            const SizedBox(height: 24),

            RoleSection(
              roleTitle: 'Residente',
              roleColor: AppColors.residentColor,
              members: const [
                TeamMemberCard(
                  name: 'Arq. García Hernández',
                  email: 'garcia@empresa.com',
                  role: 'resident',
                ),
                TeamMemberCard(
                  name: 'Ing. Martínez Cruz',
                  email: 'martinez@empresa.com',
                  role: 'resident',
                ),
              ],
            ),

            const SizedBox(height: 24),

            RoleSection(
              roleTitle: 'Cabo',
              roleColor: AppColors.caboColor,
              members: const [
                TeamMemberCard(
                  name: 'Pedro Sánchez',
                  email: 'psanchez@empresa.com',
                  role: 'cabo',
                ),
                TeamMemberCard(
                  name: 'Juan Rodríguez',
                  email: 'jrodriguez@empresa.com',
                  role: 'cabo',
                ),
                TeamMemberCard(
                  name: 'Carlos Gómez',
                  email: 'cgomez@empresa.com',
                  role: 'cabo',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
