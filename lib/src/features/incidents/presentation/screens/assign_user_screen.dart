import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incidents_provider.dart';

/// Screen 21: Asignar Tarea (Modal)
/// 
/// Permite a un Residente o Superintendente delegar una tarea (RF-B03).
/// Solo visible para usuarios con rol R/S.
/// 
/// Contenido:
/// - Lista de usuarios subordinados en el proyecto
/// - Botón de asignación
class AssignUserScreen extends StatefulWidget {
  final String incidentId;
  final String projectId;

  const AssignUserScreen({
    super.key,
    required this.incidentId,
    required this.projectId,
  });

  @override
  State<AssignUserScreen> createState() => _AssignUserScreenState();
}

class _AssignUserScreenState extends State<AssignUserScreen> {
  String? _selectedUserId;

  // TODO: Reemplazar con datos reales del Provider
  final List<Map<String, dynamic>> _availableUsers = [
    {
      'id': '1',
      'name': 'Carlos López',
      'role': 'Cabo',
      'email': 'carlos.lopez@example.com',
    },
    {
      'id': '2',
      'name': 'María Ramírez',
      'role': 'Cabo',
      'email': 'maria.ramirez@example.com',
    },
    {
      'id': '3',
      'name': 'Pedro Sánchez',
      'role': 'Cabo',
      'email': 'pedro.sanchez@example.com',
    },
    {
      'id': '4',
      'name': 'Ana Torres',
      'role': 'Residente',
      'email': 'ana.torres@example.com',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Tarea'),
      ),
      body: Column(
        children: [
          // Banner informativo
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple[50],
              border: Border(
                bottom: BorderSide(color: Colors.purple[200]!),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.assignment_ind, color: Colors.purple[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Selecciona a quién asignar esta tarea',
                    style: TextStyle(
                      color: Colors.purple[900],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Lista de usuarios
          Expanded(
            child: _availableUsers.isEmpty
                ? _buildEmptyState(theme)
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _availableUsers.length,
                    itemBuilder: (context, index) {
                      final user = _availableUsers[index];
                      return _buildUserCard(theme, user);
                    },
                  ),
          ),

          // Botón de acción
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 4,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancelar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: FilledButton.icon(
                      onPressed: _selectedUserId != null ? _assignTask : null,
                      icon: const Icon(Icons.check),
                      label: const Text('Asignar Tarea'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard(ThemeData theme, Map<String, dynamic> user) {
    final isSelected = _selectedUserId == user['id'];
    final roleColor = user['role'] == 'Residente' ? Colors.blue : Colors.orange;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: isSelected ? 4 : 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedUserId = user['id'];
          });
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: roleColor.withValues(alpha: 0.2),
                child: Text(
                  _getInitials(user['name']),
                  style: TextStyle(
                    color: roleColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Info del usuario
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user['name'],
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: roleColor.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            user['role'],
                            style: TextStyle(
                              color: roleColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            user['email'],
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Indicador de selección
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                  size: 28,
                )
              else
                Icon(
                  Icons.radio_button_unchecked,
                  color: Colors.grey[400],
                  size: 28,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(ThemeData theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No hay usuarios disponibles',
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'No se encontraron usuarios subordinados en este proyecto',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    } else if (parts.isNotEmpty) {
      return parts[0][0].toUpperCase();
    }
    return '?';
  }

  void _assignTask() async {
    if (_selectedUserId == null) return;

    final selectedUser = _availableUsers.firstWhere(
      (u) => u['id'] == _selectedUserId,
    );
    
    // Mostrar loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    // Llamar al provider
    final incidentsProvider = context.read<IncidentsProvider>();
    final success = await incidentsProvider.assignIncident(
      widget.incidentId,
      _selectedUserId!,
    );

    if (!mounted) return;
    
    // Cerrar diálogo de loading
    Navigator.of(context).pop();

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarea asignada a ${selectedUser['name']}'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.of(context).pop(true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al asignar: ${incidentsProvider.operationError ?? "Desconocido"}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
