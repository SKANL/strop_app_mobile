import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/incident_form_provider.dart';
import '../utils/ui_helpers.dart';
import '../../../../core/core_ui/widgets/widgets.dart';
import '../../../../core/core_domain/entities/user_entity.dart';

/// Screen 21: Asignar Tarea (Modal)
/// 
/// Permite a un Residente o Superintendente delegar una tarea (RF-B03).
/// Solo visible para usuarios con rol R/S.
/// 
/// REFACTORIZADO EN SEMANA 3:
/// - Usa UserSelectorWidget reutilizable
/// - Reducido de 313 → ~160 líneas (-49%)
/// - Eliminado código de UI duplicado
/// - Lógica de selección simplificada
class AssignUserScreen extends StatefulWidget {
  const AssignUserScreen({
    super.key,
    required this.incidentId,
    required this.projectId,
  });

  final String incidentId;
  final String projectId;

  @override
  State<AssignUserScreen> createState() => _AssignUserScreenState();
}

class _AssignUserScreenState extends State<AssignUserScreen> {
  String? _selectedUserId;
  String _searchQuery = '';
  
  // Mock data - TODO: Reemplazar con datos del Provider cuando se refactorice
  final List<UserEntity> _availableUsers = const [
    UserEntity(
      id: '1',
      name: 'Carlos López',
      email: 'carlos.lopez@example.com',
      role: UserRole.cabo,
    ),
    UserEntity(
      id: '2',
      name: 'María Ramírez',
      email: 'maria.ramirez@example.com',
      role: UserRole.cabo,
    ),
    UserEntity(
      id: '3',
      name: 'Pedro Sánchez',
      email: 'pedro.sanchez@example.com',
      role: UserRole.cabo,
    ),
    UserEntity(
      id: '4',
      name: 'Ana Torres',
      email: 'ana.torres@example.com',
      role: UserRole.resident,
    ),
  ];

  List<UserEntity> get filteredUsers {
    if (_searchQuery.isEmpty) return _availableUsers;
    
    final query = _searchQuery.toLowerCase();
    return _availableUsers.where((user) {
      return user.name.toLowerCase().contains(query) ||
             user.email.toLowerCase().contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignar Tarea'),
      ),
      body: Column(
        children: [
          _buildInfoBanner(),
          Expanded(
            child: UserSelectorWidget(
              users: filteredUsers,
              selectedUserId: _selectedUserId,
              onUserSelected: (userId) {
                setState(() {
                  _selectedUserId = userId;
                });
              },
              searchQuery: _searchQuery,
              onSearchChanged: (query) {
                setState(() {
                  _searchQuery = query;
                });
              },
              emptyMessage: 'No hay usuarios disponibles para asignar',
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        border: Border(
          bottom: BorderSide(color: Colors.blue.shade200),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.assignment_ind, color: Colors.blue.shade700),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Selecciona a quién asignar esta tarea',
              style: TextStyle(
                color: Colors.blue.shade900,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    final theme = Theme.of(context);
    final hasSelection = _selectedUserId != null;
    final formProvider = context.watch<IncidentFormProvider>();
    
    return Container(
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
        child: FormActionButtons(
          submitText: 'Asignar Tarea',
          onSubmit: hasSelection ? () => _handleAssign(context, formProvider) : null,
          isLoading: formProvider.isAssigning,
        ),
      ),
    );
  }

  Future<void> _handleAssign(BuildContext context, IncidentFormProvider provider) async {
    if (_selectedUserId == null) return;
    
    // Buscar nombre del usuario seleccionado
    final selectedUser = _availableUsers.firstWhere(
      (u) => u.id == _selectedUserId,
    );

    await UiHelpers.handleFormSubmit(
      context: context,
      loadingMessage: 'Asignando tarea...',
      operation: () => provider.assignIncident(widget.incidentId, _selectedUserId!),
      successMessage: 'Tarea asignada a ${selectedUser.name}',
      errorMessage: 'Error al asignar: ${provider.assignError ?? "Desconocido"}',
      onSuccess: () => Navigator.of(context).pop(true),
    );
  }
}
