// lib/src/features/home/presentation/widgets/settings/user_info_section.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Widget que muestra la información del usuario en la pantalla de configuración.
/// 
/// Incluye:
/// - Avatar con inicial del nombre
/// - Nombre completo
/// - Email
/// - Rol (chip)
/// - Navegación al perfil
class UserInfoSection extends StatelessWidget {
  const UserInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<AuthProvider>().user;
    
    return SectionCard(
      title: 'Información de Usuario',
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          child: Text(
            user?.name.substring(0, 1).toUpperCase() ?? 'U',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(user?.name ?? 'Usuario'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user?.email ?? ''),
            const SizedBox(height: 4),
            Chip(
              label: Text(
                _getRoleLabel(user?.role),
                style: const TextStyle(fontSize: 11),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () => context.push('/user-profile'),
      ),
    );
  }

  String _getRoleLabel(dynamic role) {
    if (role == null) return 'Usuario';
    final roleStr = role.toString().split('.').last;
    switch (roleStr) {
      case 'superadmin':
        return 'Super Admin';
      case 'owner':
        return 'Dueño';
      case 'superintendent':
        return 'Superintendente';
      case 'resident':
        return 'Residente';
      case 'cabo':
        return 'Cabo';
      default:
        return roleStr;
    }
  }
}
