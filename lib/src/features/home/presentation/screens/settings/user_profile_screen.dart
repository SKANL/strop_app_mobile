// lib/src/features/home/presentation/screens/settings/user_profile_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../../../auth/presentation/manager/auth_provider.dart';
import '../../widgets/user_avatar_section.dart';
import '../../widgets/dialogs/change_password_dialog.dart';
import '../../../../../core/core_ui/widgets/widgets.dart';

/// Pantalla de Perfil de Usuario (Fase 1)
class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          final user = authProvider.user;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),
                
                // Avatar
                UserAvatarSection(
                  userName: user?.name ?? 'Usuario',
                  onEditPhoto: () {
                    // TODO: Implementar cambio de foto
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Cambio de foto (pendiente)'),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Información del usuario
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Información Personal',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        
                        InfoRow(
                          icon: Icons.person_outline,
                          label: 'Nombre',
                          value: user?.name ?? 'No disponible',
                        ),
                        const Divider(),
                        
                        InfoRow(
                          icon: Icons.email_outlined,
                          label: 'Correo Electrónico',
                          value: user?.email ?? 'No disponible',
                        ),
                        const Divider(),
                        
                        InfoRow(
                          icon: Icons.badge_outlined,
                          label: 'Rol',
                          value: _getRoleLabel(user?.role),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Acciones
                Card(
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.lock_outline),
                        title: const Text('Cambiar Contraseña'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // TODO: Navegar a pantalla de cambio de contraseña
                          showDialog(
                            context: context,
                            builder: (context) => const ChangePasswordDialog(),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  String _getRoleLabel(dynamic role) {
    if (role == null) return 'No asignado';
    final roleStr = role.toString().split('.').last;
    switch (roleStr) {
      case 'superadmin':
        return 'Super Administrador';
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
