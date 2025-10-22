// lib/src/features/incidents/presentation/screens/project_team_screen.dart
import 'package:flutter/material.dart';

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
          _buildRoleSection(
            context,
            role: 'Superintendente',
            icon: Icons.engineering,
            color: Colors.purple,
            members: [
              {'name': 'Ing. López Ramírez', 'email': 'lopez@empresa.com'},
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildRoleSection(
            context,
            role: 'Residente',
            icon: Icons.badge,
            color: Colors.blue,
            members: [
              {'name': 'Arq. García Hernández', 'email': 'garcia@empresa.com'},
              {'name': 'Ing. Martínez Cruz', 'email': 'martinez@empresa.com'},
            ],
          ),
          
          const SizedBox(height: 16),
          
          _buildRoleSection(
            context,
            role: 'Cabo',
            icon: Icons.construction,
            color: Colors.orange,
            members: [
              {'name': 'Pedro Sánchez', 'email': 'psanchez@empresa.com'},
              {'name': 'Juan Rodríguez', 'email': 'jrodriguez@empresa.com'},
              {'name': 'Carlos Gómez', 'email': 'cgomez@empresa.com'},
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRoleSection(
    BuildContext context, {
    required String role,
    required IconData icon,
    required Color color,
    required List<Map<String, String>> members,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Encabezado del rol
        Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(width: 12),
            Text(
              role,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${members.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        
        const SizedBox(height: 12),
        
        // Lista de miembros
        ...members.map((member) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.1),
                  child: Text(
                    _getInitials(member['name']!),
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(member['name']!),
                subtitle: Row(
                  children: [
                    Icon(Icons.email, size: 14, color: Colors.grey[600]),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        member['email']!,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                trailing: IconButton(
                  icon: const Icon(Icons.phone),
                  onPressed: () {
                    // TODO: Implementar llamada telefónica
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Llamar a ${member['name']}'),
                      ),
                    );
                  },
                  tooltip: 'Llamar',
                ),
              ),
            )),
      ],
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name.substring(0, 1).toUpperCase();
  }
}
