import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/incident_form_provider.dart';
import 'package:mobile_strop_app/src/core/core_ui/widgets/widgets.dart';
import 'package:mobile_strop_app/src/core/core_domain/entities/user_entity.dart';

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
    return StropScaffold(
      title: 'Asignar Tarea',
      body: Column(
        children: [
          InfoBanner(
            message: 'Selecciona a quién asignar esta tarea',
            icon: Icons.assignment_ind,
            type: InfoBannerType.info,
          ),
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
            color: AppColors.withOpacity(AppColors.black, 0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: FormActionButtons(
          submitText: 'Asignar Tarea',
          onSubmit: hasSelection ? () => _handleAssign(formProvider) : null,
          isLoading: formProvider.isAssigning,
        ),
      ),
    );
  }

  Future<void> _handleAssign(IncidentFormProvider provider) async {
    if (_selectedUserId == null) return;

    // Capturar datos antes del gap asíncrono
    final selectedUser = _availableUsers.firstWhere((u) => u.id == _selectedUserId);

    try {
      await provider.assignIncident(widget.incidentId, _selectedUserId!);

      if (!mounted) return;

      // Usar context solo después de verificar mounted
      context.showSuccessSnackBar('Tarea asignada a ${selectedUser.name}');
      context.navigateBack(true);
    } catch (e) {
      if (!mounted) return;
      context.showErrorSnackBar('Error al asignar: ${provider.assignError ?? "Desconocido"}');
    }
  }
}
