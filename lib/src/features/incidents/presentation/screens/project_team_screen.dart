// lib/src/features/incidents/presentation/screens/project_team_screen.dart
import 'package:flutter/material.dart';
import '../widgets/team_member_card.dart';

/// Screen 14: Equipo del Proyecto - Ver jerarquía de personal asignado
class ProjectTeamScreen extends StatelessWidget {
  final String projectId;

  const ProjectTeamScreen({
    super.key,
    required this.projectId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipo del Proyecto'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // TODO: Obtener datos reales del Provider
          RoleSection(
            roleTitle: 'Superintendente',
            roleColor: Colors.purple,
            members: const [
              TeamMemberCard(name: 'Ing. López Ramírez', email: 'lopez@empresa.com', role: 'superintendent'),
            ],
          ),

          const SizedBox(height: 16),

          RoleSection(
            roleTitle: 'Residente',
            roleColor: Colors.blue,
            members: const [
              TeamMemberCard(name: 'Arq. García Hernández', email: 'garcia@empresa.com', role: 'resident'),
              TeamMemberCard(name: 'Ing. Martínez Cruz', email: 'martinez@empresa.com', role: 'resident'),
            ],
          ),

          const SizedBox(height: 16),

          RoleSection(
            roleTitle: 'Cabo',
            roleColor: Colors.orange,
            members: const [
              TeamMemberCard(name: 'Pedro Sánchez', email: 'psanchez@empresa.com', role: 'cabo'),
              TeamMemberCard(name: 'Juan Rodríguez', email: 'jrodriguez@empresa.com', role: 'cabo'),
              TeamMemberCard(name: 'Carlos Gómez', email: 'cgomez@empresa.com', role: 'cabo'),
            ],
          ),
        ],
      ),
    );
  }



  // Initials handled by AvatarWithInitials in TeamMemberCard
}
