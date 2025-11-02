import 'package:flutter/material.dart';
import '../../../core_domain/entities/user_entity.dart';

/// Widget reutilizable para seleccionar usuario
/// 
/// SEMANA 3: Widget compartido para selección de usuarios
/// - Usado en assign_user_screen, delegate_task_screen, etc.
/// - Incluye búsqueda en tiempo real
/// - Muestra avatar con iniciales
/// - Indicador visual de selección
/// - ~110 líneas
class UserSelectorWidget extends StatelessWidget {
  const UserSelectorWidget({
    super.key,
    required this.users,
    required this.selectedUserId,
    required this.onUserSelected,
    this.searchQuery = '',
    this.onSearchChanged,
    this.emptyMessage = 'No hay usuarios disponibles',
  });

  final List<UserEntity> users;
  final String? selectedUserId;
  final ValueChanged<String> onUserSelected;
  final String searchQuery;
  final ValueChanged<String>? onSearchChanged;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Barra de búsqueda
        if (onSearchChanged != null)
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              onChanged: onSearchChanged,
              decoration: InputDecoration(
                hintText: 'Buscar usuario...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),
          ),
        
        // Lista de usuarios
        Expanded(
          child: users.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  itemCount: users.length,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemBuilder: (context, index) {
                    final user = users[index];
                    return _buildUserCard(context, user);
                  },
                ),
        ),
      ],
    );
  }
  
  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            emptyMessage,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  
  Widget _buildUserCard(BuildContext context, UserEntity user) {
    final theme = Theme.of(context);
    final isSelected = user.id == selectedUserId;
    
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: isSelected ? Colors.blue.shade50 : null,
      elevation: isSelected ? 2 : 1,
      child: ListTile(
        leading: _buildAvatar(user, isSelected),
        title: Text(
          user.name,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        subtitle: Text(_getRoleLabel(user.role)),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: Colors.blue.shade700)
            : const Icon(Icons.radio_button_unchecked, color: Colors.grey),
        onTap: () => onUserSelected(user.id),
      ),
    );
  }
  
  Widget _buildAvatar(UserEntity user, bool isSelected) {
    final initials = _getInitials(user.name);
    final color = isSelected ? Colors.blue : Colors.grey;
    
    return CircleAvatar(
      backgroundColor: color.shade100,
      child: Text(
        initials,
        style: TextStyle(
          color: color.shade700,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
  
  String _getInitials(String name) {
    final parts = name.trim().split(' ');
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }
  
  String _getRoleLabel(UserRole role) {
    switch (role) {
      case UserRole.cabo:
        return 'Cabo';
      case UserRole.superintendent:
        return 'Superintendente';
      case UserRole.resident:
        return 'Residente';
      case UserRole.owner:
        return 'Propietario';
      case UserRole.superadmin:
        return 'Super Admin';
    }
  }
}
